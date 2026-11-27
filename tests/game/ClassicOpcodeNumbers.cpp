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
#include "ClassicOpcodes.h"
#include "Opcodes.h"

using ClassicOpcodes::TranslateClientOpcodeForBuild;
using ClassicOpcodes::TranslateServerOpcodeForBuild;

// Everlake's realms run the WoW Forever client 1.60.1.70862, which keeps the 70790 message numbers. Server messages go
// out in group 0x47 (retail 0x45, +1 for Classic, +1 from 70291); client messages arrive in the numbering of the table in
// ClassicClientOpcodes.inc for everything checked here.

TEST_CASE("70790+ server main group: mail and scene messages keep their numbers", "[ClassicOpcodes]")
{
    // advocaite/TrinityCore#274: official sniffs have INSTANCE_INFO (0xDE) unchanged and ACHIEVEMENT_EARNED (0xED in
    // 70291..70658 numbering) one higher; the new message sits right below ACHIEVEMENT_EARNED, so 0xDF..0xEC don't move.
    // With the old guess (0xDF) the mail result went out one higher and the mail window froze after Send.
    CHECK(TranslateServerOpcodeForBuild(SMSG_INSTANCE_INFO, 70862) == 0x4700DEu);
    CHECK(TranslateServerOpcodeForBuild(SMSG_PLAY_SCENE, 70862) == 0x4700E0u);
    CHECK(TranslateServerOpcodeForBuild(SMSG_CANCEL_SCENE, 70862) == 0x4700E1u);
    CHECK(TranslateServerOpcodeForBuild(SMSG_MAIL_COMMAND_RESULT, 70862) == 0x4700E5u);
    CHECK(TranslateServerOpcodeForBuild(SMSG_NOTIFY_RECEIVED_MAIL, 70862) == 0x4700E6u);
    CHECK(TranslateServerOpcodeForBuild(SMSG_ACHIEVEMENT_EARNED, 70862) == 0x4700EEu);
}

TEST_CASE("Server main group before 70790 has no extra message", "[ClassicOpcodes]")
{
    CHECK(TranslateServerOpcodeForBuild(SMSG_MAIL_COMMAND_RESULT, 70658) == 0x4700E5u);
    CHECK(TranslateServerOpcodeForBuild(SMSG_ACHIEVEMENT_EARNED, 70658) == 0x4700EDu);
}

TEST_CASE("70790+ client: charter Request Signature is OFFER_PETITION", "[ClassicOpcodes]")
{
    // advocaite/TrinityCore#298: 0x3E028C used to map to the unhandled CHROMIE_TIME_SELECT_EXPANSION
    CHECK(TranslateClientOpcodeForBuild(0x3E028C, 70862) == uint32(CMSG_OFFER_PETITION));
}

TEST_CASE("70790+ client: the guild window invite is GUILD_INVITE_BY_NAME", "[ClassicOpcodes]")
{
    // advocaite/TrinityCore#299: 0x440034 carries a 9 bit name length and the name, and was read as PARTY_INVITE_RESPONSE
    CHECK(TranslateClientOpcodeForBuild(0x440034, 70862) == uint32(CMSG_GUILD_INVITE_BY_NAME));
    // the party invite answer still has the number EmuForever's client map gives it (0x440032, by the group rule)
    CHECK(TranslateClientOpcodeForBuild(0x440032, 70862) == uint32(CMSG_PARTY_INVITE_RESPONSE));
}
