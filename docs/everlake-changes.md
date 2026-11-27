# Everlake's own changes: keep these on every update

Features that exist only in `everlake`, not in advocaite's `forever`, Karrz's `forever-bots` or TrinityCore. Upstream
doesn't know about them, so a merge that takes "theirs" in a conflict, or a file upstream rewrites, can drop them
without a build error. After every upstream merge or Karrz release port (`docs/upstream-prs.md`,
`docs/karrz-releases.md`), go down this list and check each hook is still there before opening the pull request.

Add a section here whenever a new Everlake-only feature lands.

## Bigger item stacks (`StackSize.*`), fork PR #87

Evermore's mod-stack-size rules in the core. Trade goods and spell reagents stack to 999 and consumables to 200; groups
only raise stacks and only for items that already stack. `StackSize.Items` and `StackSize.Exclude` set single items. The
changed `ItemSparse` rows go to the client as hotfixes, so bags, tooltips and the split dialog agree with the server.
Decided 2026-11-17: on for everyone, not a Legacy perk.

| Hook | Where | What breaks if it goes |
|---|---|---|
| The code | `src/server/game/Entities/Item/ItemStackSize.h` / `.cpp` | Build fails (the two callers below) |
| `ItemStackSize::Apply()` | `src/server/game/World/World.cpp`, `SetInitialWorldSettings`, just before `LoadItemTemplates()` | **Silent:** stacks go back to stock. It has to run after the DB2 stores and hotfixes load and before `ItemTemplate`s are built from `ItemSparse` |
| AH bot stock size | `src/server/game/AuctionHouseBot/AuctionHouseBotSeller.cpp`, `GetStackSizeForItem`: `urand(1, ItemStackSize::GetStockMaxStackSize(...))` | **Silent:** the bot posts stacks of up to 999 |
| Config block | `src/server/worldserver/worldserver.conf.dist`, `StackSize.*` after `Rate.Talent` | Defaults still apply (they're in the code), but the options are no longer documented |
| Tests | `tests/game/ItemStackSize.cpp` | Rule changes go unnoticed |

Things to watch in upstream changes:

- `ItemTemplate::GetMaxStackSize()` must keep reading `ExtendedData->Stackable`. If upstream caches the stack size
  somewhere else, or builds item templates before `Apply()` runs, the new sizes stop reaching the server.
- `DB2HotfixGeneratorBase::AddClientHotfix` and `ItemSparseEntry::Stackable` / `MaxCount`: a rename breaks the build,
  which is the safe kind of break.
- A new client build that changes item classes: spell reagents are class 15 subclass 1 and class 5 on the Forever
  client (`GetGroup`).

Check after a merge:

```bash
grep -n "ItemStackSize::Apply" src/server/game/World/World.cpp
grep -n "GetStockMaxStackSize" src/server/game/AuctionHouseBot/AuctionHouseBotSeller.cpp
grep -n "^StackSize.Enable" src/server/worldserver/worldserver.conf.dist
```

On the PTR, the worldserver log shows `>> Item stack sizes: changed N items` (about 1,700 with the defaults) and a
stack of Linen Cloth goes past 20.

## Timed world buffs (`Classic.WorldBuffs.*`)

Everlake does not offer the raid head turn-ins, so their world buffs go out on a timer instead, ported from Evermore's
mod-world-buff-bots. Every 30 to 150 minutes (rolled each cycle) a made-up player "returns the head of Onyxia":
Rallying Cry of the Dragonslayer (22888) goes to the Alliance in Stormwind and the Horde in Orgrimmar at the same
moment. Spirit of Zandalar (24425) follows 10 minutes later in Stranglethorn Vale for both factions. Each faction gets
a system message 10 minutes before each buff, naming the realm time it drops, and another when it lands. Alive, non-GM
players of that faction in the zone get the aura added straight on (not cast, since the spells also reach nearby allies),
bots included. The timer is not saved; a restart rolls a new first
cycle. Rend's head (Warchief's Blessing, Might of Stormwind) is left to players, since Upper Blackrock Spire stays open.

Might of Stormwind (460939), the Alliance's Rend buff, comes the way live hands it out. End of the Dark Horde 84377 goes to
Mathias Shaw, then 97883 goes to Major Mattingly, who casts the buff on the allies around him
(`sql/custom/world/2026_11_19_85_world_everlake_might_of_stormwind.sql`). Both quests come from wow-everlake-world-data.
The spell joins Warchief's Blessing's aura fix in `SpellMgr.cpp`, and it counts for the Conquering Hero and Second
Chance Legacy perks (`ClassicLegacyPerks.h`; the same SQL file binds Second Chance's cleanup script to it).

Town heralds for Rend's head, as on live since 2026-11-12
(`sql/custom/world/2026_11_19_86_world_everlake_rend_heralds.sql`):
- Thrall's turn-in summons a Herald of Thrall at the Crossroads (as before) and now also on the Razor Hill guard tower. The
  herald's own script was lost in the VMaNGOS conversion and is back: two yells, then Warchief's Blessing at 15 seconds.
- Mattingly's 97883 turn-in summons a Stormwind Crier (269863, a new template) in Goldshire, Lakeshire and Sentinel Hill.
  Each casts Might of Stormwind after 5 seconds.
- Places come from live sightings (Icy Veins). The criers don't speak, since no source has their line. Live's criers ride
  in from the road; ours appear where live's stop.
- A herald or crier summoned where no player is near does nothing until one comes by (the grid isn't updating), and is
  cleared without acting if the grid unloads first. Bots usually keep these towns busy.

Live Forever (checked 2026-11-19): the buffs come only from turn-ins. Live has no timer and no Chronoboon for sale.
Rallying Cry needs Onyxia (live from 2026-12-09) and Zul'Gurub is not on live, so this is an Everlake extra. Buff
lengths are the client's (2 hours each). Rallying Cry's dummy auras are made real in `SpellMgr.cpp`
(`ApplySpellFix({ 22888 }`); Spirit of Zandalar is already real in the client.

| Hook | Where | What breaks if it goes |
|---|---|---|
| The timing | `src/server/game/World/WorldBuffCycle.h` | Build fails (the script below) |
| The script | `src/server/scripts/Custom/Classic/world/classic_world_buffs.cpp` | **Silent:** no buffs go out |
| Script loader | `src/server/scripts/Custom/Classic/classic_script_loader.cpp`, `AddSC_classic_world_buffs()` | **Silent:** no buffs go out |
| Rallying Cry auras | `src/server/game/Spells/SpellMgr.cpp`, `ApplySpellFix({ 22888 }` | **Silent:** the buff shows but does nothing |
| Might of Stormwind auras | `src/server/game/Spells/SpellMgr.cpp`, `ApplySpellFix({ 16609, 460939 }` | **Silent:** the Alliance Rend buff shows but does nothing |
| Town heralds and criers | `sql/custom/world/2026_11_19_86_world_everlake_rend_heralds.sql` | **Silent:** the Rend buff reaches only Orgrimmar / Stormwind |
| Mattingly's turn-in + perk script | `sql/custom/world/2026_11_19_85_world_everlake_might_of_stormwind.sql` | **Silent:** quest 97883 gives no buff, or Second Chance's mark stays after Might of Stormwind ends |
| Config block | `src/server/worldserver/worldserver.conf.dist`, `Classic.WorldBuffs.*` after `Classic.CreatureHealth.Raids` | Defaults still apply (they're in the code), but the options are no longer documented |
| Tests | `tests/game/WorldBuffCycle.cpp` | Timing changes go unnoticed |

Check after a merge:

```bash
grep -n "AddSC_classic_world_buffs" src/server/scripts/Custom/Classic/classic_script_loader.cpp
grep -n "ApplySpellFix({ 22888 }" src/server/game/Spells/SpellMgr.cpp
grep -n "ApplySpellFix({ 16609, 460939 }" src/server/game/Spells/SpellMgr.cpp
grep -n "^Classic.WorldBuffs.Enable" src/server/worldserver/worldserver.conf.dist
```

On the PTR, the worldserver log shows `Classic.WorldBuffs: next Rallying Cry of the Dragonslayer in N min` at start-up. To test quickly,
set `FirstMinMinutes`, `FirstMaxMinutes`, `MinMinutes` and `MaxMinutes` to 15 and stand in Stormwind or Orgrimmar.

## Forever mechanics audit fixes (2026-11-19)

Places where TrinityCore's retail or Wrath rules leaked through and we now follow live WoW Forever (or vanilla where Forever
kept it). Report: everlake-reports/mechanics-audit-2026-11-19. An upstream merge that takes "theirs" in these spots brings
the retail rule back without a build error.

| Rule | Where | What breaks if it goes |
|---|---|---|
| Grouped kills leave one shared corpse in the open world too | `Unit.cpp`, `sharedCorpse` in `Unit::Kill` (no `IsDungeon()` test) | **Silent:** every group member gets their own loot table and money roll outside dungeons |
| Reputation discount: 10% from Honored, nothing below | `VendorPrice.h` `ReputationDiscount`, called from `Player::GetReputationPriceDiscount` | **Silent:** retail 5% per rank (20% at Exalted) on vendors, trainers, flights and repairs |
| No dungeon kill XP when the party has someone 12+ levels above the enemy | `DungeonCarryRule.h`, `KillRewarder::_RewardXP`, `Classic.DungeonCarryXpBlock` | **Silent:** level 60s carry low characters through dungeons for XP |
| No gold for quest XP at level 60 | `Rate.Quest.Money.Max.Level.Reward` default 0 (`World.cpp`, conf) | **Silent:** quests pay the vanilla gold bonus at the cap |
| Quest log 40 | `Quests.LogSize` default 40 | **Silent:** quest log full at 35 |
| Breath 1 minute | `Player::GetMirrorTimerMaxValue` | **Silent:** 3 minutes (12 for Undead) |
| Daze from behind: vanilla 20%, real defense | `ClassicAttackTable::DazeChance`, used in `Unit::DealMeleeDamage` | **Silent:** TC's `* 0.16` (3.2% at 60) |
| In-combat regen auras take a share of the Spirit regen | `Player::RegenerateHealth` | **Silent:** Troll Regeneration gives a fraction of 1 health per tick in combat |
| No cap on pushback hits | `Spell::Delayed`, `Spell::DelayedChannel` (no `IsDelayableNoMore`) | **Silent:** pushback stops after 2 hits |
| Legacy Points earned per account, 16 spendable | `Player::_LoadAccountLegacyAchievements` (login query `CHAR_SEL_ACCOUNT_ACHIEVEMENTS`), `Player::HasAchievedOnAccount` in `UpdateClassicLegacyUnlock` and `TraitMgr` `FillOwnedCurrenciesMap` (plus the `SourcedMax` clamp there) | **Silent:** every alt starts at 0 Legacy Points, or more than 16 can be spent |
| Meeting stones don't summon | `GameObject::Use`, `GAMEOBJECT_TYPE_MEETINGSTONE` | Stones try the Wrath spell 59782 (not in the client) |
| Faction auction houses, goblin houses cross-faction | `AllowTwoSide.Interaction.Auction` default 0 | One shared house everywhere at 5% / 5% |
| Auction house bot stocks and buys in the Alliance, Horde and goblin houses | `src/modules/PlayerbotV2/conf/zz-0-playerbot-defaults.conf` (`*.Items.Amount.Ratio` 100 each, faction buyers on) and `zz-forever-bots.conf` (faction buyers on) | **Silent:** the bot stocks only house 1 (goblin auctioneers); Alliance and Horde houses stay empty |
| Auction house bot keeps profession materials in stock, priced from live (TSM) | `AuctionBotSeller::AddMinStock` + `AuctionBotVanilla::IsProfessionMaterial` (`AuctionHouseBot.Items.TradeGoods.MinStock`), `zz-forever-bots.conf` (`MarketPrices = 1`, `TradeGoods.MinStock = 10`), test `tests/game/AuctionBotMarketPrice.cpp` | **Silent:** mats show up only by chance, half of them single pieces, and crafters can't level from the house |
| Riding 100g / 1,000g at Friendly | `sql/custom/world/2026_11_19_81_world_forever_riding_prices.sql` | Prices back to 90g / 900g (the Honored price) |
| Raids Forever hasn't released are closed: Molten Core, Blackwing Lair, Zul'Gurub, both Ahn'Qiraj raids, Naxxramas, and Onyxia until 2026-12-09; their dead-end quests are hidden | `sql/custom/world/2026_11_19_83_world_everlake_close_vanilla_raids.sql` (`disables` map and quest rows) | **Silent:** players can enter raids live doesn't have and pick up quests they can't finish |

Check after a merge:

```bash
grep -n "IsDelayableNoMore" src/server/game/Spells/Spell.h   # must print nothing
grep -n "ReputationDiscount" src/server/game/Entities/Player/Player.cpp
grep -n "BlocksDungeonCarry" src/server/game/Entities/Player/KillRewarder.cpp
grep -n "DazeChance" src/server/game/Entities/Unit/Unit.cpp
grep -n "HasAchievedOnAccount" src/server/game/Spells/TraitMgr.cpp src/server/game/Entities/Player/Player.cpp
grep -n "Alliance.Items.Amount.Ratio\|Buyer.Horde.Enabled" src/modules/PlayerbotV2/conf/zz-*.conf   # ratio 100, buyers 1
grep -n "TradeGoods.MinStock\|Vanilla.MarketPrices = 1" src/modules/PlayerbotV2/conf/zz-forever-bots.conf
```

Everlake choices that differ from live Forever or have no Forever source (decided 2026-11-19, keep them):

- **Dungeon kill XP at the open-world rate** (`Rate.XP.DungeonKill` default 1, Classic Era; decided 2026-11-25). Live
  Forever pays 0.6 of Era since its November 8 hotfix. The carry block (`Classic.DungeonCarryXpBlock`) still applies.
- **No debuff cap.** The official realm probably caps debuffs per target (Era: 16); Everlake keeps no cap (`MAX_AURAS`).
- **Open-world raid tagging is vanilla:** with a raid on the tap list, every raid member near the looter can roll, tagged
  or not. Keep it until Forever says otherwise.
- **Rated 2v2 / 3v3 arenas** (Mak'gora Arena in Hyjal Crater, Ring of Law in Blackrock Depths;
  `sql/custom/world/2026_11_02_50_world_arena_makgora.sql`, `2026_11_08_70_world_arena_ring_of_law.sql`). Forever has not
  announced arenas; Everlake keeps them.

## Bots swim under the surface while they move (`WaterRouteAdjust`), PTR report 2026-11-19

A bot's route over deep water runs at its swim depth (`Swim::SwimZ`, head out, body under) instead of on the navmesh's
water polygons, which lie on the surface. Before it, a moving or following bot swam on top of the water and only sank
in once it stood still. The core's `PathGenerator` calls an optional hook for every finished route whose corridor
crosses water polygons; the bot module lowers each deep-water point above the swim z to it. Dives and points on the
lake bed keep their depth, the bot's own start point is never moved, and only bots are touched.

| Hook | Where | What breaks if it goes |
|---|---|---|
| `SetWaterRouteAdjust` / `FinishPath()` | `src/server/game/Movement/PathGenerator.h` / `.cpp`, called at every exit of `CalculatePath` (Karrz 0.1.39 took this fix into his tree and renamed our `AdjustWaterRoute()` to `FinishPath()`; the Karrz 0.1.39 bot port uses his) | **Silent:** bots swim on top of the water again while they move |
| `BotSwimRouteDepth` + its registration | `src/modules/PlayerbotV2/PlayerbotV2Scripts.cpp`, `AddSC_playerbot_v2` | Build fails if the core hook goes; **silent** if only the registration goes |
| `Swim::RoutePointNeedsLowering` | `src/modules/PlayerbotV2/Api/BotSwim.h` | Build fails |
| Tests | `tests/game/BotSwimRoute.cpp` | Rule changes go unnoticed |

Check after a merge:

```bash
grep -n "AdjustWaterRoute()" src/server/game/Movement/PathGenerator.cpp
grep -n "SetWaterRouteAdjust" src/modules/PlayerbotV2/PlayerbotV2Scripts.cpp
```

## Safe shutdown on a stop signal (`SignalShutdownDelay`, database queue drain)

A container stop or restart (SIGTERM) used to roll back every character still logged in: the core kicked them and queued
their saves, then `DatabaseWorkerPool::Close()` called `io_context::stop()`, which drops queued work. TrinityCore
master has the same `Close()`. Now `Close()` waits for the queue to empty first, and `SignalShutdownDelay` (seconds,
default 0) turns the first stop signal into the in-game shutdown countdown, as Evermore's core does; a second signal
stops at once.

That was not enough (22 Nov: a live restart with the countdown still rolled a character back): the saves were queued
late, when the network was taken down after the scripts' `OnShutdown` hooks and the bots' logout, and written only when
the pools closed at the very end, so any step in between that failed, hung or was killed lost them. Now
`SavePlayersBeforeShutdown()` runs first, straight after the world loop: it logs every player out while everything is
still up, then waits for the character and login queues to empty. It logs `Shutdown: saving N online players` and
`Shutdown: N players saved`.

| Hook | Where | What breaks if it goes |
|---|---|---|
| `SavePlayersBeforeShutdown()` straight after `WorldUpdateLoop()` | `src/server/worldserver/Main.cpp`, `main` | **Silent:** a stop can roll characters back again |
| `WaitForEmptyQueue` before `_ioContext->stop()` | `src/server/database/Database/DatabaseWorkerPool.cpp`, `Close()` | **Silent:** characters roll back on every stop |
| `SignalShutdownDelay`, `SignalShutdownRequested`, re-armed `onSignal` | `src/server/worldserver/Main.cpp` (`main`, `WorldUpdateLoop`, `SignalHandler`) | **Silent:** a stop has no countdown |
| `WaitForEmptyQueue` | `src/server/database/Database/QueueDrain.h` | Build fails |
| Tests | `tests/database/QueueDrain.cpp` | Rule changes go unnoticed |

Check after a merge:

```bash
grep -n "WaitForEmptyQueue" src/server/database/Database/DatabaseWorkerPool.cpp
grep -n "SignalShutdownRequested\|SavePlayersBeforeShutdown" src/server/worldserver/Main.cpp
```

## Molten Core tier 1: the Forever copies, not Karrz's Classic rows

Everlake's Molten Core drops the Forever tier 1 copies 288823-288894 (world data #253), so the Classic pieces
16795-16868 stay without item rows here. Karrz's 0.1.39 brings them back as Classic items; leave those out.

| Karrz file | What to leave out |
|---|---|
| `sql/custom/hotfixes/2026_11_21_85_hotfixes_forever_molten_core_tier1.sql` | The whole file |
| `sql/custom/hotfixes/2026_11_21_86_hotfixes_forever_blackwing_lair_armor.sql` | Only the end: the sell prices of 16849-16868 and `hotfix_data` 26112720-26112739 (our copy already stops before it) |

If a later Karrz file writes an `item_sparse` row for one of the 72 ids in 16795-16868, leave that row out too.
