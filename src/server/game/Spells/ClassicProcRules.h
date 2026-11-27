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

#ifndef TRINITY_CLASSIC_PROC_RULES_H
#define TRINITY_CLASSIC_PROC_RULES_H

#include "Define.h"
#include "FlagsArray.h"
#include "SharedDefines.h"
#include <algorithm>
#include <array>

// Classic 1.60: the decisions of the proc scripts in classic_spell_scripts.cpp (advocaite/TrinityCore#325), apart from the
// scripts so tests can reach them. Pure: the script reads the aura, the weapon and the proc event and passes plain values.
namespace ClassicProcRules
{
    // Shaman weapon imbues: every rank's temporary enchantment applies the same DUMMY aura (Flametongue Weapon 436519, Windfury
    // Weapon 439431); the enchantment on the weapon that hit tells the rank. 0: not an enchantment of that imbue.

    // Flametongue: enchantment -> the rank's "Flametongue Weapon Proc" spell, whose effect 0 points carry the damage
    constexpr uint32 FlametongueRankSpell(uint32 enchantId)
    {
        switch (enchantId)
        {
            case 5:    return 8026;
            case 4:    return 8028;
            case 3:    return 8029;
            case 523:  return 10445;
            case 1665: return 16343;
            case 1666:
            case 7567: return 16344;    // 7567: the enchantment of the newer Flametongue Weapon 461634
            default:   return 0;
        }
    }

    // Windfury: enchantment -> the rank's attack power + extra attacks spell
    constexpr uint32 WindfuryRankSpell(uint32 enchantId)
    {
        switch (enchantId)
        {
            case 283:  return 8233;
            case 284:  return 8236;
            case 525:  return 10484;
            case 1669:
            case 7569: return 16361;    // 7569: the enchantment of the newer Windfury Weapon 461636
            case 8293: return 8233;     // Windwrath 1
            default:   return 0;
        }
    }

    // Flametongue Weapon: "${$8026m1/77} to ${$8026m1/25}" Fire damage: the rank's points / 100 per second of weapon speed
    // (1.3 s to 4.0 s), at least 1. Spell power is added by Flametongue Attack 10444 itself (its bonus coefficient).
    inline int32 FlametongueDamage(float rankPoints, uint32 weaponDelayMs)
    {
        return std::max(int32(rankPoints * (float(weaponDelayMs) / 1000.0f) / 100.0f), 1);
    }

    // Talents whose proc chance is an effect amount scaled by the trait rank while SpellAuraOptions.ProcChance is 100: the effect
    // that holds the chance (the tooltip's $m1 / $m2 / $s2).
    constexpr SpellEffIndex TalentChanceEffect(uint32 talentSpellId)
    {
        switch (talentSpellId)
        {
            case 11180:   // Winter's Chill: $m2
            case 12298:   // Shield Specialization (warrior): $m2
            case 14909:   // Searing Light: $m2
            case 16850:   // Improved Starfire: $s2
            case 20150:   // Shield Specialization (paladin): $m2
            case 1224716: // Puncturing Wounds: $m2
                return EFFECT_1;
            default:
                return EFFECT_0;
        }
    }

    // What a proc event was, as far as the talent rules look at it
    struct ProcEvent
    {
        uint32 SpellFamily = 0;     // SpellFamilyNames of the spell of the event, SPELLFAMILY_GENERIC without one (melee swing)
        flag128 SpellFamilyFlags;   // its SpellClassMask
        uint32 SchoolMask = 0;      // SpellSchoolMask of the event
        bool Blocked = false;       // PROC_HIT_BLOCK or PROC_HIT_FULL_BLOCK
        bool Critical = false;      // PROC_HIT_CRITICAL
        bool Periodic = false;      // a periodic tick (PROC_FLAG_DEAL_HARMFUL_PERIODIC)
        bool Damage = false;        // the event dealt damage
        bool FinishingMove = false; // the spell costs combo points
        bool Chill = false;         // a mage spell with a snare (a mage "Chill effect")
    };

    // What a talent's tooltip asks of the event besides its spell and school
    namespace TalentRequires
    {
        constexpr uint32 Block          = 0x01;
        constexpr uint32 Critical       = 0x02;
        constexpr uint32 Periodic       = 0x04;
        constexpr uint32 Damage         = 0x08;
        constexpr uint32 FinishingMove  = 0x10;
        constexpr uint32 Chill          = 0x20;
    }

    // The client data has no spell filter on these talents (their proc effects have no SpellClassMask and there is no spell_proc
    // row), so without these rules each fired on every event its proc flags let through: Improved Kick on every Sinister Strike,
    // Nightfall on every Shadow Bolt. Family flags are the 70862 SpellClassOptions masks of the spells the tooltip names.
    struct TalentProcRule
    {
        uint32 TalentSpellId;
        uint32 SpellFamily;         // SPELLFAMILY_GENERIC: any spell or none
        flag128 SpellFamilyFlags;   // empty: any spell of the family; else a spell with any of these bits
        uint32 SchoolMask;          // 0: any school
        uint32 Requires;            // TalentRequires
    };

    constexpr uint32 FireFrostNature = SPELL_SCHOOL_MASK_FIRE | SPELL_SCHOOL_MASK_FROST | SPELL_SCHOOL_MASK_NATURE;

    constexpr std::array<TalentProcRule, 23> TalentProcRules =
    { {
        { 19407,   SPELLFAMILY_HUNTER,  flag128(0x00000200),                   0, 0 },                              // Improved Concussive Shot: Concussive Shot
        { 19228,   SPELLFAMILY_HUNTER,  flag128(0x00000040),                   0, 0 },                              // Improved Wing Clip: Wing Clip
        { 12289,   SPELLFAMILY_WARRIOR, flag128(0x00000002),                   0, 0 },                              // Improved Hamstring: Hamstring
        { 12311,   SPELLFAMILY_WARRIOR, flag128(0x00000800),                   0, 0 },                              // Improved Shield Bash: Shield Bash
        { 12298,   SPELLFAMILY_GENERIC, flag128(),                             0, TalentRequires::Block },          // Shield Specialization (warrior): a block
        { 20150,   SPELLFAMILY_GENERIC, flag128(),                             0, TalentRequires::Block },          // Shield Specialization (paladin): a block
        { 13754,   SPELLFAMILY_ROGUE,   flag128(0x00000010),                   0, 0 },                              // Improved Kick: Kick
        { 1224716, SPELLFAMILY_ROGUE,   flag128(0x00000004),                   0, 0 },                              // Puncturing Wounds: Backstab
        { 13976,   SPELLFAMILY_ROGUE,   flag128(0x00000700),                   0, 0 },                              // Initiative: Ambush 0x200, Garrote 0x100, Cheap Shot 0x400
        { 14156,   SPELLFAMILY_ROGUE,   flag128(),                             0, TalentRequires::FinishingMove },  // Ruthlessness: finishing moves (combo point cost)
        { 16850,   SPELLFAMILY_DRUID,   flag128(0x00000004),                   0, 0 },                              // Improved Starfire: Starfire
        { 18119,   SPELLFAMILY_WARLOCK, flag128(0, 0x00800000),                0, 0 },                              // Aftermath: Conflagrate
        { 18094,   SPELLFAMILY_WARLOCK, flag128(0x0000400A, 0x00040000),       0, TalentRequires::Damage },         // Nightfall: Corruption 0x2, Drain Life 0x8, Drain Soul 0x4000, Wrack [1] 0x40000
        { 14909,   SPELLFAMILY_PRIEST,  flag128(0x00100000),                   0, TalentRequires::Periodic },       // Searing Light: Holy Fire's periodic damage
        { 15257,   SPELLFAMILY_PRIEST,  flag128(0x0280A000, 0x00180002),       0, 0 },                              // Shadow Weaving: Shadow damage spells landing, an application without damage included (WoW Forever: SW:Pain 0x8000, Devouring Plague 0x2000000, Mind Flay 0x800000, Mind Blast 0x2000, SW:Death [1] 0x2, Mind Sear [1] 0x180000; wowsims/forever talents_shadow.go)
        { 15326,   SPELLFAMILY_PRIEST,  flag128(),                             SPELL_SCHOOL_MASK_SHADOW, TalentRequires::Damage }, // Blackout: Shadow damage spells
        { 14531,   SPELLFAMILY_GENERIC, flag128(),                             0, TalentRequires::Critical },       // Martyrdom: a melee or ranged critical strike taken
        { 20210,   SPELLFAMILY_PALADIN, flag128(0x00206000, 0, 0, 0x04000000), 0, TalentRequires::Critical },       // Illumination: Flash of Light 0x2000, Holy Light 0x4000, Holy Shock 0x200000, Light's Vigil [3] 0x4000000
        { 16164,   SPELLFAMILY_SHAMAN,  flag128(),                             FireFrostNature, TalentRequires::Damage }, // Elemental Focus: Fire, Frost or Nature damage spells
        { 11071,   SPELLFAMILY_MAGE,    flag128(),                             0, TalentRequires::Chill },          // Frostbite: Chill effects
        { 11103,   SPELLFAMILY_MAGE,    flag128(),                             SPELL_SCHOOL_MASK_FIRE, TalentRequires::Damage }, // Impact: Fire spells
        { 11213,   SPELLFAMILY_MAGE,    flag128(),                             0, TalentRequires::Damage },         // Arcane Concentration: damage spells
        { 11180,   SPELLFAMILY_MAGE,    flag128(0x00000020),                   0, 0 },                              // Winter's Chill: Frostbolt
    } };

    // Whether the event is one the talent's tooltip names. Talents without a rule (Spirit Tap: kills) take every event their proc
    // flags let through. Unbridled Wrath's filter is in its own script (classic_spell_warr_unbridled_wrath).
    inline bool TalentProcMatches(uint32 talentSpellId, ProcEvent const& event)
    {
        auto rule = std::ranges::find(TalentProcRules, talentSpellId, &TalentProcRule::TalentSpellId);
        if (rule == TalentProcRules.end())
            return true;

        if (rule->SpellFamily != SPELLFAMILY_GENERIC && event.SpellFamily != rule->SpellFamily)
            return false;
        if (rule->SpellFamilyFlags && !(event.SpellFamilyFlags & rule->SpellFamilyFlags))
            return false;
        if (rule->SchoolMask && !(event.SchoolMask & rule->SchoolMask))
            return false;

        uint32 const need = rule->Requires;
        if ((need & TalentRequires::Block) && !event.Blocked)
            return false;
        if ((need & TalentRequires::Critical) && !event.Critical)
            return false;
        if ((need & TalentRequires::Periodic) && !event.Periodic)
            return false;
        if ((need & TalentRequires::Damage) && !event.Damage)
            return false;
        if ((need & TalentRequires::FinishingMove) && !event.FinishingMove)
            return false;
        if ((need & TalentRequires::Chill) && !event.Chill)
            return false;
        return true;
    }

    // 400588 - Missile Barrage: Arcane Blast $m1%; Arcane Wrath (named Arcane Surge in #325), Fireball, Frostbolt and Frostfire Bolt
    // $m1 / 2; told apart by their whole SpellClassMask, so no other mage spell matches. 0: no chance.
    constexpr float MissileBarrageChance(uint32 spellFamily, flag128 const& f, float amount)
    {
        if (spellFamily != SPELLFAMILY_MAGE || f[3] != 0)
            return 0.0f;
        if (f[0] == 0x60000000 && f[1] == 0 && f[2] == 0)                       // Arcane Blast
            return amount;
        if ((f[0] == 0x40000000 && f[1] == 0x8000 && f[2] == 0)                 // Arcane Wrath
            || (f[0] == 0x40000001 && f[1] == 0 && f[2] == 0)                   // Fireball
            || (f[0] == 0x40180020 && f[1] == 0 && f[2] == 0)                   // Frostbolt
            || (f[0] == 0x40100000 && f[1] == 0x1000 && f[2] == 0x8))           // Frostfire Bolt
            return amount / 2.0f;
        return 0.0f;
    }

    // 20177 - Reckoning: "a $m1% chance after Blocking and a ${$m1*2.5}% chance after receiving a non-periodic critical strike to gain
    // an extra attack ... Cannot occur from Blocks more than once every 1.5 sec". The chance to roll, 0 for none; fromBlock tells the
    // script to start the block cooldown when the roll succeeds.
    constexpr uint32 ReckoningBlockCooldownMs = 1500;

    constexpr float ReckoningChance(ProcEvent const& event, uint32 nowMs, uint32 lastBlockMs, float amount, bool& fromBlock)
    {
        fromBlock = false;
        if (!event.Blocked && !event.Damage)    // a full block leaves no damage and still counts
            return 0.0f;
        if (event.Blocked)
        {
            if (lastBlockMs && nowMs - lastBlockMs < ReckoningBlockCooldownMs)
                return 0.0f;
            fromBlock = true;
            return amount;
        }
        if (event.Critical)
            return amount * 2.5f;
        return 0.0f;
    }
}

#endif // TRINITY_CLASSIC_PROC_RULES_H
