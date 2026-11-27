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

#ifndef TRINITYCORE_AUTO_RESTART_SCHEDULE_H
#define TRINITYCORE_AUTO_RESTART_SCHEDULE_H

#include "Define.h"
#include "Util.h"
#include <algorithm>
#include <cstdio>
#include <ctime>
#include <optional>
#include <string>

// ServerAutoShutdown.*: when the next scheduled restart is and when its countdown starts. Worked out once when the world starts;
// the restarted process works out the one after. Server local time, daylight saving included.
// After Sakhwoow/WoWForever a5c2b04dcb (GPL-2.0, from their AzerothLegionCore).
namespace Trinity::AutoRestart
{
struct TimeOfDay
{
    uint32 Hour = 0;
    uint32 Minute = 0;
    uint32 Second = 0;
};

struct Plan
{
    time_t RestartAt = 0;
    time_t AnnounceAt = 0;      // when the countdown starts
    uint32 AnnounceSeconds = 0; // the countdown's length: RestartAt - AnnounceAt
};

// "HH:MM:SS"; nothing for anything else
inline std::optional<TimeOfDay> ParseTimeOfDay(std::string const& text)
{
    TimeOfDay time;
    char trailing;
    if (std::sscanf(text.c_str(), "%u:%u:%u%c", &time.Hour, &time.Minute, &time.Second, &trailing) != 3)
        return std::nullopt;

    if (time.Hour > 23 || time.Minute > 59 || time.Second > 59)
        return std::nullopt;

    return time;
}

// The next restart at `time` after `now`: on `weekday` (0 = Sunday ... 6 = Saturday) when it is one, else today if the time is
// still ahead or `everyDays` days from today. A restart less than 10 seconds away moves one cycle on, so a process that starts
// right at its restart time does not restart again at once. The countdown starts `preAnnounceSeconds` before the restart, or at
// once (now + 1) with whatever is left when the restart is closer than that.
inline Plan PlanNext(time_t now, TimeOfDay time, int32 weekday, uint32 everyDays, uint32 preAnnounceSeconds)
{
    bool const useWeekday = weekday >= 0 && weekday <= 6;
    int32 const cycleDays = useWeekday ? 7 : int32(std::max<uint32>(everyDays, 1));

    tm today;
    localtime_r(&now, &today);

    // a date plus a wall clock time; mktime decides whether daylight saving is in force on that date (tm_isdst = -1), so a
    // restart planned across a clock change still lands on its hour
    auto at = [&](int32 addDays)
    {
        tm day = today;
        day.tm_mday += addDays;
        day.tm_hour = int32(time.Hour);
        day.tm_min = int32(time.Minute);
        day.tm_sec = int32(time.Second);
        day.tm_isdst = -1;
        return mktime(&day);
    };

    int32 days = useWeekday ? (weekday - today.tm_wday + 7) % 7 : 0;
    time_t restartAt = at(days);
    if (restartAt <= now)
        restartAt = at(days += cycleDays);
    if (restartAt - now < 10)
        restartAt = at(days += cycleDays);

    Plan plan;
    plan.RestartAt = restartAt;
    uint32 const left = uint32(restartAt - now);
    if (left > preAnnounceSeconds)
    {
        plan.AnnounceSeconds = preAnnounceSeconds;
        plan.AnnounceAt = restartAt - time_t(preAnnounceSeconds);
    }
    else
    {
        plan.AnnounceAt = now + 1;
        plan.AnnounceSeconds = uint32(restartAt - plan.AnnounceAt);
    }
    return plan;
}
}

#endif // TRINITYCORE_AUTO_RESTART_SCHEDULE_H
