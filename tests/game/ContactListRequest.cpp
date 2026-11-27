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
#include "SocialPackets.h"

namespace
{
    uint32 ReadFlags(std::vector<uint8> const& payload)
    {
        WorldPacket raw(CMSG_SEND_CONTACT_LIST, payload.size());
        raw.append(payload.data(), payload.size());

        WorldPackets::Social::SendContactList packet(std::move(raw));
        packet.Read();
        CHECK(packet.GetRawPacket()->rpos() == packet.GetRawPacket()->size());
        return packet.Flags;
    }
}

// advocaite/TrinityCore#291 (the same change as Everlake's docker/patches/0003): the Classic 1.60 client puts a byte (0)
// before the flags. Read as a uint32, 00 15 00 00 00 gave flags 0x1500, no social flag matched and the friend list came
// back empty every time it was opened.
TEST_CASE("Classic contact list request: the byte before the flags is skipped", "[ContactListRequest]")
{
    CHECK(ReadFlags({ 0x00, 0x15, 0x00, 0x00, 0x00 }) == 0x15u);    // SOCIAL_FLAG_FRIEND | SOCIAL_FLAG_IGNORED | 0x10
    CHECK(ReadFlags({ 0x00, 0x11, 0x00, 0x00, 0x00 }) == 0x11u);
}

TEST_CASE("Retail-sized contact list request (4 bytes) still reads the flags", "[ContactListRequest]")
{
    CHECK(ReadFlags({ 0x15, 0x00, 0x00, 0x00 }) == 0x15u);
}
