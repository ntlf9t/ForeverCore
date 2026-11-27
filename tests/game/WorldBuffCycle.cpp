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

#include "../../src/server/game/World/WorldBuffCycle.h"

using namespace Trinity::WorldBuffs;

namespace
{
constexpr uint32 Minutes(uint32 minutes) { return minutes * MinuteMs; }

// the shape classic_world_buffs.cpp uses: two city buffs at the start, Spirit of Zandalar 10 minutes later
Cycle MakeCycle()
{
    Cycle cycle({ 0, 0, Minutes(10) });
    cycle.SetWarningLead(Minutes(10));
    return cycle;
}
}

TEST_CASE("World buff cycle: ranges", "[WorldBuffs]")
{
    CHECK(NormalizeRange(30, 150) == std::pair<uint32, uint32>(30, 150));
    CHECK(NormalizeRange(150, 30) == std::pair<uint32, uint32>(30, 150));
    CHECK(NormalizeRange(0, 0) == std::pair<uint32, uint32>(1, 1));
    CHECK(NormalizeRange(0, 5) == std::pair<uint32, uint32>(1, 5));
}

TEST_CASE("World buff cycle: placeholders", "[WorldBuffs]")
{
    CHECK(FillPlaceholder("{player} and {player}", "{player}", "Aldren") == "Aldren and Aldren");
    // a value holding the token is not replaced again
    CHECK(FillPlaceholder("{player}", "{player}", "{player}!") == "{player}!");
    CHECK(FillPlaceholder("no tokens", "{time}", "20:35") == "no tokens");
    CHECK(FormatMinutes(1) == "1 minute");
    CHECK(FormatMinutes(10) == "10 minutes");
}

TEST_CASE("World buff cycle: warns, fires, then waits for a new cycle", "[WorldBuffs]")
{
    Cycle cycle = MakeCycle();
    CHECK_FALSE(cycle.InFlight());
    cycle.Arm(Minutes(30), false);
    CHECK(cycle.InFlight());
    CHECK(cycle.TimeToFire(0) == Minutes(30));
    CHECK(cycle.TimeToFire(2) == Minutes(40));

    // nothing until the city buffs are 10 minutes out
    CHECK(cycle.Update(Minutes(19)).empty());

    std::vector<Step> steps = cycle.Update(Minutes(1));
    REQUIRE(steps.size() == 2);
    CHECK(steps[0].Buff == 0);
    CHECK(steps[0].Type == StepType::Warn);
    CHECK(steps[0].RemainingMs == Minutes(10));
    CHECK(steps[1].Buff == 1);
    CHECK(steps[1].Type == StepType::Warn);

    // the heads-up goes out once
    CHECK(cycle.Update(Minutes(9)).empty());

    // the city buffs fire as Zandalar's heads-up goes out
    steps = cycle.Update(Minutes(1));
    REQUIRE(steps.size() == 3);
    CHECK((steps[0].Buff == 0 && steps[0].Type == StepType::Fire));
    CHECK((steps[1].Buff == 1 && steps[1].Type == StepType::Fire));
    CHECK((steps[2].Buff == 2 && steps[2].Type == StepType::Warn && steps[2].RemainingMs == Minutes(10)));
    CHECK(cycle.InFlight());

    steps = cycle.Update(Minutes(10));
    REQUIRE(steps.size() == 1);
    CHECK((steps[0].Buff == 2 && steps[0].Type == StepType::Fire));
    CHECK_FALSE(cycle.InFlight());
    CHECK(cycle.Update(Minutes(500)).empty());
}

TEST_CASE("World buff cycle: the next cycle counts from the last start", "[WorldBuffs]")
{
    Cycle cycle = MakeCycle();
    // the last cycle started 10 minutes ago (Zandalar's offset), so a 60 minute gap leaves 50 minutes
    cycle.Arm(Minutes(60), true);
    CHECK(cycle.TimeToFire(0) == Minutes(50));
    CHECK(cycle.TimeToFire(2) == Minutes(60));

    // a gap shorter than the tail is held at a minute
    cycle.Arm(Minutes(5), true);
    CHECK(cycle.TimeToFire(0) == Minutes(1));
    CHECK(cycle.TimeToFire(2) == Minutes(11));

    // switching Zandalar off removes the tail
    cycle.SetEnabled(2, false);
    CHECK(cycle.TailMs() == 0);
    cycle.Arm(Minutes(60), true);
    CHECK(cycle.TimeToFire(0) == Minutes(60));
    CHECK(cycle.TimeToFire(2) == 0);
}

TEST_CASE("World buff cycle: short timers and switched-off buffs", "[WorldBuffs]")
{
    Cycle cycle = MakeCycle();
    cycle.SetEnabled(1, false);
    cycle.SetEnabled(2, false);
    cycle.SetWarningLead(30 * 1000);
    cycle.Arm(Minutes(1), false);

    // under a minute left when the heads-up would go out: no heads-up, the buff still fires
    CHECK(cycle.Update(30 * 1000).empty());
    std::vector<Step> steps = cycle.Update(30 * 1000);
    REQUIRE(steps.size() == 1);
    CHECK((steps[0].Buff == 0 && steps[0].Type == StepType::Fire));
    CHECK_FALSE(cycle.InFlight());

    // no heads-up at all with a lead of 0
    cycle.SetWarningLead(0);
    cycle.Arm(Minutes(30), false);
    CHECK(cycle.Update(Minutes(29)).empty());
    CHECK(cycle.Update(Minutes(1)).size() == 1);

    // nothing enabled: nothing ever fires
    cycle.SetEnabled(0, false);
    CHECK_FALSE(cycle.AnyEnabled());
    cycle.Arm(Minutes(30), false);
    CHECK_FALSE(cycle.InFlight());
    CHECK(cycle.Update(Minutes(60)).empty());
}
