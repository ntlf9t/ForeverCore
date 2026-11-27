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

#include "NameReservationRules.h"

using namespace NameReservation;

namespace
{
    constexpr uint32 A = 1001;              // Battle.net accounts
    constexpr uint32 B = 1002;
    constexpr uint32 Bot = 0;               // a bot has no player account
    constexpr time_t Day = 24 * 3600;
    constexpr time_t Grace = 90 * Day;      // NameReservation.GracePeriod default
    constexpr time_t Now = 1'800'000'000;

    Row InUse(uint32 owner, uint32 users = 1) { return Row{ true, owner, 0, users }; }
    Row Freed(uint32 owner, time_t freedAt) { return Row{ true, owner, freedAt, 0 }; }
}

TEST_CASE("NameReservation: a name nobody holds is free for players and bots", "[NameReservation]")
{
    CHECK(Evaluate(Row{}, A, Now, Grace) == Claim::Free);
    CHECK(Evaluate(Row{}, Bot, Now, Grace) == Claim::Free);
}

TEST_CASE("NameReservation: the owner may use its name on every realm, another account may not", "[NameReservation]")
{
    CHECK(Evaluate(InUse(A), A, Now, Grace) == Claim::Own);         // A's toon on a second realm
    CHECK(Evaluate(InUse(A, 3), A, Now, Grace) == Claim::Own);
    CHECK(Evaluate(InUse(A), B, Now, Grace) == Claim::Taken);       // a stranger on another realm
    CHECK_FALSE(CanUse(Evaluate(InUse(A), B, Now, Grace)));
}

TEST_CASE("NameReservation: a row being created (no character yet) is held", "[NameReservation]")
{
    // Reserve() writes the row before the character is saved: another realm must not take it meanwhile
    CHECK(Evaluate(InUse(A, 0), B, Now, Grace) == Claim::Taken);
    CHECK(Evaluate(InUse(A, 0), A, Now, Grace) == Claim::Own);
}

TEST_CASE("NameReservation: a freed name stays with its account for the grace period", "[NameReservation]")
{
    CHECK(Evaluate(Freed(A, Now), B, Now, Grace) == Claim::Taken);
    CHECK(Evaluate(Freed(A, Now - Grace + 1), B, Now, Grace) == Claim::Taken);     // one second left
    CHECK(Evaluate(Freed(A, Now - Grace), B, Now, Grace) == Claim::Expired);       // exactly over
    CHECK(Evaluate(Freed(A, Now - 400 * Day), B, Now, Grace) == Claim::Expired);
    // the owner gets it back at any time, before or after the grace period
    CHECK(Evaluate(Freed(A, Now), A, Now, Grace) == Claim::Own);
    CHECK(Evaluate(Freed(A, Now - 400 * Day), A, Now, Grace) == Claim::Own);
}

TEST_CASE("NameReservation: a freed name with a character again is not taken over", "[NameReservation]")
{
    // freed_at set but a character uses it (should not happen; Attach clears freed_at): never steal it
    CHECK(Evaluate(Row{ true, A, Now - 400 * Day, 1 }, B, Now, Grace) == Claim::Taken);
}

TEST_CASE("NameReservation: the grace period follows the setting", "[NameReservation]")
{
    CHECK(IsGraceOver(Now - 60, Now, 60));          // the scratch test's short value
    CHECK_FALSE(IsGraceOver(Now - 59, Now, 60));
    CHECK(IsGraceOver(Now, Now, 0));                // 0 = freed at once
    CHECK_FALSE(IsGraceOver(0, Now, 0));            // not freed
    CHECK(Evaluate(Freed(A, Now), B, Now, 0) == Claim::Expired);
}

TEST_CASE("NameReservation: bots may use only names nobody holds", "[NameReservation]")
{
    CHECK(Evaluate(InUse(A), Bot, Now, Grace) == Claim::Taken);
    CHECK(Evaluate(Freed(A, Now - Day), Bot, Now, Grace) == Claim::Taken);          // still in A's grace period
    CHECK(Evaluate(Freed(A, Now - Grace), Bot, Now, Grace) == Claim::Expired);
    // a row with owner 0 (should not exist) is still not a bot's own
    CHECK(Evaluate(InUse(0), Bot, Now, Grace) == Claim::Taken);
}
