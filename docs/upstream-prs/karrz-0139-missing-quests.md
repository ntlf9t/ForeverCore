# Karrz 0.1.39: the 49 quests Everlake does not have

On 2026-11-22, 49 quests that Karrz1/ForeverCore 0.1.39 (`forever-bots` `b441bf74e0`) carries were missing from the PTR
world entirely (no `quest_template` row), and in neither this fork nor world data. They are taken here row by row,
not file by file: Karrz's files also hold quests the PTR already has (some of them copies of Everlake's own data), and
those stay as they are.

## What is in it

`sql/custom/world/2026_11_22_50_world_forever_karrz_0139_missing_quests.sql`, built from 31 Karrz world files:

- **Quests (47):** every row keyed on them: `quest_template`, `_addon`, `quest_objectives`, `quest_classic_level`,
  `quest_template_classic_level`, `quest_classic_money`, texts, creature and object starters and enders.
  - Duskwood Missions I-III and XIII-XVIII (81730-81732, 81742-81747), Hinterlands Missions I-III and XIII-XV
    (81786-81788, 81837-81839), Feralas Missions I-III, XIII, XV (81855-81857, 81868, 81871)
  - An Epic Ride (99210, 99211, 99214, 99215, 99217), Blessed Arcanite Barding 97183, The Divination Scryer 97184,
    Manna-Enriched Horse Feed 97186, Just Compensation 97412, Karolek 95820, Brawl at the Maul 99234
  - It Must Be Destroyed 78092, On the Lam 79235, Cherry for Your Thoughts? 79236, No Honor Among Thieves 79242,
    The Broken Hammer 79939, Best Laid Plans 80453, One Last Drop 80454, Some Good News 81762, The Mysterious Merchant
    81764, Wisdom of the Guardians 81924, Beach Bot 84135, Oi! 84318, In Memoriam 95615, Shroud of the Winter Wilds
    98462, Alcaz Prison 95483 and 96335
- **NPCs the PTR does not have (39):** templates, difficulty, models, classic levels and 75 spawns. The mission
  captains Field Captain Palandar 221471, Field Captain Korlian 221479 and 221480, their 33 targets (221171-221393,
  221928-221985), Tokal 215643, Aeonas the Vindicated 218160, Elrick 221575, Orthas 228619, Mason Connery 264770.
  `creature_model_info` for the 9 displays that had none (without it the spawn is dropped at load); Karrz's sizes,
  human-sized where he had none (display 119778).
- **Objects:** Spear of Mannoroth 409311, Half-Buried Mech 456682 and Access Hatch 456685 (templates and spawns),
  Dropped Pouch 423569 and Orthas's Hammer 461639 (templates, loot, spawns: the items of 79242 and 84318), a spawn for
  the Burned Memorial Candle 642517 (template already on the PTR).
- **Drops:** 216956 (79939) from the creatures Karrz lists.
- Zan Shivsproket 6777 gets the quest-giver flag (he ends 80453 and starts 80454, but was a vendor only).
- **Everlake fix, not Karrz:** the An Epic Ride versions for Night Elves (99214) and Tauren (99217) ask to talk to the
  sabers 276730-276732 and kodos 276876, 276877, 276879, which had no gossip flag (the other races' mounts have it).
  `HandleGossipHelloOpcode` needs `UNIT_NPC_FLAG_GOSSIP` before `TalkedToCreature`, so those objectives could never
  complete. They get `npcflag | 1`.

The Rogue Dead Drop chain, as Karrz wrote it:

- `sql/custom/world/2026_11_21_86_world_forever_rogue_dead_drop.sql` and `_87_..._heights.sql`: the payments 78307
  (Pyrewood Signet Ring) and 78699 (Ruby-Adorned Blade), the twins Gefell 211764 and Gemela 211765, the chests, the
  Graveyard benches (area triggers), the half-keys. Everything it adds was absent on the PTR. It also sets Veenix 4086's
  quest-giver flag and changes the Venture Co. Work Order 210187 drop on Venture Co. Deforester 3991 from 0.42% to a
  quest-only 20% plus a 100% rogue pickpocket. One change of ours: a DELETE before that pickpocket row (the loot tables
  have no primary key, so `INSERT IGNORE` added it again on every run).
- `src/server/scripts/Custom/Classic/world/classic_rogue_dead_drop.cpp` (unchanged) + loader line.
- Karrz marks as **ESTIMATED**: the twins' and chests' spots inside Shadowfang Keep and the Scarlet Monastery, the
  bench spots, the payment texts (his own words), the work order chances and 78699's experience.

## How the rows were picked

Karrz's statements were split and filtered by key: quest tables by quest id (objective deletes by objective id),
creature tables by the 39 new NPC entries, object tables by the 6 objects, loot by the quest items the PTR has no
source for. Spawns written as `INSERT ... SELECT ... WHERE NOT EXISTS` were taken whole after reading each one. Karrz's
deletes by guid range were left out; every insert is `INSERT IGNORE` instead, and the new guids (creature
47600010-47600479 and 48120078, gameobject 47500100-47501199) were free on the PTR.

Not taken: Karrz's `npcflag | 2` updates for NPCs that already have the flag on the PTR, `everlake_*` / `*_1121` files,
other quests' rows in the same files.

## Checked

- Every giver, ender and target of the 49 has a template and a spawn after this (PTR + these files).
- The objective items of 79939, 80453, 80454 and 95615 have no drop anywhere: they are the quests' start items, given
  on accept.
- All three SQL files run on a scratch MySQL 8.0 (stock world schema, the four classic tables and the PTR's
  `areatrigger_create_properties`), three times in a row with the same row counts.
- `clang++ -fsyntax-only` on `classic_rogue_dead_drop.cpp` and the loader: clean.
- **Not done:** worldserver start, any of these quests in game.
