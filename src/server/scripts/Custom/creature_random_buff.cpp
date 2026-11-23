/*
 * 怪物随机附魔：玩家侧脚本
 *   - 击杀带 buff 的怪：经验/金币/掉落倍率（掉落与金币在 Loot 里处理，经验在这里）
 *   - 宝藏怪提示
 *   - .dungeon normal|hard|epic 全局副本难度
 */

#include "Chat.h"
#include "ChatCommand.h"
#include "Creature.h"
#include "CreatureRandomBuff.h"
#include "Map.h"
#include "Player.h"
#include "RBAC.h"
#include "ScriptMgr.h"
#include "SpellAuras.h"
#include "WorldSession.h"

#include <algorithm>
#include <cctype>
#include <string>

using namespace Trinity::ChatCommands;

namespace
{
    char const* DifficultyUsage = "用法：.dungeon normal | hard | epic | check | auras";

    void ShowNearbyBuffedCreatures(ChatHandler* handler)
    {
        Player* player = handler->GetSession()->GetPlayer();
        if (!player)
            return;

        uint32 shown = 0;
        for (auto const& entry : player->GetMap()->GetCreatureBySpawnIdStore())
        {
            if (shown >= 8)
                break;

            Creature* creature = entry.second;
            if (!creature || !creature->IsAlive() || !creature->IsWithinDistInMap(player, 60.0f))
                continue;

            CreatureRandomBuff::Info info;
            if (!CreatureRandomBuff::GetInfo(creature->GetGUID(), info) || !info.count)
                continue;

            handler->PSendSysMessage("%s (entry %u): %s | 倍率 x%.2f | 可见光环 %u", creature->GetName().c_str(),
                creature->GetEntry(), info.buffs.c_str(), info.lootMultiplier, uint32(creature->GetVisibleAuras().size()));
            ++shown;
        }

        if (!shown)
            handler->SendSysMessage("附近 60 码内没有带随机 buff 的怪。");
    }

    void ResendNearestAuras(ChatHandler* handler)
    {
        Player* player = handler->GetSession()->GetPlayer();
        if (!player)
            return;

        Creature* nearest = nullptr;
        float bestDist = 40.0f;
        for (auto const& entry : player->GetMap()->GetCreatureBySpawnIdStore())
        {
            Creature* creature = entry.second;
            if (!creature || !creature->IsAlive())
                continue;

            float dist = player->GetDistance(creature);
            if (dist < bestDist)
            {
                bestDist = dist;
                nearest = creature;
            }
        }

        if (!nearest)
        {
            handler->SendSysMessage("附近 40 码内没有怪物。");
            return;
        }

        uint32 count = uint32(nearest->GetVisibleAuras().size());
        player->SendAurasForTarget(nearest);
        handler->PSendSysMessage("已重发 %s 的光环（服务端可见 %u 个）。", nearest->GetName().c_str(), count);
    }

    void SendTargetBuffData(Player* player)
    {
        std::string msg = "CB;";
        Unit* target = player->GetSelectedUnit();
        Creature* creature = target ? target->ToCreature() : nullptr;

        CreatureRandomBuff::Info info;
        if (!creature || !CreatureRandomBuff::GetInfo(creature->GetGUID(), info) || !info.count)
            msg += "0;0";
        else
            msg += std::to_string(uint32(info.count)) + ';' + info.buffData;

        ChatHandler(player->GetSession()).SendSysMessage(msg);
    }

    bool HandleDungeonCommand(ChatHandler* handler, Optional<std::string> mode, Optional<uint32> spellId)
    {
        if (!mode)
        {
            uint8 difficulty = CreatureRandomBuff::GetDungeonDifficulty();
            handler->PSendSysMessage("当前副本难度：%s（每个怪 %u 个随机 buff）",
                CreatureRandomBuff::GetDungeonDifficultyName(difficulty), uint32(difficulty) + 1);
            return true;
        }

        std::string value = *mode;
        std::transform(value.begin(), value.end(), value.begin(),
            [](unsigned char c) { return char(std::tolower(c)); });

        // 测试用：.dungeon aura <spellId>，给选中怪挂永久光环
        if (value == "aura")
        {
            Creature* target = handler->getSelectedCreature();
            if (!target)
            {
                handler->SendSysMessage("先选中一只怪。");
                return true;
            }

            if (!spellId || !*spellId)
            {
                handler->SendSysMessage("用法：.dungeon aura <spellId>");
                return true;
            }

            uint32 const id = *spellId;
            if (Aura* aura = target->AddAura(id, target))
            {
                aura->SetMaxDuration(-1);
                aura->SetDuration(-1);
                handler->PSendSysMessage("已给 %s 挂上光环 %u（永久）。", target->GetName().c_str(), id);
            }
            else
                handler->PSendSysMessage("光环 %u 挂载失败。", id);
            return true;
        }

        if (value == "check" || value == "info")
        {
            ShowNearbyBuffedCreatures(handler);
            return true;
        }

        if (value == "auras")
        {
            ResendNearestAuras(handler);
            return true;
        }

        if (value == "target")
        {
            if (Player* player = handler->GetSession()->GetPlayer())
                SendTargetBuffData(player);
            return true;
        }

        uint8 difficulty;
        if (value == "normal" || value == "0")
            difficulty = 0;
        else if (value == "hard" || value == "1")
            difficulty = 1;
        else if (value == "epic" || value == "2")
            difficulty = 2;
        else
        {
            handler->SendSysMessage(DifficultyUsage);
            handler->SetSentErrorMessage(true);
            return false;
        }

        CreatureRandomBuff::SetDungeonDifficulty(difficulty);
        handler->PSendSysMessage("副本难度已设为：%s（普通 1 / 困难 2 / 史诗 3 个随机 buff），之后新进入的副本生效。",
            CreatureRandomBuff::GetDungeonDifficultyName(difficulty));
        return true;
    }
}

class creature_random_buff_playerscript : public PlayerScript
{
public:
    creature_random_buff_playerscript() : PlayerScript("creature_random_buff_playerscript") { }

    void OnAddonMessageSent(Player* player, uint32 /*type*/, std::string const& prefix,
        std::string const& text, Player* /*receiver*/) override
    {
        if (prefix != "CB")
            return;

        TC_LOG_INFO("server.loading", ">> CB addon msg from={} text={}", player ? player->GetName() : "?", text);
        if (text == "q" && player)
            SendTargetBuffData(player);
    }

    void OnGiveXP(Player* /*player*/, uint32& amount, Unit* victim) override
    {
        if (!victim || !amount)
            return;

        Creature* creature = victim->ToCreature();
        if (!creature)
            return;

        float multiplier = CreatureRandomBuff::GetLootMultiplier(creature->GetGUID());
        if (multiplier <= 1.0f)
            return;

        amount = uint32(float(amount) * multiplier);
    }

    void OnCreatureKill(Player* killer, Creature* killed) override
    {
        if (!killed || !killer)
            return;

        CreatureRandomBuff::Info info;
        if (!CreatureRandomBuff::GetInfo(killed->GetGUID(), info) || !info.count)
            return;

        TC_LOG_INFO("server.loading",
            ">> CRB kill entry={} name={} buffs=[{}] by={} count={} percent={} mult={:.2f} treasure={}",
            killed->GetEntry(), killed->GetName(), info.buffs, killer->GetName(), uint32(info.count),
            info.percentSum, info.lootMultiplier, info.treasure ? 1 : 0);

        if (info.treasure)
            ChatHandler(killer->GetSession()).PSendSysMessage("|cffffd700宝藏怪物！|r 掉落与金币 ×10");
    }
};

class creature_random_buff_commandscript : public CommandScript
{
public:
    creature_random_buff_commandscript() : CommandScript("creature_random_buff_commandscript") { }

    std::span<ChatCommandBuilder const> GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "dungeon", HandleDungeonCommand, rbac::RBAC_PERM_COMMAND_DUNGEON_DIFFICULTY, Console::No },
        };
        return commandTable;
    }
};

void AddSC_creature_random_buff()
{
    new creature_random_buff_playerscript();
    new creature_random_buff_commandscript();
}
