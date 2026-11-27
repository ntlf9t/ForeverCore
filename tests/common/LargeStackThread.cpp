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

#include "LargeStackThread.h"
#include <atomic>
#include <vector>

#if defined(__APPLE__)
#include <pthread.h>
#endif

namespace
{
struct Counter
{
    std::atomic<int> value{ 0 };
    void Add(int n) { value += n; }
};
}

TEST_CASE("LargeStackThread runs a function with its arguments and joins", "[LargeStackThread]")
{
    std::atomic<int> result{ 0 };
    Trinity::LargeStackThread t([&result](int a, int b) { result = a + b; }, 2, 3);
    REQUIRE(t.joinable());
    t.join();
    REQUIRE_FALSE(t.joinable());
    REQUIRE(result == 5);
}

TEST_CASE("LargeStackThread runs a member function, as std::thread does", "[LargeStackThread]")
{
    Counter c;
    std::vector<Trinity::LargeStackThread> threads;
    for (int i = 1; i <= 4; ++i)
        threads.emplace_back(&Counter::Add, &c, i);
    for (Trinity::LargeStackThread& t : threads)
        t.join();
    REQUIRE(c.value == 10);
}

TEST_CASE("LargeStackThread moves the running thread with it", "[LargeStackThread]")
{
    std::atomic<bool> ran{ false };
    Trinity::LargeStackThread a([&ran] { ran = true; });
    Trinity::LargeStackThread b;
    REQUIRE_FALSE(b.joinable());
    b = std::move(a);
    REQUIRE_FALSE(a.joinable());
    REQUIRE(b.joinable());
    b.join();
    REQUIRE(ran);
}

#if defined(__APPLE__)
TEST_CASE("LargeStackThread gets an 8 MB stack on macOS", "[LargeStackThread]")
{
    std::size_t stack = 0;
    Trinity::LargeStackThread t([&stack] { stack = pthread_get_stacksize_np(pthread_self()); });
    t.join();
    REQUIRE(stack >= Trinity::LargeStackThread::kStackSize);
}
#endif
