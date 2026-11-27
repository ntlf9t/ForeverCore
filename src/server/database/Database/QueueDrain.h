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

#ifndef TRINITYCORE_DATABASE_QUEUE_DRAIN_H
#define TRINITYCORE_DATABASE_QUEUE_DRAIN_H

#include <chrono>
#include <cstddef>
#include <thread>

namespace Trinity::Database
{
    // Blocks until queueSize() is 0. A pool must do this before it stops its io_context: stop() drops every handler still
    // queued, which at shutdown were the character saves World::KickAll had just queued (players rolled back to their last
    // periodic save). onWait(remaining) is called once per logEvery while waiting, so a slow shutdown shows its progress.
    template <typename SizeFn, typename WaitFn>
    void WaitForEmptyQueue(SizeFn&& queueSize, WaitFn&& onWait,
        std::chrono::milliseconds pollEvery = std::chrono::milliseconds(10),
        std::chrono::milliseconds logEvery = std::chrono::seconds(5))
    {
        auto nextLog = std::chrono::steady_clock::now() + logEvery;
        while (std::size_t remaining = queueSize())
        {
            if (std::chrono::steady_clock::now() >= nextLog)
            {
                onWait(remaining);
                nextLog += logEvery;
            }
            std::this_thread::sleep_for(pollEvery);
        }
    }
}

#endif // TRINITYCORE_DATABASE_QUEUE_DRAIN_H
