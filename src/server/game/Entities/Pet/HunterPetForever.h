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

#ifndef TRINITYCORE_HUNTER_PET_FOREVER_H
#define TRINITYCORE_HUNTER_PET_FOREVER_H

#include "Define.h"
#include <algorithm>
#include <cmath>
#include <array>

// Classic 1.60 (WoW Forever) hunter pet rules that differ from vanilla. Sources: the Classic Hunter Lodge wiki
// (github.com/classic-hunter/forever-hunter/wiki), pages Pet-Stat-Mechanics and Pet-Fundamentals, and the 1.60.1.70862
// client's PowerType table.
namespace HunterPetForever
{
    // Pet-Stat-Mechanics, "Hunter Inheritance": pet AP = 10% of the higher of the hunter's ranged and melee attack power, 2 pet
    // health per hunter Stamina, 30% of the hunter's armor, 100% of the higher of the hunter's ranged and melee crit, and the
    // hunter's hit. Inheritance follows the hunter's current stats, buffs included.
    constexpr float AttackPowerShare = 0.10f;
    constexpr float HealthPerStamina = 2.0f;
    constexpr float ArmorShare = 0.30f;
    constexpr float CritShare = 1.0f;

    // Pet-Fundamentals, "Pet Level and Experience": a pet level needs 20% of the hunter's XP for that level (vanilla: 5%).
    constexpr float LevelXpShare = 0.20f;

    // Pet-Fundamentals, "Focus": 10 focus per second, continuously, in and out of combat; the same as the client's PowerType row 3
    // (FOCUS, RegenPeace 10, RegenCombat 10). Used only when that row is missing. Vanilla gave 24 focus every 4 seconds.
    constexpr float FocusPerSecondFallback = 10.0f;

    struct HunterStats
    {
        float RangedAttackPower = 0.0f;
        float MeleeAttackPower = 0.0f;
        float Stamina = 0.0f;
        float Armor = 0.0f;
        float RangedCrit = 0.0f;    // percent
        float MeleeCrit = 0.0f;     // percent
        float RangedHit = 0.0f;     // percent
        float MeleeHit = 0.0f;      // percent
    };

    inline float AttackPower(HunterStats const& hunter)
    {
        return std::max(0.0f, std::max(hunter.RangedAttackPower, hunter.MeleeAttackPower) * AttackPowerShare);
    }

    inline float MaxHealth(HunterStats const& hunter)
    {
        return std::max(0.0f, hunter.Stamina * HealthPerStamina);
    }

    inline float Armor(HunterStats const& hunter)
    {
        return std::max(0.0f, hunter.Armor * ArmorShare);
    }

    inline float Crit(HunterStats const& hunter)
    {
        return std::max(0.0f, std::max(hunter.RangedCrit, hunter.MeleeCrit) * CritShare);
    }

    // The wiki says only "Hit: inherited by the pet"; the higher of ranged and melee hit, as for attack power and crit.
    inline float Hit(HunterStats const& hunter)
    {
        return std::max(0.0f, std::max(hunter.RangedHit, hunter.MeleeHit));
    }

    // Spell hit (Lightning Breath and the pet's other magic hits): 17/8 of the hunter's ranged hit, from Forever's developers on their
    // tracker, 22 Oct 2026 (forever-bugs issue 394, the same reply as the warlock demons' 8/17 melee share in WarlockPetForever.h;
    // MythicSim docs/mechanics.md "Pet hit" and wowsims/forever sim/hunter/pets.go, both MIT). Before, the pet took Hit() as spell hit.
    constexpr float SpellHitShare = 17.0f / 8.0f;

    inline float SpellHit(HunterStats const& hunter)
    {
        return std::max(0.0f, hunter.RangedHit * SpellHitShare);
    }

    inline uint32 NextLevelXp(uint32 hunterXpForLevel)
    {
        return uint32(float(hunterXpForLevel) * LevelXpShare);
    }

    inline float FocusPerTick(float focusPerSecond, uint32 tickMs)
    {
        return focusPerSecond * float(tickMs) / 1000.0f;
    }

    // Pet-Fundamentals, "Loyalty": 6 ranks (1 Rebellious .. 6 Best Friend). Each rank up needs both 5% of the hunter's XP for the pet's
    // current level, earned by the pet since its last rank, and time: 0, 30, 45, 60 and 90 minutes for ranks 2 to 6.
    constexpr uint8 LoyaltyRankMin = 1;
    constexpr uint8 LoyaltyRankMax = 6;
    constexpr float LoyaltyXpShare = 0.05f;
    constexpr std::array<uint32, LoyaltyRankMax + 1> LoyaltyRankMinutes = { 0, 0, 0, 30, 45, 60, 90 }; // by the rank reached

    inline uint32 LoyaltyXpForRank(uint32 hunterXpForLevel)
    {
        return uint32(float(hunterXpForLevel) * LoyaltyXpShare);
    }

    inline uint32 LoyaltySecondsForRank(uint8 rank)
    {
        return LoyaltyRankMinutes[std::clamp(rank, LoyaltyRankMin, LoyaltyRankMax)] * 60;
    }

    // rank: the pet's rank now; xp and seconds: what it earned and how long it was out since it reached that rank
    inline bool CanRankUp(uint8 rank, uint32 xp, uint32 seconds, uint32 hunterXpForLevel)
    {
        if (rank >= LoyaltyRankMax)
            return false;

        return xp >= LoyaltyXpForRank(hunterXpForLevel) && seconds >= LoyaltySecondsForRank(uint8(rank + 1));
    }

    // Attack speed. Every hunter pet swings once in 2.0 sec, and a beast that is faster or slower than that knows one of ten
    // passives of the generic pet skill line (270): Faster Attack I to VII and Slower Attack I to III, each a Mod Attack Speed
    // aura (1.60.1.70790 client). Wowhead's NPC pages name the beast's passive: "Attack Speed: 1.60 (Faster Attack II)".
    // The beast's speeds are vanilla's: 1.7, 1.6, 1.5, 1.4, 1.3, 1.2 and 1.0 sec for Faster Attack I to VII.
    constexpr uint32 BaseAttackTimeMs = 2000;
    constexpr std::array<uint32, 10> AttackSpeedPassives =
    {
        1263099, 1263100, 1263102, 1263104, 1263107, 1263109, 1263110,     // Faster Attack I .. VII: 17, 25, 33, 43, 54, 67, 100%
        1263111, 1263113, 1263114                                          // Slower Attack I .. III: -17, -20, -26%
    };

    inline bool IsAttackSpeedPassive(uint32 spellId)
    {
        return std::find(AttackSpeedPassives.begin(), AttackSpeedPassives.end(), spellId) != AttackSpeedPassives.end();
    }

    // The swing a passive leaves, as a share of the 2.0 sec one: 2.0 / (1 + percent / 100) sec, for the Slower Attack ranks
    // too. Their amounts are 2.0 / speed - 1 for vanilla's slow beasts (-17, -20 and -26% for 2.4, 2.5 and 2.7 sec) and
    // Wowhead lists a Slower Attack II beast at 2.50 sec (Young Forest Bear), where a slow of 20% would give 2.40.
    // percent: the passive's Mod Attack Speed amount, 0 without a passive.
    // Pet-Attack-Formulas, "Attack Speed Normalization": Auto Attack = (Base Pet DPS + Pet AP / 14) x Swing Speed, so a
    // faster beast hits for less and a slower one for more, and all of them do the same damage per second: one swing's
    // damage is this share of a 2.0 sec swing's damage as well.
    inline float SwingShare(int32 percent)
    {
        if (percent <= -100)
            return 1.0f;

        return 1.0f / (1.0f + float(percent) / 100.0f);
    }

    inline uint32 AttackTimeMs(int32 percent)
    {
        return uint32(float(BaseAttackTimeMs) * SwingShare(percent) + 0.5f);
    }

    // Unit::ApplyAttackTimePercentMod lengthens a swing by 1 + amount for a negative amount (a slow). The amount that
    // makes it lengthen the swing to SwingShare instead: -25 for Slower Attack II's -20.
    inline float SlowAmountForSwingShare(int32 percent)
    {
        return -(SwingShare(percent) - 1.0f) * 100.0f;
    }

    // Pet food. The client's Item table names an item's food type (ItemPetFoodID, a row of ItemPetFood: 1 Meat, 2 Fish, 3 Cheese,
    // 4 Bread, 5 Fungus, 6 Fruit, 7 Raw Meat, 8 Raw Fish) and CreatureFamily.PetFoodMask has one bit per type the family eats.
    // item_template_addon.FoodType only fills in an item the client gives no type.
    inline uint32 FoodType(int32 clientItemPetFoodId, uint32 addonFoodType)
    {
        return clientItemPetFoodId > 0 ? uint32(clientItemPetFoodId) : addonFoodType;
    }

    inline bool EatsFoodType(uint32 familyPetFoodMask, uint32 foodType)
    {
        return foodType >= 1 && foodType <= 32 && (familyPetFoodMask & (uint32(1) << (foodType - 1))) != 0;
    }

    // A tamed pet's own attack power is 30% of the creature auto attack dps of its level as attack power (14 a point of dps), the dps x 4.2
    // rounded down, with nothing from Strength (wowsims/forever, MIT, sim/hunter/pets.go, docs/evidence EV-0070); the owner's 10% adds to it.
    inline float OwnAttackPower(float creatureDps)
    {
        return std::floor(0.3f * 14.0f * creatureDps);
    }

    // The creature dps already holds that attack power, so the swing before attack power is what is left of it over the 2.0 s, 70% of the
    // creature dps, 20% either side. A level 30 Cat's 152 logged swings all land inside this range at the attack power the log gives it;
    // with the whole creature dps as the weapon 131 fell outside, about 32% high (EV-0071). One log, one pet: medium-low confidence.
    inline float SwingAverage(float creatureDps)
    {
        return (creatureDps - OwnAttackPower(creatureDps) / 14.0f) * (BaseAttackTimeMs / 1000.0f);
    }
    inline float SwingMin(float creatureDps) { return SwingAverage(creatureDps) * 0.8f; }
    inline float SwingMax(float creatureDps) { return SwingAverage(creatureDps) * 1.2f; }
}

#endif
