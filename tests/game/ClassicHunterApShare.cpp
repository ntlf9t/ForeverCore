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

// Forever hunter spells' ranged attack power shares the client rows leave out (ClassicHunterApShare.h).

#include "tc_catch2.h"
#include "ClassicHunterApShare.h"

using Catch::Approx;

TEST_CASE("Arcane Shot and Explosive Trap take their share on the hit only", "[ClassicHunterApShare]")
{
    REQUIRE(ClassicHunterApShare::For(3044, false) == Approx(0.15f));
    REQUIRE(ClassicHunterApShare::For(14287, false) == Approx(0.15f));
    REQUIRE(ClassicHunterApShare::For(13812, false) == Approx(0.10f));
    REQUIRE(ClassicHunterApShare::For(13812, true) == Approx(0.0f));
}

TEST_CASE("Serpent Sting and Immolation Trap take their share on each tick", "[ClassicHunterApShare]")
{
    REQUIRE(ClassicHunterApShare::For(25295, true) == Approx(0.05f));
    REQUIRE(ClassicHunterApShare::For(1978, false) == Approx(0.0f));
    REQUIRE(ClassicHunterApShare::For(14301, true) == Approx(0.02f));
}

TEST_CASE("Other spells take no hunter share", "[ClassicHunterApShare]")
{
    REQUIRE(ClassicHunterApShare::For(75, false) == Approx(0.0f));
    REQUIRE(ClassicHunterApShare::For(19434, false) == Approx(0.0f));
}
