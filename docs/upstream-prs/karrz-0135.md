# Karrz 0.1.35: core catch-up, bots, scripts and data

**Source:** Karrz1's WoW Forever Bots 0.1.35 (2026-11-12 00:23 UTC), imported as tag `karrz-v0.1.35` (6dae366c19) on branch
`karrz-releases` and checked against its zip with `contrib/karrz-import/verify.sh`. Merge parent: Karrz1/TrinityCore
`forever-bots` `9fe2e33df0` (2026-11-11 23:52 UTC), his last git commit before the release.
**Verdict:** taken, with the changes below.

## What it brings

- **Core, all of Karrz's changes since his base** (advocaite `forever` `f63ffc12b3`), not only 0.1.34 -> 0.1.35. The earlier
  Karrz batches (data 1a/1b, scripts, arena, bots) only took the core pieces they needed; this is the first time his whole
  core comes in. Highlights:
  - Hunters: Beast Training opens the pet training window, tamed beasts keep their abilities (`classic_pet_tame_spell`),
    pet untraining, Beast Lore, pet parking while flying and catch-up.
  - Classic combat: fractional swing rage (`ClassicRage`), Auto Shot wind-up that pauses while moving (`ClassicAutoShot`),
    spell level penalty inside the bonus coefficient, creature spell level scaling, periodic crits by the client's
    `SPELL_ATTR8_PERIODIC_CAN_CRIT` flag, Windfury and Flametongue Weapon procs (`ClassicWeaponImbue.h`), Blessing of
    Sacrifice split, Counterattack diminishing.
  - Legacy perks: Meticulous, Conquering Hero, second chance, Personal Banking (innkeeper bank).
  - World: flight points learned by visiting (new characters start with none, as on live), Darkmoon Faire dates, mining
    amount rate, group corpse loot for dungeon trash, Forever creature health and kill XP, dungeon kill XP
    `Rate.XP.DungeonKill` 1.8, quest log size setting (`Quests.LogSize`, 35), vendor option hidden for empty vendors.
  - Auction house and its bot: Karrz's whole AH bot (crafted stock, commodities, value curve, drop floor), deposit rate,
    replicate-scan cooldown, name-search folding.
  - Protocol: per-connection client build (`WorldSocket::_clientBuild`) with Karrz's 70755/70790 message tables (covers
    70862 and 70888 too), WowPacketParser-based client message numbers.
  - Server: `StatusServer` endpoint (off unless `StatusServer.Token` is set, 127.0.0.1 only), auto-restart reason, conf.d
    files loaded in name order, console output guarded against the readline prompt.
  - Bots in core: wait for a bot to log out before a character delete or login, bot path limits, bot exemptions.
- **Bots module, scripts, SQL:** `karrz-v0.1.34..karrz-v0.1.35` (those were already at 0.1.34):
  - Bots: raid callouts and banter, per-boss tactics, optional raid leader bot, Edge of Madness bosses, Hakkar,
    Nefarian (still being worked on upstream), fleeing bots fight back, Russian chat, "sell junk", owner tactics
    (`playerbot_v2/0039`).
  - Scripts: Blackwing Lair Nefarian (14 changes), Zul'Gurub Hakkar and Edge of Madness, The Drowned City and Krol'dok
    Stronghold scenarios, Shadowfang Keep Arugal's voidwalkers, Maraudon Zaetar's Spirit, Testing the Wells, Wrack, Devastate.
  - SQL: 59 world, 8 hotfix, 1 auth (`build_info` 70888), 1 bot file: Riverglades and Shen'dralas, Zephras Isle, EG Link quest
    texts and trainer prices (CC BY 4.0), player-cache items and ruRU texts, Blizzard's live pushes for 70888, quest fixes.
  - Three older Karrz characters files never taken: class quest spells taken off other classes, the "Cloaked Hood TEST" item
    bots wore, re-pricing old AH bot listings. All re-runnable.

Left out, as before: Karrz's tests (`tests/game`, never ported; a later batch), `tools/`, `repack/`, `scripts/` (Windows
repack), the warrior probe SQL, and his realm-specific auth rows.

## Merge decisions

Core: `git diff f63ffc12b3 karrz-v0.1.35` applied three-way onto `everlake`; bots/scripts/SQL: `karrz-v0.1.34..karrz-v0.1.35`.
72 files had conflicts (about 180 blocks), resolved with one rule set: one copy of each change; Karrz's newer version unless
ours carries an extra fix (TrinityCore cherry-pick, crash fix, our own); ours where we decided otherwise. Most conflicts were
the same Karrz change on both sides, because `everlake` already had older versions of it from advocaite pull requests.

Kept ours:
- `Unit::UpdateSpeed` whole: multiplicative custom speed bonuses (ours already had Karrz's ghost speed, pet catch-up, slow switch).
- Falling out of the world kills in combat or in an instance (`MovementHandler`, our #285), not always the graveyard.
- `Map` encounter check from TrinityCore #31980 (Karrz's `IsRaid()` condition would undo it).
- Talent rate: our `ScaleClassicTalentLevelPoints` keeps Legacy perk "Talented" rows unscaled (advocaite#150 fix).
- Bot battleground lookups (`GetAllBGFreeSlotQueues`, `FindBattlegroundByInstanceId`, TrinityCore e5c9acdf34).
- Tested helpers doing what Karrz inlines: `Trinity::VendorPrice`, `RenownProgress::Walk`, `Mail::SplitRecipient`,
  `IsGuildRankSetValid`; full-name (name + surname) uniqueness in `CHAR_SEL_FREE_NAME`; `CanUseBank` in `BankHandler.cpp`
  (TrinityCore moved it), with Karrz's Personal Banking added there.
- `SmartAI` follow credit guard, `SpellAuraEffects` aura 557 on our `HandleModRangedHasteNoRegen`, the bot trainer kit
  uses `IsCastToTeach()` (advocaite#113; Karrz's own branch took #113 right after this release, a44321634b).

Taken from Karrz where both changed: the AH bot and `AuctionHouseMgr` whole (our `537e2073bb` was his older version; his
replicate-scan cooldown replaces our 60 s restart from advocaite#322), `PathGenerator` whole, the classic message tables,
`BattlegroundQueue` invite reminder by `bg->GetTypeID()` (ours was wrong for random battlegrounds), `normalizePlayerName`
keeping the first word (1.60.1 "Name Surname" client).

Fixed after the merge:
- Two blocks came out twice: `WorldSocket.h` members, `PathGenerator::RemoveNearCoincidentPathPoints`,
  `ChaseMovementGenerator::GetNoPathStreak` (ours from fork PR #38 and Karrz's), the faction-change cache update.
- Linux build: `GetCrtZoneOffsetAt` is Windows-only (unused-function error under `-Werror`), `classic_boss_nefarian.cpp`
  needs `Log.h`. Karrz builds on Windows with the precompiled header, so neither shows there.
- **Shaman imbues proced twice:** Karrz now casts Windfury and Flametongue in `Player::CastItemCombatSpell`; our
  advocaite#325 scripts on the same dummy auras would fire a second time. Same rule as `2026_11_09_60`: Karrz's code owns
  what it implements; `2026_11_12_50_world_karrz_0135_imbue_owner` takes the two #325 bindings off (scripts stay, unbound).
- Personal Banking: the innkeeper bank works only with the innkeeper it was opened from (the gossip path checks the
  perk's cooldown; any innkeeper would skip it).
- Debug logging: Karrz's test-night logs stay (they go to `Playerbot.log` at INFO), except where they cost on hot paths:
  `Loot::LogTable` returns before building its item list when nobody logs it, `[certain_crit]` is checked before its mutex,
  `[addon_targeted]`'s raw hex dump moved to DEBUG. Left out: the `[missile]` projectile log and the warrior combo-point log.
- Dropped `2026_11_11_01/02`: byte copies of our own `2026_11_08_01/02` (Karrz took our fix), which only made the updater warn.

Release-only (in the 0.1.35 zip, not in Karrz's git at `9fe2e33df0`): bot hiring (`Fleet/Hire*`, hire broker SQL,
`0037_hired_bots`, `ForeverBots_Hire.lua`), arena pieces (Ring of Law script and hotfixes, Mak'gora, "All Arenas" start),
`seed_headless_account`, and smaller edits in about 50 bot files. This PR takes the zip, so they are in; the merge parent only
tells git which Karrz commits are now merged.

## Changes players will notice (Karrz defaults, now on)

- Damage and healing over time can crit where the client data says so (Corruption, Shadow Word: Pain, Immolate...).
- Dungeon kill XP x1.8 (was x1.2). Grouped dungeon trash uses the group's loot method.
- New characters learn flight points by visiting them (existing characters keep theirs).
- Open-world respawn 50/70/85% of normal at levels 1-10/11-20/21-30 (`Classic.Respawn.*`). Everlake also sets
  `Respawn.DynamicMode 1`: the two multiply. Decide in the Everlake pin.
- Creatures get up to +20% health towards level 60 (`Classic.CreatureHealth.*`, raids excluded).
- Auto Shot has its wind-up and pauses while moving. Hunters train pets through Beast Training.
- AH bot buys commodities (`Buyer.Commodities = 1`) and player listings above the drop floor; a full replicate scan waits the
  whole `Auction.ReplicateItemsCooldown`.
- Bots talk in raid chat (`Playerbot.Raid.Callouts`, `Playerbot.Raid.Banter` default 1).
- New bags are no longer equipped automatically for players.

## How it was checked

- **Build:** Ubuntu 24.04, clang-17, `-DWITH_WARNINGS_AS_ERRORS=1 -DUSE_COREPCH=0 -DUSE_SCRIPTPCH=0 -DSCRIPTS=dynamic
  -DBUILD_PLAYERBOT_V2=1 -DBUILD_TESTING=1`: everything compiles and links (worldserver, bnetserver, all script libraries,
  tests). gcc and the sanitizers: this PR's CI.
- **Tests:** all 198 test cases pass (37,293 assertions), including `ClassicOpcodeNumbers`, `ClassicTalentRate`, `FullName`,
  `VendorPrice`.
- **Review:** two reviewers, one on the 72 hand-resolved files against base/ours/Karrz, one on the 64 core files that merged
  without conflicts plus the bot module delta. Found the double imbue proc, the banking cooldown bypass, the duplicated
  cache update and the hot-path logs (all fixed above); no item duplication, crash or lifetime problem. Checked and fine:
  the client message tables give the same numbers as ours for 70790 and later (70862, 70888); new SmartAI event 91 /
  action 160 / condition 61 fully wired; `StatusServer` thread safety; no feature applied twice (rage, Overpower, transmog
  outfits, appearances). Gossip options that now cast item-creating spells: the three in the data (Executor Zygand's
  reports) require the quest and no report in the bags.
- **Pet training to test in game:** buying a pet training rank teaches the hunter (advocaite#113), while Karrz's trainer
  checks whether the pet knows the previous rank. Karrz's own branch has the same combination since a44321634b.

### SQL (scratch MySQL)
Scratch MySQL 8.0 (Docker, no published ports): TDB `TDB_full_forever_2026_10_14` + every update the realm has (`origin/everlake`
624386b `sql/updates` + `sql/custom`, world data `cb7c927` (the PTR pin in `docker-compose.ptr.yml`; `.env.example` leaves the live
pin empty), Everlake's own SQL as the Dockerfile copies it: `2026_11_08_06` auth, `2026_11_08_07/08` hotfixes,
`2026_11_09_00` world). Applied like the updater (file-name order, skip what `updates` lists, a file whose hash is already
applied under another name is applied again only while that other file still exists): 784 world, 38 hotfix, 33 auth and 13
characters files, no error. Then this batch: the 69 files of `karrz-v0.1.34..karrz-v0.1.35 -- sql`, byte-identical in the
branch. The three characters files and `2026_11_12_50` were added afterwards and run
on the same database twice: no error; 436519/439431 have no script left.

- All 59 world, 8 hotfix and 1 auth files apply with no error; `playerbot_v2/0039_owner_tactics` too (on a characters
  database with `playerbot_v2_schema_version`, run as plain SQL; it has no `@target`, so it goes to characters).
- `2026_11_11_01/02` (byte copies of our `2026_11_08_01/02`) were in the test and changed nothing; they are dropped from
  this branch.
- Applied a second time (updater re-run): no error. Three tables still move:
  - `creature_loot_template` +17. `2026_11_11_10_world_forever_live_sniff_zephras_1110c` section 11 uses `INSERT IGNORE`,
    but the table has no unique key, so every run adds the same 17 Zephras drop rows again (entries 250926, 250937, 251143,
    251145, 251160, 251169, 251448). A third run adds 17 more. The first run makes no duplicates, and the live updater and a
    fresh build each run the file once. The file still says "safe to run again", and it isn't.
  - `creature_template_locale` +12, `gameobject_template_locale` +42 (all ruRU). The ruRU text files
    (`2026_11_10_41/44_..._player_cache_ruru_texts_3/4`) run before the files that create those templates (Drowned City,
    Kroldok and other `2026_11_11_*` NPCs and objects). On the first run they find nothing to name. Only a re-run names
    them, so a fresh build and the live realm both end without these 54 ruRU names. Cosmetic.
  - Nothing else moved on the second or third run (hotfixes, auth and characters do not change; the playerbot file only
    touches `applied_at`).
- Build order: our own files were run again on top: the 24 custom world files that are ours and not Karrz's (including
  the five fix-ups `2026_11_09_50` keep-ours, `2026_11_09_60/61`, `2026_11_09_79`, `2026_11_10_50`), all 257 world-data files,
  Everlake's world file, our 4 custom hotfix files, Everlake's 2 hotfix files, and our 4 auth files plus Everlake's.
  - Of the rows this batch touches, they change back exactly one. Avala (276009) `HealthModifier`: our
    `2026_10_24_00_world_classic_misty_pine_refuge_quests` sets 2, but Karrz's `2026_11_05_99` (already in the base) resets
    the row to 1. This batch's `2026_11_09_47_world_forever_health_modifiers_live` (only rows still at 1) then makes it 1.5.
    Our 2 was already lost before this batch. A fresh build and the live realm both end at 1.5.
  - The fix-ups: nothing changes back. The 1a keep-ours `smart_scripts` owners, the proc-owner `spell_script_names`, the
    Stratholme gate script, the Zephras inn shape 1310002 / spawns 3-4, and 95984's cleared `PrevQuestID` (this batch still
    leaves 95983 out) are all untouched by the batch.
  - Other changes the re-run made (6 `creature_template`, 1 `smart_scripts`, 2 `conditions`, loot rows for 276003/276009,
    Oggleflint 11517, Bazzalan 11519, the three dwarf rifles 695222/695223/695277, 1 `spell_target_position`, `spawn_group`
    +151) are on rows this batch does not touch. They come from our own files being re-run over later base files, not from
    this batch. The +151 `spawn_group` rows are the exception: see below.
- Rows of ours this batch overwrites, matched against the world data's own record of what it added
  (`everlake_import_rows`) and every number in our files:
  - 8 quests the world data imported are now shipped by Karrz and replaced by Karrz's rows: 93786, 93788, 94483, 94532,
    94672, 95062, 95428, 97530. This replaces their template, objectives, starters/enders and texts. The world data adds a
    quest only while it is missing, so a fresh build (Karrz's file first) and the live realm (Karrz's file last) end the same.
  - Quest texts (`quest_offer_reward` / `quest_request_items`) of 25 + 45 quests from world-data slices 1, 7, 8, 9 and 12
    now carry Karrz's EG Link text.
  - `trainer_spell`: 812 rows get Karrz's EG Link prices (`2026_11_11_13`). That includes trainers our world data and
    alchemy/sandpaper files write, but re-running ours changes none of them back.
  - Nothing of ours in hotfixes or auth is overwritten. The 65 `hotfix_data`, 8 `item`/`item_sparse`, 21 `spell_name` and
    3 `spell_misc` rows deleted are Karrz's own earlier pushes being rewritten.
- Spawn groups: the batch deletes 14 spawns that Everlake's dynamic-respawn rule (`2026_11_09_00_world_dynamic_respawn`)
  had put in group 2: creature 46000035 and 46000041, and the 12 floating Flintfire crates 9518458-9518471. That leaves 14
  `spawn_group` rows without a spawn (0 -> 14; the worldserver logs and skips them). The rule ran once before the batch,
  so spawns that match it later are left out of a dynamic respawn group. Re-running the rule adds 151 rows. 101 of them
  are spawns this batch adds (47 creatures, 54 objects). The other 50 are older spawns, which either this batch's new quest
  objectives turned into targets or world-data files named after the rule added. This needs a new Everlake file that runs the rule again and removes rows whose spawn is gone.
- Script check: every new script name has a registration in the branch's `src` (and compiled). That covers 24
  names: the Kroldok and Drowned City bosses and instances, the Attack! event NPCs (1754, 1755, 7766, 8856, which now use
  C++ instead of SmartAI), Murkdeep, `classic_at_murloc_camp`, `classic_spell_quest_testing_the_wells`,
  `classic_spell_dru_not_from_shadowmeld`, `classic_spell_warl_wrack` and `spell_warr_devastate_rune_damage`. The new table
  `classic_pet_tame_spell` (381 rows) is read in `Pet.cpp`. Script names in use 5,473 -> 5,497, `spell_script_names` 4,898 ->
  4,908, templates with a ScriptName 2,969 -> 2,986, `SmartAI` NPCs without rows 367 -> 367. The 47 `smart_scripts` rows
  deleted are the Attack! NPCs' and three timed action lists (950000018, 950001106, 950001107) that nothing calls any more.
- `creature_classic_melee` and `classic_spell_info` stay empty (0 -> 0); the batch does not write either.
- Dangling references, before -> after (the same after our files are re-run on top): spawns without template 0 -> 0, quest
  starters/enders without NPC or object 0 -> 0, starters/enders without quest 22 -> 22, `PrevQuestID`/`NextQuestID` to a
  missing quest 0 -> 0, addon rows without quest 4 -> 4, objectives without quest 1 -> 1, monster objectives without NPC
  920 -> 920, `LootID` without loot 6,353 -> 6,353, loot to a missing reference 0 -> 0, stacked creature pairs (same entry,
  map and phase, under 1 yd) 426 -> 425, `creature_addon`/`pool_members` without spawn 0 -> 0, vendors and trainers without
  NPC or trainer 0 -> 0, graveyards without a safe location 4 -> 4, `spawn_group` without spawn 0 -> 14 (above).
  Hotfixes: duplicate `hotfix_data` keys 0 -> 0 (same table and record with Status 1 twice: 3 -> 3), items without
  `item_sparse` 0 -> 0, `item_sparse` without item 153 -> 153, Status 1 pushes without their item row 0 -> 0.
- Rows: creatures +263 (270 new, 7 deleted, 17 moved), objects +45 (57 new, 12 deleted), creature templates +57 (158
  changed), object templates +282, quests +19 (164 changed), objectives +23, quest texts 647 + 513 changed, creature loot
  +74, `trainer_spell` 812 prices changed, `classic_pet_tame_spell` +381 (new table); hotfixes `item`/`item_sparse` +588,
  `spell_name` +166, `hotfix_blob` +166, `hotfix_data` +1,938; auth `build_info` +1 (70888); characters
  `playerbot_v2_owner_tactics` (new, empty).
- Not checked: a worldserver start on this data (`DBErrors.log`: expect the 14 spawn-group lines); DB2 references (spell, map, item ids against the
  70888/70862 client data); playerbot 0039 through `PlayerbotMigrationMgr` on a full 0001-0038 characters database; the
  live realm's own `WORLD_DATA_COMMIT` (this used the PTR pin `cb7c927`); anything in game.
