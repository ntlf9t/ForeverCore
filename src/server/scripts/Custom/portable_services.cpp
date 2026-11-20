/*
 * 随身服务：商店 / 银行 / 主城传送
 *
 * 插件协议：WX
 *   WX|SHOP          召唤随身商人
 *   WX|BANK          打开银行
 *   WX|TP|<key>      传送到主城/中立城市
 */

#include "Creature.h"
#include "Chat.h"
#include "Player.h"
#include "Random.h"
#include "ScriptMgr.h"
#include "TemporarySummon.h"
#include "Unit.h"

#include <string>
#include <unordered_map>

namespace
{
    struct TeleportPoint
    {
        uint32 Map;
        float X;
        float Y;
        float Z;
        float O;
    };

    std::unordered_map<std::string, TeleportPoint> const _teleports =
    {
        // 联盟主城
        { "stormwind",   { 0, -8833.07f,  622.778f,  93.9317f, 0.6771f } },
        { "ironforge",   { 0, -4918.88f, -940.406f, 501.564f, 5.42347f } },
        { "darnassus",   { 1,  9949.56f, 2284.21f, 1341.40f, 1.59587f } },

        // 部落主城
        { "orgrimmar",   { 1,  1569.97f, -4397.41f, 16.0472f, 0.543025f } },
        { "thunderbluff",{ 1, -1277.37f,  124.804f, 131.287f, 5.22274f } },
        { "undercity",   { 0,  1584.07f,  241.987f, -52.1534f, 0.049647f } },

        // 中立重要城市
        { "everlook",    { 1,  6725.69f, -4619.44f, 720.909f, 4.66802f } }, // 冬泉谷
        { "ratchet",     { 1,  -956.664f, -3754.71f, 5.33239f, 0.996637f } }, // 棘齿城
        { "gadgetzan",   { 1, -7177.15f, -3785.34f, 8.36981f, 6.10237f } },  // 塔纳利斯
        { "bootybay",    { 0, -14297.20f, 530.993f, 8.77916f, 3.98863f } }    // 藏宝海湾
    };

    constexpr uint32 PORTABLE_VENDOR_ENTRY = 3625; // 通用商人模板（Rarck）
    constexpr uint32 PORTABLE_BANKER_ENTRY = 5060; // World Banker，全阵营友好

    void ShowPortableShop(Player* player)
    {
        if (!player || !player->IsInWorld())
            return;

        float x = player->GetPositionX() + 2.0f;
        float y = player->GetPositionY();
        float z = player->GetPositionZ();
        float o = player->GetOrientation();

        TempSummon* summon = player->SummonCreature(PORTABLE_VENDOR_ENTRY, x, y, z, o,
            TEMPSUMMON_TIMED_DESPAWN, 60s);
        if (!summon)
        {
            player->GetSession()->SendNotification("无法打开随身商店，请稍后再试。");
            return;
        }

        Creature* vendor = summon->ToCreature();
        if (!vendor)
            return;

        // 临时商人：对所有阵营友好，且不能被攻击
        vendor->SetFaction(35);
        vendor->SetUnitFlag(UNIT_FLAG_NON_ATTACKABLE);
        vendor->SetReactState(REACT_PASSIVE);

        player->GetSession()->SendListInventory(vendor->GetGUID());
    }

    void ShowPortableBank(Player* player)
    {
        if (!player || !player->IsInWorld())
            return;

        float x = player->GetPositionX() + 2.0f;
        float y = player->GetPositionY();
        float z = player->GetPositionZ();
        float o = player->GetOrientation();

        TempSummon* summon = player->SummonCreature(PORTABLE_BANKER_ENTRY, x, y, z, o,
            TEMPSUMMON_TIMED_DESPAWN, 300s);
        if (!summon)
        {
            player->GetSession()->SendNotification("无法打开随身银行，请稍后再试。");
            return;
        }

        Creature* banker = summon->ToCreature();
        if (!banker)
            return;

        banker->SetFaction(35);
        banker->SetUnitFlag(UNIT_FLAG_NON_ATTACKABLE);
        banker->SetReactState(REACT_PASSIVE);

        player->GetSession()->SendShowBank(banker->GetGUID(), PlayerInteractionType::Banker);
    }

    bool TeleportToCity(Player* player, std::string const& key)
    {
        if (!player || !player->IsInWorld())
            return false;

        // 回家：直接去炉石绑定点，不消耗炉石 CD
        if (key == "home")
            return player->TeleportTo(player->m_homebind);

        auto it = _teleports.find(key);
        if (it == _teleports.end())
            return false;

        TeleportPoint const& point = it->second;
        return player->TeleportTo(point.Map, point.X, point.Y, point.Z, point.O);
    }

    void BuyBuffPack(Player* player)
    {
        if (!player || !player->IsInWorld())
            return;

        constexpr uint32 BUFF_PACK_COST = 50 * GOLD;

        if (player->GetMoney() < BUFF_PACK_COST)
        {
            player->GetSession()->SendNotification("金币不足，需要 50 金。");
            return;
        }

        // 世界 Buff 套餐：屠龙者 / 大酋长 / 摩尔达 / 风歌 / 芬古斯 / 斯里基克 / 赞达拉 / 塞格
        static constexpr uint32 buffs[] =
        {
            22888, // 屠龙者的咆哮
            16609, // 大酋长的祝福
            22818, // 摩尔达的勇气
            15366, // 风歌夜曲
            22817, // 芬古斯的狂暴
            22820, // 斯里基克的机智
            24425, // 赞达拉之魂
            23768  // 塞格的黑暗塔罗牌：伤害
        };

        uint32 applied = 0;
        for (uint32 spellId : buffs)
        {
            if (player->AddAura(spellId, player))
                ++applied;
        }

        if (!applied)
        {
            player->GetSession()->SendNotification("Buff 施加失败，请稍后再试。");
            return;
        }

        player->ModifyMoney(-int64(BUFF_PACK_COST));
        ChatHandler(player->GetSession()).PSendSysMessage("已获得世界 Buff 套餐，消耗 50 金。");
    }

    std::string FormatMoney(uint64 copper)
    {
        uint64 gold = copper / GOLD;
        uint64 silver = (copper % GOLD) / SILVER;
        uint64 rest = copper % SILVER;
        return std::to_string(gold) + "金" + std::to_string(silver) + "银" + std::to_string(rest) + "铜";
    }

    void HandleGamble(Player* player, uint64 stake)
    {
        if (!player || !player->IsInWorld())
            return;

        // 只允许 1 / 10 / 100 / 1000 金
        static constexpr uint64 allowedStakes[] = { 1 * GOLD, 10 * GOLD, 100 * GOLD, 1000 * GOLD };
        bool allowed = false;
        for (uint64 value : allowedStakes)
        {
            if (stake == value)
            {
                allowed = true;
                break;
            }
        }

        if (!allowed || player->GetMoney() < stake)
        {
            player->GetSession()->SendNotification("金币不足，或押注金额无效。");
            return;
        }

        player->ModifyMoney(-int64(stake));

        // 1-970 不中（97%）；971-990 10 倍（2%）；991-1000 50 倍（1%）
        uint32 roll = urand(1, 1000);
        uint32 multiplier = 0;
        if (roll <= 970)
            multiplier = 0;
        else if (roll <= 990)
            multiplier = 10;
        else
            multiplier = 50;

        uint64 payout = stake * multiplier;
        if (payout)
            player->ModifyMoney(int64(payout));

        if (multiplier == 0)
        {
            ChatHandler(player->GetSession()).PSendSysMessage("赌博结果：血本无归，损失 %s。",
                FormatMoney(stake).c_str());
        }
        else
        {
            ChatHandler(player->GetSession()).PSendSysMessage("赌博结果：中奖 %u 倍，获得 %s。",
                multiplier, FormatMoney(payout).c_str());
        }
    }
}

class portable_services_playerscript : public PlayerScript
{
public:
    portable_services_playerscript() : PlayerScript("portable_services_playerscript") { }

    void OnAddonMessageSent(Player* player, uint32 /*type*/, std::string const& prefix,
        std::string const& text, Player* /*receiver*/) override
    {
        if (!player || prefix != "WX")
            return;

        if (text == "SHOP")
        {
            ShowPortableShop(player);
            return;
        }

        if (text == "BANK")
        {
            ShowPortableBank(player);
            return;
        }

        if (text == "BUFF50")
        {
            BuyBuffPack(player);
            return;
        }

        if (text.rfind("GAMBLE|", 0) == 0)
        {
            uint64 stake = 0;
            try
            {
                stake = std::stoull(text.substr(7));
            }
            catch (...)
            {
                return;
            }
            HandleGamble(player, stake);
            return;
        }

        if (text.rfind("TP|", 0) == 0)
            TeleportToCity(player, text.substr(3));
    }
};

void AddSC_portable_services()
{
    new portable_services_playerscript();
}
