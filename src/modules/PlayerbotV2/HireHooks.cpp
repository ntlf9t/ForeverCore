#include "HireHooks.h"
#include "Chat.h"
#include "Creature.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "WorldSession.h"
#include <atomic>

namespace Playerbot::V2::Fleet {

namespace {
HireHooks& DefaultHooks()
{
    static HireHooks none;
    return none;
}

std::atomic<HireHooks*> g_hooks{ nullptr };
}

bool HireHooks::HandleCommand(ChatHandler* handler, Optional<std::string> /*word*/)
{
    handler->SendSysMessage("There are no hired bots on this server: companions are free.");
    handler->SetSentErrorMessage(true);
    return false;
}

HireHooks& Hiring()
{
    HireHooks* const h = g_hooks.load(std::memory_order_acquire);
    return h ? *h : DefaultHooks();
}

void SetHireHooks(HireHooks* hooks)
{
    g_hooks.store(hooks, std::memory_order_release);
}

}  // namespace Playerbot::V2::Fleet

// Built without the hire module (-DPLAYERBOT_V2_HIRE=0) the broker NPCs of the world database still stand at the inns: they say so
// instead of opening an empty window.
struct npc_fb_hire_broker_off : public ScriptedAI
{
    explicit npc_fb_hire_broker_off(Creature* creature) : ScriptedAI(creature) { }

    bool OnGossipHello(Player* player) override
    {
        CloseGossipMenuFor(player);
        if (player->GetSession())
            ChatHandler(player->GetSession()).SendSysMessage("This server has no hired bots: companions are free (.bot add, or the ForeverBots add-on).");
        return true;
    }
};

void AddSC_playerbot_v2_hire_off()
{
    // The database's script name for the brokers (Hire/HireBroker.cpp registers the real one under the same name).
    new GenericCreatureScript<npc_fb_hire_broker_off>("npc_fb_hire_broker");
}
