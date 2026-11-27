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

#ifndef TRINITY_HOLIDAY_STAGE_LENGTH_H
#define TRINITY_HOLIDAY_STAGE_LENGTH_H

#include <cstddef>
#include <cstdint>
#include <iterator>

namespace Trinity::Holiday
{
    /// The length in minutes of one stage of a holiday on dated days: the client's duration for that stage (hours) when
    /// it gives one, else the length the game_event row holds. WoW: Forever's Noblegarden (Holidays 181) has a date for
    /// every year but no duration: without this its event dropped the client's dates and stayed on the row's fixed
    /// yearly start, which drifts from Easter.
    template <typename Durations>
    inline uint32_t StageLengthMinutes(Durations const& durationHours, uint8_t stageIndex, uint32_t rowLengthMinutes)
    {
        if (std::size_t(stageIndex) < std::size(durationHours) && durationHours[stageIndex])
            return uint32_t(durationHours[stageIndex]) * 60u;
        return rowLengthMinutes;
    }
}

#endif // TRINITY_HOLIDAY_STAGE_LENGTH_H
