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
#include "Player.h"
#include "VendorPrice.h"
#include <limits>

using namespace Trinity::VendorPrice;

TEST_CASE("Whole stacks cost exactly the stack price", "[VendorPrice]")
{
    CHECK(ForItems(10, 200, 200) == 10);
    CHECK(ForItems(10, 200, 1000) == 50);
    CHECK(ForItems(2500, 1, 1) == 2500);
    CHECK(ForItems(2500, 1, 20) == 50000);
    CHECK(ForItems(7, 3, 3) == 7);
}

TEST_CASE("Part of a stack rounds up to the next copper, never down to nothing", "[VendorPrice]")
{
    // arrows: 10 copper for 200
    CHECK(ForItems(10, 200, 1) == 1);
    CHECK(ForItems(10, 200, 20) == 1);
    CHECK(ForItems(10, 200, 21) == 2);
    CHECK(ForItems(10, 200, 199) == 10);
    CHECK(ForItems(10, 200, 201) == 11);
    // a price that does not divide by the stack: 7 copper for 3, so 1 costs 3 (2.33 rounded up) and 4 costs 10
    CHECK(ForItems(7, 3, 1) == 3);
    CHECK(ForItems(7, 3, 4) == 10);
}

TEST_CASE("A stack size of 0 counts as 1", "[VendorPrice]")
{
    CHECK(ForItems(10, 0, 3) == 30);
}

TEST_CASE("The largest purchase the money cap allows does not overflow", "[VendorPrice]")
{
    // BuyItemFromVendorSlot caps the count at MAX_MONEY_AMOUNT worth before it prices it
    uint32 const count = std::numeric_limits<uint32>::max();
    CHECK(ForItems(1, 1, count) == count);
    CHECK(ForItems(23, 1000, count) == (uint64(count) / 1000) * 23 + ((uint64(count) % 1000) * 23 + 999) / 1000);
}

TEST_CASE("Currency is priced per unit and refused past the money cap", "[VendorPrice]")
{
    CHECK(ForCurrency(100, 50, MAX_MONEY_AMOUNT) == uint64(5000));
    CHECK(ForCurrency(0, std::numeric_limits<uint32>::max(), MAX_MONEY_AMOUNT) == uint64(0));

    // exactly the cap is allowed, one unit more is not
    CHECK(ForCurrency(MAX_MONEY_AMOUNT, 1, MAX_MONEY_AMOUNT) == MAX_MONEY_AMOUNT);
    CHECK_FALSE(ForCurrency(MAX_MONEY_AMOUNT, 2, MAX_MONEY_AMOUNT).has_value());
    CHECK_FALSE(ForCurrency(10000, std::numeric_limits<uint32>::max(), MAX_MONEY_AMOUNT).has_value());

    // a price that would wrap 64 bits is refused, not wrapped to a small sum
    CHECK_FALSE(ForCurrency(std::numeric_limits<uint64>::max() / 2, 4, std::numeric_limits<uint64>::max()).has_value());
}

TEST_CASE("Turn-in counts that do not fit in 32 bits are refused, not wrapped", "[VendorPrice]")
{
    CHECK(TurnInCount(5, 3) == uint32(15));
    CHECK(TurnInCount(0, std::numeric_limits<uint32>::max()) == uint32(0));
    CHECK(TurnInCount(1, std::numeric_limits<uint32>::max()) == std::numeric_limits<uint32>::max());

    // 2 x 2^31 is 2^32: in 32 bits it wrapped to 0, and HasItemCount(item, 0) passed with nothing in the bags
    CHECK_FALSE(TurnInCount(2, 0x80000000u).has_value());
    CHECK_FALSE(TurnInCount(std::numeric_limits<uint16>::max(), 65538).has_value());
    CHECK_FALSE(TurnInCount(std::numeric_limits<uint32>::max(), 2).has_value());
}

TEST_CASE("Reputation discount: full price up to Friendly, 10% off from Honored", "[VendorPrice]")
{
    CHECK(ReputationDiscount(REP_HATED) == 1.0f);
    CHECK(ReputationDiscount(REP_NEUTRAL) == 1.0f);
    CHECK(ReputationDiscount(REP_FRIENDLY) == 1.0f);
    CHECK(ReputationDiscount(REP_HONORED) == 0.9f);
    CHECK(ReputationDiscount(REP_REVERED) == 0.9f);
    CHECK(ReputationDiscount(REP_EXALTED) == 0.9f);
}
