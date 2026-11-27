# Karrz 0.1.39 world data, batch 1

From Karrz1/ForeverCore `forever-bots` `b441bf74e0` (0.1.39), checked against the PTR world on 2026-11-22. Karrz's world
files rewrite rows by key (delete, then insert), and much of what they rewrite we already have from world data and earlier
merges, some of it Everlake's own data he imported. So nothing is taken file by file except small fixes that touch nothing
Everlake's world data repo also changed.

## `2026_11_22_60_world_forever_karrz_0139_world_gaps.sql`

Built from 35 bulk files (EG Link live quests, NPC templates, drops, vendors, dungeon abilities, live captures; Wowhead WoW
Forever quest NPCs, objects, drops, vendor items and costs, spawns; Ironforge objects):

- Quests: none left. Every quest Karrz adds is on the PTR already or in `2026_11_22_50` (#119).
- 330 creature templates and 169 object templates the PTR lacks (with their models, levels, difficulty rows).
- 43 spawns, only for creatures and objects with no spawn at all (never a second set beside ours).
- Loot and vendor rows the PTR lacks, row by row; Karrz's extra quest drops only for the 9 items nothing on the PTR drops.
- Live dungeon abilities (`eg_live_dungeon_abilities` 1 and 2, City of Dalaran trash) as he wrote them: guarded, a row only
  goes in when nothing else of the creature casts that spell; with the `AIName = 'SmartAI'` updates they need.
- His UPDATEs outside the quest tables: quest-giver flags (`npcflag | N`), SmartAI flags, `LootID = Entry` for creatures
  that gain drops, quest object links (`Data8` where 0), faction of the new quest NPCs, limited vendor stock (`maxcount`
  where 0), Commander Springvale's Divine Shield.
- Left out: his deletes of rows we already have, his rewrites of quests the PTR already has, and quest table updates.
- Loot rows are deleted by exact key before they are inserted, so the file can run more than once.

## Whole files (small fixes, nothing shared with world data)

- `2026_11_18_175_world_forever_malah_longwind_dead.sql`
- `2026_11_18_19_world_forever_mangy_duskbat_skinning.sql`
- `2026_11_19_17_world_forever_ruru_strigid_screecher_text.sql`
- `2026_11_19_18_world_classic_mutanus_wakes_naralex.sql`
- `2026_11_19_41_world_classic_duskwood_mining_nodes_on_ground.sql`
- `2026_11_19_42_world_classic_herb_and_mining_nodes_on_ground.sql`
- `2026_11_19_43_world_forever_ruins_of_lordaeron_teleport.sql`
- `2026_11_19_44_world_forever_dwarf_call_of_fire_fire_tar.sql`
- `2026_11_19_45_world_forever_dwarf_call_of_fire_shaman_shrine.sql`
- `2026_11_19_61_world_forever_doubled_dungeon_bosses.sql`
- `2026_11_19_62_world_forever_kobold_laborer_aggro.sql`
- `2026_11_19_67_world_forever_live_breadcrumbs.sql`
- `2026_11_19_81_world_forever_raenes_cleansing_skull.sql`
- `2026_11_19_82_world_forever_object_sizes_nailed_plank.sql`
- `2026_11_19_84_world_classic_sfk_cell_levers.sql`
- `2026_11_19_84_world_forever_patience_one_report.sql`
- `2026_11_19_85_world_forever_eliza_once_lightforge_ingots.sql`
- `2026_11_19_95_world_forever_rol_double_witherfang.sql`
- `2026_11_20_64_world_forever_sleeping_bag_chain_objects_neutral.sql`
- `2026_11_20_67_world_classic_vmangos_alternatives_walk_the_path.sql`
- `2026_11_20_86_world_forever_dungeon_creature_model_info.sql`
- `2026_11_20_87_world_forever_open_world_creature_model_info.sql`
- `2026_11_21_53_world_forever_darkshore_find_markers.sql`
- `2026_11_21_68_world_forever_riverglades_spawns_on_the_ground.sql`
- `2026_11_21_69_world_forever_eleanor_holmsby_out_of_the_wall.sql`
- `2026_11_21_70_world_classic_weapon_master_trainer_type.sql`
- `2026_11_21_75_world_forever_great_cat_spirit_statue_2.sql`
- `2026_11_21_77_world_forever_neru_model_info.sql`
- `2026_11_21_78_world_forever_missing_model_info.sql`
- `2026_11_21_79_world_forever_dungeon_event_spawn_difficulty.sql`

`2026_11_21_68_world_forever_riverglades_spawns_on_the_ground.sql` without its five updates of spawns 920xxxxxx: those are
Everlake world data spawns (Karrz imported them), so their heights belong in world data.

## Not in this batch

- 40 fix files that touch quests, NPCs or spawns Everlake's world data also changed (Brewer's Trade, Forest Song, the Thousand
  Needles shaman chain, Zum'rah's head, Gleaming Crescent Necklace, Rusty Chests, Nightveiled Rotheap, skinning and quest-drop
  gaps, ...): batch 2, each read against world data.
- Chinese quest text (`2026_11_21_63`, 1 MB), hotfix data, auth / characters / command files, core code: later batches.

## Checked

- All files run three times on a scratch MySQL (stock world schema plus the classic tables and the PTR's areatrigger columns):
  no errors, and runs 2 and 3 give the same row counts in every table touched.
- **Not done:** worldserver start, in game.
