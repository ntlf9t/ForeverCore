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
#include "Item.h"
#include "ItemScoreAffix.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "WorldSession.h"

#include <map>
#include <sstream>
#include <vector>

namespace
{
    constexpr char const* PROTOCOL_PREFIX = "REROLL;";
    constexpr char const* REPLY_PREFIX    = "REROLL;";

    constexpr uint32 BATCH_TIMES = 100;

    uint32 CostForQuality(uint32 quality)
    {
        switch (quality)
        {
            case ITEM_QUALITY_UNCOMMON:  return 20 * 100;        // 绿 20 银
            case ITEM_QUALITY_RARE:      return 1 * 10000;        // 蓝 1 金
            case ITEM_QUALITY_EPIC:      return 5 * 10000;        // 紫 5 金
            case ITEM_QUALITY_LEGENDARY: return 50 * 10000;       // 橙 50 金
            default:                     return 0;
        }
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
            TEMP_ENCHANTMENT_SLOT, BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
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

    Item* GetTargetItem(Player* player, uint32 bag, uint32 slot)
    {
        return player->GetItemByPos(uint8(bag), uint8(slot));
    }

    bool CanReroll(Player*, Item* item)
    {
        ItemTemplate const* proto = item->GetTemplate();
        if (!proto)
            return false;

        if (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR)
            return false;

        uint32 const quality = QualityOf(proto);
        return CostForQuality(quality) != 0;
    }

    void DoInfo(Player* player, Item* item)
    {
        uint32 const score = ItemScoreAffix::GetScore(item);
        uint32 const budget = ItemScoreAffix::GetBudget(player, item);
        ItemTemplate const* proto = item->GetTemplate();

        std::ostringstream oss;
        oss << "info;" << item->GetEntry() << ';' << score << ';' << budget << ';'
            << QualityOf(proto) << ';' << player->GetMoney();
        AppendAffixes(item, oss);
        Reply(player, oss.str());
    }

    void DoScore(Player* player, Item* item, bool batch)
    {
        ItemTemplate const* proto = item->GetTemplate();
        uint32 const cost = CostForQuality(QualityOf(proto)) * (batch ? BATCH_TIMES : 1);

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
            // 100 次里取最高：记录 enchant 快照
            EnchantmentSlot const slots[] =
            {
                PERM_ENCHANTMENT_SLOT, TEMP_ENCHANTMENT_SLOT, BONUS_ENCHANTMENT_SLOT,
                USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
            };

            uint32 bestScore = 0;
            uint32 bestIds[5] = { 0, 0, 0, 0, 0 };

            for (uint32 i = 0; i < BATCH_TIMES; ++i)
            {
                ItemScoreAffix::Reroll(player, item);

                uint32 const score = ItemScoreAffix::GetScore(item);
                if (score > bestScore)
                {
                    bestScore = score;
                    for (uint32 s = 0; s < 5; ++s)
                        bestIds[s] = item->GetEnchantmentId(slots[s]);
                }
            }

            for (uint32 s = 0; s < 5; ++s)
                item->SetEnchantment(slots[s], bestIds[s], 0, 0);
        }

        item->SetState(ITEM_CHANGED, player);

        uint32 const score = ItemScoreAffix::GetScore(item);
        uint32 const budget = ItemScoreAffix::GetBudget(player, item);

        std::ostringstream oss;
        oss << "done;" << item->GetEntry() << ';' << score << ';' << budget << ';' << cost;
        AppendAffixes(item, oss);
        Reply(player, oss.str());
    }

    void DoLine(Player* player, Item* item, uint32 index)
    {
        if (index >= 4)
        {
            Reply(player, "err;badindex");
            return;
        }

        ItemTemplate const* proto = item->GetTemplate();
        uint32 const cost = CostForQuality(QualityOf(proto));

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
        AppendAffixes(item, oss);
        Reply(player, oss.str());
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
                    TC_LOG_INFO("server.loading", "   backpack slot={} entry={} guid={}", s, it->GetEntry(), it->GetGUID().ToString());
            }
        }
        TC_LOG_INFO("server.loading", ">> REROLL cmd={} bag={} slot={} item={}", cmd, bag, slot, item ? item->GetEntry() : 0);
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
    }
}

class reroll_addon_playerscript : public PlayerScript
{
public:
    reroll_addon_playerscript() : PlayerScript("reroll_addon_playerscript") { }

    void OnChat(Player* player, uint32 /*type*/, uint32 /*lang*/, std::string& msg) override
    {
        TC_LOG_INFO("server.loading", ">> CHAT hook: {}", msg);

        if (msg.rfind(PROTOCOL_PREFIX, 0) != 0)
            return;

        TC_LOG_INFO("server.loading", ">> REROLL protocol recv: {}", msg);

        HandleProtocol(player, msg);
        msg.clear();   // 不广播给其他人
    }
};

void AddSC_reroll_addon()
{
    new reroll_addon_playerscript();
}
