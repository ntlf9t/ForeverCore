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
#include "ClassicManaRegen.h"

// Classic 1.60 (WoW Forever, R-0036): the five second rule, and a paid channel holding it until the channel ends.
TEST_CASE("ClassicManaRegen::IsInterrupted", "[ClassicManaRegen]")
{
    using ClassicManaRegen::IsInterrupted;

    SECTION("paying mana stops the regeneration for 5 seconds")
    {
        REQUIRE(IsInterrupted(0, false));
        REQUIRE(IsInterrupted(4999, false));
        REQUIRE_FALSE(IsInterrupted(5000, false));
    }

    SECTION("a paid channel holds it past 5 seconds until it ends")
    {
        REQUIRE(IsInterrupted(8000, false, true));
        REQUIRE_FALSE(IsInterrupted(8000, false, false));
    }

    SECTION("a channel ending inside the window does not end the window early")
    {
        REQUIRE(IsInterrupted(3000, false, false));
    }

    SECTION("an interrupting aura holds it whatever the time")
    {
        REQUIRE(IsInterrupted(60000, true));
    }
}
