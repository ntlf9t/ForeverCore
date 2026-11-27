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
#include "FallOutOfWorld.h"

using Trinity::FallOutOfWorld::For;
using Trinity::FallOutOfWorld::Outcome;

TEST_CASE("Falling out of the open world out of combat returns the player to the graveyard alive", "[FallOutOfWorld]")
{
    CHECK(For(false, false) == Outcome::ReturnToGraveyard);
}

TEST_CASE("Falling out of the world in combat or in an instance still kills", "[FallOutOfWorld]")
{
    CHECK(For(true, false) == Outcome::Die);   // no free escape from a fight
    CHECK(For(false, true) == Outcome::Die);   // no free way out of a dungeon or raid
    CHECK(For(true, true) == Outcome::Die);
}
