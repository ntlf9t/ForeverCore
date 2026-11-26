/*
 * 洗练插件服务端接口
 *
 * 插件通过 /say 发送 "@R|..." 协议，服务端拦截后处理，不广播给其他人。
 *
 * 协议：
 *   @R|info|bag|slot            查询装备评分/上限
 *   @R|score|bag|slot           重置整件评分（按品质扣金币）
 *   @R|best|bag|slot            批量 100 次取最高
 *   @R|line|bag|slot|index      单条重抽（index 0..3）
 *
 * 回复（系统消息，插件监听 CHAT_MSG_SYSTEM）：
 *   REROLL|info|entry|score|max|quality|money
 *   REROLL|done|entry|score|max|cost
 *   REROLL|err|<错误码>
 */

#include "Chat.h"
#include "Bag.h"
#include "Item.h"
#include "ItemScoreAffix.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "WorldSession.h"

#include <map>
#include <sstream>
#include <vector>
#include <cstdio>

namespace
{
    constexpr char const* PROTOCOL_PREFIX = "REROLL;";
    constexpr char const* REPLY_PREFIX    = "REROLL;";

    constexpr uint32 BATCH_TIMES = 100;

    constexpr uint32 COPPER_PER_SILVER = 100;
    constexpr uint32 COPPER_PER_GOLD   = 10000;

    uint32 BaseCostForItemLevel(uint32 itemLevel)
    {
        if (itemLevel <= 20)
            return 5 * COPPER_PER_SILVER;
        if (itemLevel <= 40)
            return 10 * COPPER_PER_SILVER;
        if (itemLevel <= 60)
            return 15 * COPPER_PER_SILVER;
        return 20 * COPPER_PER_SILVER;
    }

    uint32 CostForItem(Player* player, Item* item)
    {
        if (!player || !item)
            return 0;

        ItemTemplate const* proto = item->GetTemplate();
        if (!proto)
            return 0;

        uint32 multiplier = 0;
        switch (proto->GetQuality())
        {
            case ITEM_QUALITY_UNCOMMON:  multiplier = 1;   break; // 绿
            case ITEM_QUALITY_RARE:      multiplier = 5;   break; // 蓝
            case ITEM_QUALITY_EPIC:      multiplier = 25;  break; // 紫
            case ITEM_QUALITY_ARTIFACT:  multiplier = 25;  break;
            case ITEM_QUALITY_LEGENDARY: multiplier = 100; break; // 橙
            default:                     return 0;
        }

        uint64 cost = uint64(BaseCostForItemLevel(item->GetItemLevel(player))) * multiplier;

        // 紫色会出现 1.25 / 2.5 / 3.75 金，按整金四舍五入
        if (proto->GetQuality() == ITEM_QUALITY_EPIC || proto->GetQuality() == ITEM_QUALITY_ARTIFACT)
            cost = ((cost + COPPER_PER_GOLD / 2) / COPPER_PER_GOLD) * COPPER_PER_GOLD;

        return uint32(cost);
    }

    uint32 QualityOf(ItemTemplate const* proto)
    {
        return proto ? proto->GetQuality() : 0;
    }

    void Reply(Player* player, std::string const& text)
    {
        ChatHandler(player->GetSession()).SendSysMessage(std::string(REPLY_PREFIX) + text);
    }

    std::map<uint32, std::string> const& EnchantNames()
    {
        static std::map<uint32, std::string> names;
        if (names.empty())
        {
            if (QueryResult result = WorldDatabase.Query("SELECT ench, name FROM item_score_ench_name"))
            {
                do
                {
                    Field* fields = result->Fetch();
                    names[fields[0].GetUInt32()] = fields[1].GetString();
                } while (result->NextRow());
            }
        }
        return names;
    }

    void AppendAffixes(Item* item, std::ostringstream& oss)
    {
        static constexpr EnchantmentSlot affixSlots[] =
        {
            BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
        };

        auto const& names = EnchantNames();
        for (EnchantmentSlot slot : affixSlots)
        {
            uint32 const ench = item->GetEnchantmentId(slot);
            if (!ench)
                continue;

            auto it = names.find(ench);
            if (it == names.end())
            {
                oss << ";词条#" << ench;
                continue;
            }

            oss << ';' << it->second;
        }
    }

    void AppendBudgets(Item* item, std::ostringstream& oss)
    {
        static constexpr EnchantmentSlot affixSlots[] =
        {
            BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
        };

        uint32 const score = ItemScoreAffix::GetScore(item);
        oss << ";b:";
        for (uint32 i = 0; i < 3; ++i)
        {
            if (i)
                oss << ',';

            if (!item->GetEnchantmentId(affixSlots[i]))
            {
                oss << 0;
                continue;
            }

            uint32 const budget = ItemScoreAffix::GetLineBudget(item, i);
            oss << (budget ? budget : score);
        }
    }

    Item* GetTargetItem(Player* player, uint32 bag, uint32 slot)
    {
        return player->GetItemByPos(uint8(bag), uint8(slot));
    }

    bool CanReroll(Player* player, Item* item)
    {
        ItemTemplate const* proto = item->GetTemplate();
        if (!proto)
            return false;

        if (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR)
            return false;

        return CostForItem(player, item) != 0;
    }

    void DoInfo(Player* player, Item* item)
    {
        uint32 const score = ItemScoreAffix::GetScore(item);
        uint32 const budget = ItemScoreAffix::GetBudget(player, item);
        ItemTemplate const* proto = item->GetTemplate();

        std::ostringstream oss;
        oss << "info;" << item->GetEntry() << ';' << score << ';' << budget << ';'
            << QualityOf(proto) << ';' << player->GetMoney()
            << ";c:" << CostForItem(player, item);
        AppendBudgets(item, oss);
        AppendAffixes(item, oss);
        Reply(player, oss.str());
    }

    void DoScore(Player* player, Item* item, bool batch)
    {
        uint32 const cost = CostForItem(player, item) * (batch ? BATCH_TIMES : 1);

        if (player->GetMoney() < cost)
        {
            Reply(player, "err;nomoney");
            return;
        }

        player->ModifyMoney(-int64(cost));

        if (!batch)
        {
            ItemScoreAffix::Reroll(player, item);
        }
        else
        {
            // 100 次里取最高：记录 enchant 快照（评分 9，词条 5/7/8）
            EnchantmentSlot const slots[] =
            {
                PROP_ENCHANTMENT_SLOT_1,
                BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
            };

            uint32 bestScore = 0;
            uint32 bestIds[4] = { 0, 0, 0, 0 };

            for (uint32 i = 0; i < BATCH_TIMES; ++i)
            {
                ItemScoreAffix::Reroll(player, item);

                uint32 const score = ItemScoreAffix::GetScore(item);
                if (score > bestScore)
                {
                    bestScore = score;
                    for (uint32 s = 0; s < 4; ++s)
                        bestIds[s] = item->GetEnchantmentId(slots[s]);
                }
            }

            for (uint32 s = 0; s < 4; ++s)
            {
                item->SetEnchantment(slots[s], bestIds[s], 0, 0);
                if (s > 0)
                    ItemScoreAffix::SetLineBudget(item, s - 1, bestScore);
            }
        }

        item->SetState(ITEM_CHANGED, player);

        uint32 const score = ItemScoreAffix::GetScore(item);
        uint32 const budget = ItemScoreAffix::GetBudget(player, item);

        std::ostringstream oss;
        oss << "done;" << item->GetEntry() << ';' << score << ';' << budget << ';' << cost;
        AppendBudgets(item, oss);
        AppendAffixes(item, oss);
        Reply(player, oss.str());
    }

    void DoLine(Player* player, Item* item, uint32 index)
    {
        if (index >= 3)
        {
            Reply(player, "err;badindex");
            return;
        }

        uint32 const cost = CostForItem(player, item);

        if (player->GetMoney() < cost)
        {
            Reply(player, "err;nomoney");
            return;
        }

        player->ModifyMoney(-int64(cost));
        ItemScoreAffix::RerollLine(player, item, index);
        item->SetState(ITEM_CHANGED, player);

        uint32 const score = ItemScoreAffix::GetScore(item);
        uint32 const budget = ItemScoreAffix::GetBudget(player, item);

        std::ostringstream oss;
        oss << "done;" << item->GetEntry() << ';' << score << ';' << budget << ';' << cost;
        AppendBudgets(item, oss);
        AppendAffixes(item, oss);
        Reply(player, oss.str());
    }

    void DoSpecial(Player* player, Item* item, bool chaos)
    {
        uint32 const cost = CostForItem(player, item);

        if (player->GetMoney() < cost)
        {
            Reply(player, "err;nomoney");
            return;
        }

        bool changed = chaos
            ? ItemScoreAffix::RerollChaos(player, item)
            : ItemScoreAffix::RerollStyle(player, item);

        if (!changed)
        {
            Reply(player, "err;nochange");
            return;
        }

        player->ModifyMoney(-int64(cost));
        item->SetState(ITEM_CHANGED, player);

        uint32 const score = ItemScoreAffix::GetScore(item);
        uint32 const budget = ItemScoreAffix::GetBudget(player, item);

        std::ostringstream oss;
        oss << "done;" << item->GetEntry() << ';' << score << ';' << budget << ';' << cost;
        AppendBudgets(item, oss);
        AppendAffixes(item, oss);
        Reply(player, oss.str());
    }

    Item* FindItemByEntry(Player* player, uint32 entry)
    {
        for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
            if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
                if (item->GetEntry() == entry)
                    return item;

        for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
            if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
                if (item->GetEntry() == entry)
                    return item;

        for (uint8 bagSlot = INVENTORY_SLOT_BAG_START; bagSlot < INVENTORY_SLOT_BAG_END; ++bagSlot)
        {
            Item* bag = player->GetItemByPos(INVENTORY_SLOT_BAG_0, bagSlot);
            if (!bag || !bag->IsBag())
                continue;

            for (uint8 slot = 0; slot < bag->ToBag()->GetBagSize(); ++slot)
                if (Item* item = player->GetItemByPos(bagSlot, slot))
                    if (item->GetEntry() == entry)
                        return item;
        }

        return nullptr;
    }

    void HandleItemAffixQuery(Player* player, std::string const& text)
    {
        std::string key;
        Item* item = nullptr;

        if (text.rfind("i;", 0) == 0)
        {
            uint32 entry = 0;
            if (sscanf(text.c_str() + 2, "%u", &entry) != 1)
                return;

            key = "i:" + std::to_string(entry);
            item = FindItemByEntry(player, entry);
        }
        else if (text.rfind("e;", 0) == 0)
        {
            uint32 slot = 0, entry = 0;
            if (sscanf(text.c_str() + 2, "%u;%u", &slot, &entry) < 1 || slot >= EQUIPMENT_SLOT_END)
                return;

            key = "e:" + std::to_string(slot);
            item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, uint8(slot));

            // 双手武器/界面可能给的是空槽：按 entry 在已装备物品里找
            if (entry && (!item || item->GetEntry() != entry))
            {
                item = nullptr;
                for (uint8 s = EQUIPMENT_SLOT_START; s < EQUIPMENT_SLOT_END; ++s)
                {
                    Item* equipped = player->GetItemByPos(INVENTORY_SLOT_BAG_0, s);
                    if (equipped && equipped->GetEntry() == entry)
                    {
                        item = equipped;
                        break;
                    }
                }
            }
        }
        else if (text.rfind("b;", 0) == 0)
        {
            uint32 bag = 0, slot = 0;
            if (sscanf(text.c_str() + 2, "%u;%u", &bag, &slot) != 2)
                return;

            key = "b:" + std::to_string(bag) + ":" + std::to_string(slot);

            if (bag == 0)
            {
                if (slot >= INVENTORY_SLOT_ITEM_END - INVENTORY_SLOT_ITEM_START)
                    return;
                item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, uint8(INVENTORY_SLOT_ITEM_START + slot));
            }
            else if (bag <= 4)
            {
                uint8 const bagSlot = uint8(INVENTORY_SLOT_BAG_START + bag - 1);
                item = player->GetItemByPos(bagSlot, uint8(slot));
            }
        }

        if (!item)
            return;

        static constexpr EnchantmentSlot hiddenSlots[] =
        {
            PROP_ENCHANTMENT_SLOT_1, PROP_ENCHANTMENT_SLOT_2,
            PROP_ENCHANTMENT_SLOT_3, PROP_ENCHANTMENT_SLOT_4
        };

        auto const& names = EnchantNames();
        std::string reply = std::to_string(ItemScoreAffix::GetScore(item)) + ";";
        for (EnchantmentSlot hidden : hiddenSlots)
        {
            uint32 const ench = item->GetEnchantmentId(hidden);
            if (!ench)
                continue;

            auto it = names.find(ench);
            if (it == names.end())
                continue;

            if (reply.back() != ';')
                reply += "#";
            reply += it->second;
        }

        ChatHandler(player->GetSession()).SendSysMessage("IA;" + key + ";" + reply);
    }

    void HandleProtocol(Player* player, std::string const& msg)
    {
        std::vector<std::string> parts;
        std::stringstream ss(msg);
        std::string token;
        while (std::getline(ss, token, ';'))
            parts.push_back(token);

        // parts[0] = "@R", parts[1] = 命令
        if (parts.size() < 4)
            return;

        std::string const& cmd = parts[1];
        uint32 const bag = uint32(atoi(parts[2].c_str()));
        uint32 const slot = uint32(atoi(parts[3].c_str()));

        Item* item = GetTargetItem(player, bag, slot);
        if (!item)
        {
            for (uint8 s = INVENTORY_SLOT_ITEM_START; s < INVENTORY_SLOT_ITEM_END; ++s)
            {
                if (Item* it = player->GetItemByPos(INVENTORY_SLOT_BAG_0, s))
                    TC_LOG_TRACE("server.loading", "   backpack slot={} entry={} guid={}", s, it->GetEntry(), it->GetGUID().ToString());
            }
        }
        TC_LOG_TRACE("server.loading", ">> REROLL cmd={} bag={} slot={} item={}", cmd, bag, slot, item ? item->GetEntry() : 0);
        if (!item)
        {
            Reply(player, "err;noitem");
            return;
        }

        if (cmd == "info")
        {
            DoInfo(player, item);
            return;
        }

        if (!CanReroll(player, item))
        {
            Reply(player, "err;quality");
            return;
        }

        if (cmd == "score")
            DoScore(player, item, false);
        else if (cmd == "best")
            DoScore(player, item, true);
        else if (cmd == "line")
        {
            uint32 const index = parts.size() > 4 ? uint32(atoi(parts[4].c_str())) : 0;
            DoLine(player, item, index);
        }
        else if (cmd == "chaos")
            DoSpecial(player, item, true);
        else if (cmd == "style")
            DoSpecial(player, item, false);
    }
}

class reroll_addon_playerscript : public PlayerScript
{
public:
    reroll_addon_playerscript() : PlayerScript("reroll_addon_playerscript") { }

    void OnLogin(Player* player, bool /*firstLogin*/) override
    {
        ItemScoreAffix::MigrateAll(player);
    }

    void OnChat(Player* player, uint32 /*type*/, uint32 /*lang*/, std::string& msg) override
    {
        TC_LOG_TRACE("server.loading", ">> CHAT hook: {}", msg);

        if (msg.rfind(PROTOCOL_PREFIX, 0) != 0)
            return;

        TC_LOG_TRACE("server.loading", ">> REROLL protocol recv: {}", msg);

        HandleProtocol(player, msg);
        msg.clear();   // 不广播给其他人
    }

    void OnAddonMessageSent(Player* player, uint32 /*type*/, std::string const& prefix,
        std::string const& text, Player* /*receiver*/) override
    {
        if (prefix == "IA")
            HandleItemAffixQuery(player, text);
    }
};

void AddSC_reroll_addon()
{
    new reroll_addon_playerscript();
}
