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

// Auto Shot's hidden half-second retry checks (ClassicAutoShot::RetryTickFrom).

#include "tc_catch2.h"
#include "ClassicAutoShot.h"

using ClassicAutoShot::RetryTickFrom;

TEST_CASE("The first retry check is half a second after the failed attempt", "[ClassicAutoShot]")
{
    REQUIRE(RetryTickFrom(10000, 10000) == 10500);
    REQUIRE(RetryTickFrom(10000, 10001) == 10500);
    REQUIRE(RetryTickFrom(10000, 9000) == 10500);     // stopped before the shot came due
}

TEST_CASE("Stopping just after a check waits for the next one", "[ClassicAutoShot]")
{
    REQUIRE(RetryTickFrom(10000, 10501) == 11000);    // lost 499 ms
    REQUIRE(RetryTickFrom(10000, 10999) == 11000);    // lost 1 ms
    REQUIRE(RetryTickFrom(10000, 11000) == 11000);    // stopped on the check
}

TEST_CASE("A failed check moves on to the next one", "[ClassicAutoShot]")
{
    REQUIRE(RetryTickFrom(10000, 10500 + 1) == 11000);
    REQUIRE(RetryTickFrom(10000, 11000 + 1) == 11500);
}

TEST_CASE("Retry checks are right across the ms clock wrap", "[ClassicAutoShot]")
{
    uint32_t const anchor = 0xFFFFFF00u;
    REQUIRE(RetryTickFrom(anchor, anchor + 1) == anchor + 500);
    REQUIRE(RetryTickFrom(anchor, anchor + 700) == anchor + 1000);
    REQUIRE(ClassicAutoShot::HasReached(anchor + 600, anchor + 500));
    REQUIRE_FALSE(ClassicAutoShot::HasReached(anchor + 400, anchor + 500));
    REQUIRE(ClassicAutoShot::Later(anchor + 300, anchor) == anchor + 300);
}
