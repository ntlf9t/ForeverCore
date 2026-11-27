# Karrz 0.1.36: client 70938, quest and class fixes, bots, world data

**Source:** Karrz1's WoW Forever Bots 0.1.36 (published 2026-11-13 21:47 UTC), source zip sha256
`1e92c3d84833b5500695255a83e92971d167fe5c906393ad2d973a086f4f522d`, imported as tag `karrz-v0.1.36` (441114b453) on branch
`karrz-releases` and checked against its zip with `contrib/karrz-import/verify.sh` ("OK"). `UPSTREAM_PIN` unchanged
(`f63ffc12b3`). Merge parent: Karrz1/TrinityCore `forever-bots` `0da7e58472` (2026-11-13 20:07 UTC), his last git commit before
the release.
**Verdict:** taken, with the changes below.

## Karrz git and the release are not the same

Since #47 (`063c74ab24`) Karrz's git has **one** new commit: `0da7e58472`, which takes the hired bot calls out of
`cs_playerbot_v2.cpp` so the public module builds without the hire code. Everything else in 0.1.36 is only in the zip. The zip
against his git head, whitespace and line endings ignored, `sql/old`, `.github`, `repack/`, `scripts/`, `tools/` left out: 130
files only in the zip, 145 that differ, 5 only in git. So this is again a release import: the merge parent tells git that
`0da7e58472` is merged, the tree is `git diff karrz-v0.1.35 karrz-v0.1.36` applied three-way onto `everlake`.

That delta is 236 files (+19,650 / -375). 30 of them were already the same in `everlake` (they came in with #47, the 37 commits
after 0.1.35), 19 are in folders we never carry, 4 SQL files stay out, and 4 files are kept as ours. This PR changes 168 files
(+13,803 / -396) outside `docs/`.

## What it brings

- **Client 1.60.1.70938** (Battle.net update of 13 November): `build_info` row (`2026_11_13_70` auth), Blizzard's live hotfix
  pushes 114002-114051 for 70888 and 70938 and the values 70938 has built in (`2026_11_12_52`, `2026_11_13_50/51` hotfixes),
  29 more player-cache items, 31 NPC lines, bear form NPCs no longer a black shape. 70938 clients get the 70790 message numbers,
  as 70862 and 70888 do. No auth key is known for 70938.
- **Core:**
  - On-next-swing abilities (Heroic Strike, Raptor Strike, Maul, Cleave) send the attacker state the live server sends, so the
    client's swing timer keeps running (`Spell::SendNextMeleeSwingAttackerState`).
  - Revive (437138) no longer hits an assert: corpse target types give an explicit target mask (`SpellInfo.cpp`).
  - Guild charters keep the whole guild name (`PetitionBuy` reads the title length with 8 bits).
  - Transmog outfits with every slot are saved (the packet accepts 45 slots, was 30).
  - Quest items sold or destroyed no longer stay counted: the `QUEST_OBJECTIVE_FLAG_PRESERVE_QUEST_ITEMS` exceptions in
    `Player::AdjustQuestObjectiveProgress` and `ItemRemovedQuestCheck` are gone.
  - A spawn can have its own level range (`creature_classic_level_spawn`, new table, read after the spawns): creatures Forever
    placed in a second zone at another level (Rabid Longtooth in the Whispering Forest).
  - Talent configs that lose ranks in the check at login, or are not made active, are logged (`[talent_login]`).
  - DB2 tables with sections locked by an unknown TACT key are named at start-up. `RealmList::Close` stops the update timer
    from being armed again. AH bot: `AuctionHouseBot.Vanilla.ValueCurve.FullValueItemLevel` (default 0, off).
- **Scripts:** Razorfen Downs gong unlocks after each wave, Zul'Gurub logs what High Priest Thekal's trio is doing when one
  evades or stays down beside a standing partner (diagnosis only), Hoof-Shaped Foot Pedal
  (centaur form, speed only in Desolace), Arcane Blast stacks, four "chance on ability" talents roll their chance
  (`classic_spell_talent_ability_proc_chance`).
- **World data, 54 files:** Defias Traitor escort, Counterattack!, One Shot. One Kill., Bashal'Aran, Bitter Rivals, Tome of
  Divinity, The Sleeper Has Awakened, Lost in the Shadows, Remember That I Love You, Crest of Lordaeron by faction; first riding
  mount quests of four races; Whitemane raises Mograine, Baron Rivendare does not evade on pull, the two Naxxramas items; Elwynn
  hunter and camping NPCs; spawns moved onto the ground (Riverglades, Westfall, Dun Morogh); Sergeant Bly and nine more scripted
  NPCs can be talked to; Jason Mathers and Innkeeper Karakul sell again; one Whispering Horror; Ghost Wolf is spell 1238640 (with
  a characters file that moves players' 2645 to it); Well Fed buffs replace each other; Seal of Fury hits once; live captures of
  Zephras Isle and Teldrassil; EG Link quest data and live rows; Questie givers and **quest order** (see "Changes players will
  notice"); marker fixes in 119 Russian and the Spanish, German, French and Chinese quest texts; model info for the new dungeons'
  creatures (The Drowned City and Krol'dok Stronghold bosses spawn).
- **Bots (77 files):** Nefarian and other raid tactics, bot dungeon scripts for City of Dalaran, The Drowned City, the
  Excavation Site and Krol'dok Stronghold, "change talents <Wowhead link>" for an owner's companion (`playerbot_v2/0040`,
  `Api/TalentCode.h`), `.bot goto <name>`, gathering again, healers keep mana, outgrown soulbound gear is sold, world bots leave
  rare beasts to hunters, fewer two-state flips, `.playerbot selftest` console checks (`cs_selftest.cpp`, GM only) and more
  probes.

## Merge decisions

Conflicts: 5 files. Everything else applied cleanly; every auto-merged file was compared with both sides (see "How it was
checked").

Kept ours:
- `Trainer.cpp` / `Trainer.h`: the release now has Karrz's copy of advocaite#113 (`Spell::TeachesPetAbility`, checked when a
  trainer spell is bought). `everlake` has the same behaviour as the tested helpers `IsPetTrainingSpell` / `IsCastToTeach`;
  same call as #47.
- `classic_spell_scripts.cpp`: no conflict, but the release adds Karrz's copy of advocaite#325
  (`classic_spell_sha_windfury_weapon`, `ClassicImbuedWeapon`, `classic_spell_proc_chance_from_effect`) to a file that already
  has them: the same classes twice, which does not compile. Left as ours; same call as #47.
- `sql/custom/world/2026_11_11_70_world_forever_tameable_beasts_live_70888.sql`: the zip differs from our copy (from his git) in
  one comment line. Karrz-data-1a's rule: a comment-only change is not taken, a new hash makes the updater run the file again.
- `cs_playerbot_v2.cpp`, against git only: `0da7e58472` removes the `Fleet::Hire` / `HireMgr` calls. We carry the hire code
  from the zips, so the zip's file stays (with its new probes; the three conflict blocks were ours plus Karrz's additions).
- Two comments name Karrz by his first name in the zip (`bot_bridge_models.txt`, `bot_bridge_ollama.py`); written "Karrz", as
  his git does (#52).

Taken from Karrz where both had a copy:
- `sql/custom/hotfixes/2026_11_12_50_hotfixes_forever_live_pushes_70888_c.sql`: the zip has a rebuilt file with more records
  (Seal of the Dawn, Rune of the Dawn, Bloody Claws of Attack, item effects and search names) than the copy from his git that
  #47 took. Its hash changes, so the updater runs it again; it deletes its own rows first.

Left out on purpose:
- `2026_10_25_01` / `2026_10_25_02` (advocaite#186, exploration objectives with made-up ids), `2026_10_26_07` (advocaite#180,
  Shadowvale elixir bottles) and `2026_11_12_02_world_classic_windfury_talent_proc_chances` (the SQL of Karrz's #325 copy):
  Karrz ships them in the zip now; #47 left the same four out of his git, and the reasons there still hold (#186's rows would
  block the live objectives of `2026_11_12_03`; #310's `2026_11_06_60` covers #180; `2026_11_12_02` would bind Windfury a second
  time and undo `2026_11_09_60`).
- `tests/game` (4 new, 3 changed), `tools/` (4), `repack/` (6), `scripts/` (2): not carried, as in every Karrz batch.

## Changes players will notice

- **Quest order** (`2026_11_13_86`, from Questie's traces of the live realm): the file lists a required earlier quest for 1,073
  quests, but only fills quests that have no link yet, and `everlake` already has most of them. On our data 58 quests gain a
  quest that must be done first, 4 more come with new rows, and 17 lose
  theirs because the earlier quest becomes an optional lead-in (40 `BreadcrumbForQuestId` rows: the lead-in is no longer offered
  once the quest it leads to is taken). 22 quests get their "any of these opens it" links.
- **Quest items** that are sold or destroyed no longer stay counted, for every quest (two core exceptions removed).
- **70938 clients** can log in once the realm accepts the build (see "After the merge"). Mounting works in Magram Front,
  Outcast Hideaway, Bristleback Retreat, Evenshade's Overlook, Forlorn Gardens and Valley of Bones.
- **Classes:** the swing timer keeps running after Heroic Strike, Raptor Strike, Maul and Cleave. Improved Hamstring, Improved
  Shield Bash, Improved Wing Clip and Improved Concussive Shot roll their talent chance (they fired on every hit). Seal of Fury
  hits once per swing (it hit twice). Arcane Blast stacks. Nature's Grace, Improved Enrage, shaman Clearcasting and Missile
  Barrage get proc rows. Ghost Wolf is spell 1238640: trainers teach it, and a characters file swaps 2645 for it on every
  character and action bar. Revive no longer crashes the server.
- **Buffs:** every aura named Well Fed is in the exclusive group 1001, so a second food replaces the first.
- **World:** Rabid Longtooth in the Whispering Forest is level 8-9 and Redrock Earth Spirit in Dun Morogh level 5-6 (they were
  level 47-48 and 1). Summoned quest mobs from the VMaNGOS conversion no longer vanish in the middle of a fight. One Whispering
  Horror in the Shadowvale crypt instead of nine.
- **Guild charters** keep the whole guild name. **Transmog** outfits with all slots save.
- **Bots:** sell soulbound gear they have outgrown (`Playerbot.Behavior.SellOutclassedGear = 1`), build talents by the talent
  frame's row rule (`Playerbot.ClassicTalents.RowsPerTab = 1`), and an owner can give a companion a build ("change talents
  <link>"). `Playerbot.Behavior.InvitePassingBots = 1` keeps what bots did before; 0 stops world bots inviting each other.

## Decisions worth a look

- **The quest item exception is gone** (`Player.cpp`). The two blocks Karrz removes came from advocaite#114 (dqhoang,
  `4fabfb430e`): an item objective flagged `QUEST_OBJECTIVE_FLAG_PRESERVE_QUEST_ITEMS` (0x20) kept its count when the item left
  the bags. That fixed Traditions of the Bluff (97485: using the Prepared Incense consumes it and the objective fell back to
  0/1), but it also kept every such objective counted after the item was sold or destroyed, which is the bug Karrz fixes. Taken
  as Karrz has it. 329 item objectives carry the flag on our data after this batch (338 before; 253 of them on quests with a
  Classic level). Nothing in the release replaces the fix for 97485, so that quest needs a PTR test; putting the two blocks back
  is the alternative.
- **`.bot goto <name>`** is open to every player: it takes the player to one of their own bots (not in combat, dead, in flight
  or across a battleground; same group for a dungeon). No cooldown and no cost, so it is free travel to wherever a companion
  stands. Karrz's choice; ours to keep or to put behind a permission.
- **`Playerbot.Behavior.SellOutclassedGear = 1`**: a bot sells (or, with no vendor near, destroys to make bag room) soulbound
  green and blue weapons and armor that its worn gear outscores for its current spec. An off-spec set a companion carries
  would go. Whether a player's own summoned alt runs these rules was not checked. Set 0 in the Everlake config to keep the old
  behaviour until that is known.

## Notes on Karrz's code (taken as is, for later or for Karrz)

- Failed transmog requests are now logged as errors on `entities.player.cheat` (were debug lines on `network`): a player who
  walks away from the transmogrifier writes one. Log noise, no behaviour change.
- `[talent_login]`: the second warning fires at each login of a character whose active talent config is empty while another
  saved one has talents. `Logger.entities.player.talents` is 4 in the dist config, so it shows.
- `OwnerRegistry` now reads `playerbot_v2_character.companion_talents`. Without migration `0040` the query fails and no owner is
  loaded (owned bots count as unowned). The bot module applies its migrations at start-up; the image has to ship
  `sql/playerbot_v2/`.
- "change talents <link>" does a database write and up to 250 ms of talent walk on the world thread per accepted order, with
  no rate limit. Only a bot's owner (or a group member of an unowned bot) can give it.
- `Playerbot.ClassicTalents.RowsPerTab = 1` walks every bot whose build breaks the row rule once after the first start.
- `2026_11_13_61` (the Teldrassil live captures) and `2026_11_13_91` (Everlake's rows) both write 11 vendor rows (Laird 4200's
  fish and three more vendors). `_91` runs last and deletes by NPC and item, so the live capture's rows (restock 900 s, build
  70888) are replaced by ours again (restock 3,600 s): those 11 end exactly as they were before this batch. Karrz's own realm
  ends the same way. The capture is the better witness; a later file of ours can take its values.
- `2026_11_13_87` adds a quest giver for quest 97921 and `2026_11_12_15` a turn-in for 96822; neither quest is in
  `quest_template` (the server logs and skips both rows).

## Fixed here on top of Karrz

- `Spell::SendNextMeleeSwingAttackerState` took a process-wide lock on every Heroic Strike, Cleave, Maul and Raptor Strike for
  a once-per-ability log line. It now does so only while `playerbot.v2` logs at INFO (the same guard #45 put on `[certain_crit]`).
- gcc build: `classic_instance_razorfen_downs.cpp` compared the wave number sent with `_gongWaves + 1` (a `uint8` promoted to
  `int`) against a `uint32`, an error under `-Werror=sign-compare`. Cast added. Karrz builds with MSVC, clang does not warn.

## How it was checked

- **Release against git:** zip sha256 matches the release's `SHA256SUMS.txt`; `verify.sh` says "OK" for the imported tag. The
  zip and `0da7e58472` compared file by file (numbers above).
- **Merge:** for each of the 217 files of the delta outside the folders we do not carry, the result was compared with
  `karrz-v0.1.36` and with `everlake` before the merge. 170 files are byte-identical to Karrz's, 4 are the SQL files left out.
  In the other 43, every line that differs from Karrz's file differed
  before the merge too (our earlier decisions), except the files listed under "Kept ours". Every line the delta adds is in the
  result, except in those files.
- **Review:** a reviewer subagent read the core, script and bot module changes against both sides: no block twice, no hunk in
  the wrong function, every new identifier declared in our tree, includes present for a build without precompiled headers, no
  Windows-only call; `cs_selftest.cpp` and the four bot dungeon scripts are in the build and registered. Its runtime notes are
  the "Decisions" and "Notes" above; it found the swing lock (fixed).
- **Build and tests:** this PR's CI (gcc-13, clang-17 with and without precompiled headers, AddressSanitizer,
  UndefinedBehaviorSanitizer, unit tests). No local build this time.

### SQL (scratch MySQL)

Scratch MySQL 8.0 (Docker, no published ports): `TDB_full_forever_2026_10_14` world and hotfixes, `sql/base` auth and
characters, then everything `everlake` has at `b5c98f7ad4` (`sql/updates` and `sql/custom`), the world data at `cb7c927` (257
files) and Everlake's own files as the Dockerfile copies them (3 world, 3 hotfixes, 1 auth), applied like the updater: file-name
order, skipping what `updates` lists. 862 world, 51 hotfix, 34 auth and 16 characters files, no error, no file name twice.
Then this batch: 54 world, 9 hotfix (8 new and the changed `2026_11_12_50`), 1 auth and 1 characters file.

- **All 65 files apply with no error. Applied a second time: no error and no table changes** (every table of the four databases
  compared by checksum and row count).
- **File names:** the 54 new world files keep Karrz's names. No name is used twice across `sql/custom/world`, the world data's
  `sql/world` and Everlake's world files. The release adds nothing to `sql/updates`: its 38 world files there are the ones we
  have, except the three #52 left out.
- **`2026_11_13_91_world_forever_everlake_data.sql`** is Everlake's own world data (`cb7c9278`) coming back through Karrz: 44
  quest givers and 8 turn-ins, 357 drops, 105 vendor items, each deleted by key and inserted again. On a database that has the
  world data, every one of those rows is already there with the same values: the file adds no row and nothing is applied twice.
  What it changes: the `Comment` of the 357 drop rows (ours name the item, Karrz's say "Everlake data: <source>"), and the 11
  vendor rows of the note above, back to what they were. The world data's own record of its rows (`everlake_import_rows`) is
  not touched. On a realm built without the world data the file brings those rows, so it stays in.
- **Rows the world data added** (`everlake_import_rows`) against the batch: none is removed. Changed: the four first riding
  mount quests (96989, 96994, 96996, 96997), which Karrz ships now (`2026_11_12_16` replaces their rows; the same quests, 13
  minor columns and the build stamp differ) with their 14 objectives; 9 item objectives lose flag 0x20 and get a NULL
  description (`2026_11_12_14`, EG Link); the reward display rows get a build stamp (233 rows, same spells); 307 of the drop
  comments above; one quest giver row's build stamp. Vendors, trainer spells, spawns, quest texts and quest links: unchanged.
- **Our own files run again on top** (the six fix-up files `2026_11_09_50/60/61_world_karrz_*`, `2026_11_09_79`,
  `2026_11_10_50`, `2026_11_12_50_world_karrz_0135_imbue_owner`, all 257 world-data files and Everlake's three world files),
  once on the database with the batch and once on a copy without it: with the batch they change 20 `spawn_group` rows and the
  same 4 `creature_template` rows they change without it. So the batch undoes none of our fix-ups and none of the world data.
  Everlake's three hotfix files run again change nothing.
- **Spawn groups:** the batch deletes 7 spawns (5 Whispering Horrors, 2 of Sentinel Lynessa Duskblossom) and takes 9 rows out of
  Everlake's dynamic respawn group 2, leaving no row without a spawn. Running Everlake's rule again adds 20 rows (4 creatures,
  16 objects, all older spawns that match the rule now).
- **Script names:** three new ones in the data (`classic_spell_hoof_shaped_foot_pedal`, `classic_spell_mage_arcane_blast`,
  `classic_spell_talent_ability_proc_chance`), each registered in `src/server/scripts`; none disappears. 436519 and 439431 stay
  without a script (the imbue owner rule holds). `creature_classic_melee` and `classic_spell_info` stay empty.
- **Dangling references, before -> after:** spawns without template 0 -> 0, starters/enders without NPC or object 0 -> 0,
  starters without quest 10 -> 11 and enders without quest 12 -> 13 (the two rows in the notes), `PrevQuestID` / `NextQuestID`
  to a missing quest 0 -> 0, a required quest that nobody and no item starts 4,501 -> 4,480 (none of the new links), addon rows
  without quest 4 -> 4, objectives without quest 1 -> 1, `spawn_group` / `creature_addon` / `pool_members` without spawn
  0 -> 0, vendors without NPC 0 -> 0, loot to a missing reference 0 -> 0, stacked creature pairs 425 -> 425,
  `creature_classic_level_spawn` rows without spawn 0 (new table, 19 rows).
- **Rows:** creatures -3 (4 new NPCs, 7 deleted, 62 moved; no guid reused for another entry), objects 0, creature templates
  +4, object templates +93, creature model info +60, quests 0 new, objectives +14, quest givers +40 and turn-ins +24, vendor
  items +34, creature loot +121, `smart_scripts` +33, `spell_proc` +9, `spell_group` +20, `spell_script_names` +10; hotfixes:
  `hotfix_data` +154, `item` / `item_sparse` +32, `broadcast_text` +31; auth `build_info` +1 (70938); characters: no rows on an
  empty database.
- **Bot migration:** `sql/playerbot_v2/0001` to `0040` as plain SQL on an empty database: `0040` adds
  `playerbot_v2_character.companion_talents` and records version 40 (nine older files need the characters tables or the
  module's placeholder and fail as plain SQL, as before). It is an `ALTER TABLE`: the module runs it once by version.
- **Not checked:** a worldserver start on this data, anything in game, DB2 references of the new rows against the 70938 client
  data, the characters file on a database with characters, the live realm's own data pin (this used `cb7c927`).

## After the merge (Everlake pin PR)

- Add 70938 to the builds the realm accepts (`ALSO_ACCEPT_BUILDS`); no auth key is known for it. bnetserver and worldserver
  read `build_info` at start-up only.
- `sql/custom/hotfixes/2026_11_12_50_hotfixes_forever_live_pushes_70888_c.sql` changed, so the updater runs it again and then
  every later custom hotfix file. The later ones are all new in this pin. No custom world file changed.
- Run the dynamic respawn rule again in a new Everlake file (20 rows).
- Decide `Playerbot.Behavior.SellOutclassedGear` and `.bot goto` (above), and test Traditions of the Bluff (97485) on the PTR.
- New config defaults otherwise change nothing (`AuctionHouseBot.Vanilla.ValueCurve.FullValueItemLevel = 0`,
  `Playerbot.Behavior.InvitePassingBots = 1`).
