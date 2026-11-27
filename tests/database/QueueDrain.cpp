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

#include "QueueDrain.h"
#include <boost/asio/executor_work_guard.hpp>
#include <boost/asio/io_context.hpp>
#include <boost/asio/post.hpp>
#include <atomic>
#include <chrono>
#include <thread>

TEST_CASE("WaitForEmptyQueue lets the worker finish every queued handler before stop()")
{
    boost::asio::io_context context;
    auto guard = boost::asio::make_work_guard(context);
    std::thread worker([&context] { context.run(); });

    std::atomic<std::size_t> queued{ 0 };
    std::atomic<int> ran{ 0 };
    constexpr int Saves = 50;
    for (int i = 0; i < Saves; ++i)
    {
        ++queued;
        boost::asio::post(context, [&]
        {
            std::this_thread::sleep_for(std::chrono::milliseconds(2));   // a character save takes a while
            ++ran;
            --queued;
        });
    }

    int waits = 0;
    Trinity::Database::WaitForEmptyQueue([&] { return queued.load(); }, [&](std::size_t remaining)
    {
        REQUIRE(remaining > 0);
        ++waits;
    }, std::chrono::milliseconds(1), std::chrono::milliseconds(10));

    context.stop();
    guard.reset();
    worker.join();

    REQUIRE(ran == Saves);
    REQUIRE(waits > 0);   // 50 x 2 ms is past the 10 ms log interval
}

TEST_CASE("WaitForEmptyQueue returns at once on an empty queue")
{
    int waits = 0;
    Trinity::Database::WaitForEmptyQueue([] { return std::size_t(0); }, [&](std::size_t) { ++waits; });
    REQUIRE(waits == 0);
}
