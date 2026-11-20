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
        { "stormwind",   { 0, -8913.23f,  554.63f,  93.79f, 0.0f } },
        { "ironforge",   { 0, -4982.60f, -881.80f, 501.60f, 0.0f } },
        { "darnassus",   { 0,  9949.50f, 2284.20f, 1341.40f, 0.0f } },

        // 部落主城
        { "orgrimmar",   { 1,  1629.50f, -4373.40f, 31.20f, 0.0f } },
        { "thunderbluff",{ 1, -1274.60f,   71.20f, 128.80f, 0.0f } },
        { "undercity",   { 1,  1819.70f,   239.40f, 60.00f, 0.0f } },

        // 中立重要城市
        { "everlook",    { 1,  6767.60f, -2973.00f, 617.00f, 0.0f } }, // 冬泉谷
        { "ratchet",     { 1,  -824.00f, -4933.00f, 22.00f, 0.0f } },  // 棘齿城
        { "gadgetzan",   { 1, -7144.00f, -3782.00f,  9.00f, 0.0f } },  // 塔纳利斯
        { "bootybay",    { 0, -14281.00f,  553.00f,  8.00f, 0.0f } }   // 藏宝海湾
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

        if (text.rfind("TP|", 0) == 0)
            TeleportToCity(player, text.substr(3));
    }
};

void AddSC_portable_services()
{
    new portable_services_playerscript();
}
