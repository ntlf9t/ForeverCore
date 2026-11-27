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
#include "Unit.h"

// advocaite/TrinityCore#320: World::LoadConfigSettings now sets baseMoveSpeed (NPCs, mobs) and playerBaseMoveSpeed (players)
// from defaultBaseMoveSpeed times Rate.MoveSpeed.Creature and Rate.MoveSpeed. With both rates at their default 1 that
// must give the speeds the two tables started with, so a realm that sets neither option moves exactly as before.
TEST_CASE("The default move speeds are the speeds both tables start with", "[MoveSpeedDefaults]")
{
    float const expected[MAX_MOVE_TYPE] = { 2.5f, 7.0f, 4.5f, 4.722222f, 2.5f, 3.141594f, 7.0f, 4.5f, 3.14f };
    for (uint32 i = 0; i < MAX_MOVE_TYPE; ++i)
    {
        CAPTURE(i);
        CHECK(defaultBaseMoveSpeed[i] == expected[i]);
        CHECK(defaultBaseMoveSpeed[i] * 1.0f == baseMoveSpeed[i]);
        CHECK(defaultBaseMoveSpeed[i] * 1.0f == playerBaseMoveSpeed[i]);
    }
}
