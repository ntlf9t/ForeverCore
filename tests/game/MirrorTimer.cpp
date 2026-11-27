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
#include "MirrorTimer.h"

// TrinityCore 270f1397ac + 34cd48e6f9: the breath and fatigue bars (and feign death) run in MirrorTimer. Player::UpdateMirrorTimers
// deals drowning or fatigue damage on every ExpiredTicked and sends SMSG_START_MIRROR_TIMER whenever IsChanged(). The numbers
// are TrinityCore's (breath 3 minutes; Everlake now uses vanilla's 1 minute), fatigue 1 minute; scale -1 = running out, 10 = refilling.

using UpdateResult = MirrorTimer::UpdateResult;

TEST_CASE("Breath runs out, then ticks once a second", "[MirrorTimer]")
{
    MirrorTimer breath;
    breath.SetScale(-1);                        // under water
    breath.Start(180000, 0);
    REQUIRE(breath.IsActive());
    CHECK(breath.IsChanged());                  // the client gets the bar
    breath.ClearChanged();

    CHECK(breath.Update(1000) == UpdateResult::Decreased);
    CHECK(breath.GetValue() == 179000);

    // the bar empties: the first drowning tick comes at once
    CHECK(breath.Update(179000) == UpdateResult::ExpiredTicked);
    CHECK(breath.GetValue() == 0);

    // then one tick per second, not one per update
    CHECK(breath.Update(500) == UpdateResult::DecreasedExpired);
    CHECK(breath.Update(500) == UpdateResult::ExpiredTicked);
    CHECK(breath.Update(400) == UpdateResult::DecreasedExpired);
    CHECK(breath.Update(600) == UpdateResult::ExpiredTicked);
    CHECK_FALSE(breath.IsChanged());            // ticking does not resend the bar
}

TEST_CASE("Surfacing refills the bar ten times as fast and then stops it", "[MirrorTimer]")
{
    MirrorTimer breath;
    breath.SetScale(-1);
    breath.Start(180000, 0);
    CHECK(breath.Update(60000) == UpdateResult::Decreased);     // 120 s left
    breath.ClearChanged();

    breath.SetScale(10);                        // above water
    CHECK(breath.IsChanged());                  // the client gets the refilling bar
    CHECK(breath.Update(3000) == UpdateResult::Regenerated);
    CHECK(breath.GetValue() == 150000);
    CHECK(breath.IsActive());

    CHECK(breath.Update(3000) == UpdateResult::Regenerated);    // full: the bar goes away
    CHECK_FALSE(breath.IsActive());
    CHECK(breath.Update(1000) == UpdateResult::Inactive);
}

TEST_CASE("Water breathing: the breath bar does not start", "[MirrorTimer]")
{
    // UpdateLiquidMirrorTimerFlagsOnPositionChange sets scale 10 under water while SPELL_AURA_WATER_BREATHING is on
    MirrorTimer breath;
    breath.SetScale(10);
    breath.Start(180000, 0);
    CHECK_FALSE(breath.IsActive());
}

TEST_CASE("A longer breath (MOD_WATER_BREATHING) keeps the air already used", "[MirrorTimer]")
{
    // Player::UpdateLiquidMirrorTimerValuesOnAura: max and value move by the same amount
    MirrorTimer breath;
    breath.SetScale(-1);
    breath.Start(180000, 0);
    breath.Update(30000);
    breath.SetMaxValue(720000);                 // Undead Underwater Breathing 5227: +300%
    breath.SetValue(breath.GetValue() + (720000 - 180000));
    CHECK(breath.GetMaxValue() == 720000);
    CHECK(breath.GetValue() == 690000);
}

TEST_CASE("Fatigue: a minute, then damage", "[MirrorTimer]")
{
    MirrorTimer fatigue;
    fatigue.SetScale(-1);                       // dark water
    fatigue.Start(60000, 0);
    CHECK(fatigue.Update(59999) == UpdateResult::Decreased);
    CHECK(fatigue.Update(1) == UpdateResult::ExpiredTicked);
}
