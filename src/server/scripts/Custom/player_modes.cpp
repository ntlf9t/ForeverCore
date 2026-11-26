/*
 * 模式系统：.mode 命令
 *   .mode info     查看当前模式
 *   .mode lone     选择孤勇（1 级、金币 0、银行空、物品全绑定）
 *   .mode rebirth  重生（后续阶段）
 */

#include "Chat.h"
#include "ChatCommand.h"
#include "Player.h"
#include "PlayerMode.h"
#include "RBAC.h"
#include "ScriptMgr.h"
#include "WorldSession.h"

#include <algorithm>
#include <string>
#include <vector>

using namespace Trinity::ChatCommands;

namespace
{
    char const* ModeUsage = "用法：.mode lone | leave | rebirth | info";

    void SendModeBuffData(Player* player)
    {
        if (!player || !player->GetSession())
            return;

        PlayerMode::Data data = PlayerMode::Get(player);
        ChatHandler handler(player->GetSession());

        if (!data.lone && !data.loneExited)
        {
            handler.SendSysMessage("CM;0;");
            handler.SendSysMessage("CMX;0");
            return;
        }

        std::vector<std::pair<uint32, std::string>> list;

        if (data.lone)
        {
            if (player->GetLevel() < 60)
            {
                list.emplace_back(1, "玻璃大炮-伤害 +30%");
                list.emplace_back(3, "玻璃大炮-承伤 +30%");
            }

            list.emplace_back(1, "孤勇-伤害 +" + std::to_string(data.loneDamage) + "%");
            list.emplace_back(4, "孤勇-生命 +" + std::to_string(data.loneHealth) + "%");
            list.emplace_back(3, "孤勇-承伤 +" + std::to_string(data.loneTaken) + "%");
        }
        else
        {
            // 退出孤勇后的固定传承
            list.emplace_back(1, "孤勇传承-伤害 +30%");
            list.emplace_back(4, "孤勇传承-生命 +30%");
        }

        std::string msg = "CM;" + std::to_string(list.size()) + ";";
        bool first = true;
        for (auto const& [category, name] : list)
        {
            if (!first)
                msg += "#";
            msg += std::to_string(category) + ":" + name;
            first = false;
        }

        handler.SendSysMessage(msg);
        handler.SendSysMessage(data.lone && player->GetLevel() >= 60 ? "CMX;1" : "CMX;0");
    }

    void ShowMode(ChatHandler* handler, Player* player)
    {
        PlayerMode::Data data = PlayerMode::Get(player);

        char const* modeName = data.lone ? "孤勇" : (data.loneExited ? "孤勇已退出" : (data.chosen ? "重生" : "未选择"));
        handler->PSendSysMessage("模式：%s", modeName);
        handler->PSendSysMessage("重生次数：%u", data.rebirths);
        if (data.loneExited)
            handler->SendSysMessage("孤勇传承：伤害 +30% / 生命 +30%（永久，重生不再增加）");
        else
            handler->PSendSysMessage("孤勇增伤 +%u%% / 孤勇生命 +%u%% / 孤勇承伤 +%u%%",
                data.loneDamage, data.loneHealth, data.loneTaken);
        handler->PSendSysMessage("重生流程中：%s", data.rebirthActive ? "是" : "否");
    }

    bool HandleModeCommand(ChatHandler* handler, Optional<std::string> mode)
    {
        Player* player = handler->GetSession()->GetPlayer();
        if (!player)
            return false;

        if (!mode)
        {
            ShowMode(handler, player);
            return true;
        }

        std::string value = *mode;
        std::transform(value.begin(), value.end(), value.begin(),
            [](unsigned char c) { return char(std::tolower(c)); });

        std::string reason;

        if (value == "info")
        {
            ShowMode(handler, player);
            return true;
        }

        if (value == "lone" || value == "孤勇")
        {
            if (!PlayerMode::ChooseLone(player, reason))
            {
                handler->PSendSysMessage("无法选择孤勇：%s", reason.c_str());
                handler->SetSentErrorMessage(true);
                return false;
            }

            handler->SendSysMessage("孤勇模式已开启。禁止组队/交易/邮件/拍卖行，60 级前死亡自动退出公会且无法复活。");
            SendModeBuffData(player);
            return true;
        }

        if (value == "leave" || value == "退出孤勇")
        {
            if (!PlayerMode::ExitLone(player, reason))
            {
                handler->PSendSysMessage("无法退出孤勇：%s", reason.c_str());
                handler->SetSentErrorMessage(true);
                return false;
            }

            handler->SendSysMessage(reason);
            SendModeBuffData(player);
            return true;
        }

        if (value == "rebirth" || value == "重生")
        {
            if (!PlayerMode::DoRebirth(player, reason))
            {
                handler->PSendSysMessage("无法重生：%s", reason.c_str());
                handler->SetSentErrorMessage(true);
                return false;
            }

            handler->SendSysMessage(reason);
            SendModeBuffData(player);
            return true;
        }

        handler->SendSysMessage(ModeUsage);
        handler->SetSentErrorMessage(true);
        return false;
    }
}

class player_modes_playerscript : public PlayerScript
{
public:
    player_modes_playerscript() : PlayerScript("player_modes_playerscript") { }

    void OnLogin(Player* player, bool /*firstLogin*/) override
    {
        PlayerMode::Load(player);
        PlayerMode::HandleLevelUp(player, player->GetLevel());
        SendModeBuffData(player);
    }

    void OnLevelChanged(Player* player, uint8 /*oldLevel*/) override
    {
        // 60 级时移除玻璃大炮；重生降级时重新挂上
        PlayerMode::ApplyAuras(player);
        PlayerMode::SyncTalentPoints(player);
        PlayerMode::HandleLevelUp(player, player->GetLevel());

        // 重生流程到 60 级自动解除
        if (player->GetLevel() >= 60 && PlayerMode::IsRebirthActive(player))
        {
            PlayerMode::SetRebirthActive(player, false);
            PlayerMode::Save(player);
        }

        SendModeBuffData(player);
    }

    void OnAddonMessageSent(Player* player, uint32 /*type*/, std::string const& prefix,
        std::string const& text, Player* /*receiver*/) override
    {
        if (prefix == "CM" && text == "q" && player)
            SendModeBuffData(player);
    }

    void OnLogout(Player* player) override
    {
        PlayerMode::Save(player);
    }
};

class player_modes_commandscript : public CommandScript
{
public:
    player_modes_commandscript() : CommandScript("player_modes_commandscript") { }

    std::span<ChatCommandBuilder const> GetCommands() const override
    {
        static ChatCommandTable commandTable =
        {
            { "mode", HandleModeCommand, rbac::RBAC_PERM_COMMAND_MODE, Console::No },
        };
        return commandTable;
    }
};

void AddSC_player_modes()
{
    new player_modes_playerscript();
    new player_modes_commandscript();
}
