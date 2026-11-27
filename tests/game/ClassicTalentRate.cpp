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
#include "DB2Structure.h"
#include "TraitMgr.h"
#include <numeric>

// advocaite/TrinityCore#319 Rate.Talent. Rows are the Forever client's TraitCurrencySource for the class talent currency 3820
// (build 70862): one point at each level 10-60 (51 rows), and five Talented rows (37163-37167, levels 9..5, each behind a
// Talented node entry).
namespace
{
    std::vector<int32> const LevelRows(51, 1);

    int32 Sum(std::vector<int32> const& points) { return std::accumulate(points.begin(), points.end(), 0); }

    TraitCurrencySourceEntry Row(int32 playerLevel, int32 traitNodeEntryId = 0, int32 questId = 0)
    {
        TraitCurrencySourceEntry source{};
        source.TraitCurrencyID = 3820;
        source.Amount = 1;
        source.PlayerLevel = playerLevel;
        source.TraitNodeEntryID = traitNodeEntryId;
        source.QuestID = questId;
        return source;
    }
}

TEST_CASE("Rate.Talent 1 leaves every level row at one point", "[ClassicTalentRate]")
{
    CHECK(TraitMgr::ScaleClassicTalentLevelPoints(LevelRows, 1.0f) == LevelRows);
}

TEST_CASE("Rate.Talent hands points out level by level", "[ClassicTalentRate]")
{
    std::vector<int32> const doubled = TraitMgr::ScaleClassicTalentLevelPoints(LevelRows, 2.0f);
    CHECK(doubled == std::vector<int32>(51, 2));
    CHECK(Sum(doubled) == 102);

    std::vector<int32> const half = TraitMgr::ScaleClassicTalentLevelPoints(LevelRows, 1.5f);
    REQUIRE(half.size() == 51);
    CHECK(half[0] == 1);    // level 10: 1.5 -> 1
    CHECK(half[1] == 2);    // level 11: 3.0 -> 3 in all
    CHECK(half[2] == 1);    // level 12: 4.5 -> 4 in all
    CHECK(Sum(half) == 76); // round-down(51 x 1.5)

    std::vector<int32> const lower = TraitMgr::ScaleClassicTalentLevelPoints(LevelRows, 0.5f);
    CHECK(lower[0] == 0);
    CHECK(lower[1] == 1);
    CHECK(Sum(lower) == 25);
}

TEST_CASE("Rate.Talent leaves the Legacy perk Talented rows alone", "[ClassicTalentRate]")
{
    // The server adds Talented's points itself, one a level and never multiplied; scaling these rows only for the client made
    // the talent window offer more points than the server accepts.
    for (auto [level, nodeEntry] : { std::pair{9, 136852}, {8, 137374}, {7, 137373}, {6, 137372}, {5, 137371} })
    {
        INFO("Talented row for level " << level);
        CHECK(TraitMgr::GetClassicTalentRateRow(Row(level, nodeEntry)) == TraitMgr::ClassicTalentRateRow::Unchanged);
    }

    CHECK(TraitMgr::GetClassicTalentRateRow(Row(10)) == TraitMgr::ClassicTalentRateRow::Level);
    CHECK(TraitMgr::GetClassicTalentRateRow(Row(60)) == TraitMgr::ClassicTalentRateRow::Level);
    CHECK(TraitMgr::GetClassicTalentRateRow(Row(0, 0, 12345)) == TraitMgr::ClassicTalentRateRow::Scaled);
    CHECK(TraitMgr::GetClassicTalentRateRow(Row(20, 0, 12345)) == TraitMgr::ClassicTalentRateRow::Scaled);
}
