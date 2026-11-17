#include "RuneDrop.h"

#include "Chat.h"
#include "Creature.h"
#include "Item.h"
#include "Player.h"
#include "Random.h"
#include "WorldSession.h"

namespace
{
    constexpr uint32 ITEM_RUNE_RESET     = 2304;   // 重置符文（整件重洗）
    constexpr uint32 ITEM_RUNE_RESET_MAX = 2863;   // 满级重置符文（磨刀石载体）

    // 满级符文在掉落中的占比（百分比）
    constexpr uint32 MAX_RUNE_PERCENT = 2;

    uint32 BaseChancePercent(uint32 level)
    {
        if (level <= 30)
            return 5;

        if (level <= 50)
            return 8;

        return 10;
    }
}

void RuneDrop::OnCreatureKilled(Creature* creature, Player* looter)
{
    if (!creature || !looter)
        return;

    CreatureTemplate const* proto = creature->GetCreatureTemplate();
    if (!proto)
        return;

    // 小动物不掉
    if (proto->type == CREATURE_TYPE_CRITTER)
        return;

    uint32 chance = BaseChancePercent(creature->GetLevel());

    switch (proto->Classification)
    {
        case CreatureClassifications::Elite:
        case CreatureClassifications::RareElite:
        case CreatureClassifications::Rare:
            chance *= 2;
            break;
        default:
            break;
    }

    if (creature->isWorldBoss())
        chance *= 3;

    uint32 const roll = urand(1, 100);
    TC_LOG_INFO("server.loading", ">> RUNE DROP check creature={} level={} chance={} roll={}", creature->GetEntry(), creature->GetLevel(), chance, roll);

    if (roll > chance)
        return;

    uint32 itemId = (urand(1, 100) <= MAX_RUNE_PERCENT) ? ITEM_RUNE_RESET_MAX : ITEM_RUNE_RESET;

    ItemPosCountVec dest;
    InventoryResult msg = looter->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, itemId, 1);
    if (msg != EQUIP_ERR_OK)
        return;

    if (Item* rune = looter->StoreNewItem(dest, itemId, true))
    {
        looter->SendNewItem(rune, 1, true, false);

        ItemTemplate const* runeProto = rune->GetTemplate();
        if (runeProto)
            ChatHandler(looter->GetSession()).PSendSysMessage("|cffa335ee你获得了：%s|r",
                runeProto->GetName(looter->GetSession()->GetSessionDbLocaleIndex()));
    }
}
