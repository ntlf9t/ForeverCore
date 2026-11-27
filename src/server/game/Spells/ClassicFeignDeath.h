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

#ifndef TRINITY_CLASSIC_FEIGN_DEATH_H
#define TRINITY_CLASSIC_FEIGN_DEATH_H

#include <algorithm>
#include <cstdint>

// Classic 1.60 (vanilla, kept by WoW Forever): a player's Feign Death is resisted by each nearby enemy on its own, with the spell
// hit table's level based chance: 4% against the same level, 5 / 6% at +1 / +2, then 11 points more per level (17 / 28 / 39 / 50%).
// One enemy resisting keeps attacking the hunter; the rest drop it. The hunter's hit chance lowers the resist, as hit is shared by
// spells and attacks in Forever. Source: the forever-hunter wiki's Ability Mechanics page (resist table, ~40 yd checks).
namespace ClassicFeignDeath
{
    constexpr float CheckRange = 40.0f;

    // levelGap: enemy level minus hunter level. hitBonus: the hunter's +hit in percent.
    inline float ResistChance(int32_t levelGap, float hitBonus, bool enemyIsPlayer)
    {
        int32_t const perLevel = enemyIsPlayer ? 7 : 11;
        float hit = levelGap < 3 ? float(96 - levelGap) : float(94 - (levelGap - 2) * perLevel);
        hit = std::max(hit, 22.0f);                 // vanilla floor of the spell hit table
        hit = std::min(hit + hitBonus, 99.0f);      // 1% always resists
        return std::clamp(100.0f - hit, 0.0f, 100.0f);
    }
}

#endif
