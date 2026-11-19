/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

#include "starter_guild.h"
#include "Chat.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Guild.h"
#include "GuildMgr.h"
#include "Log.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "WorldSession.h"

namespace
{
class starter_guild_player : public PlayerScript
{
public:
    starter_guild_player() : PlayerScript("starter_guild_player") { }

    void OnLogin(Player* player, bool firstLogin) override
    {
        if (!sConfigMgr->GetBoolDefault("StarterGuild.Enable", false, true))
            return;

        if (sConfigMgr->GetBoolDefault("StarterGuild.Announce", false, true))
            ChatHandler(player->GetSession()).SendSysMessage("This server uses automatic starter guilds.");

        if (!firstLogin || player->GetGuildId())
            return;

        int32 level = GetRequiredLevel();
        if (level >= 0 && StarterGuild::EligibleOnFirstLogin(player->GetLevel(), uint32(level)))
            JoinGuild(player);
    }

    void OnLevelChanged(Player* player, uint8 oldLevel) override
    {
        if (!sConfigMgr->GetBoolDefault("StarterGuild.Enable", false, true) || player->GetGuildId())
            return;

        int32 level = GetRequiredLevel();
        if (level >= 0 && StarterGuild::EligibleOnLevelChange(oldLevel, player->GetLevel(), uint32(level)))
            JoinGuild(player);
    }

private:
    static int32 GetRequiredLevel()
    {
        int32 level = sConfigMgr->GetIntDefault("StarterGuild.Level", 0, true);
        if (level < 0 || level > 255)
        {
            TC_LOG_ERROR("scripts", "StarterGuild.Level must be between 0 and 255, got {}.", level);
            return -1;
        }
        return level;
    }

    static void JoinGuild(Player* player)
    {
        bool const alliance = player->GetTeamId() == TEAM_ALLIANCE;
        char const* guildOption = alliance ? "StarterGuild.Alliance" : "StarterGuild.Horde";
        int64 guildId = sConfigMgr->GetInt64Default(guildOption, alliance ? 2 : 1, true);
        if (guildId <= 0)
        {
            TC_LOG_ERROR("scripts", "{} must be a positive guild ID, got {}.", guildOption, guildId);
            ChatHandler(player->GetSession()).SendSysMessage("The starter guild is not configured correctly.");
            return;
        }

        Guild* guild = sGuildMgr->GetGuildById(uint64(guildId));
        if (!guild)
        {
            TC_LOG_ERROR("scripts", "Starter guild {} configured by {} does not exist.", guildId, guildOption);
            ChatHandler(player->GetSession()).SendSysMessage("The starter guild does not exist.");
            return;
        }

        if (!StarterGuild::HasCapacity(guild->GetMembersCount()))
        {
            TC_LOG_ERROR("scripts", "Starter guild {} has reached the {} member limit.", guildId, StarterGuild::MemberLimit);
            ChatHandler(player->GetSession()).SendSysMessage("The starter guild is full.");
            return;
        }

        CharacterDatabaseTransaction trans(nullptr);
        if (!guild->AddMember(trans, player->GetGUID()))
        {
            TC_LOG_ERROR("scripts", "Failed to add player {} ({}) to starter guild {}.",
                player->GetName(), player->GetGUID().ToString(), guildId);
            ChatHandler(player->GetSession()).SendSysMessage("Failed to join the starter guild.");
            return;
        }

        char const* welcomeOption = alliance ? "StarterGuild.AllianceWelcomeText" : "StarterGuild.HordeWelcomeText";
        std::string welcome = sConfigMgr->GetStringDefault(welcomeOption, "Welcome to {GUILD}, {PLAYER}!", true);
        if (!welcome.empty())
            ChatHandler(player->GetSession()).SendSysMessage(StarterGuild::FormatWelcome(welcome, guild->GetName(), player->GetName()));
    }
};
}

void AddStarterGuildScripts()
{
    new starter_guild_player();
}
