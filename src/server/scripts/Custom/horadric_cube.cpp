/*
 * 赫拉迪克方块（Horadric Cube）
 *
 * 载体：炉石（物品 6948，已在 item_sparse 里改名为「赫拉迪克方块」）
 * 机制：右键使用 -> 召唤一个隐形 NPC -> 用 NPC 作为 gossip 来源打开菜单
 *
 * 菜单：
 *   - 模式选择（占位）
 *   - 传送（主城 + 中立城镇）
 *   - 符文石商店（占位）
 *   - 关闭
 */

#include "Chat.h"
#include "Creature.h"
#include "GossipDef.h"
#include "Item.h"
#include "PhasingHandler.h"
#include "Player.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "ScriptMgr.h"
#include "TemporarySummon.h"
#include <limits>

namespace
{
    constexpr uint32 CUBE_NPC_ENTRY   = 950000;
    constexpr uint32 CUBE_SUMMON_TIME = 60000;

    enum CubeAction : uint32
    {
        CUBE_ACTION_MODE     = 1,
        CUBE_ACTION_TELEPORT = 2,
        CUBE_ACTION_SHOP     = 3,
        CUBE_ACTION_BACK     = 100,
        CUBE_ACTION_CLOSE    = 101,
        CUBE_ACTION_TP_FIRST = 1000,   // 1000 + 索引
    };

    struct CubeTeleport
    {
        char const* Name;
        uint32 MapId;
        float X, Y, Z, O;
    };

    CubeTeleport const CubeTeleports[] =
    {
        // 联盟主城
        { "暴风城",   0, -8913.23f,   554.63f,  93.79f, 0.0f },
        { "铁炉堡",   0, -5032.00f,  -819.00f, 495.00f, 0.0f },
        { "达纳苏斯", 1,  9949.56f,  2284.21f, 1341.4f, 0.0f },
        // 部落主城
        { "奥格瑞玛", 1,  1629.50f, -4373.60f,  31.20f, 0.0f },
        { "雷霆崖",   1, -1274.00f,    71.00f, 128.00f, 0.0f },
        { "幽暗城",   0,  1633.00f,   240.00f, -43.00f, 0.0f },
        // 中立城镇
        { "棘齿城",   1, -1034.00f, -3689.00f,  22.00f, 0.0f },
        { "永望镇",   1,  6773.00f, -4796.00f, 700.00f, 0.0f },
        { "加基森",   1, -7134.00f, -4747.00f,  36.00f, 0.0f },
        { "藏宝海湾", 0, -14306.0f,   522.00f,   4.00f, 0.0f },
    };

    constexpr uint32 CubeTeleportCount = sizeof(CubeTeleports) / sizeof(CubeTeleports[0]);

    void ShowMainMenu(Player* player, ObjectGuid source)
    {
        ClearGossipMenuFor(player);
        InitGossipMenuFor(player, 21);   // 给一个合法 GossipID，否则客户端会忽略服务器主动推送的菜单
        AddGossipItemFor(player, GossipOptionNpc::None,     "模式选择（开发中）",   1, CUBE_ACTION_MODE);
        AddGossipItemFor(player, GossipOptionNpc::Taxinode, "传送",                 1, CUBE_ACTION_TELEPORT);
        AddGossipItemFor(player, GossipOptionNpc::Vendor,   "符文石商店（开发中）", 1, CUBE_ACTION_SHOP);
        AddGossipItemFor(player, GossipOptionNpc::None,     "关闭",                 1, CUBE_ACTION_CLOSE);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, source);
    }

    void ShowTeleportMenu(Player* player, ObjectGuid source)
    {
        ClearGossipMenuFor(player);
        InitGossipMenuFor(player, 21);
        for (uint32 i = 0; i < CubeTeleportCount; ++i)
            AddGossipItemFor(player, GossipOptionNpc::Taxinode, CubeTeleports[i].Name, 1, CUBE_ACTION_TP_FIRST + i);

        AddGossipItemFor(player, GossipOptionNpc::None, "返回", 1, CUBE_ACTION_BACK);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, source);
    }
}

class npc_horadric_cube_AI : public ScriptedAI
{
public:
    npc_horadric_cube_AI(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipHello(Player* player) override
    {
        TC_LOG_INFO("server.loading", ">> CUBE gossip hello: npcflags={} entry={}", me->GetNpcFlags(), me->GetEntry());
        ShowMainMenu(player, me->GetGUID());
        return true;
    }

    bool OnGossipSelect(Player* player, uint32 /*menuId*/, uint32 action) override
    {
        player->PlayerTalkClass->ClearMenus();

        switch (action)
        {
            case CUBE_ACTION_CLOSE:
                CloseGossipMenuFor(player);
                me->AddObjectToRemoveList();
                return true;
            case CUBE_ACTION_BACK:
                ShowMainMenu(player, me->GetGUID());
                return true;
            case CUBE_ACTION_MODE:
                ChatHandler(player->GetSession()).SendSysMessage("模式选择功能开发中。");
                ShowMainMenu(player, me->GetGUID());
                return true;
            case CUBE_ACTION_SHOP:
                ChatHandler(player->GetSession()).SendSysMessage("符文石商店开发中。");
                ShowMainMenu(player, me->GetGUID());
                return true;
            case CUBE_ACTION_TELEPORT:
                ShowTeleportMenu(player, me->GetGUID());
                return true;
            default:
                break;
        }

        if (action >= CUBE_ACTION_TP_FIRST && action < CUBE_ACTION_TP_FIRST + CubeTeleportCount)
        {
            CubeTeleport const& tp = CubeTeleports[action - CUBE_ACTION_TP_FIRST];
            CloseGossipMenuFor(player);
            me->AddObjectToRemoveList();
            player->TeleportTo(tp.MapId, tp.X, tp.Y, tp.Z, tp.O);
            return true;
        }

        return false;
    }
};

class npc_horadric_cube : public CreatureScript
{
public:
    npc_horadric_cube() : CreatureScript("npc_horadric_cube") { }

    CreatureAI* GetAI(Creature* creature) const override
    {
        TC_LOG_INFO("server.loading", ">> CUBE GetAI entry={}", creature->GetEntry());
        return new npc_horadric_cube_AI(creature);
    }
};

class item_horadric_cube : public ItemScript
{
public:
    item_horadric_cube() : ItemScript("item_horadric_cube") { }

    bool OnUse(Player* player, Item* item, SpellCastTargets const& /*targets*/, ObjectGuid /*castId*/) override
    {
        TC_LOG_INFO("server.loading", ">> CUBE OnUse item={} scriptId={}", item->GetEntry(), item->GetScriptId());

        // 传送点与 world.creature 里预放的 950000 方块 NPC 坐标一一对应
        struct CubeAnchor { uint32 MapId; float X, Y, Z, O; };
        static CubeAnchor const anchors[] =
        {
            { 0, -8913.23f,   554.63f,  93.79f, 0.0f },   // 暴风城
            { 0, -5032.00f,  -819.00f, 495.00f, 0.0f },   // 铁炉堡
            { 1,  9949.56f,  2284.21f, 1341.4f, 0.0f },   // 达纳苏斯
            { 1,  1629.50f, -4373.60f,  31.20f, 0.0f },   // 奥格瑞玛
            { 1, -1274.00f,    71.00f, 128.00f, 0.0f },   // 雷霆崖
            { 0,  1633.00f,   240.00f, -43.00f, 0.0f },   // 幽暗城
        };

        uint32 bestMap = player->GetMapId();
        float bestX = anchors[0].X, bestY = anchors[0].Y, bestZ = anchors[0].Z, bestO = anchors[0].O;
        float bestDist = std::numeric_limits<float>::max();

        for (CubeAnchor const& a : anchors)
        {
            if (a.MapId != player->GetMapId())
                continue;

            float dx = player->GetPositionX() - a.X;
            float dy = player->GetPositionY() - a.Y;
            float d = dx * dx + dy * dy;
            if (d < bestDist)
            {
                bestDist = d;
                bestMap = a.MapId;
                bestX = a.X; bestY = a.Y; bestZ = a.Z; bestO = a.O;
            }
        }

        if (bestDist > 100.0f * 100.0f || bestMap != player->GetMapId())
        {
            // 不在主城附近：直接传送到最近的主城方块旁
            player->TeleportTo(bestMap, bestX + 2.0f, bestY + 2.0f, bestZ, bestO);
            ChatHandler(player->GetSession()).SendSysMessage("已传送到赫拉迪克方块旁，点击方块选择功能。");
            return true;
        }

        ChatHandler(player->GetSession()).SendSysMessage("你附近就有赫拉迪克方块，点击它选择功能。");
        return true;   // 阻止炉石原本的传送效果
    }
};

void AddSC_horadric_cube()
{
    new npc_horadric_cube();
    new item_horadric_cube();
}
