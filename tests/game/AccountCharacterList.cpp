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
#include "CharacterPackets.h"
#include "ClassicOpcodes.h"
#include "Opcodes.h"

// The account's characters, which the client offers in the mail window's To box. The layout is the 12.1.0 one
// (WowPacketParser V12_0_0_65390 AccountDataHandler): token, count, the characters, and the ConsoleCommand bit last.

TEST_CASE("Account character list request: token, then the ConsoleCommand bit", "[AccountCharacterList]")
{
    std::vector<uint8> payload = { 0x07, 0x00, 0x00, 0x00, 0x80 };
    WorldPacket raw(CMSG_GET_ACCOUNT_CHARACTER_LIST, payload.size());
    raw.append(payload.data(), payload.size());

    WorldPackets::Character::GetAccountCharacterList packet(std::move(raw));
    packet.Read();

    CHECK(packet.Token == 7u);
    CHECK(packet.ConsoleCommand);
    CHECK(packet.GetRawPacket()->rpos() == packet.GetRawPacket()->size());
}

TEST_CASE("Account character list answer: characters first, the ConsoleCommand bit last", "[AccountCharacterList]")
{
    WorldPackets::Character::GetAccountCharacterListResult packet;
    packet.Token = 7;

    WorldPackets::Character::AccountCharacterData& character = packet.Characters.emplace_back();
    character.VirtualRealmAddress = 0x01020003;
    character.RaceID = 1;
    character.ClassID = 3;
    character.SexID = 0;
    character.ExperienceLevel = 42;
    character.LastActiveTime = time_t(0x0102030405);
    character.CharacterName = "Mira";
    character.RealmName = "PTR";

    WorldPacket const* data = packet.Write();

    std::vector<uint8> expected =
    {
        0x07, 0x00, 0x00, 0x00,                             // Token
        0x01, 0x00, 0x00, 0x00,                             // character count
        0x00, 0x00,                                         // WowAccount (empty guid: two mask bytes)
        0x00, 0x00,                                         // Guid
        0x03, 0x00, 0x02, 0x01,                             // VirtualRealmAddress
        0x01, 0x03, 0x00, 0x2A,                             // race, class, sex, level
        0x05, 0x04, 0x03, 0x02, 0x01, 0x00, 0x00, 0x00,     // LastActiveTime
        0x00, 0x00, 0x00, 0x00,                             // ContentSetID
        0x10, 0x06,                                         // name length 4 (6 bits), realm name length 3 (9 bits), padding
        'M', 'i', 'r', 'a',
        'P', 'T', 'R',
        0x00,                                               // ConsoleCommand
    };

    REQUIRE(data->size() == expected.size());
    CHECK(std::vector<uint8>(data->data(), data->data() + data->size()) == expected);
}

TEST_CASE("Account character list answer with no characters: token, 0 and the bit", "[AccountCharacterList]")
{
    WorldPackets::Character::GetAccountCharacterListResult packet;
    packet.Token = 1;
    packet.ConsoleCommand = true;

    WorldPacket const* data = packet.Write();

    std::vector<uint8> expected = { 0x01, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x80 };
    REQUIRE(data->size() == expected.size());
    CHECK(std::vector<uint8>(data->data(), data->data() + data->size()) == expected);
}

TEST_CASE("Account character list answer goes out between exploration XP and the rename result", "[AccountCharacterList]")
{
    // the 70790+ number is not confirmed by a sniff; it follows the main-group rule, like its neighbours that are in daily use
    uint32 exploration = ClassicOpcodes::TranslateServerOpcodeForBuild(SMSG_EXPLORATION_EXPERIENCE, 70938);
    uint32 list = ClassicOpcodes::TranslateServerOpcodeForBuild(SMSG_GET_ACCOUNT_CHARACTER_LIST_RESULT, 70938);
    uint32 rename = ClassicOpcodes::TranslateServerOpcodeForBuild(SMSG_CHARACTER_RENAME_RESULT, 70938);

    CHECK(list == exploration + 2);
    CHECK(rename == list + 2);
    CHECK(list == 0x47020Du);
}

TEST_CASE("Account character list answer is never sent: its 70790+ number crashes the 70938 client", "[AccountCharacterList]")
{
    // 2026-11-16: every login on a 1.60.1.70938 client crashed (ERROR #132) a few seconds after this answer went out on 0x47020D;
    // the client's crash data held our answer as the last message of that number
    CHECK(ClassicOpcodes::IsServerOpcodeBlocked(SMSG_GET_ACCOUNT_CHARACTER_LIST_RESULT, 70938));
    CHECK(ClassicOpcodes::IsServerOpcodeBlocked(SMSG_GET_ACCOUNT_CHARACTER_LIST_RESULT, 70790));
    CHECK_FALSE(ClassicOpcodes::IsServerOpcodeBlocked(SMSG_EXPLORATION_EXPERIENCE, 70938));
}
