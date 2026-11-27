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

// TrinityCore 545be4dddc + 4ad7c7ba5b: an areatrigger with MaxUnits lets in only as many entering units as it has room
// for. 545be4dddc used MaxUnits - inside as the count even when fewer units entered, and HandleUnitEnterExit read
// enteringUnits past its end (crash).

#include "tc_catch2.h"
#include "AreaTrigger.h"

TEST_CASE("Without MaxUnits every entering unit counts as inside", "[AreaTriggerMaxUnits]")
{
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit({}, 0, 0) == 0);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit({}, 0, 7) == 7);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit({}, 40, 7) == 7);
}

TEST_CASE("Never more than the units that entered", "[AreaTriggerMaxUnits]")
{
    // MaxUnits 5, nobody inside, one unit enters: 545be4dddc returned 5 and read 4 units past the end
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(5, 0, 1) == 1);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(5, 0, 0) == 0);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(5, 2, 1) == 1);
}

TEST_CASE("Only as many as the limit has room for", "[AreaTriggerMaxUnits]")
{
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(1, 0, 3) == 1);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(5, 3, 4) == 2);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(5, 5, 4) == 0);
}

TEST_CASE("A full or overfull areatrigger lets nobody in", "[AreaTriggerMaxUnits]")
{
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(2, 3, 4) == 0);
    CHECK(AreaTrigger::GetEnteringUnitsInsideLimit(0, 0, 4) == 0);
}
