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

#include "ItemStackSize.h"
#include "Config.h"
#include "DB2HotfixGenerator.h"
#include "DB2Stores.h"
#include "ItemTemplate.h"
#include "Log.h"
#include "StringConvert.h"
#include "Util.h"
#include <algorithm>

namespace ItemStackSize
{
namespace
{
    struct GroupOption
    {
        Group Id;
        char const* Option;
        uint32 Default;
    };

    // Defaults: Evermore's mod-stack-size, with spell reagents at 999 as well.
    constexpr GroupOption GroupOptions[] =
    {
        { Group::TradeGoods,  "StackSize.TradeGoods",  999 },
        { Group::Reagents,    "StackSize.Reagents",    999 },
        { Group::Consumables, "StackSize.Consumables", 200 },
        { Group::Gems,        "StackSize.Gems",        0 },
        { Group::Projectiles, "StackSize.Projectiles", 0 },
        { Group::Glyphs,      "StackSize.Glyphs",      0 },
        { Group::Quest,       "StackSize.Quest",       0 },
        { Group::Misc,        "StackSize.Misc",        0 },
    };

    std::string SpacesForCommas(std::string_view list)
    {
        std::string out(list);
        std::ranges::replace(out, ',', ' ');
        return out;
    }

    std::unordered_map<uint32, uint32> StockSizes;  // item id -> stack size before Apply()
}

Group GetGroup(uint32 itemClass, uint32 itemSubClass)
{
    switch (itemClass)
    {
        case ITEM_CLASS_TRADE_GOODS:    return Group::TradeGoods;
        case ITEM_CLASS_REAGENT:        return Group::Reagents;
        case ITEM_CLASS_CONSUMABLE:     return Group::Consumables;
        case ITEM_CLASS_GEM:            return Group::Gems;
        case ITEM_CLASS_PROJECTILE:     return Group::Projectiles;
        case ITEM_CLASS_GLYPH:          return Group::Glyphs;
        case ITEM_CLASS_QUEST:          return Group::Quest;
        case ITEM_CLASS_MISCELLANEOUS:
            return itemSubClass == ITEM_SUBCLASS_MISCELLANEOUS_REAGENT ? Group::Reagents : Group::Misc;
        default:
            return Group::None;
    }
}

Change GetChange(Settings const& settings, uint32 itemId, uint32 itemClass, uint32 itemSubClass, int32 stackable, int32 maxCount)
{
    Change change;
    if (!settings.Enabled)
        return change;

    if (auto itr = settings.ItemSizes.find(itemId); itr != settings.ItemSizes.end())
    {
        uint32 const size = itr->second;
        // a lower carry limit (Unique (N)) could never fill the new stack, so it goes up with it
        if (maxCount > 0 && uint32(maxCount) < size)
            change.MaxCount = int32(size);
        if (stackable != int32(size) || change.MaxCount >= 0)
            change.Stackable = size;
        return change;
    }

    if (settings.Excluded.contains(itemId))
        return change;

    Group const group = GetGroup(itemClass, itemSubClass);
    if (group == Group::None)
        return change;

    uint32 const size = settings.GroupSizes[std::size_t(group)];
    // 0 = group left alone; 1 (doesn't stack) and "no limit" (<= 0 or int max) stay as they are; groups never lower a stack
    if (!size || stackable <= 1 || stackable == 2147483647 || uint32(stackable) >= size)
        return change;

    change.Stackable = size;
    return change;
}

std::unordered_map<uint32, uint32> ParseItemSizes(std::string_view list, std::vector<std::string>* errors)
{
    std::unordered_map<uint32, uint32> sizes;
    std::string const spaced = SpacesForCommas(list);
    for (std::string_view token : Trinity::Tokenize(spaced, ' ', false))
    {
        std::size_t const colon = token.find(':');
        Optional<uint32> entry = colon == std::string_view::npos ? Optional<uint32>() : Trinity::StringTo<uint32>(token.substr(0, colon));
        Optional<uint32> size = colon == std::string_view::npos ? Optional<uint32>() : Trinity::StringTo<uint32>(token.substr(colon + 1));
        if (!entry || !size || !*size)
        {
            if (errors)
                errors->emplace_back(token);
            continue;
        }

        sizes[*entry] = std::min(*size, MaxStack);
    }

    return sizes;
}

std::unordered_set<uint32> ParseItemList(std::string_view list, std::vector<std::string>* errors)
{
    std::unordered_set<uint32> entries;
    std::string const spaced = SpacesForCommas(list);
    for (std::string_view token : Trinity::Tokenize(spaced, ' ', false))
    {
        if (Optional<uint32> entry = Trinity::StringTo<uint32>(token))
            entries.insert(*entry);
        else if (errors)
            errors->emplace_back(token);
    }

    return entries;
}

void Apply()
{
    Settings settings;
    settings.Enabled = sConfigMgr->GetBoolDefault("StackSize.Enable", true);
    if (!settings.Enabled)
    {
        TC_LOG_INFO("server.loading", ">> Item stack sizes: StackSize.Enable = 0, stock sizes kept");
        return;
    }

    for (GroupOption const& option : GroupOptions)
        settings.GroupSizes[std::size_t(option.Id)] = std::min<uint32>(std::max(sConfigMgr->GetIntDefault(option.Option, int32(option.Default)), 0), MaxStack);

    std::vector<std::string> errors;
    settings.ItemSizes = ParseItemSizes(sConfigMgr->GetStringDefault("StackSize.Items", ""), &errors);
    for (std::string const& bad : errors)
        TC_LOG_ERROR("server.loading", "StackSize.Items has a bad entry '{}', expected item:size", bad);

    errors.clear();
    settings.Excluded = ParseItemList(sConfigMgr->GetStringDefault("StackSize.Exclude", ""), &errors);
    for (std::string const& bad : errors)
        TC_LOG_ERROR("server.loading", "StackSize.Exclude has a bad item id '{}'", bad);

    std::vector<std::pair<uint32, Change>> changes;
    for (ItemSparseEntry const* sparse : sItemSparseStore)
    {
        ItemEntry const* item = sItemStore.LookupEntry(sparse->ID);
        if (!item)
            continue;

        Change const change = GetChange(settings, sparse->ID, uint32(item->ClassID), item->SubclassID, sparse->Stackable, sparse->MaxCount);
        if (change.Stackable)
            changes.emplace_back(sparse->ID, change);
    }

    for (auto const& [itemId, size] : settings.ItemSizes)
        if (!sItemSparseStore.HasRecord(itemId))
            TC_LOG_ERROR("server.loading", "StackSize.Items names item {}, which has no ItemSparse row", itemId);

    // each changed row goes to the client as a hotfix, so its bags and tooltips use the new size too
    for (auto const& [itemId, change] : changes)
    {
        ItemSparseEntry* sparse = const_cast<ItemSparseEntry*>(sItemSparseStore.AssertEntry(itemId));
        StockSizes.emplace(itemId, sparse->Stackable > 0 ? uint32(sparse->Stackable) : 1u);
        sparse->Stackable = int32(change.Stackable);
        if (change.MaxCount >= 0)
            sparse->MaxCount = change.MaxCount;
        DB2HotfixGeneratorBase::AddClientHotfix(sItemSparseStore.GetTableHash(), itemId);
    }

    TC_LOG_INFO("server.loading", ">> Item stack sizes: changed {} items (trade goods {}, reagents {}, consumables {})", changes.size(),
        settings.GroupSizes[std::size_t(Group::TradeGoods)], settings.GroupSizes[std::size_t(Group::Reagents)],
        settings.GroupSizes[std::size_t(Group::Consumables)]);
}

uint32 GetStockMaxStackSize(uint32 itemId, uint32 currentMaxStackSize)
{
    auto itr = StockSizes.find(itemId);
    return itr != StockSizes.end() ? itr->second : currentMaxStackSize;
}
}
