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
#include "ItemStackSize.h"
#include "ItemTemplate.h"

// Everlake StackSize.* options. Classes and stacks are the Forever client's (build 70790): Linen Cloth 2589 7/5 stack 20,
// Arcane Powder 17020 15/1 stack 20, Ankh 17030 5/0 stack 5, Soul Shard 6265 15/1 stack 1, Minor Healing Potion 118 0/1 stack 5.
namespace
{
    ItemStackSize::Settings Defaults()
    {
        ItemStackSize::Settings settings;
        settings.Enabled = true;
        settings.GroupSizes[std::size_t(ItemStackSize::Group::TradeGoods)] = 999;
        settings.GroupSizes[std::size_t(ItemStackSize::Group::Reagents)] = 999;
        settings.GroupSizes[std::size_t(ItemStackSize::Group::Consumables)] = 200;
        return settings;
    }
}

TEST_CASE("Spell reagents on the Forever client are miscellaneous subclass 1 and class 5", "[ItemStackSize]")
{
    REQUIRE(ItemStackSize::GetGroup(ITEM_CLASS_MISCELLANEOUS, ITEM_SUBCLASS_MISCELLANEOUS_REAGENT) == ItemStackSize::Group::Reagents);
    REQUIRE(ItemStackSize::GetGroup(ITEM_CLASS_REAGENT, 0) == ItemStackSize::Group::Reagents);
    REQUIRE(ItemStackSize::GetGroup(ITEM_CLASS_MISCELLANEOUS, 0) == ItemStackSize::Group::Misc);
    REQUIRE(ItemStackSize::GetGroup(ITEM_CLASS_TRADE_GOODS, 5) == ItemStackSize::Group::TradeGoods);
    REQUIRE(ItemStackSize::GetGroup(ITEM_CLASS_ARMOR, 1) == ItemStackSize::Group::None);
}

TEST_CASE("Group rules raise stacks of items that already stack", "[ItemStackSize]")
{
    ItemStackSize::Settings const settings = Defaults();
    REQUIRE(ItemStackSize::GetChange(settings, 2589, ITEM_CLASS_TRADE_GOODS, 5, 20, 0).Stackable == 999);
    REQUIRE(ItemStackSize::GetChange(settings, 17020, ITEM_CLASS_MISCELLANEOUS, 1, 20, 0).Stackable == 999);
    REQUIRE(ItemStackSize::GetChange(settings, 17030, ITEM_CLASS_REAGENT, 0, 5, 0).Stackable == 999);
    REQUIRE(ItemStackSize::GetChange(settings, 118, ITEM_CLASS_CONSUMABLE, 1, 5, 0).Stackable == 200);
    REQUIRE(ItemStackSize::GetChange(settings, 2589, ITEM_CLASS_TRADE_GOODS, 5, 20, 0).MaxCount == -1);
}

TEST_CASE("Group rules never make an item stack, never lower a stack and skip groups set to 0", "[ItemStackSize]")
{
    ItemStackSize::Settings const settings = Defaults();
    REQUIRE(ItemStackSize::GetChange(settings, 6265, ITEM_CLASS_MISCELLANEOUS, 1, 1, 0).Stackable == 0);       // Soul Shard
    REQUIRE(ItemStackSize::GetChange(settings, 1, ITEM_CLASS_TRADE_GOODS, 11, 2500, 0).Stackable == 0);
    REQUIRE(ItemStackSize::GetChange(settings, 2, ITEM_CLASS_TRADE_GOODS, 11, 2147483647, 0).Stackable == 0);  // no limit
    REQUIRE(ItemStackSize::GetChange(settings, 3, ITEM_CLASS_QUEST, 0, 20, 0).Stackable == 0);
    REQUIRE(ItemStackSize::GetChange(settings, 4, ITEM_CLASS_ARMOR, 1, 20, 0).Stackable == 0);
}

TEST_CASE("StackSize.Enable = 0 changes nothing", "[ItemStackSize]")
{
    ItemStackSize::Settings settings = Defaults();
    settings.Enabled = false;
    settings.ItemSizes[6265] = 999;
    REQUIRE(ItemStackSize::GetChange(settings, 2589, ITEM_CLASS_TRADE_GOODS, 5, 20, 0).Stackable == 0);
    REQUIRE(ItemStackSize::GetChange(settings, 6265, ITEM_CLASS_MISCELLANEOUS, 1, 1, 0).Stackable == 0);
}

TEST_CASE("StackSize.Items wins, can make an item stack and raises a lower carry limit", "[ItemStackSize]")
{
    ItemStackSize::Settings settings = Defaults();
    settings.ItemSizes[6265] = 999;
    settings.ItemSizes[2589] = 50;
    settings.ItemSizes[7] = 40;

    ItemStackSize::Change const shard = ItemStackSize::GetChange(settings, 6265, ITEM_CLASS_MISCELLANEOUS, 1, 1, 32);
    REQUIRE(shard.Stackable == 999);
    REQUIRE(shard.MaxCount == 999);

    REQUIRE(ItemStackSize::GetChange(settings, 2589, ITEM_CLASS_TRADE_GOODS, 5, 20, 0).Stackable == 50);
    REQUIRE(ItemStackSize::GetChange(settings, 2589, ITEM_CLASS_TRADE_GOODS, 5, 20, 0).MaxCount == -1);
    REQUIRE(ItemStackSize::GetChange(settings, 7, ITEM_CLASS_TRADE_GOODS, 5, 40, 0).Stackable == 0);   // already that size
}

TEST_CASE("StackSize.Exclude keeps an item out of the group rules", "[ItemStackSize]")
{
    ItemStackSize::Settings settings = Defaults();
    settings.Excluded.insert(17030);
    REQUIRE(ItemStackSize::GetChange(settings, 17030, ITEM_CLASS_REAGENT, 0, 5, 0).Stackable == 0);
}

TEST_CASE("Item lists parse with spaces or commas and report bad tokens", "[ItemStackSize]")
{
    std::vector<std::string> errors;
    auto const sizes = ItemStackSize::ParseItemSizes("6265:999, 17020:500 bad 1:0 2:x", &errors);
    REQUIRE(sizes.size() == 2);
    REQUIRE(sizes.at(6265) == 999);
    REQUIRE(sizes.at(17020) == 500);
    REQUIRE(errors.size() == 3);

    REQUIRE(ItemStackSize::ParseItemSizes("5:4294967295").at(5) == ItemStackSize::MaxStack);

    errors.clear();
    auto const list = ItemStackSize::ParseItemList("17030,21177 x", &errors);
    REQUIRE(list.size() == 2);
    REQUIRE(list.contains(21177));
    REQUIRE(errors.size() == 1);
}
