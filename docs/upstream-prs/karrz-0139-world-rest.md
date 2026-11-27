# Karrz 0.1.39: the last world fixes

`sql/custom/world/2026_11_22_62_world_forever_karrz_0139_world_rest.sql`. Every Karrz 0.1.39 world file not yet ported was
gap-checked against the PTR (world_ptr, 2026-11-22): 37 files, 71 inserts of things the PTR lacks, 556 deletes and updates
read by hand.

## Taken

- **Dungeon trash AI.** Everlake's own Alcaz Prison, Blackmaw Hold and Shaper's Terrace had trash with no AI (no AIName,
  ScriptName or smart_scripts). Karrz's SmartAI and spell rows for those 68 creatures are taken; our bosses (`classic_boss_bmh_*`,
  `classic_boss_shapers_terrace`, `classic_boss_alcaz_prison`), spawns, loot, gold, entrances and graveyards stay.
- **Blackmaw Hold fights** (`2026_11_19_71`, whole): target conditions for seven boss spells, and creature 248546.
- **The Drowned City** (`2026_11_19_67`, whole): Everlake runs Karrz's `2026_11_11_30` unchanged; this replaces its guessed
  spawns with live ones.

## Not taken

- Already ported, not yet on the PTR: Alcaz quests 95483 and 96335 (`2026_11_22_50`), Heed My Call (`2026_11_22_61`).
- Everlake's own version: Viktor the Vile, Rend's head and heralds, Rusty Chests, Brewer's Trade, Forest Song, Zum'rah, the
  Gleaming Crescent quest, riding prices, Shipping Label, Dire Maul Ironbark, Panic at the Digsite, low blue disenchant, the
  Portable Repair Bot, Krol'dok Stronghold.
- Valor shaman starters (`2026_11_19_40`, undone by Karrz's own `2026_11_21_73`); Zephras portal gates (Everlake removed both
  portals); quest rewrites the PTR already has (Grom'gol, Blackmaw and Alcaz quests, Dragon's Journal, King Op and Nanaya loot);
  Karrz-only spawn moves (Ironhide pack guids we don't have); Everlake-derived files; free tele ids.

## Checked

- Scratch MySQL (stock world schema plus the classic tables): runs once and again with no errors and the same row counts.
- **Not done:** worldserver start, in game.
