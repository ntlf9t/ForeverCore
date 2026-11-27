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

#include "../../src/server/game/Events/HolidayStageLength.h"

#include <array>

using Trinity::Holiday::StageLengthMinutes;

TEST_CASE("A holiday stage lasts as long as the client says", "[HolidayStageLength]")
{
    std::array<uint16_t, 10> const darkmoon = { 168 };          // Forever's Darkmoon Faire (263, 264): one stage of 168 hours
    CHECK(StageLengthMinutes(darkmoon, 0, 10080) == 10080);
    CHECK(StageLengthMinutes(darkmoon, 0, 120) == 10080);       // the client wins over the row
    std::array<uint16_t, 10> const callToArms = { 168, 336 };   // a looping holiday of two stages
    CHECK(StageLengthMinutes(callToArms, 1, 0) == 336 * 60);
}

TEST_CASE("A holiday with dates but no duration keeps the game_event row's length", "[HolidayStageLength]")
{
    std::array<uint16_t, 10> const noblegarden = {};            // Forever's Noblegarden (181): a date every year, no duration
    CHECK(StageLengthMinutes(noblegarden, 0, 10080) == 10080);
    CHECK(StageLengthMinutes(noblegarden, 0, 0) == 0);          // nothing to go on: the caller logs it and keeps the row's times
    CHECK(StageLengthMinutes(noblegarden, 12, 7200) == 7200);   // a stage past the client's list
}
