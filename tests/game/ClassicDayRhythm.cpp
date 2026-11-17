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

#include "../../src/modules/PlayerbotV2/Fleet/DayRhythm.h"
#include "DayCycle.h"

using namespace Playerbot::V2::Fleet;

TEST_CASE("The night is quiet, the evening is busy", "[ClassicDayRhythm]")
{
    CHECK(RhythmPercent(3) == 60);
    CHECK(RhythmPercent(12) == 100);
    CHECK(RhythmPercent(20) == 125);
    CHECK(RhythmPercent(23) == 80);
    CHECK(RhythmPercent(-1) == 100);
    CHECK(RhythmPercent(24) == 100);
}

TEST_CASE("The target follows the hour but never passes the world cap", "[ClassicDayRhythm]")
{
    CHECK(RhythmTarget(60, 3, 220) == 36);
    CHECK(RhythmTarget(60, 20, 220) == 75);
    CHECK(RhythmTarget(200, 20, 220) == 220);   // 250 capped
    CHECK(RhythmTarget(1, 3, 220) == 1);        // a nonzero target stays nonzero
    CHECK(RhythmTarget(0, 20, 220) == 0);
}

// The sky's clock (game/Time/DayCycle.h, Forever.DayCycle.Speed and .time): here with the bots' day rhythm, both are about the hour.
TEST_CASE("At speed 1 the sky shows the realm's own time of day", "[ClassicDayCycle]")
{
    using namespace DayCycle;
    // 2026-11-14 08:51:30 on the realm's wall clock
    int64 const t = 1794646290;
    SkyClock c = ShownClock(t, 1, SkyMode::Auto);
    CHECK(c.Hour == 8);
    CHECK(c.Minute == 51);
    CHECK(c.Speed == NormalSpeed);
    c = ShownClock(t - 8 * 3600 - 51 * 60 - 30, 1, SkyMode::Auto);   // midnight
    CHECK(c.Hour == 0);
    CHECK(c.Minute == 0);
}

TEST_CASE("A faster sky runs speed times as fast and goes on without a jump at midnight", "[ClassicDayCycle]")
{
    using namespace DayCycle;
    int64 const midnight = 1794614400;   // 2026-11-14 00:00:00
    SkyClock c = ShownClock(midnight + 6 * 3600, 2, SkyMode::Auto);   // 06:00 real at 2x: noon
    CHECK(c.Hour == 12);
    CHECK(c.Minute == 0);
    CHECK(c.Speed == NormalSpeed * 2.0f);
    c = ShownClock(midnight + 4 * 3600, 3, SkyMode::Auto);            // 04:00 real at 3x: noon
    CHECK(c.Hour == 12);
    c = ShownClock(midnight + 12 * 3600 + 20 * 60, 2, SkyMode::Auto); // 12:20 real at 2x: 00:40 of the second day
    CHECK(c.Hour == 0);
    CHECK(c.Minute == 40);
    // the last minute before the real midnight and the first after it: 23:58 and 00:00 at 2x
    c = ShownClock(midnight - 60, 2, SkyMode::Auto);
    CHECK(c.Hour == 23);
    CHECK(c.Minute == 58);
    c = ShownClock(midnight, 2, SkyMode::Auto);
    CHECK(c.Hour == 0);
    CHECK(c.Minute == 0);
    // 24x: a day in an hour
    c = ShownClock(midnight + 30 * 60, 24, SkyMode::Auto);
    CHECK(c.Hour == 12);
}

TEST_CASE("Every player sees the same sky: the clock depends on the time alone", "[ClassicDayCycle]")
{
    using namespace DayCycle;
    for (int64 t : { int64(0), int64(1794614400), int64(1794646290), int64(-3600) })
        for (uint32 s : { 1u, 2u, 3u, 24u })
        {
            SkyClock a = ShownClock(t, s, SkyMode::Auto), b = ShownClock(t, s, SkyMode::Auto);
            CHECK(a.Hour == b.Hour);
            CHECK(a.Minute == b.Minute);
            CHECK(a.Hour >= 0);
            CHECK(a.Hour < 24);
            CHECK(a.Minute >= 0);
            CHECK(a.Minute < 60);
        }
}

TEST_CASE(".time day and .time night keep noon and midnight, still", "[ClassicDayCycle]")
{
    using namespace DayCycle;
    SkyClock c = ShownClock(1794646290, 3, SkyMode::Day);
    CHECK(c.Hour == 12);
    CHECK(c.Minute == 0);
    CHECK(c.Speed == 0.0f);
    c = ShownClock(1794646290, 1, SkyMode::Night);
    CHECK(c.Hour == 0);
    CHECK(c.Minute == 0);
    CHECK(c.Speed == 0.0f);
}

TEST_CASE("A speed out of range and an unknown saved mode are read safely", "[ClassicDayCycle]")
{
    using namespace DayCycle;
    CHECK(ShownClock(1794646290, 0, SkyMode::Auto).Speed == NormalSpeed);
    CHECK(ShownClock(1794646290, 100, SkyMode::Auto).Speed == NormalSpeed * float(MaxSpeed));
    CHECK(SkyModeFromDb(0) == SkyMode::Auto);
    CHECK(SkyModeFromDb(1) == SkyMode::Day);
    CHECK(SkyModeFromDb(2) == SkyMode::Night);
    CHECK(SkyModeFromDb(7) == SkyMode::Auto);
}

TEST_CASE(".time day and .time night also put a fixed light over the map, .time auto none", "[ClassicDayCycle]")
{
    using namespace DayCycle;
    static_assert(OverrideLightFor(SkyMode::Day) == DayLightID);
    static_assert(OverrideLightFor(SkyMode::Night) == NightLightID);
    static_assert(OverrideLightFor(SkyMode::Auto) == 0);
    CHECK(DayLightID != NightLightID);
    CHECK(OverrideLightFor(SkyModeFromDb(7)) == 0);
}
