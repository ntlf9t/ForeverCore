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

#ifndef TRINITYCORE_ITEM_STACK_SIZE_H
#define TRINITYCORE_ITEM_STACK_SIZE_H

#include "Define.h"
#include <array>
#include <string>
#include <string_view>
#include <unordered_map>
#include <unordered_set>
#include <vector>

// Everlake: bigger item stacks from the config (StackSize.* in worldserver.conf), the same rules as Evermore's mod-stack-size.
// ItemSparse.Stackable is edited in memory at startup and each changed row is sent to the client as a hotfix, so bags, tooltips
// and the split dialog show the same size the server allows. The database is never changed: StackSize.Enable = 0 and a restart
// bring the stock sizes back (the client drops pushes a realm stops sending).
namespace ItemStackSize
{
    // Item groups with their own option. Spell reagents are class 15 subclass 1 on the Forever client (Arcane Powder,
    // Symbol of Kings, Rune of Portals...) and class 5 for a few (Ankh), so both count as reagents.
    enum class Group : uint8
    {
        TradeGoods,
        Reagents,
        Consumables,
        Gems,
        Projectiles,
        Glyphs,
        Quest,
        Misc,
        Max,
        None = Max
    };

    constexpr std::size_t GroupCount = std::size_t(Group::Max);

    // One below the core's "no limit" value, which GetMaxStackSize() treats specially.
    constexpr uint32 MaxStack = 0x7FFFFFFE;

    struct Settings
    {
        bool Enabled = false;
        std::array<uint32, GroupCount> GroupSizes = { };    // 0 = leave the group alone
        std::unordered_map<uint32, uint32> ItemSizes;       // item id -> stack size, wins over the groups
        std::unordered_set<uint32> Excluded;                // never touched by the group rules
    };

    struct Change
    {
        uint32 Stackable = 0;
        int32 MaxCount = -1;    // -1 = carry limit unchanged
    };

    TC_GAME_API Group GetGroup(uint32 itemClass, uint32 itemSubClass);

    // What an item's stack should become, or a Change with Stackable 0 to leave it alone. Group rules only raise a stack and only
    // for items that already stack; StackSize.Items can set any size, and raises a lower carry limit ("Unique (N)") to match.
    TC_GAME_API Change GetChange(Settings const& settings, uint32 itemId, uint32 itemClass, uint32 itemSubClass, int32 stackable, int32 maxCount);

    // "6265:999 17020:500" (commas work too). Bad tokens are skipped and listed in errors.
    TC_GAME_API std::unordered_map<uint32, uint32> ParseItemSizes(std::string_view list, std::vector<std::string>* errors = nullptr);
    TC_GAME_API std::unordered_set<uint32> ParseItemList(std::string_view list, std::vector<std::string>* errors = nullptr);

    // Reads the StackSize.* options and changes ItemSparse; call after the DB2 stores and hotfixes are loaded.
    TC_GAME_API void Apply();

    // The stack size the item had before Apply() (its stock size), for code that should keep stock behaviour (the AH bot).
    TC_GAME_API uint32 GetStockMaxStackSize(uint32 itemId, uint32 currentMaxStackSize);
}

#endif // TRINITYCORE_ITEM_STACK_SIZE_H
