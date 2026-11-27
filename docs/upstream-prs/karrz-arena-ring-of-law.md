# Karrz arena: Ring of Law (2v2 / 3v3 on map 3200) from release 0.1.34

**Source:** branch `karrz-releases` (see `docs/karrz-releases.md`), tag `karrz-v0.1.34` (Karrz1, 2026-11-09). The two SQL
files are copied byte for byte; the code is ported hunk by hunk, keeping our side where `everlake` differs.
**Verdict:** taken. This is the code and SQL that data batch 1b (`karrz-data-1b.md`) held back.

0.1.34 moves the Classic arenas from the open Hyjal Crater bowl (map 2995) into the Ring of Law of Blackrock Depths. The
Classic client has no TBC arena maps, so the arena is a new map 3200: a copy of Blackrock Depths (map 230, same WDT) with
its own id and type arena, so Blackrock Depths itself does not change and no dungeon spawns load in it.

## What it brings

- **`arena_ring_of_law`** (new, `src/server/scripts/Battlegrounds/RingOfLaw/`), with its line in
  `battlegrounds_script_loader.cpp`: a battleground map script on map 3200. It spawns the four Ring of Law gates
  (161522-161525, at their Blackrock Depths spots); the south and east gates hold the two teams in their tunnels and open
  when the match starts, the other two stay shut.
- **`BattlegroundMgr.cpp`**, three hunks. "All Arenas" (6) is a queue that picks another template (Mak'gora Arena 1169),
  and in Classic it lists only one map, which the core read as "a battleground played itself":
  - `GetBattleground` looks through every template's matches for queue 6 and the random battlegrounds, not only when the
    queue lists more than one map (0.1.34). Before, an arena match was never found: Enter did nothing and the invite
    never ran out.
  - `LoadBattlegroundTemplates` asks no start points of 6 / the random battlegrounds, and does not let them take the
    map-to-template slot of the template they pick (0.1.29). Without this, 6 is registered for map 3200 too and can
    be picked in place of 1169.
  Our side is kept: the `int32` compare in `GetMinPlayersPerTeam` and `FindBattlegroundByInstanceId`.
- **`BattleGroundHandler.cpp`**, arena join (0.1.29): a 2v2 needs a party of exactly 2 and a 3v3 exactly 3 (the queue took
  a lone player as a full team, giving 1 vs 2 matches; `.debug arena` testing mode skips the check). "Template bg (all
  arenas) not found" now also tells the player arenas are off.
- **Bot side** (PlayerbotV2, only files `everlake` already has): `Bot/Battleground/Scripts/ArenaScript.cpp` gets the
  Mak'gora Arena (1169) geometry with 0.1.34's rally point (the ring centre) and its factory; `Services.cpp` registers it.
  Bots that are in an arena (a player's own party bots) then head for the ring centre when the gates open.
- **SQL** (`2026_11_08_70`):
  - hotfixes: `map` row 3200 (the client's own map 230 row with a new id, name, type arena, 10 players) and its
    `hotfix_data` row (3200001), so the client learns map 3200; `battlemaster_list_x_map` 1208 (1169) and 1500 (6) point
    at 3200 (server only, the client keeps 1169 -> 2995); `pvp_difficulty` 32000-32005, the same level brackets as 2995.
  - world: start points 1104112 / 1104113 (south and east tunnels, from the Blackrock Depths script's fighter spawns),
    templates 6 and 1169 on them, `StartMaxDist` 30.

## Left out

| What | Why |
|---|---|
| `BattleGroundHandler.cpp`: arena join calls `OnPlayerBattlegroundQueueJoin` (0.1.29) | Karrz's newer bot module answers it by forming a bot team for the party. Our PlayerbotV2 has no arena team forming: its handler would treat the arena queue as a battleground fill. Comes with a bot module update. Until then an arena match needs two real parties. |
| `Bot/Battleground/Scripts/ArenaScript.cpp` rest of 0.1.34, other bot files | Not arena; part of the bot module gap, not this batch. |
| Map 3200 server data (maps, vmaps, mmaps) | Not code: the extractor copies map 230's files as 3200 (wow-project-everlake PR #63). Without them map 3200 has no terrain on the server. |
| Old Mak'gora rows on map 2995 (`2026_11_02_50`, `2026_11_04_60`, start points 1104110/1104111, `pvp_difficulty` 1900-1905) | Kept, as Karrz kept them. Nothing points at them after this batch; they are harmless. |

Karrz's code comments still say "map 2995" in the `BattlegroundMgr.cpp` hunks; kept as he wrote them (the logic does not
depend on the map).

## How it was checked

- **Compile:** the six changed or new `.cpp` (`BattlegroundMgr`, `BattleGroundHandler`, `arena_ring_of_law`,
  `battlegrounds_script_loader`, PlayerbotV2 `ArenaScript` and `Services`), clang-17 no-PCH with
  `-DBUILD_PLAYERBOT_V2=1`, the Docker recipe of the scripts batch, after a CMake re-run (new source file): no error,
  no warning. Not linked or run locally: CI builds, links and runs the tests.
- **SQL**, scratch MySQL 8.0 holding `TDB_full_forever_2026_10_14` + this branch's base `everlake` updates + world data
  `24a3b39` + data batch 1b:
  - both files apply with no error; run a second time (updater re-run): no error and the checksums of all six tables they
    touch (`map`, `hotfix_data`, `battlemaster_list_x_map`, `pvp_difficulty`, `world_safe_locs`, `battleground_template`)
    are the same as after the first run.
  - no clash: `hotfix_data` 3200001 / UniqueId 1611080001 and `pvp_difficulty` 32000-32005 were free, duplicate
    `hotfix_data` keys 0 -> 0; no other file in `sql/` or the world data touches these rows, so file order does not matter.
  - after: 6 and 1169 both list map 3200 only, 3200 has the six brackets, both start points are on 3200, the four gate
    templates exist, nothing is spawned on map 3200 (the script spawns the gates per match).
- **Not checked:** a worldserver start, and an arena match in game (needs map 3200 data on the server and two parties).
  First start after the pin bump: watch `Server.log` for "Loaded N battlegrounds" (6 and 1169 must load) and
  `DBErrors.log` for start point errors.
