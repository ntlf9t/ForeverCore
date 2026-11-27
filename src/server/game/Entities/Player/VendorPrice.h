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

#ifndef TRINITYCORE_VENDOR_PRICE_H
#define TRINITYCORE_VENDOR_PRICE_H

#include "Define.h"
#include "Optional.h"
#include "SharedDefines.h"
#include <limits>

// The sums a vendor purchase is checked and paid with, apart from the Player so they can be tested.
namespace Trinity::VendorPrice
{
// Copper for `count` items sold `buyCount` to a stack at `stackPrice` the stack. Whole stacks cost exactly the stack price
// and part of a stack (a few arrows of 200) rounds up to the next copper, never down to nothing.
inline uint64 ForItems(uint64 stackPrice, uint32 buyCount, uint32 count)
{
    if (!buyCount)
        buyCount = 1;

    uint64 const wholeStacks = count / buyCount;
    uint64 const rest = count % buyCount;
    return wholeStacks * stackPrice + (rest * stackPrice + buyCount - 1) / buyCount;
}

// Copper for `count` of a currency at `pricePerUnit` each; nothing when it would pass `maxMoney`, so the sum can never wrap.
inline Optional<uint64> ForCurrency(uint64 pricePerUnit, uint32 count, uint64 maxMoney)
{
    if (pricePerUnit && count > maxMoney / pricePerUnit)
        return {};

    return pricePerUnit * count;
}

// Items or currency to hand in for `stacks` stacks at `perStack` each; nothing when it does not fit in 32 bits. The product
// in 32 bits wrapped round for a large purchase, to 0 at worst, and the turn-in check then passed with nothing in the bags.
inline Optional<uint32> TurnInCount(uint32 perStack, uint32 stacks)
{
    uint64 const needed = uint64(perStack) * stacks;
    if (needed > std::numeric_limits<uint32>::max())
        return {};

    return uint32(needed);
}

// WoW Forever's reputation discount, as live vendors and trainers show it (EG Link prices, build 70862): the neutral price up
// to Friendly, 10% off from Honored. Vanilla 1.12 gave the same 10% at Honored, Revered and Exalted. The retail rule was 5% per
// rank above Neutral (5% at Friendly up to 20% at Exalted).
inline float ReputationDiscount(ReputationRank rank)
{
    return rank >= REP_HONORED ? 0.9f : 1.0f;
}
}

#endif // TRINITYCORE_VENDOR_PRICE_H
