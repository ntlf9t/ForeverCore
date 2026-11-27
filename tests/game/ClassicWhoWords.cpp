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
#include "WhoPackets.h"
#include <string>
#include <vector>

namespace
{
    // A Classic 1.60 who request (layout in WhoPackets.cpp, ReadWhoRequest): no name, guild or areas, only search words
    WorldPacket BuildWhoRequest(std::vector<std::string> const& words)
    {
        WorldPacket packet(CMSG_WHO);
        packet << int32(1);                 // MinLevel
        packet << int32(60);                // MaxLevel
        packet << int32(0) << int32(0);     // RaceFilter
        packet << int32(-1);                // ClassFilter
        packet.WriteBits(0, 6);             // Name
        packet.WriteBits(0, 9);             // VirtualRealmName
        packet.WriteBits(0, 9);             // Surname
        packet.WriteBits(0, 7);             // Guild
        packet.WriteBits(0, 9);             // GuildVirtualRealmName
        packet.WriteBits(words.size(), 3);  // Words
        packet.WriteBits(0, 4);             // ShowEnemies, ShowArenaPlayers, ExactName, Unknown
        packet.WriteBits(0, 6);             // Areas
        packet.WriteBits(0, 1);             // ServerInfo
        packet.FlushBits();

        for (std::string const& word : words)
        {
            packet.WriteBits(word.size(), 7);
            packet.FlushBits();
            packet.WriteString(word);
        }

        packet << uint32(7);                // Token
        packet << uint8(1);                 // Origin: Social
        packet.WriteBits(0, 1);             // IsAddon
        packet.FlushBits();
        return packet;
    }
}

// TrinityCore 914a6f655c bounded the words to 4 (the retail client's limit); the Classic 1.60 client sends a 3 bit count, so
// a /who with 5 to 7 words would throw while reading and the whole request would be dropped.
TEST_CASE("Classic who request: up to 7 search words are read", "[ClassicWhoWords]")
{
    std::vector<std::string> const words = { "a", "bb", "ccc", "dddd", "eeeee", "ffffff", "ggggggg" };

    WorldPackets::Who::WhoRequestPkt request(BuildWhoRequest(words));
    REQUIRE_NOTHROW(request.Read());

    REQUIRE(request.Request.Words.size() == words.size());
    for (std::size_t i = 0; i < words.size(); ++i)
        CHECK(request.Request.Words[i].Word == words[i]);
    CHECK(request.Token == 7u);
    CHECK(request.Origin == 1);
    CHECK(request.GetRawPacket()->rpos() == request.GetRawPacket()->size());
}

TEST_CASE("Classic who request: a single search word still works", "[ClassicWhoWords]")
{
    WorldPackets::Who::WhoRequestPkt request(BuildWhoRequest({ "Everlake" }));
    REQUIRE_NOTHROW(request.Read());
    REQUIRE(request.Request.Words.size() == 1);
    CHECK(request.Request.Words[0].Word == "Everlake");
}
