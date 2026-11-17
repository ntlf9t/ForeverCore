/*
 * 符文石系统（第一期）
 *
 * 符文石宝箱（4634）：右键开启，随机给 1 个重置符文
 * 重置符文（118/858/2455/3385）：右键后洗练当前装备（第二期实现，先占位）
 */

#include "Chat.h"
#include "Item.h"
#include "ItemScoreAffix.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedGossip.h"

namespace
{
    constexpr uint32 ITEM_RUNE_CHEST = 4634;

    constexpr uint32 ITEM_RUNE_GREEN  = 118;
    constexpr uint32 ITEM_RUNE_BLUE   = 858;
    constexpr uint32 ITEM_RUNE_PURPLE = 2455;
    constexpr uint32 ITEM_RUNE_ORANGE = 3385;

    void ConsumeOne(Player* player, Item* item)
    {
        uint32 count = item->GetCount();
        if (count <= 1)
        {
            player->DestroyItem(item->GetBagSlot(), item->GetSlot(), true);
            return;
        }

        item->SetCount(count - 1);
        item->SetState(ITEM_CHANGED, player);
    }
}

class item_rune_chest : public ItemScript
{
public:
    item_rune_chest() : ItemScript("item_rune_chest") { }

    bool OnUse(Player* player, Item* item, SpellCastTargets const& /*targets*/, ObjectGuid /*castId*/) override
    {
        // 第一期只有四种重置符文，等概率
        static uint32 const runes[] = { ITEM_RUNE_GREEN, ITEM_RUNE_BLUE, ITEM_RUNE_PURPLE, ITEM_RUNE_ORANGE };
        uint32 runeId = runes[urand(0, 3)];

        ItemPosCountVec dest;
        InventoryResult msg = player->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, runeId, 1);
        if (msg != EQUIP_ERR_OK)
        {
            ChatHandler(player->GetSession()).SendSysMessage("背包满了，无法取出符文。");
            return true;
        }

        if (Item* rune = player->StoreNewItem(dest, runeId, true))
            player->SendNewItem(rune, 1, true, false);

        ConsumeOne(player, item);
        return true;   // 阻止宝箱原本的开锁流程
    }
};

class item_rune_reset : public ItemScript
{
public:
    item_rune_reset() : ItemScript("item_rune_reset") { }

    bool OnUse(Player* player, Item* item, SpellCastTargets const& targets, ObjectGuid /*castId*/) override
    {
        ObjectGuid itemGuid = targets.GetItemTargetGUID();
        Item* target = targets.GetItemTarget();
        TC_LOG_INFO("server.loading", ">> RUNE use item={} guid={} targetEntry={}", item->GetEntry(), itemGuid.ToString(),
            target ? std::to_string(target->GetEntry()) : std::string("null"));

        if (!itemGuid.IsEmpty())
            if (Item* byGuid = player->GetItemByGuid(itemGuid))
                target = byGuid;

        if (!target || !target->GetEntry())
        {
            ChatHandler(player->GetSession()).SendSysMessage("请先右键符文，再点击要洗练的装备。");
            return true;
        }

        ItemTemplate const* proto = target->GetTemplate();
        if (!proto || (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR))
        {
            ChatHandler(player->GetSession()).SendSysMessage("这件装备不能洗练。");
            return true;
        }

        if (proto->GetQuality() == ITEM_QUALITY_NORMAL || proto->GetQuality() == ITEM_QUALITY_POOR)
        {
            ChatHandler(player->GetSession()).SendSysMessage("白色和灰色装备不能洗练。");
            return true;
        }

        ItemScoreAffix::Reroll(player, target);
        ChatHandler(player->GetSession()).PSendSysMessage("洗练完成：%s", proto->GetName(player->GetSession()->GetSessionDbLocaleIndex()));
        ConsumeOne(player, item);
        return true;
    }
};

class item_rune_reset_max : public ItemScript
{
public:
    item_rune_reset_max() : ItemScript("item_rune_reset_max") { }

    bool OnUse(Player* player, Item* item, SpellCastTargets const& targets, ObjectGuid /*castId*/) override
    {
        ObjectGuid itemGuid = targets.GetItemTargetGUID();
        Item* target = targets.GetItemTarget();
        if (!itemGuid.IsEmpty())
            if (Item* byGuid = player->GetItemByGuid(itemGuid))
                target = byGuid;

        if (!target || !target->GetEntry())
        {
            ChatHandler(player->GetSession()).SendSysMessage("请先右键符文，再点击要洗练的装备。");
            return true;
        }

        ItemTemplate const* proto = target->GetTemplate();
        if (!proto || (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR))
        {
            ChatHandler(player->GetSession()).SendSysMessage("这件装备不能洗练。");
            return true;
        }

        if (proto->GetQuality() == ITEM_QUALITY_NORMAL || proto->GetQuality() == ITEM_QUALITY_POOR)
        {
            ChatHandler(player->GetSession()).SendSysMessage("白色和灰色装备不能洗练。");
            return true;
        }

        ItemScoreAffix::Reroll(player, target, true);
        ChatHandler(player->GetSession()).PSendSysMessage("满级洗练完成：%s", proto->GetName(player->GetSession()->GetSessionDbLocaleIndex()));
        ConsumeOne(player, item);
        return true;
    }
};

void AddSC_rune_system()
{
    new item_rune_chest();
    new item_rune_reset();
    new item_rune_reset_max();
}
