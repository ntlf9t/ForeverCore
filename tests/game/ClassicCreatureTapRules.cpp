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

#include "../../src/server/game/Entities/Creature/CreatureTapRules.h"

using namespace CreatureTapRules;

namespace
{
constexpr std::size_t SoftCap = 5;
}

TEST_CASE("Classic tagging: the first tag owns the mob", "[ClassicCreatureTapRules]")
{
    // untagged: the first player (a bot too) tags it
    REQUIRE(AcceptsTag(true, 0, SoftCap));
    REQUIRE_FALSE(ShowsTapped(true, 0, SoftCap));
    // tagged by one player or a whole group: nobody else joins, and it is grey to everyone outside the list at once
    REQUIRE_FALSE(AcceptsTag(true, 1, SoftCap));
    REQUIRE_FALSE(AcceptsTag(true, 4, SoftCap));
    REQUIRE(ShowsTapped(true, 1, SoftCap));
}

TEST_CASE("Retail tagging: up to the soft cap of players share the mob", "[ClassicCreatureTapRules]")
{
    REQUIRE(AcceptsTag(false, 0, SoftCap));
    REQUIRE(AcceptsTag(false, 1, SoftCap));
    REQUIRE(AcceptsTag(false, 4, SoftCap));
    REQUIRE_FALSE(AcceptsTag(false, 5, SoftCap));
    REQUIRE_FALSE(ShowsTapped(false, 4, SoftCap));
    REQUIRE(ShowsTapped(false, 5, SoftCap));
}
