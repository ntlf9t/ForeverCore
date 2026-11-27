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

#include "BagSortAssignment.h"
#include <array>

TEST_CASE("Bag sorting keeps earlier items in earlier equally preferred slots", "[BagSort]")
{
    std::array<std::size_t, 3> const order = { 0, 1, 2 };
    std::vector<std::size_t> owners;
    REQUIRE(BagSorting::AssignSlots(3, 3,
        [&order](std::size_t) -> auto const& { return order; },
        [](std::size_t, std::size_t) { return true; }, owners));
    REQUIRE(owners == std::vector<std::size_t>{ 0, 1, 2 });
}

TEST_CASE("Bag sorting leaves a restricted slot available to its item", "[BagSort]")
{
    std::array<std::size_t, 2> const order = { 0, 1 };
    std::vector<std::size_t> owners;
    REQUIRE(BagSorting::AssignSlots(2, 2,
        [&order](std::size_t) -> auto const& { return order; },
        [](std::size_t item, std::size_t slot) { return item == 0 || slot == 0; }, owners));
    REQUIRE(owners == std::vector<std::size_t>{ 1, 0 });
}

TEST_CASE("Bag sorting rejects an impossible assignment", "[BagSort]")
{
    std::array<std::size_t, 1> const order = { 0 };
    std::vector<std::size_t> owners;
    REQUIRE_FALSE(BagSorting::AssignSlots(2, 1,
        [&order](std::size_t) -> auto const& { return order; },
        [](std::size_t, std::size_t) { return true; }, owners));
}
