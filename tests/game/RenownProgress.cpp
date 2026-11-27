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
#include "RenownProgress.h"
#include <algorithm>
#include <array>

// advocaite/TrinityCore#321: the Classic 1.60 PvP rank is the renown track of faction 2800, 14 ranks, each with its own cost
// (Forever client build 70862, CurvePoint rows of curve 103650).
namespace
{
    constexpr std::array<int32, 15> PvPRankCost = { 0, 750, 900, 1050, 1200, 1350, 1500, 1650, 1800, 1950, 2100, 2350, 2500, 2650, 3000 };
    auto const PvPRank = [](int32 level) { return PvPRankCost[std::clamp(level, 1, 14)]; };

    // the old rule: every level costs the faction's ReputationMax (20000 for faction 2800)
    struct OldResult { int32 Level; int32 Standing; };
    OldResult OldFlat(int32 level, int32 standing, int32 maxLevel, int32 threshold)
    {
        int32 total = level * threshold + standing;
        OldResult result{ total / threshold, total % threshold };
        if (result.Level >= maxLevel)
            result = { maxLevel, 0 };
        return result;
    }
}

TEST_CASE("PvP rank points reach rank 1 at 750, not at the flat 20000", "[RenownProgress]")
{
    auto rank = Trinity::RenownProgress::Walk(0, 800, 14, PvPRank);
    CHECK(rank.Level == 1);
    CHECK(rank.Standing == 50);
    CHECK(rank.Discarded == 0);

    // the old rule left 800 points at rank 0 ("800 of 20000" while the client showed rank 1)
    CHECK(OldFlat(0, 800, 14, 20000).Level == 0);

    // one battle win (250) at rank 3 with 1000 of 1200 into rank 4
    rank = Trinity::RenownProgress::Walk(3, 1000 + 250, 14, PvPRank);
    CHECK(rank.Level == 4);
    CHECK(rank.Standing == 50);
}

TEST_CASE("A large gain climbs several ranks, each at its own cost", "[RenownProgress]")
{
    // 750 + 900 + 1050 = 2700 reaches rank 3
    auto rank = Trinity::RenownProgress::Walk(0, 2700, 14, PvPRank);
    CHECK(rank.Level == 3);
    CHECK(rank.Standing == 0);

    // rank 14 needs 24750 in all; the rest is discarded
    rank = Trinity::RenownProgress::Walk(0, 24750 + 400, 14, PvPRank);
    CHECK(rank.Level == 14);
    CHECK(rank.Standing == 0);
    CHECK(rank.Discarded == 400);

    rank = Trinity::RenownProgress::Walk(13, 2999, 14, PvPRank);
    CHECK(rank.Level == 13);
    CHECK(rank.Standing == 2999);
}

TEST_CASE("A loss walks down the ranks and stops at rank 0", "[RenownProgress]")
{
    // rank 2 with 100 into rank 3, minus 1000: back to rank 1 with 100 + 900 - 1000 = 0
    auto rank = Trinity::RenownProgress::Walk(2, 100 - 1000, 14, PvPRank);
    CHECK(rank.Level == 1);
    CHECK(rank.Standing == 0);

    rank = Trinity::RenownProgress::Walk(1, 10 - 5000, 14, PvPRank);
    CHECK(rank.Level == 0);
    CHECK(rank.Standing == 0);
    CHECK(rank.Discarded == 10 + 750 - 5000);
}

TEST_CASE("A track with one cost per level moves as before", "[RenownProgress]")
{
    auto const flat = [](int32) { return 2500; };
    for (auto [level, standing] : { std::pair{0, 0}, {0, 2499}, {0, 2500}, {3, 7600}, {10, 1000}, {19, 3000} })
    {
        INFO("level " << level << " standing " << standing);
        auto rank = Trinity::RenownProgress::Walk(level, standing, 20, flat);
        OldResult old = OldFlat(level, standing, 20, 2500);
        CHECK(rank.Level == old.Level);
        CHECK(rank.Standing == old.Standing);
    }
}
