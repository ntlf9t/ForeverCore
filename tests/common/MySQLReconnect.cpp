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

#include "DatabaseWorkerPool.h"
#include "Field.h"
#include "LoginDatabase.h"
#include "MySQLConnection.h"
#include "MySQLPreparedStatement.h"
#include "PreparedStatement.h"
#include "QueryResult.h"
#include <atomic>
#include <cstdlib>
#include <fstream>
#include <memory>
#include <thread>
#include <vector>

namespace
{
    class ReconnectTestConnection : public MySQLConnection
    {
    public:
        explicit ReconnectTestConnection(MySQLConnectionInfo& info) : MySQLConnection(info, CONNECTION_SYNCH) { }

    private:
        void DoPrepareStatements() override
        {
            if (!m_reconnecting)
                m_stmts.resize(2);
            PrepareStatement(0, "DO ?", CONNECTION_SYNCH);
            PrepareStatement(1, "SELECT ?", CONNECTION_SYNCH);
        }
    };

    uint64 ConnectionId(MySQLConnection& connection)
    {
        std::unique_ptr<ResultSet> result(connection.Query("SELECT CONNECTION_ID()"));
        REQUIRE(result);
        REQUIRE(result->NextRow());
        return result->Fetch()[0].GetUInt64();
    }
}

TEST_CASE("MySQL reconnects and recreates prepared statements", "[MySQLReconnect]")
{
    // The file contains host;port;user;password;database for an isolated local test instance.
    char const* connectionFile = std::getenv("TC_TEST_MYSQL_RECONNECT_FILE");
    if (!connectionFile)
        SKIP("TC_TEST_MYSQL_RECONNECT_FILE is not set");

    std::ifstream input(connectionFile);
    REQUIRE(input.is_open());
    std::string connectionString;
    REQUIRE(static_cast<bool>(std::getline(input, connectionString)));
    MySQLConnectionInfo info(connectionString);
    REQUIRE(info.host == "127.0.0.1");
    REQUIRE(info.database == "forevercore_reconnect_test");

    ReconnectTestConnection connection(info);
    REQUIRE(connection.Open() == 0);
    REQUIRE(connection.PrepareStatements());
    uint64 const oldId = ConnectionId(connection);

    ReconnectTestConnection control(info);
    REQUIRE(control.Open() == 0);
    std::string const killQuery = "KILL CONNECTION " + std::to_string(oldId);
    REQUIRE(control.Execute(killQuery.c_str()));

    SECTION("Ping reconnects before the next statement")
    {
        connection.Ping();
        REQUIRE(connection.GetLastError() == 0);
        PreparedStatementBase statement(0, 1);
        statement.setUInt32(0, 42);
        REQUIRE(connection.Execute(&statement));
    }

    SECTION("A failed prepared execution reconnects and retries")
    {
        PreparedStatementBase statement(0, 1);
        statement.setUInt32(0, 42);
        REQUIRE(connection.Execute(&statement));
    }

    SECTION("A failed prepared query reconnects and retries")
    {
        PreparedStatementBase statement(1, 1);
        statement.setUInt32(0, 42);
        std::unique_ptr<PreparedResultSet> result(connection.Query(&statement));
        REQUIRE(result);
        REQUIRE(result->Fetch()[0].GetUInt32() == 42);
    }

    REQUIRE(ConnectionId(connection) != oldId);
}

TEST_CASE("MySQL pool serializes concurrent escaping and queries", "[MySQLReconnect]")
{
    char const* connectionFile = std::getenv("TC_TEST_MYSQL_RECONNECT_FILE");
    if (!connectionFile)
        SKIP("TC_TEST_MYSQL_RECONNECT_FILE is not set");

    std::ifstream input(connectionFile);
    REQUIRE(input.is_open());
    std::string connectionString;
    REQUIRE(static_cast<bool>(std::getline(input, connectionString)));
    MySQLConnectionInfo info(connectionString);
    REQUIRE(info.host == "127.0.0.1");
    REQUIRE(info.database == "forevercore_reconnect_test");

    DatabaseWorkerPool<LoginDatabaseConnection> pool;
    pool.SetConnectionInfo(connectionString, 0, 1);
    REQUIRE(pool.Open() == 0);

    constexpr unsigned threadCount = 6;
    constexpr unsigned iterations = 200;
    std::atomic<unsigned> ready{ 0 };
    std::atomic<unsigned> failures{ 0 };
    std::atomic<bool> start{ false };
    std::vector<std::thread> threads;
    threads.reserve(threadCount);
    for (unsigned threadIndex = 0; threadIndex < threadCount; ++threadIndex)
    {
        threads.emplace_back([&, threadIndex]
        {
            ++ready;
            while (!start.load())
                std::this_thread::yield();

            for (unsigned i = 0; i < iterations; ++i)
            {
                std::string original = "quote ' slash \\ newline \n";
                original.push_back('\0');
                original += std::to_string(threadIndex) + ":" + std::to_string(i);
                std::string escaped = original;
                pool.EscapeString(escaped);
                std::string const sql = "SELECT '" + escaped + "'";
                QueryResult result = pool.Query(sql.c_str());
                if (!result || result->Fetch()[0].GetString() != original)
                    ++failures;
            }
        });
    }

    while (ready.load() != threadCount)
        std::this_thread::yield();
    start = true;
    for (std::thread& thread : threads)
        thread.join();
    pool.Close();

    REQUIRE(failures.load() == 0);
}
