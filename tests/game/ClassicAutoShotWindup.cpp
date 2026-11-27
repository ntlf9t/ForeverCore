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

// Auto Shot's half-second wind-up is shortened by ranged haste, like the swing (ClassicAutoShot::WindupFor).

#include "tc_catch2.h"
#include "ClassicAutoShot.h"

TEST_CASE("Auto Shot wind-up without haste is half a second", "[ClassicAutoShot]")
{
    REQUIRE(ClassicAutoShot::WindupFor(1.0f) == 500);
}

TEST_CASE("Ranged haste shortens the Auto Shot wind-up", "[ClassicAutoShot]")
{
    REQUIRE(ClassicAutoShot::WindupFor(1.0f / 1.10f) == 455);                 // 10% quiver
    REQUIRE(ClassicAutoShot::WindupFor(1.0f / (1.15f * 1.40f)) == 311);       // 15% quiver and Rapid Fire
}

TEST_CASE("A slowed or broken attack speed keeps the plain wind-up", "[ClassicAutoShot]")
{
    REQUIRE(ClassicAutoShot::WindupFor(1.25f) == 500);
    REQUIRE(ClassicAutoShot::WindupFor(0.0f) == 500);
}

TEST_CASE("The wind-up is done once the hunter stood still long enough", "[ClassicAutoShot]")
{
    REQUIRE_FALSE(ClassicAutoShot::IsWindupDone(1454, 1000, 455));
    REQUIRE(ClassicAutoShot::IsWindupDone(1455, 1000, 455));
    REQUIRE(ClassicAutoShot::IsWindupDone(10, 0xFFFFFF00u, 200));          // across the clock wrap
}
