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

#include "../../src/server/game/World/AutoRestartSchedule.h"

#include <cstdlib>
#include <string>

using namespace Trinity::AutoRestart;

namespace
{
// Toronto's rules as a POSIX TZ string (no tz database needed): EST, EDT from the second Sunday of March to the first of November
class TorontoTime
{
public:
    TorontoTime()
    {
        if (char const* tz = std::getenv("TZ"))
            _old = tz, _had = true;
        Set("EST5EDT,M3.2.0,M11.1.0");
    }
    ~TorontoTime() { _had ? Set(_old.c_str()) : Unset(); }

private:
    static void Set(char const* tz)
    {
#ifdef _WIN32
        _putenv_s("TZ", tz);
        _tzset();
#else
        setenv("TZ", tz, 1);
        tzset();
#endif
    }
    static void Unset()
    {
#ifdef _WIN32
        _putenv_s("TZ", "");
        _tzset();
#else
        unsetenv("TZ");
        tzset();
#endif
    }

    std::string _old;
    bool _had = false;
};

time_t Local(int year, int month, int day, int hour, int minute, int second = 0)
{
    tm t = {};
    t.tm_year = year - 1900;
    t.tm_mon = month - 1;
    t.tm_mday = day;
    t.tm_hour = hour;
    t.tm_min = minute;
    t.tm_sec = second;
    t.tm_isdst = -1;
    return mktime(&t);
}

tm LocalTm(time_t t)
{
    tm result;
    localtime_r(&t, &result);
    return result;
}

constexpr TimeOfDay FourAm = { 4, 0, 0 };
}

TEST_CASE("Restart times are HH:MM:SS", "[AutoRestartSchedule]")
{
    REQUIRE(ParseTimeOfDay("04:00:00").has_value());
    CHECK(ParseTimeOfDay("23:59:59")->Hour == 23);
    CHECK(ParseTimeOfDay("4:05:09")->Minute == 5);
    CHECK_FALSE(ParseTimeOfDay("").has_value());
    CHECK_FALSE(ParseTimeOfDay("04:00").has_value());
    CHECK_FALSE(ParseTimeOfDay("24:00:00").has_value());
    CHECK_FALSE(ParseTimeOfDay("04:60:00").has_value());
    CHECK_FALSE(ParseTimeOfDay("04:00:00 pm").has_value());
}

TEST_CASE("A daily restart is today while its time is ahead, else tomorrow", "[AutoRestartSchedule]")
{
    TorontoTime toronto;

    Plan early = PlanNext(Local(2026, 11, 16, 1, 0), FourAm, -1, 1, 3600);
    CHECK(early.RestartAt == Local(2026, 11, 16, 4, 0));
    CHECK(early.AnnounceAt == Local(2026, 11, 16, 3, 0));
    CHECK(early.AnnounceSeconds == 3600);

    Plan late = PlanNext(Local(2026, 11, 16, 5, 0), FourAm, -1, 1, 3600);
    CHECK(late.RestartAt == Local(2026, 11, 17, 4, 0));

    // every 3 days: once today's time has passed, 3 days on
    CHECK(PlanNext(Local(2026, 11, 16, 5, 0), FourAm, -1, 3, 3600).RestartAt == Local(2026, 11, 19, 4, 0));
}

TEST_CASE("A process started at its restart time does not restart again at once", "[AutoRestartSchedule]")
{
    TorontoTime toronto;
    // 5 seconds before 04:00: too close, the next day's
    CHECK(PlanNext(Local(2026, 11, 16, 3, 59, 55), FourAm, -1, 1, 3600).RestartAt == Local(2026, 11, 17, 4, 0));
    // right at 04:00 (the restarted process): tomorrow
    CHECK(PlanNext(Local(2026, 11, 16, 4, 0, 0), FourAm, -1, 1, 3600).RestartAt == Local(2026, 11, 17, 4, 0));
}

TEST_CASE("A weekday restart waits for its day", "[AutoRestartSchedule]")
{
    TorontoTime toronto;
    // 2026-11-16 is a Monday; Wednesday is 3
    CHECK(PlanNext(Local(2026, 11, 16, 12, 0), FourAm, 3, 1, 3600).RestartAt == Local(2026, 11, 18, 4, 0));
    // Monday, before the time: today; after it: next Monday
    CHECK(PlanNext(Local(2026, 11, 16, 1, 0), FourAm, 1, 1, 3600).RestartAt == Local(2026, 11, 16, 4, 0));
    CHECK(PlanNext(Local(2026, 11, 16, 5, 0), FourAm, 1, 1, 3600).RestartAt == Local(2026, 11, 23, 4, 0));
}

TEST_CASE("A server started inside the countdown counts down from the start", "[AutoRestartSchedule]")
{
    TorontoTime toronto;
    time_t const now = Local(2026, 11, 16, 3, 50);
    Plan plan = PlanNext(now, FourAm, -1, 1, 3600);
    CHECK(plan.RestartAt == Local(2026, 11, 16, 4, 0));
    CHECK(plan.AnnounceAt == now + 1);
    CHECK(plan.AnnounceSeconds == 599);
}

TEST_CASE("A restart planned across a clock change still lands on its hour", "[AutoRestartSchedule]")
{
#ifdef _WIN32
    SKIP("The MSVC CRT does not apply POSIX TZ transition rules used by this test");
#else
    TorontoTime toronto;

    // planned on EDT Saturday 2026-10-31 for Sunday 2026-11-01, when the clocks went back at 02:00
    Plan fallBack = PlanNext(Local(2026, 10, 31, 5, 0), FourAm, -1, 1, 3600);
    tm fallBackTm = LocalTm(fallBack.RestartAt);
    CHECK(fallBackTm.tm_mday == 1);
    CHECK(fallBackTm.tm_hour == 4);
    CHECK(fallBackTm.tm_min == 0);
    CHECK(fallBack.RestartAt - Local(2026, 10, 31, 5, 0) == 24 * 3600);   // 23 wall hours, plus the hour repeated

    // planned on EST Saturday 2026-03-07 for Sunday 2026-03-08, when the clocks went forward at 02:00
    Plan springForward = PlanNext(Local(2026, 3, 7, 5, 0), FourAm, -1, 1, 3600);
    tm springTm = LocalTm(springForward.RestartAt);
    CHECK(springTm.tm_mday == 8);
    CHECK(springTm.tm_hour == 4);
    CHECK(springForward.RestartAt - Local(2026, 3, 7, 5, 0) == 22 * 3600);
#endif
}
