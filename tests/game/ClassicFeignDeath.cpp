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

// Feign Death resist chance per enemy (ClassicFeignDeath.h), the forever-hunter wiki's table.

#include "tc_catch2.h"
#include "ClassicFeignDeath.h"

using Catch::Approx;

TEST_CASE("Feign Death resist chance by creature level", "[ClassicFeignDeath]")
{
    REQUIRE(ClassicFeignDeath::ResistChance(0, 0.0f, false) == Approx(4.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(1, 0.0f, false) == Approx(5.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(2, 0.0f, false) == Approx(6.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(3, 0.0f, false) == Approx(17.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(4, 0.0f, false) == Approx(28.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(5, 0.0f, false) == Approx(39.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(6, 0.0f, false) == Approx(50.0f));
}

TEST_CASE("Hit lowers the Feign Death resist, never below 1%", "[ClassicFeignDeath]")
{
    REQUIRE(ClassicFeignDeath::ResistChance(3, 3.0f, false) == Approx(14.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(0, 8.0f, false) == Approx(1.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(-10, 0.0f, false) == Approx(1.0f));
}

TEST_CASE("Feign Death resist is capped by the spell hit floor", "[ClassicFeignDeath]")
{
    REQUIRE(ClassicFeignDeath::ResistChance(20, 0.0f, false) == Approx(78.0f));
    REQUIRE(ClassicFeignDeath::ResistChance(4, 0.0f, true) == Approx(20.0f));   // players: 7 per level
}
