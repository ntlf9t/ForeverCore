/*
 * Level rewards inspired by AzerothCore's mod-congrats-on-level
 * (https://github.com/azerothcore/mod-congrats-on-level, AGPL-3.0).
 */

#include "Chat.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Log.h"
#include "ObjectMgr.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "SpellMgr.h"
#include "World.h"
#include "WorldSession.h"

#include <string>

namespace
{
void GiveLevelRewards(Player* player)
{
    std::string query = "SELECT `money`, `spell`, `learn`, `itemId1`, `itemId2` "
        "FROM `mod_congrats_on_level_items` WHERE `level` = " + std::to_string(player->GetLevel()) +
        " AND (`race` = 0 OR `race` = " + std::to_string(player->GetRace()) +
        ") AND (`class` = 0 OR `class` = " + std::to_string(player->GetClass()) + ")";
    QueryResult result = WorldDatabase.Query(query.c_str());
    if (!result)
        return;

    ChatHandler handler(player->GetSession());
    bool failed = false;
    do
    {
        Field* fields = result->Fetch();
        uint64 copper = uint64(fields[0].GetUInt32()) * GOLD;
        if (copper && (copper > MAX_MONEY_AMOUNT || !player->ModifyMoney(int64(copper))))
        {
            TC_LOG_ERROR("scripts", "Level reward money could not be granted to {}: {} copper.", player->GetName(), copper);
            failed = true;
        }

        uint32 spell = fields[1].GetUInt32();
        if (spell)
        {
            if (!sSpellMgr->GetSpellInfo(spell, DIFFICULTY_NONE))
            {
                TC_LOG_ERROR("scripts", "Level reward spell {} does not exist.", spell);
                failed = true;
            }
            else if (fields[2].GetUInt8())
                player->LearnSpell(spell, false);
            else if (player->CastSpell(player, spell) != SPELL_CAST_OK)
            {
                TC_LOG_ERROR("scripts", "Level reward spell {} could not be cast on {}.", spell, player->GetName());
                failed = true;
            }
        }

        for (uint8 i = 3; i <= 4; ++i)
        {
            uint32 item = fields[i].GetUInt32();
            if (!item)
                continue;

            if (!sObjectMgr->GetItemTemplate(item) || !player->AddItem(item, 1))
            {
                TC_LOG_ERROR("scripts", "Level reward item {} could not be granted to {}.", item, player->GetName());
                failed = true;
            }
        }
    } while (result->NextRow());

    if (failed)
        handler.SendSysMessage("Some level rewards could not be granted. Please contact a GM.");
    else
        handler.SendSysMessage("Your level rewards have been granted.");
}

class congrats_on_level : public PlayerScript
{
public:
    congrats_on_level() : PlayerScript("congrats_on_level") { }

    void OnLogin(Player* player, bool /*firstLogin*/) override
    {
        if (sConfigMgr->GetBoolDefault("Congrats.Enable", false, true) &&
            sConfigMgr->GetBoolDefault("Congrats.Announce", false, true))
            ChatHandler(player->GetSession()).SendSysMessage("Level-up rewards are enabled on this server.");
    }

    void OnLevelChanged(Player* player, uint8 oldLevel) override
    {
        uint8 level = player->GetLevel();
        if (!sConfigMgr->GetBoolDefault("Congrats.Enable", false, true) ||
            level <= oldLevel || level > 60)
            return;

        GiveLevelRewards(player);

        if (sConfigMgr->GetBoolDefault("CongratsPerLevel.Enable", true, true))
        {
            std::string message;
            switch (player->GetSession()->GetSessionDbLocaleIndex())
            {
                case LOCALE_zhCN:
                    message = "恭喜 " + player->GetName() + " 达到 " + std::to_string(level) + " 级！";
                    break;
                case LOCALE_zhTW:
                    message = "恭喜 " + player->GetName() + " 達到 " + std::to_string(level) + " 級！";
                    break;
                case LOCALE_esES:
                case LOCALE_esMX:
                    message = "¡Felicidades a " + player->GetName() + " por alcanzar el nivel " + std::to_string(level) + "!";
                    break;
                default:
                    message = "Congratulations to " + player->GetName() + " on reaching level " + std::to_string(level) + "!";
                    break;
            }
            sWorld->SendServerMessage(SERVER_MSG_STRING, message);
        }
    }
};
}

void AddSC_congrats_on_level()
{
    new congrats_on_level();
}
