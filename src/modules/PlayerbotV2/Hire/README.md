# Hired bots (sellswords)

Bots you pay for. Next to the innkeeper of 30 towns stands a **Sellsword Captain**, in the six capitals a **Veteran
Recruiter**, and in Gadgetzan, Booty Bay and Ratchet a goblin **Black Market Broker**. Talk to one, pick a role and a class,
pay, and the bot walks out to join you. It is an ordinary companion from then on (`.bot call`, `.bot dismiss`, orders, the
ForeverBots add-on), it just cost gold, and it may want its wages.

The idea came from Neylem on the WoW Forever Discord.

## The three grades

| Grade | Where | Who can hire | Gear (default) | Price at the level cap (default) |
|---|---|---|---|---|
| Sellsword | every listed inn and the capitals | any level, comes at your level | match: normal gear for its level, up to yours | 1g a bot in a 5-man (20g for a whole 40-man) |
| Veteran | the capitals | level cap only | best: raid gear up to `Playerbot.Gear.MaxTier` | 3g (60g) |
| Legend | Gadgetzan, Booty Bay, Ratchet (both factions) | level cap only | bis: best in slot | 5g (100g) |

A Sellsword below the cap costs less: (your level / cap)², never under 1 silver. A bot for a raid place (a raid group, or an
instance for more than 5) costs the raid package price / 39, a party place the party price / 4.

**Upkeep:** a hired bot wants a share of what you paid for it (25 % by default) once for each day you call it. A day it
stays home costs nothing. If you cannot pay, it stays home and says so. `.bot delete` ends the contract; nothing is paid back.

## The realm's rule: `Playerbot.Hire.Mode`

| Mode | What it means |
|---|---|
| `0` (default) | Bots are free as before (`.bot add`, Quick party, the Group finder). The brokers still hire out Veterans and Legends to anyone who wants the better gear. |
| `1` | Hired bots only, for everyone. Nobody makes bots out of nothing: `.bot add` and Quick party call a free companion you already have (same role, same class first), or hire a Sellsword when you stand next to a broker. The ForeverBots add-on hides its "Add a bot" buttons and says where bots come from. |
| `2` | Each player chooses: `.bot hire on` / `.bot hire off`, the broker's gossip, or the add-on's `/fb hire`. |

With hired bots on, the Group finder and the dungeon finder (`.bot lfg`, `.bot dungeon`, a posted listing) still fill your
group for free, but those bots are only lent: they play in that group, cannot be called on their own, and go away once they
leave it. A listed bot group you join plays with you without becoming yours. Bots you owned before hired mode came on count
as Sellswords with no upkeep. World bots are not touched.

`Playerbot.Hire.GmBypass = 1` lets GM accounts keep making free bots. On a realm of your own your account is usually a GM,
so it is 0 by default: the rule holds for you too.

## Commands

| Command | What it does |
|---|---|
| `.bot hire` | Whether you must hire, and what one bot of each grade costs where you stand. |
| `.bot hire on` / `off` | Your own choice, when the realm runs Mode 2. |
| `/fb hire [on\|off]` | The same from the ForeverBots add-on. |
| Broker gossip | Hire (grade, role, class), "Who works for me?" (your bots, their grade and daily wages), and the Mode 2 choice. |

## Settings (playerbot.conf, `.reload config` takes them at once)

All of these are described in `conf/playerbot.conf.dist` under "Hired bots".

```
Playerbot.Hire.Mode = 0                       # 0 off, 1 everyone, 2 each player chooses
Playerbot.Hire.GmBypass = 0
Playerbot.Hire.BrokerRange = 15               # yards: how close to a broker `.bot add` / Quick party hire
Playerbot.Hire.Sellsword.PartyPrice = 10000   # copper for the 4 bots of a 5-man, at the level cap
Playerbot.Hire.Sellsword.RaidPrice = 200000   # copper for the 39 bots of a 40-man
Playerbot.Hire.Veteran.PartyPrice = 30000
Playerbot.Hire.Veteran.RaidPrice = 600000
Playerbot.Hire.Legend.PartyPrice = 50000
Playerbot.Hire.Legend.RaidPrice = 1000000
Playerbot.Hire.UpkeepPct = 25                 # 0 = no wages
Playerbot.Hire.MaxPerAccount = 0              # 0 = no limit
Playerbot.Hire.Legend.MaxPerAccount = 0
Playerbot.Hire.Sellsword.Gear = "match"       # match, best, bis, t1, t2, t3
Playerbot.Hire.Veteran.Gear = "best"
Playerbot.Hire.Legend.Gear = "bis"
Playerbot.Hire.Sellsword.HealthPct = 100      # 25 to 1000: tougher (or weaker) mercenaries
Playerbot.Hire.Veteran.HealthPct = 100
Playerbot.Hire.Legend.HealthPct = 100
Playerbot.Hire.Inn.Sells = "sellsword"        # what each kind of broker sells; "none" = nothing
Playerbot.Hire.Capital.Sells = "sellsword, veteran"
Playerbot.Hire.BlackMarket.Sells = "legend"
```

Some ideas: a hardcore realm with `Mode = 1` and `UpkeepPct = 50`; a raid-ready realm where Veterans wear `t2`; a goblin
cartel that sells Veterans and Legends (`BlackMarket.Sells = "veteran, legend"`) and nothing in the capitals.

## Building

Hired bots are part of the bot module and built in by default. They need nothing beyond `-DBUILD_PLAYERBOT_V2=1`.

- `-DPLAYERBOT_V2_HIRE=0` leaves them out. Companions are then always free, `.bot hire` says there are none, and a broker
  you talk to says the same (the NPCs are in the world database either way).
- The database parts come with the normal updates:
  - `sql/custom/world/2026_10_31_20_world_forever_hire_brokers.sql`: the 39 brokers (entries 6110000-6110299, spawns
    61100000-61100099, each beside the town's innkeeper).
  - `sql/custom/world/2026_11_01_20_world_forever_hire_broker_gossip.sql`: their gossip menu (6110000), without which the
    client shows no talk cursor.
  - `sql/playerbot_v2/0037_hired_bots.sql`: the contracts (characters database, applied by the module at start).

## How it fits together (for developers)

| File | What |
|---|---|
| `../HireTypes.h` | Grade and Mode, shared with the rest of the module. |
| `../HireHooks.h` | The only door between the bot module and hired bots. Every question the module asks (must this player hire? is this bot lent? take the wages, give the grade's health and gear) goes through `Fleet::Hiring()`. Without a hire module the answers are "no hired bots", so the module works the same as before. |
| `HirePolicy.h` | The rules (prices, grades, upkeep, who must hire), free of game types; pinned by `tests/game/ClassicHirePolicy.cpp`. |
| `HireMgr.*` | The contracts: grade, price paid, wages paid until, loans, the player's choice. |
| `HireBroker.*` | The broker NPCs' gossip (`npc_fb_hire_broker`). |
| `HireModule.cpp` | Puts the above in charge of `HireHooks` (`AddSC_playerbot_v2_hire`). |

The hiring itself goes through `.bot add`'s own path (race, name, room checks, setup, login), so a hired bot is set up, geared
and grouped like any companion.

**Writing your own:** derive from `Playerbot::V2::Fleet::HireHooks`, override what you need, and call `SetHireHooks` from
your module's `AddSC` function (build with `-DPLAYERBOT_V2_HIRE=0` so the two do not both register). The hooks can be asked
from any thread; everything that changes a player or money is called on the world thread. `HireCompanionForOwner` and
`CanHaveCompanionClass` in `HireHooks.h` are what a hire module may call back into the bot module.

## Licence

GPL-2.0, like TrinityCore and the rest of WoW Forever Bots (see `../NOTICE.md`).
