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

#ifndef TRINITY_BAG_SORT_ASSIGNMENT_H
#define TRINITY_BAG_SORT_ASSIGNMENT_H

#include <algorithm>
#include <cstddef>
#include <limits>
#include <vector>

namespace BagSorting
{
    constexpr std::size_t NoOwner = std::numeric_limits<std::size_t>::max();

    template <typename Preferences, typename CanAssign>
    bool AssignSlots(std::size_t itemCount, std::size_t slotCount, Preferences const& preferences,
        CanAssign const& canAssign, std::vector<std::size_t>& slotOwners)
    {
        slotOwners.assign(slotCount, NoOwner);
        std::vector<bool> visited(slotCount);

        auto assign = [&](auto&& self, std::size_t itemIndex, std::size_t fixedItems) -> bool
        {
            for (std::size_t slotIndex : preferences(itemIndex))
            {
                if (visited[slotIndex] || !canAssign(itemIndex, slotIndex))
                    continue;

                std::size_t const owner = slotOwners[slotIndex];
                if (owner != NoOwner && owner < fixedItems)
                    continue;

                visited[slotIndex] = true;
                if (owner == NoOwner || self(self, owner, fixedItems))
                {
                    slotOwners[slotIndex] = itemIndex;
                    return true;
                }
            }
            return false;
        };

        // Later items are assigned first so earlier ones keep their preferred slots when possible.
        for (std::size_t itemIndex = itemCount; itemIndex-- > 0;)
        {
            std::fill(visited.begin(), visited.end(), false);
            if (!assign(assign, itemIndex, 0))
                return false;
        }

        // A displacement chain can reorder later items, so improve each assignment while keeping earlier ones fixed.
        for (std::size_t itemIndex = 0; itemIndex < itemCount; ++itemIndex)
        {
            std::size_t const currentSlot = std::find(slotOwners.begin(), slotOwners.end(), itemIndex) - slotOwners.begin();
            for (std::size_t slotIndex : preferences(itemIndex))
            {
                if (slotIndex == currentSlot)
                    break;

                std::size_t const owner = slotOwners[slotIndex];
                if ((owner != NoOwner && owner < itemIndex) || !canAssign(itemIndex, slotIndex))
                    continue;

                slotOwners[currentSlot] = NoOwner;
                std::fill(visited.begin(), visited.end(), false);
                visited[slotIndex] = true;
                if (owner == NoOwner || assign(assign, owner, itemIndex))
                {
                    slotOwners[slotIndex] = itemIndex;
                    break;
                }
                slotOwners[currentSlot] = itemIndex;
            }
        }
        return true;
    }
}

#endif
