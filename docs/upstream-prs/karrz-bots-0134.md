# Karrz bots: the PlayerbotV2 module brought up to release 0.1.34

**Source:** branch `karrz-releases` (see `docs/karrz-releases.md`), tag `karrz-v0.1.34` (Karrz1, 2026-11-09).
**Base:** `everlake`'s module is advocaite `forever-bots` `19bdc6af66` (Karrz's module as of 2026-10-27/28, nearest release
0.1.24) plus our own changes since. **Verdict:** taken: the whole module at 0.1.34, 3-way merged with ours, plus the bots'
database migrations and three small core additions the module needs.

## Why one pull request

The module is one tightly coupled program: `BotAI`, `Services`, the bot snapshot types, `PlayerbotAPI` and the module's
`CMakeLists.txt` are touched by nearly every feature since 0.1.24, and the 53 new files are wired in through them. Area-sized
pull requests would not compile on their own, so this is one merge, reviewed area by area below.

## What it brings (releases 0.1.25 to 0.1.34)

- **Group finder and companions:** the dungeon finder (`DungeonFinder.cpp`, `LfgBotFill`, `LfgRoleGap`) always fills the tank and
  healers and doesn't count a role a class can't play; companions follow on foot, mounted and flying, catch up over long
  distances (`OwnerCatchUp`, `OwnerTrail`), ride boats and zeppelins with their owner, swim properly (`BotSwim`), wear gear
  traded to them, and stop piling up copies of gear in their bags.
- **Dungeons and raids:** per-dungeon tactics and routes (21 dungeon files, `TankStill`, `PackPullGate`, entrance pockets),
  every Zul'Gurub boss (`RaidMechanics_ZG`, `ZgHakkar`), raid brain and mechanics work (Molten Core movement, Naxxramas),
  Onyxia cloak check.
- **PvP:** world PvP for world bots (`WorldPvp`, `WorldPvpConfig`: some flag, some hunt or attack flagged enemies of their
  level in border and contested zones), arena opponents for real parties (`Playerbot.Arena.BotOpponents`), battleground
  fixes.
- **World and social:** bots chat face to face in cities, post in Trade and General, greet, invite to their guilds by
  whisper, mages open city portals, drink and say, hire brokers (`Hire*`, off by default), language per player (English or
  Russian, `BotLanguage`, `BotLocaleRu`).
- **Commands and add-on:** plain-words orders (come here, wait, follow, mount up, spread out, trade me water...), the
  ForeverBots add-on's new windows (finder, gear, hire, quests, spec, arena), saving bots every 15 minutes.
- **Optional AI chat:** `BotChatModel*` talks to a local Ollama (`127.0.0.1:11434`) and `BotBridge` to a file folder. Both
  are **off** by default (`Playerbot.ChatModel.Enable = 0`, `Playerbot.Bridge.Enable = 0`) and make no connection while off.
- **Bots' database:** migrations `sql/playerbot_v2/0034`-`0038` (dungeon routes for Shadowfang Keep, Uldaman and other
  classic dungeons, hired bots, owner language) and the matching `playerbot_shared_data.sql`. The module applies new
  migrations by itself at start (`PlayerbotMigrationMgr`).

## Our side kept

- Battleground lookups: our core finds a battleground by instance id and keeps one free-slot list per queue (TrinityCore
  `e5c9acdf34`, our `e3a94d6366`). Four conflicts in `BotInspector`, `BotPopulationManager`, `BotQueueFiller` and
  `PlayerbotV2.cpp` keep ours; Karrz's `FindInvitedBattleground` helper (a workaround for his older lookup, including arena
  queues) is dropped because our lookup already covers it.
- Everything else of ours in the module (bot names unique by full name, name reservation across realms, account prefix,
  Everlake config) merged without conflict.

## Core additions (three, from Karrz's core)

- `ChaseMovementGenerator::GetNoPathStreak()`: counts repaths in a row that found no path, so a bot gives up on a mob it can't
  reach (`BotSnapshotBuilder`).
- `AreaTriggerDataStore::ForEachAreaTriggerSpawn()`: lets bots find area trigger spawns (`CoreFlowRules`).
- `HandleBattlemasterJoinArena` calls `OnPlayerBattlegroundQueueJoin` like a battleground join does, so the module can form
  a bot team against a real party queued for an arena.

## Defaults that change what players see

The build installs the module's config files; Everlake overrides only the bot counts (`docker-compose.yml`, `BOTS_*`).
Changed defaults that reach Everlake as they are:

| Setting | Before | Now |
|---|---|---|
| `Playerbot.World.Pvp.Enable` | (no world PvP) | 1: world bots flag, hunt and attack in border and contested zones (owner decision 2026-11-10: keep on) |
| `PlayerbotV2.Guilds.Enabled` | 0 | 1: bot guilds, which invite by whisper (`PlayerbotV2.Guilds.InvitePlayers = 0` keeps real players out) |
| `Playerbot.World.PoolMax` | 700 | 3000 sleeping bot characters built up in the background |
| `Playerbot.Arena.BotOpponents` | (none) | 1 |
| `Playerbot.Language.Enable` | (none) | 1: replies in the player's client language |

New `Bots.*` sizing keys exist; they replace the old `Playerbot.World.*` counts only when one of the sizing keys (`Bots.Size`,
`Reserve`, `ActiveCap`, `InCity`, `PerZone`) is set. The shipped `zz-0-playerbot-defaults.conf` sets only
`Bots.SaveIntervalSec`, so Everlake's `BOTS_*` numbers keep working.

## Left out (for the Karrz core batch)

Karrz's core also changed how the game treats bots, outside the module: bots skip the instances-per-hour limit
(`Map.cpp`), auto-equip new bags (`Player.cpp`), get a path tweak (`PathGenerator.cpp`), and bot characters are deleted through
the owner's session (`CharacterHandler.cpp`). Those are core game changes and go in with the rest of Karrz's core work. Karrz's
12 bot test files in `tests/` are not ported either.

## How it was checked

- 3-way merge per file (base `19bdc6af66`, ours `everlake`, theirs `karrz-v0.1.34`, line endings normalised): 203 files
  taken as they are, 11 merged, 4 with conflicts resolved as above. No conflict markers left.
- Compile: every module `.cpp` (385) plus the three core files and the module's three tests (`BotAccountName`,
  `ClassicRidingTier`, `ClassicDrinkSay`), with CI's no-PCH clang-17 flags and warnings as errors: no errors. Before the
  core additions, 2 objects failed (the two missing core functions); nothing else.
- Not linked or run locally: CI builds, links and runs the tests. Not started on a server or seen in game; the bots'
  migrations run on the first start (watch `Playerbot.log`).
