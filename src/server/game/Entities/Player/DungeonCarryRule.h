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

#ifndef TRINITYCORE_DUNGEON_CARRY_RULE_H
#define TRINITYCORE_DUNGEON_CARRY_RULE_H

#include "Define.h"

// WoW Forever hotfixes of November 13 and 14 2026: no party member gets kill experience in a 5 player dungeon when the highest
// level player in the party is more than 12 levels above the enemy, so a level 60 can't carry a low level character through a
// dungeon for experience. Open world and raid kills are not affected.
namespace Trinity::XP
{
inline constexpr uint8 DungeonCarryLevelGap = 12;

inline constexpr bool BlocksDungeonCarry(uint8 maxPartyLevel, uint8 victimLevel)
{
    return maxPartyLevel > victimLevel + DungeonCarryLevelGap;
}
}

#endif // TRINITYCORE_DUNGEON_CARRY_RULE_H
