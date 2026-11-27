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
#include "DB2Stores.h"
#include "DummyData.h"
#include "Item.h"
#include "ItemTemplate.h"

// advocaite/TrinityCore#283: an item sells for its own ItemSparse SellPrice, the price its tooltip shows. In the
// 1.60.1.70862 client 2538 items have no ITEM_FLAG2_OVERRIDE_GOLD_COST; 929 of them have a sell price, and the retail
// item level formula priced those instead.
namespace
{
    // Price rows for an uncommon (quality 2) item level 20 shield, so the retail formula has something to work with
    void LoadPriceTables()
    {
        static UnitTestDataLoader::DB2<ImportPriceQualityEntry, &ImportPriceQualityEntry::ID> quality{sImportPriceQualityStore};
        static UnitTestDataLoader::DB2<ItemPriceBaseEntry, &ItemPriceBaseEntry::ID> base{sItemPriceBaseStore};
        static UnitTestDataLoader::DB2<ImportPriceShieldEntry, &ImportPriceShieldEntry::ID> shield{sImportPriceShieldStore};
        static bool loaded = false;
        if (loaded)
            return;

        loaded = true;
        {
            auto loader = quality.Loader();
            ImportPriceQualityEntry& entry = loader.Add();
            entry.ID = ITEM_QUALITY_UNCOMMON + 1;
            entry.Data = 1.0f;
        }
        {
            auto loader = base.Loader();
            ItemPriceBaseEntry& entry = loader.Add();
            entry.ID = 20;
            entry.ItemLevel = 20;
            entry.Armor = 100.0f;
            entry.Weapon = 100.0f;
        }
        {
            auto loader = shield.Loader();
            ImportPriceShieldEntry& entry = loader.Add();
            entry.ID = 2;
            entry.Data = 1.0f;
        }
    }

    struct ShieldTemplate
    {
        ItemEntry Basic{};
        ItemSparseEntry Sparse{};
        ItemTemplate Proto{};

        ShieldTemplate(uint32 sellPrice, bool overrideGoldCost)
        {
            Basic.ID = 1;
            Basic.ClassID = ITEM_CLASS_ARMOR;
            Basic.SubclassID = ITEM_SUBCLASS_ARMOR_SHIELD;
            Sparse.ID = 1;
            Sparse.InventoryType = INVTYPE_SHIELD;
            Sparse.OverallQualityID = ITEM_QUALITY_UNCOMMON;
            Sparse.ItemLevel = 20;
            Sparse.SellPrice = sellPrice;
            Sparse.BuyPrice = sellPrice * 5;
            Sparse.PriceVariance = 1.0f;
            Sparse.PriceRandomValue = 1.0f;
            if (overrideGoldCost)
                Sparse.Flags[1] = int32(ITEM_FLAG2_OVERRIDE_GOLD_COST);
            Proto.BasicData = &Basic;
            Proto.ExtendedData = &Sparse;
        }
    };
}

TEST_CASE("An item without the gold cost override flag sells for its own sell price", "[ItemSellPrice]")
{
    LoadPriceTables();
    ShieldTemplate shield(1234, false);
    // the old code priced it with the item level formula (100 copper here, then the item class price modifier: no ItemClass
    // row in the test, so 0, an unsellable item); its tooltip says 12s 34c
    CHECK(Item::GetSellPrice(&shield.Proto, ITEM_QUALITY_UNCOMMON, 20) == 1234);
}

TEST_CASE("An item with the gold cost override flag sells for its own sell price", "[ItemSellPrice]")
{
    LoadPriceTables();
    ShieldTemplate shield(1234, true);
    CHECK(Item::GetSellPrice(&shield.Proto, ITEM_QUALITY_UNCOMMON, 20) == 1234);
}

TEST_CASE("An item with no sell price can't be sold", "[ItemSellPrice]")
{
    LoadPriceTables();
    for (bool overrideGoldCost : { false, true })
    {
        CAPTURE(overrideGoldCost);
        ShieldTemplate shield(0, overrideGoldCost);
        CHECK(Item::GetSellPrice(&shield.Proto, ITEM_QUALITY_UNCOMMON, 20) == 0);
    }
}
