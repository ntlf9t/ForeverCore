// The hire brokers (Playerbot.Hire.*): Sellsword Captains at inns, Veteran Recruiters in the capitals, black-market brokers in
// Gadgetzan, Booty Bay and Ratchet. Their gossip hires a bot of the broker's grade; the hiring itself is `.bot add`'s
// (cs_playerbot_v2.cpp AddCompanionFor, through HireCompanionForOwner), so a hired bot is set up, geared and grouped like any companion.

#pragma once

#include "HirePolicy.h"
#include "../HireHooks.h"   // HireCompanionForOwner, CanHaveCompanionClass: the bot module's side

void AddSC_playerbot_v2_hire_broker();
