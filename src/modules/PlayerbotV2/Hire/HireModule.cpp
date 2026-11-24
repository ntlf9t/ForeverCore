// HireModule - puts the hired bots in charge of the bot module's hire questions (HireHooks.h). Everything here forwards to HireMgr
// (the contracts) and HirePolicy (the rules); the broker NPCs are HireBroker.cpp. Registered by AddSC_playerbot_v2_hire, which the
// bot module's script loader calls when the module is built with PLAYERBOT_V2_HIRE (the default).

#include "HireBroker.h"
#include "HireMgr.h"
#include "HirePolicy.h"
#include "../HireHooks.h"
#include "../Bot/ClassTables.h"
#include "../Fleet/OwnerRegistry.h"
#include "../Services.h"
#include "Chat.h"
#include "Log.h"
#include "Player.h"
#include "StringFormat.h"
#include "WorldSession.h"
#include <cctype>

namespace Playerbot::V2::Fleet {

namespace {

class HireModuleHooks final : public HireHooks
{
public:
    bool Built() const override { return true; }

    void LoadFromDb() override { HireMgr::Instance().LoadFromDb(); }

    Hire::Mode ConfigMode() const override { return HireMgr::ConfigMode(); }

    bool MustHire(Player const* player) const override { return HireMgr::Instance().MustHire(player); }
    bool MustHireAccount(uint32 account_id) const override { return HireMgr::Instance().MustHireAccount(account_id); }

    void SetLoaned(BotId bot, uint32 now_ms) override { HireMgr::Instance().SetLoaned(bot, now_ms); }
    bool IsLoaned(BotId bot) const override { return HireMgr::Instance().IsLoaned(bot); }
    bool LoanSettled(BotId bot, uint32 now_ms) const override { return HireMgr::Instance().LoanSettled(bot, now_ms); }
    std::vector<BotId> LoanedBots() const override { return HireMgr::Instance().LoanedBots(); }

    void NoteCalled(BotId bot, uint32 now_ms) override { HireMgr::Instance().NoteCalled(bot, now_ms); }
    bool RecentlyCalled(BotId bot, uint32 now_ms) const override { return HireMgr::Instance().RecentlyCalled(bot, now_ms); }

    bool BrokerNear(Player* player, Hire::Grade grade) const override { return HireMgr::Instance().NearbyBroker(player, grade) != nullptr; }

    bool CheckHire(Player* me, Hire::Grade grade, uint64& price, std::string& why) const override
    {
        HireMgr const& hire = HireMgr::Instance();
        price = 0;
        if (!me || !me->GetSession())
            return false;
        uint32 const account = me->GetSession()->GetAccountId();
        if (!hire.NearbyBroker(me, grade))
        { why = Trinity::StringFormat("There is nobody here who hires out a {}.", Hire::GradeName(grade)); return false; }
        price = HireMgr::PriceHere(me, grade);
        if (!price)
        { why = Trinity::StringFormat("A {} only signs on with a level {} hero.", Hire::GradeName(grade), uint32(MaxPlayerLevel())); return false; }
        if (uint32 const max = HireMgr::MaxPerAccount(); max && Services::Owners().BotsOwnedBy(account).size() >= max)
        { why = Trinity::StringFormat("You have {} bots already, the most this realm allows. End a contract first.", max); return false; }
        if (uint32 const max = HireMgr::LegendMaxPerAccount(); grade == Hire::Grade::Legend && max && hire.CountGrade(account, Hire::Grade::Legend) >= max)
        { why = Trinity::StringFormat("The cartel hires out {} Legend(s) to one hero at a time.", max); return false; }
        if (!me->HasEnoughMoney(price))
        { why = Trinity::StringFormat("You need {} to hire a {}.", Hire::MoneyText(price), Hire::GradeName(grade)); return false; }
        return true;
    }

    void OnHired(Player* me, BotId bot, Hire::Grade grade, uint64 price, std::string const& bot_name, std::string const& class_name) override
    {
        me->ModifyMoney(-int64(price));
        HireMgr::Instance().SetHired(bot, grade, price);
        HireMgr::Instance().NoteCalled(bot, getMSTime());
        TC_LOG_INFO("playerbot.v2", "[hire] {} hired {} ({} {}) for {} copper", me->GetName(), bot_name, Hire::GradeName(grade), class_name, price);
    }

    std::string SignOnText(std::string const& bot_name, Hire::Grade grade, uint64 price) const override
    {
        return Trinity::StringFormat("{} the {} signs on for {} and is on the way.", bot_name, Hire::GradeName(grade), Hire::MoneyText(price));
    }

    bool TakeUpkeep(Player* owner, BotId bot, std::string const& bot_name, std::string& why) override
    {
        return HireMgr::Instance().TakeUpkeep(owner, bot, bot_name, why);
    }

    void Forget(BotId bot) override { HireMgr::Instance().Forget(bot); }

    void ApplyHealth(Player* bot) override { HireMgr::Instance().ApplyHealth(bot); }

    int GearModeOverride(BotId bot, uint32 owner_account) const override { return HireMgr::Instance().GearModeOverride(bot, owner_account); }

    // .bot hire [on|off]: no word: whether you must hire, and what one bot costs here. on / off: your own choice when the realm
    // leaves it to each player (Hire.Mode = 2).
    bool HandleCommand(ChatHandler* handler, Optional<std::string> word) override
    {
        WorldSession* sess = handler->GetSession();
        Player* me = sess ? sess->GetPlayer() : nullptr;
        if (!me)
        {
            handler->SetSentErrorMessage(true);
            return false;
        }
        Hire::Mode const mode = HireMgr::ConfigMode();
        if (word)
        {
            std::string w = *word;
            for (char& c : w)
                c = char(std::tolower(static_cast<unsigned char>(c)));
            if (w != "on" && w != "off")
            {
                handler->SendSysMessage("Usage: .bot hire [on|off]");
                handler->SetSentErrorMessage(true);
                return false;
            }
            if (mode != Hire::Mode::PlayerChoice)
            {
                handler->SendSysMessage(mode == Hire::Mode::Everyone ? "This realm has hired bots for everyone." : "Hired bots are off on this realm.");
                handler->SetSentErrorMessage(true);
                return false;
            }
            HireMgr::Instance().SetOptedIn(sess->GetAccountId(), w == "on");
        }
        bool const must = HireMgr::Instance().MustHire(me);
        std::string prices;
        for (Hire::Grade g : { Hire::Grade::Sellsword, Hire::Grade::Veteran, Hire::Grade::Legend })
            if (uint64 const p = HireMgr::PriceHere(me, g))
                prices += Trinity::StringFormat("{}{} {}", prices.empty() ? "" : ", ", Hire::GradeName(g), Hire::MoneyText(p));
        handler->PSendSysMessage("Hired bots: %s. One bot costs %s here; upkeep %u%% a day you call it.",
                                 must ? "on (your companions come from the brokers)" : "off (bots are free)", prices.c_str(),
                                 HireMgr::ConfigPrices().upkeep_pct);
        return true;
    }
};

}  // namespace

}  // namespace Playerbot::V2::Fleet

void AddSC_playerbot_v2_hire()
{
    static Playerbot::V2::Fleet::HireModuleHooks hooks;
    Playerbot::V2::Fleet::SetHireHooks(&hooks);
    AddSC_playerbot_v2_hire_broker();
}
