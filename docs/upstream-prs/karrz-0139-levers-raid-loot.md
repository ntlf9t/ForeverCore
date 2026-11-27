# Karrz 0.1.39 / 0.1.39.1: dungeon door and lever scripts, raid loot

Two pieces of Karrz1/ForeverCore (the renamed Karrz1/TrinityCore), taken by hand from `forever-bots`, not as a merge:
0.1.39.1 `7509ecbfcc` (SQL only) and the raid loot part of 0.1.39 `b441bf74e0`.

## Dungeon door, lever and event scripts (0.1.39.1)

`2026_11_05_99_world_forever_restore_forever_quest_data.sql`, which we carry from Karrz data batch 1a, was made by comparing
two test worlds that never ran the classic script files writing through a `world.` prefix, so it deleted their rows.

- `sql/custom/world/2026_11_22_47_world_classic_gameobject_script_doors.sql`: the gameobject-run door lists set the door
  state (action 118) instead of action 147, which never moved a door in its spawn state (Blackrock Depths Shadowforge
  Lock and the giant door).
- `sql/custom/world/2026_11_22_48_world_classic_restore_scripts_lost_in_1105.sql`: 353 `smart_scripts` rows, by key
  (delete + insert of exactly those keys, no table-wide delete); lever and torch AINames (2689, 2690, 4072, 61935,
  113757, 144070, 176210); Stratholme service entrance script; Rajaxx's AIName; SmartQuest for quest 5525.

Checked against the PTR world on 2026-11-22, with the 22_47 change applied to the PTR rows first: 313 of the 353 rows
are already there unchanged, none differ, and 40 are missing: Darkmaster Gandling 1853, the five Pyrewood councilmen
(2062-2067, id 0), 8023, Pyroguard Emberseer 9816 and 10316 event start (ids 100+), and Kirtonos the Herald 10506
(the whole fight; only his id 13 is there). The PTR also has rows these keys do not cover (Emberseer ids 0-16,
councilmen id 30, Kirtonos id 13, 8023 waypoint actions, Rajaxx ids 7-9); the file leaves them alone. The 7 lever and
torch objects have no AIName on the PTR and quest 5525 has no SmartQuest, so those levers do nothing today.

Left out: `2026_11_11_29_world_forever_free_forever_tele_ids.sql`. It only moves a server's own `.tele` entries off ids
2342-2399; the PTR has five there (DrownedCity, DrownedCityEntrance, KroldokStronghold, KroldokStrongholdEntrance,
Naxx), all names the file keeps, so it would change nothing.

## Raid loot (0.1.39)

The WoW Forever client blanks the ItemSparse rows of the Classic raid items, and the server had none either, so every one
was an invalid loot item: the loot rows are there (514 of the 521 items are in creature, gameobject or reference loot on
the PTR) but nothing dropped and `.additem` said "Invalid item id".

- `sql/custom/hotfixes/2026_11_21_86` to `_96`: Blackwing Lair, Zul'Gurub, AQ20, AQ40, Naxxramas, Onyxia, Molten Core
  (non-tier), shared raid loot (tier 2 chests and legs, Abyssal and Undead Slaying sets), world bosses, a few
  non-raid items, and 121 raid weapons. 521 `item_sparse` rows, 621 item effects (Classic equip and use spells),
  1,763 `hotfix_data` rows so the client shows them. Stats are Karrz's: Classic (Wowhead Classic) values worked out
  as item level budget shares, not live records.
- `sql/custom/world/2026_11_21_88_world_forever_classic_weapon_damage.sql` + code: table `classic_item_damage`
  (770 weapons), loaded by `ObjectMgr::LoadClassicItemDamage()` after the item templates. A weapon with a row uses that
  damage at its own item level and scales by the item level table elsewhere (`ItemTemplate::GetDPS`, `GetDamage`,
  `GetClassicDamageScale`; the old table lookup is now `GetTableDPS`). The row is the in-game range, so
  `GetClassicDamage` and `GetClassicDPS` skip the reduced-caster share and QualityModifier for it. Rows are the live
  Forever item page damage, and the Classic damage for the raid weapons the client blanks; weapons without a row keep
  the table damage. This also changes non-raid bows, guns, crossbows, staves, wands and thrown weapons to their live
  damage (Karrz: the table matches live for 2,056 of 2,826 weapons, nearly every melee one).

Left out on purpose:

- `2026_11_21_85_hotfixes_forever_molten_core_tier1.sql` (Classic tier 1, 16795-16868): Everlake drops the Forever
  copies 288823-288894 instead (world-data #253). None of the 72 Classic tier 1 ids is in the ported files.
- The end of `_86`: 20 tier 1 sell-price updates (16849-16868) and their `hotfix_data` rows 26112720-26112739.

Ids: `item_effect` / `item_x_item_effect` 9900413-9901033 and `hotfix_data` 26112457-26114239 are empty on the PTR
and unused in this repo (our own hotfix_data ranges are 2090000-2114999 and 26103101-26103666). Two of the items had a
row on the PTR already, blank placeholders (Goblin and Gnome Engineer's Renewal Gift 11422/11423, item level 1, common);
`_95` writes the Classic rows over them.

## Checked

- `clang++ -fsyntax-only` (with `TRINITY_PLAYERBOT_V2` and `DT_VIRTUAL_QUERYFILTER`) on `ItemTemplate.cpp`, `Item.cpp`,
  `ObjectMgr.cpp`, `World.cpp`: clean.
- All 14 SQL files run on a scratch MySQL 8.0 with the stock `world` and `hotfixes` schemas (plus the PTR's
  `item_sparse.AmmunitionType`), and run a second time with the same counts.
- **Not done:** worldserver start, `.additem` of a raid item, a kill in a raid, a lever in game. Build, link and tests are
  this PR's CI.
