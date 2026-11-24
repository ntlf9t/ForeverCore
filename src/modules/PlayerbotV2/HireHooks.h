// HireHooks - the one place the bot module asks about hired bots. The bot module (`.bot add`, `.bot call`, the Group Finder,
// companion upkeep, gear, the add-on) never calls the hired bots directly: it asks Hiring(), and without a hire module that answers
// "no hired bots here" for everything, so bots are free as before.
//
// The hire module in Hire/ (CMake option PLAYERBOT_V2_HIRE, on by default) installs its HireHooks at script load
// (AddSC_playerbot_v2_hire). Another hire module can do the same: derive from HireHooks, override what it needs and call
// SetHireHooks once from its AddSC function. Only one is in charge; the last one set wins.
//
// Threads: Hiring() may be called from any thread. Every call that changes a Player or money is world thread only (marked below).

#pragma once

#include "HireTypes.h"
#include "Bot/BotTypes.h"
#include "Optional.h"
#include <string>
#include <vector>

class ChatHandler;
class Player;

namespace Playerbot::V2::Fleet {

class HireHooks
{
public:
    virtual ~HireHooks() = default;

    // True when a hire module is built in (the default hooks answer false).
    virtual bool Built() const { return false; }

    // Loads the hire records; called once when the bot services start (after the owner registry).
    virtual void LoadFromDb() { }

    // The realm's hire mode (Playerbot.Hire.Mode); Off without a hire module.
    virtual Hire::Mode ConfigMode() const { return Hire::Mode::Off; }

    // Whether `player` must hire companions instead of making them (hired mode on for them, no GM bypass).
    virtual bool MustHire(Player const* /*player*/) const { return false; }
    // The same for the account owning a bot, its owner offline.
    virtual bool MustHireAccount(uint32 /*account_id*/) const { return false; }

    // Group Finder / dungeon finder bots of a player who must hire are lent, not hired: free while they stay in that group.
    virtual void SetLoaned(BotId /*bot*/, uint32 /*now_ms*/) { }
    virtual bool IsLoaned(BotId /*bot*/) const { return false; }
    // A loan bot old enough to be taken back when it is out of its group.
    virtual bool LoanSettled(BotId /*bot*/, uint32 /*now_ms*/) const { return false; }
    virtual std::vector<BotId> LoanedBots() const { return {}; }

    // A companion that was just called by an add is not picked again for the next place while it logs in.
    virtual void NoteCalled(BotId /*bot*/, uint32 /*now_ms*/) { }
    virtual bool RecentlyCalled(BotId /*bot*/, uint32 /*now_ms*/) const { return false; }

    // Whether a broker that hires out `grade` stands near `player`. World thread.
    virtual bool BrokerNear(Player* /*player*/, Hire::Grade /*grade*/) const { return false; }

    // Before a bot of `grade` is made for `me`: a broker near, the price at the player's level, the account's limits and the money.
    // True with `price` set, or false with `why` for the player. Nothing is paid yet. World thread.
    virtual bool CheckHire(Player* /*me*/, Hire::Grade /*grade*/, uint64& price, std::string& why) const
    {
        price = 0;
        why = "There are no hired bots on this server.";
        return false;
    }
    // The bot `bot` (named `bot_name`, a `class_name`) was made for `me` after CheckHire: take the money and keep the contract.
    // Called before its setup, so its first gear is its grade's. World thread.
    virtual void OnHired(Player* /*me*/, BotId /*bot*/, Hire::Grade /*grade*/, uint64 /*price*/, std::string const& /*bot_name*/,
                         std::string const& /*class_name*/) { }
    // What the player is told when a hired bot is on the way.
    virtual std::string SignOnText(std::string const& bot_name, Hire::Grade /*grade*/, uint64 /*price*/) const
    {
        return bot_name + " is on the way.";
    }

    // A companion of `owner` is being called: takes the day's upkeep when it is due. False (and `why`) when the owner cannot pay;
    // the bot then stays home. World thread.
    virtual bool TakeUpkeep(Player* /*owner*/, BotId /*bot*/, std::string const& /*bot_name*/, std::string& /*why*/) { return true; }

    // The bot is deleted: its contract ends with it.
    virtual void Forget(BotId /*bot*/) { }

    // Gives a hired bot its grade's health on top of what its class, level and gear give it. World thread.
    virtual void ApplyHealth(Player* /*bot*/) { }

    // The gear mode (Gear::Owned::GearMode value) a companion wears under hired mode; -1 = the owner's own choice stands.
    virtual int GearModeOverride(BotId /*bot*/, uint32 /*owner_account*/) const { return -1; }

    // `.bot hire [on|off]`. World thread.
    virtual bool HandleCommand(ChatHandler* handler, Optional<std::string> word);
};

// The hooks in charge: the hire module's, or the default ones (no hired bots).
HireHooks& Hiring();
// Puts `hooks` in charge (nullptr = back to the default). The object must live until shutdown. Call it from an AddSC function.
void SetHireHooks(HireHooks* hooks);

}  // namespace Playerbot::V2::Fleet

namespace Playerbot::V2 {

// What a hire module may call in the bot module (cs_playerbot_v2.cpp).
// Makes one companion of `cls` and `grade` for `owner` through `.bot add`'s path (room checks, race, name, setup, login), after
// CheckHire and with OnHired; `msg` is what the owner is told. World thread.
bool HireCompanionForOwner(Player* owner, uint8 cls, Playerbot::Role role, Fleet::Hire::Grade grade, std::string const& className,
                           std::string& msg);
// Whether a race of the owner's faction can be a companion of class `cls` on this realm.
bool CanHaveCompanionClass(Player const* owner, uint8 cls);

}  // namespace Playerbot::V2
