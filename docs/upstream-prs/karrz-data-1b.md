# Karrz data, batch 1b: world and hotfix SQL from release 0.1.34

**Source:** branch `karrz-releases` (see `docs/karrz-releases.md`), tag `karrz-v0.1.34` (Karrz1, 2026-11-09), files copied
byte for byte. **Verdict:** taken, 29 of the 31 SQL files the release adds (24 world, 5 hotfixes), plus our fix-up
`sql/custom/world/2026_11_10_50_world_karrz_1b_keep_quest_reachable.sql`. Player-sourced data is allowed for Karrz's data
(owner decision 2026-11-08) and is checked as it goes in, as in batch 1a.

0.1.34 adds SQL files only; it changes or deletes none of 0.1.33's. Every older Karrz SQL file not in `everlake` is one
batch 1a or the scripts batch left out on purpose (auth and characters files, the two warrior probes, and the four
duplicates listed in `karrz-data-1a.md`).

## What it brings

- **Riverglades quests** (`2026_11_08_96`): 38 of the zone's quests with their givers, enders, objectives, rewards and
  drops, 11 NPCs and 11 objects the world lacked (120 creature and 38 object spawns, guids 47200000-47200999 and
  47210000-47210999, both free here), the quest-giver flag on 17 NPCs we already had, and quest drops for 16 NPCs (12 we already
  had; `LootID` set only where it was 0, existing loot rows kept). Built by Karrz from one player's game cache (build 70862) and
  QuestieTrace export. **Inferred, check in game:** spawn spots (from where the player stood, fitted on 13 of our quest
  givers, under 10 yd error), heights (from nearby spawns), drop chances (what the player looted, at least 25%), and new
  hostile NPCs' stats (copied from a related NPC). 27 quests that need a script, a missing credit NPC or an unknown giver
  are left out; the file lists them at the end.
- **Items** (hotfixes `2026_11_08_60/62/64`, `2026_11_09_10`): 197 items the client knows but had no data for anywhere
  (Naglering, Freezing Band, Might of Hakkar, the Bloodmail and Deathbone sets, 42 new Forever items), from players'
  hotfix caches; Russian names and texts for 4,541 items.
- **Quest XP and levels** (`2026_11_08_22`, `2026_11_08_80`): XP and level from the Questie project's live traces
  (724 quests seen); about 250 quests changed, the rest already matched.
- **Quest fixes from player reports:** Destruction in Deadmines (spell focus object), Garments of the Light (Guard Roberts
  healable), Ritual Fire turn-in (Horde can click it), The Missing Scholar (one Fillion), Call of Fire (Loch Modan shrine),
  The Sleeper Has Awakened (no item objective), Rare Books (Mother Fang elite, quicker respawn), Bitter Rivals (unguarded
  barrel appears), A Sealed Crate (Marcy Baker and Dokimi take the crates; lifts the hold in `2026_11_05_71`), Questie's
  hand-written corrections (Arugal's Folly chain and others), placeholder quests filled from player caches (A Donation of
  Silk, Khan Hratha), Russian quest, NPC and object texts.
- **World:** Moonglade druid flights, Skyborne portal landing in Dalaran (was under the floor), the retail instance portal
  inside Blackrock Spire removed, Wailing Caverns deviate raptors attackable by bots and pets, Searing Totem ranks 1-2 and
  Stoneclaw Totem rank 1 back on the core `TotemAI`.
- **Taming:** Matriarch Bristlefur and the other cache-seen beasts get their pet family and tameable flag
  (`2026_11_09_10`); `2026_11_09_12` then marks every beast with a pet family that spawns on the two continents as
  tameable. That second rule is **inferred** by Karrz (248 of 250 cache-seen beasts with a family are tameable; the client
  has no table for it), with the two known exceptions and rares, elites and service NPCs left out.

## Left out

| File(s) | Why |
|---|---|
| `2026_11_08_70_hotfixes_arena_ring_of_law`, `2026_11_08_70_world_arena_ring_of_law` | Move 2v2/3v3 arenas to a new map 3200 (a copy of Blackrock Depths). Needs map 230's maps, vmaps and mmaps copied as 3200 and the `arena_ring_of_law` script and battleground changes from Karrz's core, which we don't have. Loaded alone, arenas would point at a map the server can't load. They go in with the arena code. |

## Our fix-up (`2026_11_10_50_world_karrz_1b_keep_quest_reachable`)

Song of the Strider (95984) follows A Feast for Buzzards (95983) in the Riverglades file, but 95983 is one of the quests
that file leaves out, so 95984 could never be offered. The fix-up clears that one link; whoever adds 95983 later sets it
back.

## How it was checked

Scratch MySQL 8.0: TDB `TDB_full_forever_2026_10_14` + every update the live realm has (this branch's base `everlake`
`sql/updates` + `sql/custom`, world data `24a3b39`, Everlake's own SQL), applied like the updater (file-name order, skip
what `updates` lists): 507 world and 33 hotfix files, no error. Then this batch.

- All 24 world and 5 hotfix files apply with no error; the fix-up too. Applied a second time (updater re-run): no error.
  On that second run only `creature_template_difficulty` moved (the Riverglades file rewrites its new NPCs' rows, then the
  later taming rule flags them); a third run changes nothing, and the live updater and a fresh build both run each file once.
- Build order: our own files named after this batch (`2026_11_09_50` keep-ours, `2026_11_09_60/61`, `2026_11_09_79`) and
  the world data / Everlake SQL were run again on top: no table this batch touches changed, so a fresh build (file-name
  order) and the live realm (new files last) end the same.
- None of the Riverglades quests, NPCs, objects or guids existed before, so nothing of ours is overwritten. Its loot
  deletes remove only the exact rows it adds. Our world data sets no quest XP, so the two XP files overwrite none of it.
- Script check: no new `ScriptName`; only stock AI names (`SmartAI`, and `AIName` cleared for the three totems). Script
  names in use 1,849 -> 1,849, `spell_script_names` 4,898 -> 4,898, `SmartAI` NPCs without rows 367 -> 367.
- Dangling references, before -> after (with the fix-up): spawns without template 0 -> 0, quest starters/enders without
  NPC or object 0 -> 0, starters/enders without quest 22 -> 22, `PrevQuestID` to a missing quest 0 -> 0 (1 without the
  fix-up), addon rows without quest 4 -> 4, monster objectives without NPC 925 -> 925, `LootID` without loot 6,353 -> 6,353,
  loot to a missing reference 0 -> 0, stacked creature pairs 374 -> 374. Hotfixes: duplicate `hotfix_data` keys 0 -> 0,
  items without `item_sparse` 0 -> 0.
- Rows: creatures +120, objects +38, creature templates +11, quests +38, objectives +41, creature loot +21; hotfixes items
  +197, `item_sparse_locale` +4,553, `hotfix_data` +394.
- Not checked: a worldserver start on this data, and the Riverglades quests in game (spawn spots, heights and drop rates
  are inferred). First start after the pin bump is the test; watch `Server.log` / `DBErrors.log`.
