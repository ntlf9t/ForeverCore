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

// TrinityCore 9358e2437b (#32081): a pool's connections share one MySQLConnectionInfo. Opening a connection over a unix
// socket (host ".") used to rewrite that shared host to "localhost", so every later connection of the pool took the TCP
// branch and lost the socket path.

#include "tc_catch2.h"
#include "CompilerDefs.h"
#include "MySQLConnection.h"

namespace
{
class TestConnection final : public MySQLConnection
{
public:
    explicit TestConnection(MySQLConnectionInfo& info) : MySQLConnection(info, CONNECTION_SYNCH) { }

protected:
    void DoPrepareStatements() override { }
};
}

#if TRINITY_PLATFORM != TRINITY_PLATFORM_WINDOWS
TEST_CASE("Opening a unix socket connection leaves the pool's shared host as \".\"", "[MySQLConnectionSocket]")
{
    // no server listens on this socket: Open fails, but only after it has picked host and socket
    MySQLConnectionInfo info(".;/nonexistent-trinity-test/mysqld.sock;user;password;database");
    REQUIRE(info.host == ".");

    TestConnection first(info);
    CHECK(first.Open() != 0);
    CHECK(info.host == ".");
    CHECK(info.port_or_socket == "/nonexistent-trinity-test/mysqld.sock");

    // the pool's second connection must still see the socket settings
    TestConnection second(info);
    CHECK(second.Open() != 0);
    CHECK(info.host == ".");
}
#endif

TEST_CASE("A TCP connection's host is not changed by Open", "[MySQLConnectionSocket]")
{
    // port 1 on the loopback address: nothing listens, the connect is refused at once
    MySQLConnectionInfo info("127.0.0.1;1;user;password;database");
    TestConnection connection(info);
    CHECK(connection.Open() != 0);
    CHECK(info.host == "127.0.0.1");
    CHECK(info.port_or_socket == "1");
}
