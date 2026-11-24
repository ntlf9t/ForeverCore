/*
 * 炉石对话菜单（参考 legion-core Hearthstone.cpp 移植）
 *
 * 载体：炉石（物品 6948），通过 world.item_script_names 绑定 ScriptName 'item_hearthstone_menu'
 * 机制：右键使用 -> 以物品 GUID 作为 gossip 来源打开菜单 -> PlayerScript::OnGossipSelect 响应
 *
 * 功能：
 *   1. 炉石回家（旅店绑定点，原本炉石功能，施放 8690）
 *   2. 炉石绑定点传送（读取 characters.Hearthstone_teleport_home）
 *   3. 世界主城传送（读取 world.Hearthstone_teleport：idx, map, x, y, z, o, comment）
 *   4. 随身商人（召唤临时商人 NPC）
 *   5. 绑定炉石（将当前位置写入 characters.Hearthstone_teleport_home）
 *   6. 角色解卡（同账号离线角色传送到最近墓地 / 出生点，2 小时冷却）
 */

#include "Chat.h"
#include "ChatCommand.h"
#include "Creature.h"
#include "DatabaseEnv.h"
#include "GameTime.h"
#include "GossipDef.h"
#include "Item.h"
#include "Map.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "PlayerMode.h"
#include "RBAC.h"
#include "ScriptedGossip.h"
#include "ScriptMgr.h"
#include "Spell.h"
#include "SpellHistory.h"
#include "TemporarySummon.h"
#include "WorldSession.h"

#include <limits>
#include <string>
#include <vector>

using namespace Trinity::ChatCommands;

namespace
{
    constexpr uint32 HEARTHSTONE_ITEM_ID  = 6948;
    constexpr uint32 HEARTHSTONE_SPELL_ID = 8690;
    constexpr uint32 HEARTHSTONE_MENU_ID  = 21;      // 合法 GossipID，否则客户端会忽略服务器主动推送的菜单
    constexpr uint32 GHOST_AURA_SPELL_ID  = 8326;    // 幽灵状态
    constexpr uint32 UNSTUCK_COOLDOWN     = 7200;    // 解卡冷却：2 小时
    constexpr uint32 VENDOR_COOLDOWN      = 600;     // 随身商人冷却：10 分钟
    constexpr uint32 BIND_COOLDOWN        = 600;     // 绑定炉石冷却：10 分钟
    constexpr uint32 LONE_BIND_COOLDOWN   = 1800;    // 孤勇绑定炉石冷却：30 分钟

    // 随身商人（与 portable_services 共用商人 NPC 及 npc_vendor 数据）
    constexpr uint32 PORTABLE_VENDOR_HORDE    = 3625; // 兽人商人
    constexpr uint32 PORTABLE_VENDOR_ALLIANCE = 1459; // 人类商人

    enum HearthstoneSenders : uint32
    {
        SENDER_MAIN    = 1,
        SENDER_CITY    = 2,
        SENDER_UNSTUCK = 5
    };

    enum HearthstoneActions : uint32
    {
        ACTION_MAIN_MENU     = 1,
        ACTION_HEARTHSTONE   = 2,
        ACTION_TELEPORT_HOME = 3,
        ACTION_CITY_MENU     = 4,
        ACTION_VENDOR        = 5,
        ACTION_BIND          = 6,
        ACTION_UNSTUCK_MENU  = 7,
        ACTION_CLOSE         = 8
    };

    struct HearthstoneTeleport
    {
        uint32 Team = 0;
        uint32 Map = 0;
        float X = 0.f, Y = 0.f, Z = 0.f, O = 0.f;
        std::string Comment;
    };

    std::vector<HearthstoneTeleport> _cityTeleports;

    void LoadCityTeleports()
    {
        _cityTeleports.clear();

        QueryResult result = WorldDatabase.Query("SELECT team, map, x, y, z, o, comment FROM Hearthstone_teleport ORDER BY idx ASC");
        if (!result)
        {
            TC_LOG_INFO("server.loading", ">> 炉石菜单：world.Hearthstone_teleport 为空，主城传送列表未加载。");
            return;
        }

        do
        {
            Field* fields = result->Fetch();

            HearthstoneTeleport tele;
            tele.Team    = fields[0].GetUInt32();
            tele.Map     = fields[1].GetUInt32();
            tele.X       = fields[2].GetFloat();
            tele.Y       = fields[3].GetFloat();
            tele.Z       = fields[4].GetFloat();
            tele.O       = fields[5].GetFloat();
            tele.Comment = fields[6].GetString();

            _cityTeleports.push_back(std::move(tele));
        } while (result->NextRow());

        TC_LOG_INFO("server.loading", ">> 炉石菜单：已加载 {} 个主城传送点。", _cityTeleports.size());
    }

    void Notify(Player* player, std::string const& text)
    {
        player->GetSession()->SendNotification("%s", text.c_str());
    }

    uint32 GetCooldownRemaining(ObjectGuid::LowType guidLow, char const* column, uint32 duration, uint32 now)
    {
        QueryResult result = CharacterDatabase.PQuery(
            "SELECT {} FROM Hearthstone_cooldown WHERE guid = {}", column, guidLow);
        if (!result)
            return 0;

        uint32 lastUse = result->Fetch()[0].GetUInt32();
        if (lastUse > now)
            return duration;

        uint32 elapsed = now - lastUse;
        return elapsed < duration ? duration - elapsed : 0;
    }

    void UpdateCooldown(ObjectGuid::LowType guidLow, char const* column, uint32 now)
    {
        CharacterDatabase.PExecute(
            "INSERT INTO Hearthstone_cooldown (guid, {}) VALUES ({}, {}) "
            "ON DUPLICATE KEY UPDATE {} = VALUES({})",
            column, guidLow, now, column, column);
    }

    std::string FormatCooldown(uint32 remaining)
    {
        uint32 minutes = (remaining + 59) / 60;
        return std::to_string(minutes) + " 分钟";
    }

    uint32 GetBindCooldown(Player* player)
    {
        return PlayerMode::IsLone(player) ? LONE_BIND_COOLDOWN : BIND_COOLDOWN;
    }

    uint32 GetUnstuckCooldownRemaining(uint64 guidLow, uint32 now)
    {
        QueryResult result = CharacterDatabase.PQuery(
            "SELECT last_unlock_time FROM character_cardunlock_cooldown WHERE guid = {}", guidLow);
        if (!result)
            return 0;

        uint32 lastUnlockTime = result->Fetch()[0].GetUInt32();
        if (now - lastUnlockTime < UNSTUCK_COOLDOWN)
            return UNSTUCK_COOLDOWN - (now - lastUnlockTime);

        return 0;
    }

    void ShowMainMenu(Player* player, ObjectGuid source)
    {
        ClearGossipMenuFor(player);
        InitGossipMenuFor(player, HEARTHSTONE_MENU_ID);

        uint32 now = uint32(GameTime::GetGameTime());
        ObjectGuid::LowType guid = player->GetGUID().GetCounter();
        std::string vendorText = "召唤随身商人";
        std::string bindText = "绑定炉石（记录当前位置）";

        if (uint32 remaining = GetCooldownRemaining(guid, "last_vendor_time", VENDOR_COOLDOWN, now))
            vendorText += "（冷却：" + FormatCooldown(remaining) + "）";

        if (uint32 remaining = GetCooldownRemaining(guid, "last_bind_time", GetBindCooldown(player), now))
            bindText += "（冷却：" + FormatCooldown(remaining) + "）";

        AddGossipItemFor(player, GossipOptionNpc::Binder,   "炉石回家（旅店绑定点）",   SENDER_MAIN, ACTION_HEARTHSTONE);
        AddGossipItemFor(player, GossipOptionNpc::Taxinode, "传送到炉石绑定点",         SENDER_MAIN, ACTION_TELEPORT_HOME);
        AddGossipItemFor(player, GossipOptionNpc::Taxinode, "世界主城传送",             SENDER_MAIN, ACTION_CITY_MENU);
        AddGossipItemFor(player, GossipOptionNpc::Vendor,   vendorText,                 SENDER_MAIN, ACTION_VENDOR);
        AddGossipItemFor(player, GossipOptionNpc::Binder,   bindText,                   SENDER_MAIN, ACTION_BIND,
            "确定要将炉石绑定点设置为当前位置吗？", 0, false);
        AddGossipItemFor(player, GossipOptionNpc::None,     "角色解卡",                 SENDER_MAIN, ACTION_UNSTUCK_MENU);
        AddGossipItemFor(player, GossipOptionNpc::None,     "关闭",                     SENDER_MAIN, ACTION_CLOSE);

        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, source);
    }

    void ShowCityMenu(Player* player, ObjectGuid source)
    {
        if (_cityTeleports.empty())
            LoadCityTeleports();

        ClearGossipMenuFor(player);
        InitGossipMenuFor(player, HEARTHSTONE_MENU_ID);

        for (uint32 i = 0; i < _cityTeleports.size(); ++i)
        {
            if (_cityTeleports[i].Team != 0 && _cityTeleports[i].Team != uint32(player->GetTeam()))
                continue;

            AddGossipItemFor(player, GossipOptionNpc::Taxinode, _cityTeleports[i].Comment, SENDER_CITY, i);
        }

        AddGossipItemFor(player, GossipOptionNpc::None, "返回", SENDER_MAIN, ACTION_MAIN_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, source);
    }

    void ShowUnstuckMenu(Player* player, ObjectGuid source)
    {
        ClearGossipMenuFor(player);
        InitGossipMenuFor(player, HEARTHSTONE_MENU_ID);

        uint32 now = uint32(GameTime::GetGameTime());
        QueryResult result = CharacterDatabase.PQuery(
            "SELECT c.guid, c.name, c.online, COALESCE(m.lone, 0) "
            "FROM characters c LEFT JOIN character_modes m ON m.guid = c.guid WHERE c.account = {}",
            player->GetSession()->GetAccountId());
        if (result)
        {
            do
            {
                Field* fields = result->Fetch();
                uint64 guidLow   = fields[0].GetUInt64();
                std::string name = fields[1].GetString();
                bool online      = fields[2].GetBool();
                bool lone        = fields[3].GetBool();

                // action 为 uint32，过大的 guid 无法编码
                if (guidLow >= uint64(std::numeric_limits<uint32>::max()) - GOSSIP_ACTION_INFO_DEF)
                    continue;

                std::string text = name;
                if (lone)
                    text += "（孤勇模式禁止解卡）";
                else if (online)
                    text += "（在线）";
                else if (uint32 remaining = GetUnstuckCooldownRemaining(guidLow, now))
                    text += "（冷却：" + std::to_string((remaining + 59) / 60) + " 分钟）";
                else
                    text += "（可解卡）";

                AddGossipItemFor(player, GossipOptionNpc::None, text, SENDER_UNSTUCK, GOSSIP_ACTION_INFO_DEF + uint32(guidLow));
            } while (result->NextRow());
        }

        AddGossipItemFor(player, GossipOptionNpc::None, "返回", SENDER_MAIN, ACTION_MAIN_MENU);
        SendGossipMenuFor(player, DEFAULT_GOSSIP_MESSAGE, source);
    }

    // 原本炉石功能：施放炉石法术回旅店绑定点
    void CastHearthstone(Player* player)
    {
        CloseGossipMenuFor(player);

        player->GetSpellHistory()->ResetCooldown(HEARTHSTONE_SPELL_ID, true);
        player->CastSpell(player, HEARTHSTONE_SPELL_ID, false);
    }

    // 炉石绑定点传送：读取 characters.Hearthstone_teleport_home
    void TeleportToBindPoint(Player* player)
    {
        CloseGossipMenuFor(player);

        if (player->IsInCombat())
        {
            Notify(player, "战斗中无法使用传送。");
            return;
        }

        QueryResult result = CharacterDatabase.PQuery(
            "SELECT map, x, y, z, o FROM Hearthstone_teleport_home WHERE guid = {}", player->GetGUID().GetCounter());
        if (!result)
        {
            Notify(player, "你还没有绑定炉石传送点，请先使用「绑定炉石」。");
            return;
        }

        Field* fields = result->Fetch();
        uint32 mapId = fields[0].GetUInt32();
        float x = fields[1].GetFloat();
        float y = fields[2].GetFloat();
        float z = fields[3].GetFloat();
        float o = fields[4].GetFloat();

        if (!player->TeleportTo(mapId, x, y, z, o))
            Notify(player, "炉石绑定点已失效，请重新绑定。");
    }

    void TeleportToCity(Player* player, uint32 index)
    {
        CloseGossipMenuFor(player);

        if (index >= _cityTeleports.size())
            return;

        if (player->IsInCombat())
        {
            Notify(player, "战斗中无法使用传送。");
            return;
        }

        HearthstoneTeleport const& tele = _cityTeleports[index];
        if (tele.Team != 0 && tele.Team != uint32(player->GetTeam()))
        {
            Notify(player, "该传送点不属于你的阵营。");
            return;
        }

        if (!player->TeleportTo(tele.Map, tele.X, tele.Y, tele.Z, tele.O))
            Notify(player, "传送点「" + tele.Comment + "」已损坏，请联系管理员。");
    }

    // 随身商人：召唤临时商人并直接打开购买列表
    void SummonPortableVendor(Player* player)
    {
        CloseGossipMenuFor(player);

        if (!player->IsInWorld())
            return;

        uint32 now = uint32(GameTime::GetGameTime());
        if (uint32 remaining = GetCooldownRemaining(player->GetGUID().GetCounter(), "last_vendor_time", VENDOR_COOLDOWN, now))
        {
            Notify(player, "随身商人冷却中，剩余 " + FormatCooldown(remaining) + "。");
            return;
        }

        bool alliance = player->GetTeam() == ALLIANCE;
        uint32 entry = alliance ? PORTABLE_VENDOR_ALLIANCE : PORTABLE_VENDOR_HORDE;

        float x = player->GetPositionX() + 2.0f;
        float y = player->GetPositionY();
        float z = player->GetPositionZ();
        float o = player->GetOrientation();

        TempSummon* summon = player->SummonCreature(entry, x, y, z, o, TEMPSUMMON_TIMED_DESPAWN, 60s);
        if (!summon)
        {
            Notify(player, "无法召唤随身商人，请稍后再试。");
            return;
        }

        Creature* vendor = summon->ToCreature();
        if (!vendor)
            return;

        // 只禁止攻击，不改阵营
        vendor->SetFaction(alliance ? 12 : 1215);
        vendor->SetUnitFlag(UNIT_FLAG_NON_ATTACKABLE);
        vendor->SetReactState(REACT_PASSIVE);

        player->GetSession()->SendListInventory(vendor->GetGUID());
        UpdateCooldown(player->GetGUID().GetCounter(), "last_vendor_time", now);
    }

    // 绑定炉石：将当前位置写入 characters.Hearthstone_teleport_home
    void BindHearthstone(Player* player)
    {
        CloseGossipMenuFor(player);

        if (player->GetMap()->IsBattlegroundOrArena())
        {
            Notify(player, "你所在地图无法设置炉石绑定点！");
            return;
        }

        uint32 now = uint32(GameTime::GetGameTime());
        if (uint32 remaining = GetCooldownRemaining(player->GetGUID().GetCounter(), "last_bind_time", GetBindCooldown(player), now))
        {
            Notify(player, "绑定炉石冷却中，剩余 " + FormatCooldown(remaining) + "。");
            return;
        }

        std::string name = player->GetName();
        CharacterDatabase.EscapeString(name);

        CharacterDatabase.PExecute(
            "INSERT INTO Hearthstone_teleport_home (guid, account, name, map, x, y, z, o, comment) "
            "VALUES ({}, {}, '{}', {}, {}, {}, {}, {}, '炉石绑定') "
            "ON DUPLICATE KEY UPDATE account = VALUES(account), name = VALUES(name), map = VALUES(map), "
            "x = VALUES(x), y = VALUES(y), z = VALUES(z), o = VALUES(o), comment = VALUES(comment)",
            player->GetGUID().GetCounter(), player->GetSession()->GetAccountId(), name,
            player->GetMapId(), player->GetPositionX(), player->GetPositionY(),
            player->GetPositionZ(), player->GetOrientation());

        UpdateCooldown(player->GetGUID().GetCounter(), "last_bind_time", now);
        Notify(player, "炉石绑定点已设置为当前位置。");
    }

    // 角色解卡：同账号离线角色传送到最近墓地 / 出生点，下次登录生效
    void DoUnstuck(Player* player, uint64 targetGuid)
    {
        CloseGossipMenuFor(player);

        // 校验目标角色属于当前账号，防止伪造 action
        QueryResult result = CharacterDatabase.PQuery(
            "SELECT c.online, c.race, c.class, c.map, c.position_x, c.position_y, c.position_z, COALESCE(m.lone, 0) "
            "FROM characters c LEFT JOIN character_modes m ON m.guid = c.guid WHERE c.guid = {} AND c.account = {}",
            targetGuid, player->GetSession()->GetAccountId());
        if (!result)
        {
            Notify(player, "角色不存在。");
            return;
        }

        Field* fields = result->Fetch();
        bool online    = fields[0].GetBool();
        uint8 race     = fields[1].GetUInt8();
        uint8 class_   = fields[2].GetUInt8();
        uint32 mapId   = fields[3].GetUInt32();
        float posX     = fields[4].GetFloat();
        float posY     = fields[5].GetFloat();
        float posZ     = fields[6].GetFloat();
        bool lone      = fields[7].GetBool();

        if (online)
        {
            Notify(player, "该角色当前在线，请先下线再操作。");
            return;
        }

        if (lone)
        {
            Notify(player, "孤勇模式角色禁止使用角色解卡。");
            return;
        }

        uint32 now = uint32(GameTime::GetGameTime());
        if (uint32 remaining = GetUnstuckCooldownRemaining(targetGuid, now))
        {
            Notify(player, "该角色解卡冷却中，剩余 " + std::to_string((remaining + 59) / 60) + " 分钟。");
            return;
        }

        // 清除幽灵状态光环
        CharacterDatabase.PExecute("DELETE FROM character_aura WHERE guid = {} AND spell = {}", targetGuid, GHOST_AURA_SPELL_ID);

        // 优先传送到角色当前位置附近的墓地（掉出世界的坐标跳过，避免无效区域查询）
        uint32 team = Player::TeamForRace(race);
        WorldSafeLocsEntry const* graveyard = nullptr;
        if (posZ > -500.0f)
            graveyard = sObjectMgr->GetClosestGraveyard(WorldLocation(mapId, posX, posY, posZ), team, nullptr);

        if (graveyard)
        {
            CharacterDatabase.PExecute(
                "UPDATE characters SET map = {}, position_x = {}, position_y = {}, position_z = {}, orientation = 0, "
                "transguid = 0, trans_x = 0, trans_y = 0, trans_z = 0, trans_o = 0 WHERE guid = {}",
                graveyard->Loc.GetMapId(), graveyard->Loc.GetPositionX(), graveyard->Loc.GetPositionY(),
                graveyard->Loc.GetPositionZ(), targetGuid);
            Notify(player, "角色已传送至最近墓地，下次登录生效。");
        }
        else
        {
            // 备用：出生点
            QueryResult spawnResult = WorldDatabase.PQuery(
                "SELECT map, position_x, position_y, position_z, orientation FROM playercreateinfo WHERE race = {} AND class = {}",
                race, class_);
            if (!spawnResult)
            {
                Notify(player, "未找到该角色的出生点，解卡失败。");
                return;
            }

            Field* spawnFields = spawnResult->Fetch();
            CharacterDatabase.PExecute(
                "UPDATE characters SET map = {}, position_x = {}, position_y = {}, position_z = {}, orientation = {}, "
                "transguid = 0, trans_x = 0, trans_y = 0, trans_z = 0, trans_o = 0 WHERE guid = {}",
                spawnFields[0].GetUInt32(), spawnFields[1].GetFloat(), spawnFields[2].GetFloat(),
                spawnFields[3].GetFloat(), spawnFields[4].GetFloat(), targetGuid);
            Notify(player, "角色已传送至出生点，下次登录生效。");
        }

        // 记录冷却
        CharacterDatabase.PExecute(
            "INSERT INTO character_cardunlock_cooldown (guid, last_unlock_time) VALUES ({}, {}) "
            "ON DUPLICATE KEY UPDATE last_unlock_time = VALUES(last_unlock_time)",
            targetGuid, now);
    }
}

// 右键使用炉石打开菜单
class item_hearthstone_menu : public ItemScript
{
public:
    item_hearthstone_menu() : ItemScript("item_hearthstone_menu") { }

    bool OnUse(Player* player, Item* item, SpellCastTargets const& /*targets*/, ObjectGuid /*castId*/) override
    {
        ShowMainMenu(player, item->GetGUID());
        return true; // 阻止炉石原本的传送效果，回家走菜单里的「炉石回家」
    }
};

// 响应以炉石物品为来源的 gossip 菜单选择
class hearthstone_menu_playerscript : public PlayerScript
{
public:
    hearthstone_menu_playerscript() : PlayerScript("hearthstone_menu_playerscript") { }

    void OnSpellCast(Player* player, Spell* spell, bool /*skipCheck*/) override
    {
        if (!player || !spell || spell->GetSpellInfo()->Id != HEARTHSTONE_SPELL_ID)
            return;

        // OnSpellCast 位于法术真正执行阶段；稍后清除核心刚写入的冷却。
        player->m_Events.AddEventAtOffset([player]()
        {
            player->GetSpellHistory()->ResetCooldown(HEARTHSTONE_SPELL_ID, true);
        }, 100ms);
    }

    void OnGossipSelect(Player* player, ObjectGuid source, uint32 menuId, uint32 listId, std::string const& /*code*/) override
    {
        if (menuId != HEARTHSTONE_MENU_ID || !source.IsItem())
            return;

        Item* item = player->GetItemByGuid(source);
        if (!item || item->GetEntry() != HEARTHSTONE_ITEM_ID)
        {
            CloseGossipMenuFor(player);
            return;
        }

        // 必须在清空菜单前读取 sender / action
        uint32 sender = GetGossipSenderFor(player, listId);
        uint32 action = GetGossipActionFor(player, listId);

        switch (sender)
        {
            case SENDER_MAIN:
                switch (action)
                {
                    case ACTION_MAIN_MENU:
                        ShowMainMenu(player, source);
                        break;
                    case ACTION_HEARTHSTONE:
                        CastHearthstone(player);
                        break;
                    case ACTION_TELEPORT_HOME:
                        TeleportToBindPoint(player);
                        break;
                    case ACTION_CITY_MENU:
                        ShowCityMenu(player, source);
                        break;
                    case ACTION_VENDOR:
                        SummonPortableVendor(player);
                        break;
                    case ACTION_BIND:
                        BindHearthstone(player);
                        break;
                    case ACTION_UNSTUCK_MENU:
                        ShowUnstuckMenu(player, source);
                        break;
                    case ACTION_CLOSE:
                    default:
                        CloseGossipMenuFor(player);
                        break;
                }
                break;
            case SENDER_CITY:
                TeleportToCity(player, action);
                break;
            case SENDER_UNSTUCK:
                if (action >= GOSSIP_ACTION_INFO_DEF)
                    DoUnstuck(player, action - GOSSIP_ACTION_INFO_DEF);
                else
                    CloseGossipMenuFor(player);
                break;
            default:
                CloseGossipMenuFor(player);
                break;
        }
    }
};

// 启动时加载主城传送表
class hearthstone_menu_worldscript : public WorldScript
{
public:
    hearthstone_menu_worldscript() : WorldScript("hearthstone_menu_worldscript") { }

    void OnStartup() override
    {
        LoadCityTeleports();
    }
};

class hearthstone_menu_commandscript : public CommandScript
{
public:
    hearthstone_menu_commandscript() : CommandScript("hearthstone_menu_commandscript") { }

    std::span<ChatCommandBuilder const> GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "reload hearthstone_teleport", HandleReloadHearthstoneTeleportCommand,
                rbac::RBAC_PERM_COMMAND_RELOAD_GAME_TELE, Console::Yes },
        };
        return commandTable;
    }

private:
    static bool HandleReloadHearthstoneTeleportCommand(ChatHandler* handler)
    {
        LoadCityTeleports();
        handler->PSendSysMessage("Hearthstone_teleport 重载完成，共加载 %zu 个传送点。",
            _cityTeleports.size());
        return true;
    }
};

void AddSC_hearthstone_menu()
{
    new item_hearthstone_menu();
    new hearthstone_menu_playerscript();
    new hearthstone_menu_worldscript();
    new hearthstone_menu_commandscript();
}
