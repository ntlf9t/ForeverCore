/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#ifndef TRINITYCORE_WARLOCK_PET_FOREVER_H
#define TRINITYCORE_WARLOCK_PET_FOREVER_H

#include "Define.h"
#include <algorithm>

// Classic 1.60 (WoW Forever) demon stat inheritance from the warlock. 416189 Warlock Pet Scaling names what a demon takes (health, attack
// power, spell damage, resistances, armor, hit, crit, haste, mana regen) but every amount is 0 in the client: the server supplies them.
// The shares are wowsims/forever's (sim/warlock/pets.go, petStatInheritance), each read in game at one level:
//  - health: 2 per point of the warlock's Stamina (Blizzard's WoW Forever notes of 3 November 2026: "Pets now gain 2 Health per point
//    of Master's Stamina")
//  - armor: 35% of the warlock's armor, Demon Armor included, fixed at the summon (EV-0078)
//  - spell damage: 10% of the warlock's, the better of Shadow and Fire (EV-0079, read on the Sayaad)
//  - attack power: 17% of that same spell damage
//  - mana regen: MP5 = a share of the warlock's Intellect, Imp 30%, the others 10% (EV-0080, level 30; the Felhunter's not read)
//  - hit: the warlock's spell hit as spell hit, and 8/17 of it as melee hit (forever-bugs issue 394)
// Not inherited here: crit (wowsims notes that in game a demon still has its own crit, EV-0081), resistances, haste and mana.
namespace WarlockPetForever
{
    constexpr float HealthPerStamina = 2.0f;
    constexpr float ArmorShare = 0.35f;
    constexpr float SpellDamageShare = 0.10f;
    constexpr float AttackPowerShare = 0.17f;
    constexpr float ImpMp5PerIntellect = 0.30f;
    constexpr float DemonMp5PerIntellect = 0.10f;
    constexpr float MeleeHitShare = 8.0f / 17.0f;

    struct WarlockStats
    {
        float Stamina = 0.0f;
        float Intellect = 0.0f;
        float Armor = 0.0f;
        float ShadowDamage = 0.0f;  // spell damage the warlock's Shadow spells get
        float FireDamage = 0.0f;    // and its Fire spells
        float SpellHit = 0.0f;      // percent
    };

    // The warlock's spell damage as its own tooltips read it: the better of its two schools.
    inline float WarlockSpellDamage(WarlockStats const& warlock)
    {
        return std::max(0.0f, std::max(warlock.ShadowDamage, warlock.FireDamage));
    }

    inline float MaxHealth(WarlockStats const& warlock)
    {
        return std::max(0.0f, warlock.Stamina * HealthPerStamina);
    }

    inline float Armor(WarlockStats const& warlock)
    {
        return std::max(0.0f, warlock.Armor * ArmorShare);
    }

    inline float SpellDamage(WarlockStats const& warlock)
    {
        return WarlockSpellDamage(warlock) * SpellDamageShare;
    }

    inline float AttackPower(WarlockStats const& warlock)
    {
        return WarlockSpellDamage(warlock) * AttackPowerShare;
    }

    inline float ManaPer5(WarlockStats const& warlock, bool imp)
    {
        return std::max(0.0f, warlock.Intellect * (imp ? ImpMp5PerIntellect : DemonMp5PerIntellect));
    }

    inline float SpellHit(WarlockStats const& warlock)
    {
        return std::max(0.0f, warlock.SpellHit);
    }

    inline float MeleeHit(WarlockStats const& warlock)
    {
        return SpellHit(warlock) * MeleeHitShare;
    }

    // The demons' own stats as shares of the client's ExpectedStat creature values for their level (wowsims/forever pets.go, EV-0075,
    // EV-0076, EV-0078; read at levels 20 and 30, level 60 extrapolated). Armor already matches the vanilla pet_levelstats within 3%;
    // health is in 2026_11_17_10_world_forever_demon_base_health.sql (Imp and Sayaad +15% for Blizzard's 10 November hotfix in
    // 2026_11_24_61_world_forever_demon_base_health_1110.sql), the weapons in Pet::InitStatsForLevel, attack power and the
    // Voidwalker's halved melee in Guardian::UpdateAttackPowerAndDamage and Guardian::UpdateDamagePhysical.
    constexpr float ImpHealthShare = 0.359f;
    constexpr float VoidwalkerHealthShare = 1.400f;
    constexpr float SayaadHealthShare = 0.699f;

    constexpr uint32 VoidwalkerEntry = 1860;
    constexpr uint32 SayaadEntry = 1863;          // Succubus
    constexpr uint32 IncubusEntry = 185317;       // Summon Incubus 713; the same Sayaad as the Succubus

    // A demon's average swing before attack power, as a share of the creature dps at its 2.0 s swing, and how far either side of it
    // the damage range spans.
    struct SwingModel
    {
        float Share;
        float Spread;
    };
    constexpr float DemonSwingSeconds = 2.0f;
    constexpr SwingModel SayaadSwing = { 0.698f, 0.215f };
    constexpr SwingModel VoidwalkerSwing = { 0.494f, 0.264f };

    // The Voidwalker's melee is halved, attack power included (EV-0076).
    constexpr float VoidwalkerMeleeShare = 0.5f;

    inline SwingModel const* DemonSwing(uint32 entry)
    {
        switch (entry)
        {
            case SayaadEntry:
            case IncubusEntry:    return &SayaadSwing;
            case VoidwalkerEntry: return &VoidwalkerSwing;
            default:              return nullptr;
        }
    }

    inline float MinDamage(SwingModel const& swing, float creatureDps)
    {
        return creatureDps * DemonSwingSeconds * swing.Share * (1.0f - swing.Spread);
    }

    inline float MaxDamage(SwingModel const& swing, float creatureDps)
    {
        return creatureDps * DemonSwingSeconds * swing.Share * (1.0f + swing.Spread);
    }

    // The Voidwalker's and Sayaad's own attack power: 3 x level + 6, nothing from Strength (a line through 66 at level 20 and 96 at 30).
    inline float DemonAttackPower(uint8 level)
    {
        return 3.0f * level + 6.0f;
    }
}

#endif // TRINITYCORE_WARLOCK_PET_FOREVER_H
