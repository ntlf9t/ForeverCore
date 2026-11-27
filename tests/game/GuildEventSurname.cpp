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
#include "CharacterCache.h"
#include "GuildPackets.h"
#include <string_view>

namespace
{
    ObjectGuid AddCharacter(ObjectGuid::LowType counter, std::string const& name, std::string const& surname)
    {
        ObjectGuid guid = ObjectGuid::Create<HighGuid::Player>(counter);
        sCharacterCache->AddCharacterCacheEntry(guid, 1 /*account*/, name, 0 /*gender*/, 1 /*race*/, 1 /*class*/, 60 /*level*/, false);
        sCharacterCache->UpdateCharacterSurname(guid, surname);
        return guid;
    }

    void CheckPlayer(WorldPacket& data, ObjectGuid expectedGuid, uint32 expectedRealm)
    {
        ObjectGuid guid;
        uint32 realm = 0;
        data >> guid;
        data >> realm;
        CHECK(guid == expectedGuid);
        CHECK(realm == expectedRealm);
    }
}

// advocaite/TrinityCore#300: the 70790 client reads a surname (9 bit length) after every name in these two guild events, as
// in PLAYER_JOINED. Without it the client ran past the end of the message and crashed on every guild kick or leave.
// The checks read each message in the order the client's reader does.

TEST_CASE("Guild member kicked: remover and leaver each carry a surname", "[GuildEventSurname]")
{
    ObjectGuid leaver = AddCharacter(990301, "Avenaro", "Youngfield");
    ObjectGuid remover = AddCharacter(990302, "Karrz", "");

    WorldPackets::Guild::GuildEventPlayerLeft packet;
    packet.Removed = true;
    packet.LeaverGUID = leaver;
    packet.LeaverName = "Avenaro";
    packet.LeaverVirtualRealmAddress = 0x01000046;
    packet.RemoverGUID = remover;
    packet.RemoverName = "Karrz";
    packet.RemoverVirtualRealmAddress = 0x01000046;

    WorldPacket data = *packet.Write();
    data.ResetBitPos();
    CHECK(data.ReadBit());
    uint32 leaverNameLength = data.ReadBits(6);
    uint32 leaverSurnameLength = data.ReadBits(9);
    uint32 removerNameLength = data.ReadBits(6);
    uint32 removerSurnameLength = data.ReadBits(9);
    data.ResetBitPos();

    CheckPlayer(data, remover, 0x01000046);
    CHECK(data.ReadString(removerNameLength) == std::string_view("Karrz"));
    CHECK(data.ReadString(removerSurnameLength).empty());
    CheckPlayer(data, leaver, 0x01000046);
    CHECK(data.ReadString(leaverNameLength) == std::string_view("Avenaro"));
    CHECK(data.ReadString(leaverSurnameLength) == std::string_view("Youngfield"));
    CHECK(data.rpos() == data.size());
}

TEST_CASE("Guild member left: only the leaver, with a surname", "[GuildEventSurname]")
{
    ObjectGuid leaver = AddCharacter(990303, "Berle", "Stonehand");

    WorldPackets::Guild::GuildEventPlayerLeft packet;
    packet.LeaverGUID = leaver;
    packet.LeaverName = "Berle";

    WorldPacket data = *packet.Write();
    data.ResetBitPos();
    CHECK_FALSE(data.ReadBit());
    uint32 leaverNameLength = data.ReadBits(6);
    uint32 leaverSurnameLength = data.ReadBits(9);
    data.ResetBitPos();

    CheckPlayer(data, leaver, 0);
    CHECK(data.ReadString(leaverNameLength) == std::string_view("Berle"));
    CHECK(data.ReadString(leaverSurnameLength) == std::string_view("Stonehand"));
    CHECK(data.rpos() == data.size());
}

TEST_CASE("New guild leader: old and new leader each carry a surname", "[GuildEventSurname]")
{
    ObjectGuid oldLeader = AddCharacter(990304, "Karrz", "Ironfoot");
    ObjectGuid newLeader = AddCharacter(990305, "Avenaro", "Youngfield");

    WorldPackets::Guild::GuildEventNewLeader packet;
    packet.OldLeaderGUID = oldLeader;
    packet.OldLeaderName = "Karrz";
    packet.NewLeaderGUID = newLeader;
    packet.NewLeaderName = "Avenaro";

    WorldPacket data = *packet.Write();
    data.ResetBitPos();
    CHECK_FALSE(data.ReadBit());
    uint32 oldNameLength = data.ReadBits(6);
    uint32 oldSurnameLength = data.ReadBits(9);
    uint32 newNameLength = data.ReadBits(6);
    uint32 newSurnameLength = data.ReadBits(9);
    data.ResetBitPos();

    CheckPlayer(data, oldLeader, 0);
    CheckPlayer(data, newLeader, 0);
    CHECK(data.ReadString(oldNameLength) == std::string_view("Karrz"));
    CHECK(data.ReadString(oldSurnameLength) == std::string_view("Ironfoot"));
    CHECK(data.ReadString(newNameLength) == std::string_view("Avenaro"));
    CHECK(data.ReadString(newSurnameLength) == std::string_view("Youngfield"));
    CHECK(data.rpos() == data.size());
}
