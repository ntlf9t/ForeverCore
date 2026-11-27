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
#include "Guild.h"
#include <utility>
#include <vector>

namespace
{
    using Ranks = std::vector<std::pair<GuildRankId, GuildRankOrder>>;

    Ranks MakeRanks(std::initializer_list<std::pair<uint8, uint8>> idAndOrder)
    {
        Ranks ranks;
        for (auto [id, order] : idAndOrder)
            ranks.emplace_back(GuildRankId(id), GuildRankOrder(order));
        return ranks;
    }
}

TEST_CASE("A new guild's five ranks are a valid set", "[GuildRankSet]")
{
    CHECK(IsGuildRankSetValid(MakeRanks({ { 0, 0 }, { 1, 1 }, { 2, 2 }, { 3, 3 }, { 4, 4 } })));
}

TEST_CASE("A guild that once deleted a rank still has a valid set", "[GuildRankSet]")
{
    // HandleRemoveRank deletes rank id 2 and closes the orders up: ids 0, 1, 3, 4 with orders 0, 1, 2, 3. Validate looked the
    // ranks up by id 0..3, found none for id 2 and read through the null pointer at every start.
    CHECK(IsGuildRankSetValid(MakeRanks({ { 0, 0 }, { 1, 1 }, { 3, 2 }, { 4, 3 } })));
    // the order in which the ranks were loaded does not matter
    CHECK(IsGuildRankSetValid(MakeRanks({ { 4, 3 }, { 0, 0 }, { 3, 2 }, { 1, 1 } })));
    // a rank added after a delete takes the next free id, which can be above the old count
    CHECK(IsGuildRankSetValid(MakeRanks({ { 0, 0 }, { 1, 1 }, { 3, 2 }, { 4, 3 }, { 5, 4 } })));
}

TEST_CASE("A set without the guild master rank is not valid", "[GuildRankSet]")
{
    CHECK_FALSE(IsGuildRankSetValid(MakeRanks({ { 1, 0 }, { 2, 1 }, { 3, 2 } })));
    CHECK_FALSE(IsGuildRankSetValid(Ranks{}));
}

TEST_CASE("A gap or a double in the rank order is not valid", "[GuildRankSet]")
{
    CHECK_FALSE(IsGuildRankSetValid(MakeRanks({ { 0, 0 }, { 1, 1 }, { 2, 3 } })));
    CHECK_FALSE(IsGuildRankSetValid(MakeRanks({ { 0, 0 }, { 1, 1 }, { 2, 1 } })));
    CHECK_FALSE(IsGuildRankSetValid(MakeRanks({ { 0, 1 }, { 1, 2 } })));
}
