# Karrz data, batch 1a: world and hotfix SQL that needs no new core code

**Source:** branch `karrz-releases` (see `docs/karrz-releases.md`), tag `karrz-v0.1.33` (Karrz1, 2026-11-08), files copied
byte for byte. **Verdict:** taken, 272 Karrz files (249 world, 23 hotfixes) + our fix-up
`sql/custom/world/2026_11_09_50_world_karrz_1a_keep_ours.sql`. Player-sourced data is allowed for Karrz's data (owner decision
2026-11-08), checked as it goes in.

## What it brings

Karrz's `sql/custom/world` and `sql/custom/hotfixes` files that `everlake` does not have (351), minus the ones listed below.
By file name: 120 `forever_*`, 95 `classic_*`, 11 `zephras_*`, the rest Azeroth/Skyborne/arena/ruRU fixes. Highlights:

- `2026_11_05_99_world_forever_restore_forever_quest_data`: about 100 Forever quests that fresh worlds lost (Elwynn, Westfall,
  Dun Morogh, Loch Modan, Redridge, Wetlands; "players run out of quests around level 14"). Data credited by Karrz to the
  AnoCore project.
- `2026_10_31_80_world_forever_broken_quests`: clears `quest_template.QuestPackageID` (the 1.60 client has no quest packages),
  which gives back the reward choices of 150 quests (Wanted: Hogger and others) and Stormheart's loot.
- Vanilla world events (VMaNGOS spawns, seasonal quests only during their event), vanilla player base mana, pet stats,
  creature levels, resistances, immunities and loot, spell values (`classic_spell_value`, later trimmed toward Forever's own
  numbers by Karrz's 10-31 to 11-04 files), Forever trainers, NPC/quest fixes from player reports, City of Dalaran world data,
  items, spells and TACT keys in hotfixes.

## Left out

| File(s) | Why |
|---|---|
| `2026_10_31_00_hotfixes_spell_duration_per_level` | Adds a column we already add in `2026_11_06_00_hotfixes_classic_spell_duration_per_level`; would stop the worldserver (duplicate column). |
| `2026_11_05_00_hotfixes_classic_70790_tact_keys` | Identical to our `2026_11_07_00_hotfixes_classic_70790_tact_keys`. |
| `2026_10_29_70_world_classic_quest_5727_hidden_enemies_poi` | Same fix as our `2026_10_29_91_…`. |
| `2026_11_06_50_world_classic_resupplying_the_excavation` | Older than our `2026_11_08_71_world_everlake_resupplying_the_excavation_trigger` (live Forever objective 385478); would add a second, made-up objective. |
| 75 files that add, remove or replace `spell_script_names`, or move bosses to C++ scripts (Thekal trio, Rajaxx waves, Alterac Valley assaults, Chromaggus lever) | Their scripts exist only in Karrz's core (150 script names). Loaded alone they strip working retail scripts from 188 spells (e.g. Lay on Hands would lose Forbearance). They go in with those scripts (Karrz scripts batch). |
| 7 files both sides have, changed by Karrz in comments only | A new hash makes the updater run them again for nothing. |
| `2026_10_10_01_…_classic_spell_values`, `2026_10_11_06_…_classic_spell_twins` (Karrz filled the tables we create empty) | Spell values: Karrz's later `2026_10_10_21_world_classic_spell_values_v2` (in this batch) refills the table. Spell twins: read only by Karrz's core. |
| `2026_10_11_01_…_classic_creature_melee`, `2026_10_11_05_…_classic_spell_info` (filled by Karrz, empty in ours) | Our core reads both; filling them would give every creature vanilla melee and spells vanilla timings. Owner decision 2026-11-09: keep Forever's own values, so these stay empty (not taken in later batches either). |

## Our fix-up (`2026_11_09_50_world_karrz_1a_keep_ours`)

1. Karrz's quest-data restore is a row diff between two of his worlds; on ours it deletes SmartAI rows we use. Every owner the
   batch leaves with no `smart_scripts` rows gets its rows back as before (139 owners, 479 rows: Gazban, Krakle's Thermometer,
   Alterac Valley commanders, Thekal, the Zul'Gurub zealots, ...), and General Rajaxx and the Peacekeeper Elite get `SmartAI`
   back. The held boss-script files replace these when Karrz's scripts come in.
2. Re-applies two of our files that are newer than Karrz files touching the same rows: `2026_11_08_01_world_dead_quest_loot`
   (Karrz's VMaNGOS loot rebuild writes those rows back) and `2026_10_26_06_world_classic_warlock_binding_demons_hostile`.

## How it was checked

Scratch MySQL 8.0: TDB `TDB_full_forever_2026_10_14` + every update the live realm has (this branch's base `everlake`
`sql/updates` + `sql/custom`, world data `24a3b39`, Everlake's own SQL), applied like the updater (file-name order, skip
what `updates` lists), then this batch.

- All 250 world files and 23 hotfix files apply with no error; the whole batch applied a second time (updater re-run): no error.
- Script check: no spell, creature, object, instance or area trigger loses a script or AI our core has; no `smart_scripts`
  owner is left empty.
- Our newer fixes hold: Binding demons 5676/5677/6268 faction 90; dead quest loot rows gone; quest 273 has only 385478.
- Dangling references, before -> after: creature spawns without template 34 -> 0; quest starters/enders without NPC 12 -> 0;
  `PrevQuestID` to a missing quest 33 -> 0; addon rows without quest 47 -> 4; monster objectives without NPC 932 -> 925;
  quests with no ender 44,241 -> 44,223. Worse: `LootID` without loot 6,359 -> 6,360 (+1), and creature loot referencing a
  missing reference 0 -> 394 (see below).
- Rows: about +11.3k objects, +6k creatures, +8k creature loot, +12.6k item durability, +1.3k trainer spells; changed in
  place mainly `quest_template` (5,033, `QuestPackageID`), `creature_template` (1.8k), `player_classlevelstats` (420 base mana).

## Known gaps (fixed by later batches)

- 394 creature loot rows reference the "Untranslated mage scroll" reference loot made by the held
  `2026_11_01_42_world_classic_mage_scroll_deciphering` (needs Karrz's `classic_spell_mage_decipher`). The loader logs them
  and skips them until that file comes in.
- Data for tables only Karrz's core reads (`classic_crate_bundle`, `classic_item_durability`, `classic_spell_effect`,
  `spell_classic_summon_level`) loads but does nothing until that code is ported.
- A few new NPCs and objects use scripts only Karrz's core has (Excavation Site in the Wetlands: Relic Guardian, Archival
  Panel, instance script; Rigger Gizelton; Twiggy Flathead's area trigger). Those quests stay incomplete until the scripts batch.
- Stacked spawns added by Karrz: 13 object pairs (Sprung Trap, Forgotten Loa Idol) and 36 creature pairs (Ironforge
  Mountaineer, Enraged Silverback Gorilla, critters); 991 decoration pairs stacked inside one world event (800 Hallow's End).
  Cleanup later.
- Not checked: a worldserver start on this data (no local build of the realm image); first start after the pin bump is the
  test, watch `Server.log` / `DBErrors.log`.
