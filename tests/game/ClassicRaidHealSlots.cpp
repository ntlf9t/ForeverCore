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

#include "../../src/modules/PlayerbotV2/Bot/Raid/RaidHealSlots.h"
#include <algorithm>

using namespace Playerbot::Raid;

TEST_CASE("four slots for four tanks: the main tank gets two healers", "[classic][heal]")
{
    auto const s = HealSlotOrder(1, 2, { 3, 4 }, 4);
    REQUIRE(s.size() == 4);
    CHECK(std::count(s.begin(), s.end(), 1) == 2);
    CHECK(std::count(s.begin(), s.end(), 2) == 1);
    CHECK(std::count(s.begin(), s.end(), 3) == 1);
    CHECK(std::count(s.begin(), s.end(), 4) == 0);
}

TEST_CASE("a single slot goes to the main tank", "[classic][heal]")
{
    auto const s = HealSlotOrder(1, 2, { 3 }, 1);
    REQUIRE(s.size() == 1);
    CHECK(s[0] == 1);
}

TEST_CASE("a full budget gives main 3, off 2 and every spare 1", "[classic][heal]")
{
    auto const s = HealSlotOrder(1, 2, { 3, 4 }, 99);
    REQUIRE(s.size() == 7);
    CHECK(std::count(s.begin(), s.end(), 1) == 3);
    CHECK(std::count(s.begin(), s.end(), 2) == 2);
    CHECK(std::count(s.begin(), s.end(), 3) == 1);
    CHECK(std::count(s.begin(), s.end(), 4) == 1);
}

TEST_CASE("without an off tank the main tank still comes first, absent tanks add nothing", "[classic][heal]")
{
    auto const s = HealSlotOrder(1, 0, { 3 }, 3);
    REQUIRE(s.size() == 3);
    CHECK(s[0] == 1);
    CHECK(s[1] == 1);
    CHECK(s[2] == 3);
    CHECK(HealSlotOrder(0, 0, {}, 5).empty());
}

TEST_CASE("a melee-soak boss gives the soakers three each and the main tank one, then a second", "[classic][heal]")
{
    auto const s = SoakHealSlotOrder(1, 2, { 3, 4 }, 10);
    REQUIRE(s.size() == 10);
    CHECK(s[0] == 1);
    CHECK(std::count(s.begin(), s.end(), 1) == 1);
    CHECK(std::count(s.begin(), s.end(), 2) == 3);
    CHECK(std::count(s.begin(), s.end(), 3) == 3);
    CHECK(std::count(s.begin(), s.end(), 4) == 3);
    auto const full = SoakHealSlotOrder(1, 2, { 3 }, 99);
    REQUIRE(full.size() == 8);
    CHECK(full.back() == 1);
    auto const short_budget = SoakHealSlotOrder(1, 2, { 3, 4 }, 4);
    REQUIRE(short_budget.size() == 4);
    CHECK(short_budget[0] == 1);
    CHECK(short_budget[1] == 2);
    CHECK(short_budget[2] == 3);
    CHECK(short_budget[3] == 4);
    CHECK(SoakHealSlotOrder(0, 0, {}, 5).empty());
}

TEST_CASE("held tanks first: the tanks a mob hits take the healer slots before the waiting ones", "[classic][heal]")
{
    // naxx_horsemen af52-1: main 1 holds Mograine, off tank 2 waits, 3/5/8 hold the other three, 4/6/7 wait; 8 slots
    auto const holds = [](uint64_t t) { return t == 1 || t == 3 || t == 5 || t == 8; };
    auto const [off, spares] = HeldTanksFirst(2, { 3, 4, 5, 6, 7, 8 }, holds);
    CHECK(off == 0);
    REQUIRE(spares.size() == 7);
    CHECK(spares[0] == 3);
    CHECK(spares[1] == 5);
    CHECK(spares[2] == 8);
    CHECK(spares[3] == 2);
    auto const s = HealSlotOrder(1, off, spares, 8);
    REQUIRE(s.size() == 8);
    CHECK(std::count(s.begin(), s.end(), 1) == 2);
    for (uint64_t t : { 3, 5, 8 })
        CHECK(std::count(s.begin(), s.end(), t) == 1);
    CHECK(std::count(s.begin(), s.end(), 2) == 1);
    CHECK(std::count(s.begin(), s.end(), 7) == 0);
}

TEST_CASE("held tanks first: nothing changes while no spare holds a mob or the off tank holds one", "[classic][heal]")
{
    auto const none = [](uint64_t) { return false; };
    auto const [off1, spares1] = HeldTanksFirst(2, { 3, 4 }, none);
    CHECK(off1 == 2);
    CHECK(spares1 == std::vector<uint64_t>{ 3, 4 });
    auto const offHolds = [](uint64_t t) { return t == 2 || t == 4; };
    auto const [off2, spares2] = HeldTanksFirst(2, { 3, 4 }, offHolds);
    CHECK(off2 == 2);
    CHECK(spares2 == std::vector<uint64_t>{ 4, 3 });
}
