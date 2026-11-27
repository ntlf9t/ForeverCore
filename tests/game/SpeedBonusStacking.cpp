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

// Everlake keeps movement speed bonuses multiplicative (decision of 2026-11-09): TrinityCore a1845983e3 makes them add
// up like retail; our commit after it keeps the old rule. Examples use 70862 spells.

#include "tc_catch2.h"
#include "Unit.h"

using Catch::Matchers::WithinAbs;

TEST_CASE("A stacking mount bonus multiplies the mount speed", "[SpeedBonusStacking]")
{
    // 100% mount (aura 32) with Mithril Spurs +4% (aura 130, stacking): 2.0 x 1.04, not 1 + 1.00 + 0.04
    CHECK_THAT(Unit::CombineSpeedBonuses(100.0f, 1.04f, 1.0f), WithinAbs(2.08, 1e-5));
}

TEST_CASE("Stacking and non-stacking bonuses: the larger one counts", "[SpeedBonusStacking]")
{
    // 100% mount, Mithril Spurs +4% (stacking) and Pursuit of Justice +15% (aura 172, not stacking)
    CHECK_THAT(Unit::CombineSpeedBonuses(100.0f, 1.04f, 1.15f), WithinAbs(2.30, 1e-5));
}

TEST_CASE("A main bonus alone, and no bonus", "[SpeedBonusStacking]")
{
    CHECK_THAT(Unit::CombineSpeedBonuses(40.0f, 1.0f, 1.0f), WithinAbs(1.40, 1e-5));   // Travel Form
    CHECK_THAT(Unit::CombineSpeedBonuses(0.0f, 1.0f, 1.0f), WithinAbs(1.00, 1e-5));
    CHECK_THAT(Unit::CombineSpeedBonuses(0.0f, 1.25f, 1.0f), WithinAbs(1.25, 1e-5));   // Gathering Speed (aura 129)
}
