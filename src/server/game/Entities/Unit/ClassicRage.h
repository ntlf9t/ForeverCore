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

#ifndef TRINITY_CLASSIC_RAGE_H
#define TRINITY_CLASSIC_RAGE_H

#include <algorithm>
#include <cstdint>
#include <iterator>

// WoW Forever rage (build 1.60.1, measured on combat logs; the vanilla damage-based swing rage is gone). Pure: no game types.
//
// Dealing: a landed white swing (hit, glancing, block, crit, crushing; not a miss, dodge or parry) gives 3.46 rage per second of the
// weapon's base speed, half of that for an off-hand swing, times 4.5 / 3.46 for a two-hander (bear forms too, at a normalized 2.5),
// and twice all of that on a crit (Rule of Rage (DND) 1322574, value 100). Haste does not change it. Sources:
// magey/forever-warrior#3 (rates exact to the tenth over 1H, 2H, off-hand and bear logs), wowsims/forever sim/core/rage.go and its
// EV-0053 (crits double the whole swing's rage, two-hand factor included, logs from 2026-10-09 on).
//
// Taking damage: 2.5 x (1 - A) x damage / c(attacker level), where c is the vanilla conversion value read at the ATTACKER's level and A
// an armor reduction the game assumes from the attacker's level (developer notes: "20% to 40%"). A physical melee swing counts its
// damage before armor and the block (crit x2, crushing x1.5); non-physical damage and every periodic tick give twice the swing rule;
// other physical hits give twice the rule on the damage that lands. Attackers that use mana or energy give half. Sources:
// magey/forever-warrior#3, wowsims/forever EV-0048, EV-0052, EV-0118.
namespace ClassicRage
{
    constexpr float OneHandRatePerSecond = 3.46f;
    constexpr float TwoHandRatePerSecond = 4.5f;
    constexpr float BearNormalizedSpeed = 2.5f;
    constexpr float UnarmedSpeed = 2.0f;
    constexpr float CritMultiplier = 2.0f;           // Rule of Rage (DND) 1322574: +100%
    constexpr float DamageTakenFactor = 2.5f;
    constexpr float NonSwingTakenMultiplier = 2.0f;  // spells, ticks and physical specials taken
    constexpr float NonRageAttackerMultiplier = 0.5f; // attackers that use mana or energy

    // Rage points (not tenths) of a landed white swing, before rage auras and the server rate.
    // offHandBonusPct: Dual Wield Specialization's off-hand rage bonus (0 for other swings).
    inline float SwingRage(float weaponSpeedSeconds, bool offHand, bool twoHand, bool crit, float offHandBonusPct = 0.0f)
    {
        float rage = OneHandRatePerSecond * weaponSpeedSeconds;
        if (offHand)
            rage *= 0.5f * (1.0f + offHandBonusPct / 100.0f);
        if (twoHand)
            rage *= TwoHandRatePerSecond / OneHandRatePerSecond;
        if (crit)
            rage *= CritMultiplier;
        return rage;
    }

    // The level's rage conversion value (vanilla): 230.6 at 60.
    inline float Conversion(float level)
    {
        return 0.0091107836f * level * level + 3.225598133f * level + 4.2652911f;
    }

    // The armor reduction the game assumes in place of the defender's own, by the attacker's level (wowsims/forever EV-0048; 0.20 at
    // 16-42 and 0.38 at 50-60 in magey/forever-warrior#3; 0.40 at 63 is the top of the developer's stated range, unmeasured).
    inline float AssumedArmorReduction(float attackerLevel)
    {
        struct Row { float level; float reduction; };
        static constexpr Row rows[] = { { 38, 0.218f }, { 42, 0.239f }, { 44, 0.31f }, { 46, 0.36f }, { 47, 0.377f }, { 50, 0.38f },
            { 55, 0.381f }, { 59, 0.38f }, { 63, 0.40f } };
        if (attackerLevel <= rows[0].level)
            return rows[0].reduction;
        for (std::size_t i = 1; i < std::size(rows); ++i)
            if (attackerLevel <= rows[i].level)
                return rows[i - 1].reduction + (rows[i].reduction - rows[i - 1].reduction) * (attackerLevel - rows[i - 1].level) / (rows[i].level - rows[i - 1].level);
        return rows[std::size(rows) - 1].reduction;
    }

    // Rage points (not tenths) for damage taken, before the server rate. multiplier: NonSwingTakenMultiplier and / or
    // NonRageAttackerMultiplier as they apply.
    inline float RageFromDamageTaken(float damage, float attackerLevel, float multiplier = 1.0f)
    {
        attackerLevel = std::max(attackerLevel, 1.0f);
        return DamageTakenFactor * (1.0f - AssumedArmorReduction(attackerLevel)) * damage / Conversion(attackerLevel) * multiplier;
    }
}

#endif
