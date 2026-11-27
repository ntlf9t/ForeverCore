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

// WorldSession::DropClientOnlyManagers: a bot session gives up its CollectionMgr and BattlePetMgr before login (Everlake).

#include "tc_catch2.h"

#include "ClientBuildInfo.h"
#include "SharedDefines.h"
#include "World.h"
#include "WorldSession.h"
#include <memory>

namespace
{
// A session without a client, made the way PlayerbotV2's BotSession makes one. Only bot sessions are made here: a player's session
// marks its account offline in the login database when it ends, and the tests have no database.
std::unique_ptr<WorldSession> MakeBotSession()
{
    (void)sWorld; // the session reads a few World settings
    return std::make_unique<WorldSession>(
        1, std::string("BOTTEST"), 1, std::string(), std::shared_ptr<WorldSocket>(), SEC_PLAYER, uint8(EXPANSION_LEVEL_CURRENT),
        0, std::string(), Minutes(0), 0, ClientBuild::VariantId{}, LOCALE_enUS, 0, false, true);
}
}

TEST_CASE("A bot session drops its collections and battle pet journal", "[BotSessionManagers]")
{
    std::unique_ptr<WorldSession> session = MakeBotSession();
    REQUIRE(session->IsBot());

    // Made with both, as every session is
    REQUIRE(session->GetCollectionMgr() != nullptr);
    REQUIRE(session->GetBattlePetMgr() != nullptr);
    REQUIRE(session->HasClientOnlyManagers());

    REQUIRE(session->DropClientOnlyManagers());
    REQUIRE(session->GetCollectionMgr() == nullptr);
    REQUIRE(session->GetBattlePetMgr() == nullptr);
    REQUIRE_FALSE(session->HasClientOnlyManagers());

    // Asking again changes nothing
    REQUIRE(session->DropClientOnlyManagers());
    REQUIRE(session->GetCollectionMgr() == nullptr);

    // Ending the session without them (no character, no logout) is safe
    session.reset();
}

TEST_CASE("Only a bot session with no character may drop them", "[BotSessionManagers]")
{
    // A bot before login
    REQUIRE(WorldSession::MayDropClientOnlyManagers(true, false, false));
    // A player's session keeps them, whatever its state
    REQUIRE_FALSE(WorldSession::MayDropClientOnlyManagers(false, false, false));
    REQUIRE_FALSE(WorldSession::MayDropClientOnlyManagers(false, true, false));
    REQUIRE_FALSE(WorldSession::MayDropClientOnlyManagers(false, false, true));
    // A bot whose character is loading or in the world: Player and its items may already point into them
    REQUIRE_FALSE(WorldSession::MayDropClientOnlyManagers(true, false, true));
    REQUIRE_FALSE(WorldSession::MayDropClientOnlyManagers(true, true, false));
}
