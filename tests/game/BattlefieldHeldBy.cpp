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
#include "Battlefield.h"

namespace
{
    // Stands in for Battlefield, whose constructor needs a live map
    struct FakeBattlefield
    {
        bool Enabled;
        TeamId Defender;

        bool IsEnabled() const { return Enabled; }
        TeamId GetDefenderTeam() const { return Defender; }
    };
}

TEST_CASE("No battlefield on the map is held by nobody", "[BattlefieldHeldBy]")
{
    // condition_is_wintergrasp_* got null for a player outside Northrend and read through it (worldserver segfault)
    FakeBattlefield const* none = nullptr;
    CHECK_FALSE(IsBattlefieldHeldBy(none, TEAM_ALLIANCE));
    CHECK_FALSE(IsBattlefieldHeldBy(none, TEAM_HORDE));
    CHECK_FALSE(IsBattlefieldHeldBy(static_cast<Battlefield const*>(nullptr), TEAM_HORDE));
}

TEST_CASE("An enabled battlefield is held by its defender only", "[BattlefieldHeldBy]")
{
    FakeBattlefield const alliance{ true, TEAM_ALLIANCE };
    CHECK(IsBattlefieldHeldBy(&alliance, TEAM_ALLIANCE));
    CHECK_FALSE(IsBattlefieldHeldBy(&alliance, TEAM_HORDE));

    FakeBattlefield const horde{ true, TEAM_HORDE };
    CHECK(IsBattlefieldHeldBy(&horde, TEAM_HORDE));
    CHECK_FALSE(IsBattlefieldHeldBy(&horde, TEAM_ALLIANCE));
}

TEST_CASE("A disabled battlefield is held by nobody", "[BattlefieldHeldBy]")
{
    FakeBattlefield const off{ false, TEAM_ALLIANCE };
    CHECK_FALSE(IsBattlefieldHeldBy(&off, TEAM_ALLIANCE));
    CHECK_FALSE(IsBattlefieldHeldBy(&off, TEAM_HORDE));
}
