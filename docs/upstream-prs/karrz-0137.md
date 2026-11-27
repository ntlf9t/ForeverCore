# Karrz 0.1.37 (git, up to 0.1.37.2)

**Source:** Karrz1/TrinityCore `forever-bots` `9e7e4694f5` (2026-11-16 22:18 UTC), his last commit before release 0.1.37.2
(22:21 UTC). 0.1.37.1 and 0.1.37.3 changed only the launcher (same source zip as the release before them). Since our last
Karrz merge parent `0da7e58472` (#54): 453 non-merge commits (452 Karrz1, 1 Ricardo Lopez Salazar), 478 files, +35k lines.
The releases are imported as tags `karrz-v0.1.37` .. `karrz-v0.1.37.3` on `karrz-releases`.
**Verdict:** taken, with the changes below.

## What it brings

- **New:** day and night cycle (`Forever.DayCycle.Speed`, `.time day|night|auto`, new table `character_day_cycle`, RBAC 1000);
  a bot tank that leads dungeon runs (`.bot lead on`); trading with bots; optional switches, all off by default:
  `Forever.VanillaAoE`, `Classic.AdventureGuide`.
- **Raids:** Nefarian (Bone Constructs, landing, `Instance.NefarianCapAdds`), world buffs give their stats (Rallying Cry, Warchief's
  Blessing, Slip'kik's Savvy, Mol'dar's Moxie, Songflower Serenade), boss knockbacks move bots, raid talk (`Playerbot.Raid.Talk`).
- **Dungeons:** City of Dalaran, Uldaman / UBRS altars, Wailing Caverns Naralex restart, Blackfathom brazier waves, Shadowfang Keep,
  Deadmines cannon, Dire Maul Knot Thimblejack.
- **Quests and world:** the fixes in the 0.1.37 and 0.1.37.2 notes (Banner of the Fallen, Excavation Tools, Algaz / Rethban
  Gauntlet, Snowbound, Daggerfang, duplicate NPCs, Westfall wells, Touch of the Grave procs from spells, creature sizes, camp items).
- **SIN's fixes** (0.1.37.2): bot trade in one click, hunter bots Revive Pet, open-world dynamic respawns (spawn groups 901035 /
  901036, `Respawn.DynamicMode` now defaults to 1).
- **Positional attacks:** Shred, Ravage, Pounce, Backstab, Garrote and Ambush need the caster behind the target (Garrote unless the
  rogue has Dirty Deeds).
- **SQL:** 86 new world, 10 hotfix, 2 characters, 1 auth files; `sql/custom/*/.gitignore` no longer hides `*.sql` (Karrz made the
  same fix we needed in #47).
- **Bots:** 144 files: raid brain, trade, tank leads, ritual joins, healer wand and mana oil, world errands.

## Merge decisions

59 files conflicted.

- **Whitespace only (11 files)**: ours.
- `README.md`, `NOTICE.md`: ours (this fork's).
- **Karrz tests and tools we do not carry** (9 tests, 5 tools that were deleted on our side and changed on his): kept deleted.
  Karrz's new tests that merged cleanly stay (our `tests/CMakeLists.txt` picks up every file).
- **Bot module (14 files)**: Karrz's, plus what we carry from his release zips: hiring (`Fleet/Hire*`, `HIRE_REQ`,
  `AddSC_playerbot_v2_hire_broker`) and the arena menu (`ForeverBots_Arena.lua`). `Playerbot.World.Pvp.Enable` stays 1 (decided 11-10).
- `MMapManager.cpp`: combined. Our node pool (open world `Pathfinding.NavMeshQueryNodes`, 32768; instances 8192) and Karrz's
  per-thread queries and tile locks; bot-thread queries get the same pool size.
- `Pet.cpp`, `ObjectMgr.cpp`, `StatSystem.cpp`: ours (#59 hunter pet design: 2.0 s swing, speed passive from `classic_pet_tame_spell`,
  `HunterPetForever` food types), plus Karrz's null check on item `BasicData`. **Left out:** Karrz's e29b5b1438 (pet learns the
  Faster / Slower Attack passive nearest its wild speed, and `UpdateDamagePhysical` counts attack power per wild-speed second). With
  ours it gave a second speed passive and scaled pet damage twice. `ClassicPetAttackSpeed.h` and its test are dropped with it.
- `FriendsService.cpp`: ours (handles names that are not unique, surnames).
- `GameEventMgr.cpp`: our tested `Trinity::Holiday::StageLengthMinutes`, with Karrz's error text.
- `PathGenerator.cpp`: Karrz's (`Pathfinding.PetLiquidCost`, default 2.5, same as our #50 constant).
- `IpConnectionLimit.h`, `ItemEnchantmentMgr.cpp`: Karrz's (same fix on both sides, comment differed).
- `Spell.cpp`: ours (the swing log takes its lock only while `playerbot.v2` logs at info).
- `SpellMgr.cpp`: Karrz's: the proc tables moved into `GenerateDefaultSpellProcEntry` (native charged spell modifiers), with two
  aura names changed to ours (TrinityCore renamed `MOD_CASTING_SPEED_NOT_STACK` -> `MOD_CASTING_SPEED`, `MOD_MELEE_HASTE_3` ->
  `MOD_MELEE_HASTE_NO_REGEN`). Skyborne racial tooltip and world buff spell fixes added.
- `zone_wintergrasp.cpp`: ours (null-safe battlefield check, the 0x1c crash fix).
- `classic_instance_razorfen_downs.cpp`: ours (same gong fix, with our gcc cast).
- `spell_rogue.cpp`: Karrz's Garrote positional registration; `spell_rog_acrobatic_strikes` registration dropped (TrinityCore removed
  the script on our side).
- `npc_professions.cpp`, Dire Maul, Naxxramas: Karrz's (gossip texts, comments).
- `FallOutOfWorld.cpp`: ours (git took Karrz's `ClassicDayRhythm.cpp` for a rename of it; that test stays out, as in #54).

Auto-merge duplicates removed: a second `_ipConnectionSlot.reset()` in `WorldSocket::OnClose` (same fix both sides), and three
doubled `#include` lines (`IdleWatch.h`, Vaelastrasz, Anub'Rekhan). No script class, registration or `AddSC_` is defined twice.

## Ours on top: our dynamic respawn groups off

`sql/custom/world/2026_11_16_65_world_everlake_dynamic_respawn_off.sql` empties spawn groups 2 and 4, which the Everlake image fills
(quest targets, herb and ore nodes; wow-project-everlake `sql/everlake/2026_11_09_00` .. `2026_11_14_00`). Karrz's open-world groups
(SIN's `2026_11_16_66` / `_67`) skip spawns that are already in a group, and the updater runs files in file-name order across folders,
so this file runs just before them and the quest creatures join 901036. After this, dynamic respawns cover normal outdoor combat
creatures on maps 0, 1 and 2991; herb and ore nodes and quest objects keep their normal timers. The Everlake repo should drop its own
files and the `Respawn.DynamicMode` / rate overrides in the pin PR (see below).

## Notes for the pin PR

- `Respawn.DynamicMode` defaults to 1 now; bots count as players in the zone. Everlake's compose sets the rates to 40 creature /
  60 s minimum (objects 40 / 120 s); Karrz's defaults are 10 / 10 s. Decide which.
- Karrz copied our `2026_11_12_80_world_zephras_scene_npcs.sql` as `2026_11_14_10_world_forever_zephras_scene_npcs.sql` (same
  content, safe to run again); `2026_11_14_97` (Questie) and `2026_11_15_97` (live drops and vendor items from our world data, only
  what his world lacked) come back to us too; they insert only missing rows.
- Open fork PRs #40 (BFD shrine waves) and #41 (Naralex ritual retry) overlap Karrz's fixes for the same events in this merge; check
  them against it before merging.

## How it was checked

- No conflict markers; duplicate scan: every line Karrz added appears no more often than in his tree or ours (after the fixes
  above); no duplicate script registrations.
- SQL read, not run: nothing touches `creature_classic_melee` / `classic_spell_info` or rebinds Windfury / Flametongue; the two
  `sql/base` additions (`character_day_cycle`, RBAC 1000) have matching custom update files.
- Local `clang++ -fsyntax-only` on all 127 changed `src` C++ files and the 12 changed tests (stub Catch2): clean after b55843fe18 (Warchief's Blessing used Karrz's `SPELL_AURA_MELEE_SLOW`; checked every added line for aura names whose value differs between his tree and ours: only the three handled).
- **Build, link and tests: this PR's CI.** No scratch database run, no worldserver start, nothing in game.
