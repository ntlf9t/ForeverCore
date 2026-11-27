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

// Classic attack table rules shared by white and yellow attacks (ClassicAttackTable.h), Magey's Attack table numbers.

#include "tc_catch2.h"
#include "ClassicAttackTable.h"

using Catch::Approx;

TEST_CASE("Crit drops 0.2% per point of defense above a creature attacker's capped skill", "[ClassicAttackTable]")
{
    REQUIRE(ClassicAttackTable::CritSkillAdjustment(300, 300, 315, false) == Approx(-3.0f));   // +3 boss, 300 skill
    REQUIRE(ClassicAttackTable::CritSkillAdjustment(305, 300, 315, false) == Approx(-3.0f));   // +5 skill does not help crit
    REQUIRE(ClassicAttackTable::CritSkillAdjustment(300, 300, 305, false) == Approx(-1.0f));   // +1 level
    REQUIRE(ClassicAttackTable::CritSkillAdjustment(300, 300, 300, false) == Approx(0.0f));
}

TEST_CASE("Crit against players and lower defense moves 0.04% per point", "[ClassicAttackTable]")
{
    REQUIRE(ClassicAttackTable::CritSkillAdjustment(300, 300, 315, true) == Approx(-0.6f));
    REQUIRE(ClassicAttackTable::CritSkillAdjustment(305, 300, 300, false) == Approx(0.2f));
}

TEST_CASE("Aura crit loses 1.8% against creatures three or more levels up", "[ClassicAttackTable]")
{
    REQUIRE(ClassicAttackTable::AuraCritSuppressionFor(5.0f, 3, false) == Approx(1.8f));
    REQUIRE(ClassicAttackTable::AuraCritSuppressionFor(1.0f, 3, false) == Approx(1.0f));        // never more than the aura crit
    REQUIRE(ClassicAttackTable::AuraCritSuppressionFor(0.0f, 3, false) == Approx(0.0f));
    REQUIRE(ClassicAttackTable::AuraCritSuppressionFor(5.0f, 2, false) == Approx(0.0f));
    REQUIRE(ClassicAttackTable::AuraCritSuppressionFor(5.0f, 3, true) == Approx(0.0f));         // not against players
}

TEST_CASE("Daze from behind: 20% at equal skill, less below level 30 and with more defense", "[ClassicAttackTable]")
{
    REQUIRE(ClassicAttackTable::DazeChance(60, 300, 300) == Approx(20.0f));
    REQUIRE(ClassicAttackTable::DazeChance(10, 50, 50) == Approx(7.0f));      // newbie protection
    REQUIRE(ClassicAttackTable::DazeChance(60, 315, 300) == Approx(21.0f));   // +3 elite against capped defense
    REQUIRE(ClassicAttackTable::DazeChance(60, 300, 400) == Approx(15.0f));   // defense gear lowers it
    REQUIRE(ClassicAttackTable::DazeChance(60, 300, 100) == Approx(40.0f));   // capped at 40%
    REQUIRE(ClassicAttackTable::DazeChance(60, 300, 0) == Approx(40.0f));     // no divide by zero
}
