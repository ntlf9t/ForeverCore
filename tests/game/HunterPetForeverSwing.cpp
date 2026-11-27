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
#include "HunterPetForever.h"

// WoW Forever (EV-0070, EV-0071): own attack power 30% of the creature dps, swing 70% of it over 2.0 s, 20% either side.
TEST_CASE("HunterPetForever swing and attack power", "[HunterPetForever]")
{
    using namespace HunterPetForever;

    SECTION("own attack power is the creature dps x 4.2, rounded down")
    {
        REQUIRE(OwnAttackPower(60.45f) == 253.0f);
        REQUIRE(OwnAttackPower(10.0f) == 42.0f);
    }

    SECTION("the swing leaves the own attack power out of the creature dps")
    {
        // 10 dps: 42 attack power is 3 dps, the swing is 7 dps over 2.0 s
        REQUIRE(SwingAverage(10.0f) == Catch::Approx(14.0f));
        REQUIRE(SwingMin(10.0f) == Catch::Approx(11.2f));
        REQUIRE(SwingMax(10.0f) == Catch::Approx(16.8f));
    }
}
