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

#ifndef TRINITYCORE_RENOWN_PROGRESS_H
#define TRINITYCORE_RENOWN_PROGRESS_H

#include "Define.h"

// How a reputation change moves a renown track (advocaite/TrinityCore#321), apart from the ReputationMgr so it can be tested.
namespace Trinity::RenownProgress
{
struct Result
{
    int32 Level = 0;
    int32 Standing = 0;     // progress into the next level
    int32 Discarded = 0;    // reputation past the top level, or below level 0, that the track could not take
};

// `level` and `standing` + the change (`standing` may be negative) on a track of `maxLevel` levels; `threshold(n)` is the cost
// of reaching level n. Each level can cost a different amount (the Classic 1.60 PvP rank: RenownThresholdCurveID 103650,
// 750 for rank 1 ... 3000 for rank 14), so the levels are walked one by one.
template <typename ThresholdFn>
inline Result Walk(int32 level, int32 standing, int32 maxLevel, ThresholdFn&& threshold)
{
    Result result{ level, standing, 0 };
    while (result.Standing < 0 && result.Level > 0)
        result.Standing += threshold(result.Level--);

    if (result.Standing < 0)
    {
        result.Discarded += result.Standing;
        result.Standing = 0;
    }

    while (result.Level < maxLevel)
    {
        int32 const levelThreshold = threshold(result.Level + 1);
        if (levelThreshold <= 0 || result.Standing < levelThreshold)
            break;

        result.Standing -= levelThreshold;
        ++result.Level;
    }

    if (result.Level >= maxLevel)
    {
        result.Level = maxLevel;
        result.Discarded += result.Standing;
        result.Standing = 0;
    }

    return result;
}
}

#endif // TRINITYCORE_RENOWN_PROGRESS_H
