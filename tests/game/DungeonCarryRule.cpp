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

#include "tc_catch2.h"
#include "DungeonCarryRule.h"

using namespace Trinity::XP;

TEST_CASE("Dungeon kill XP stops when a party member is more than 12 levels above the enemy", "[DungeonCarryRule]")
{
    CHECK_FALSE(BlocksDungeonCarry(30, 20));    // 10 above
    CHECK_FALSE(BlocksDungeonCarry(32, 20));    // exactly 12 above still pays
    CHECK(BlocksDungeonCarry(33, 20));          // 13 above
    CHECK(BlocksDungeonCarry(60, 18));          // a level 60 in Ragefire Chasm
    CHECK_FALSE(BlocksDungeonCarry(20, 25));    // party below the enemy
}
