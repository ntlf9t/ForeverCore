# Karrz 0.1.35 gaps: what #45 recorded as merged but did not take

**Source:** Karrz1/TrinityCore `forever-bots` `9fe2e33df0`, the merge parent #45 gave `everlake`. #45 built its tree from the
0.1.35 release zip (core: `f63ffc12b3..karrz-v0.1.35`; bots, scripts, SQL: `karrz-v0.1.34..karrz-v0.1.35`), so Karrz code that was
in his git at `9fe2e33df0` but missed by the earlier batches, or that only his git has, never reached `everlake`. Git now treats
it as dropped on purpose: a later Karrz merge will not show it as a conflict. #47 found two cases (adventurer camp Boosted Rest,
restored there; the Eclipse cast time modifier). This audit looks for the rest.
**Base:** #47's branch `claude/karrz-git-1112` (`dbba638449`); #47 merged into `everlake` as `8f857617ae` while this was built.
**Verdict:** 14 gaps restored, 4 left out with a reason written down here; everything else that differs is already recorded.

## How it was checked

- Every file Karrz changed between `f63ffc12b3` (advocaite `forever`, his base) and `9fe2e33df0`: 2,219 files after leaving out
  `tests/`, `tools/`, `repack/`, `scripts/`, `sql/old`, `.github` and the top-level `README.md`, as every Karrz batch does.
- For each file: the lines of `9fe2e33df0` that are not in our tree and that Karrz wrote (not already in `f63ffc12b3`), and lines
  Karrz removed that we still have. Whitespace and line endings ignored. Each block is tagged with whether the 0.1.35 zip has the
  same lines (release) or only his git has them (git only). Lines we added or changed ourselves where Karrz wrote nothing are
  not gaps and are not listed.
- A three-way merge of `9fe2e33df0` onto the branch (base `f63ffc12b3`) as a cross-check: 158 files conflict, nearly all where the
  zip is newer than his git (bot hiring, arena) or where his git rewrote comments.
- Result: 190 files with Karrz lines missing, 228 blocks, plus 254 world editor files. Every block was read and sorted below.

## Restored here

| What | Files | Why it was missing |
|---|---|---|
| **Eclipse cast time modifier** (Starfire tooltip shows the shorter cast while Eclipse is up) | `classic_talents_warlock_druid.cpp` | In both zips; the scripts batch took an older copy. #47 saw it. |
| **`EMBED_BUILD_PATHS`** (`-DEMBED_BUILD_PATHS=0` keeps the build machine's folders out of the programs; MSVC release builds trim them) | `cmake/options.cmake`, `cmake/genrev.cmake`, `src/genrev/CMakeLists.txt`, `revision_data.h.in.cmake`, `cmake/compiler/msvc/settings.cmake` | Karrz's 0.1.34 sync (`ff699fb5cf`); #45 took no CMake files. Default 1: same as before. |
| **Map extractor fails on a broken client**: counts tiles it could not convert, exits 2 when an Eastern Kingdoms or Kalimdor tile is missing (a client still downloading), 1 when nothing could be read | `src/tools/map_extractor/System.cpp` | Same. Our CI warning fix in `ConvertADT` kept. |
| **`mmap_probe --crumbs`**: the whole Detour route sampled every N yards (dungeon route waypoints) | `src/tools/mmap_probe/mmap_probe.cpp` | Same. |
| **`walk_link_check`, `dungeon_reach_check`** (navigation checkers; built with `-DTOOLS=1`) | `src/tools/walk_link_check/`, `src/tools/dungeon_reach_check/`, `src/tools/CMakeLists.txt` | Same. |
| **World editor** (Qt 6 desktop editor for maps, navmesh, SmartAI) | `src/tools/world_editor/` (254 files) | Never taken. Karrz does not add it to any `CMakeLists.txt`, so it is not built here either. |
| **`Instance.MoltenCoreRagnarosReady`** in the config and the options page (the code was already here) | `worldserver.conf.dist`, `doc/OptionalServerOptions.md` | Git only. |
| **Classic aura exclusivity** (see "Changes players will notice") | `sql/updates/world/master/2026_10_26_55_world_classic_aura_exclusivity.sql` | From the 0.1.34 sync, in both zips. The data batches looked at `sql/custom` only, so Karrz's `sql/updates/*/master` files were never considered. |
| **Elwynn Road to Sentinel Hill**, 37 traced road segments | `sql/updates/world/master/2026_10_17_00_world.sql` | Same. See the note below: the rows are not read yet. |
| **Comments in Karrz's public wording**: his git names him "Karrz" where the zip uses his first name | 31 files in `src/modules/PlayerbotV2` (49 lines, 7 of them in zip-only hiring and arena text), `sql/playerbot_v2/0019_bot_texts.sql`, `ChaseMovementGenerator.cpp`, `FollowMovementGenerator.cpp`, dates in three `Spell.cpp` and one `Unit.cpp` comment | Git only (his "Comments: Karrz, as in the rest of the public code"). Bot migrations are tracked by version number, not by hash, so `0019` does not run again. |
| **Docs**: `doc/Classic70532.md`, `doc/ForeverSetup.md`, `doc/UPSTREAM.md`, `doc/class-audit-2026-10-08.md`, `doc/classic-70291-protocol.md`, `doc/classic70532/`, `doc/dungeon_tactics/` (14 files), `doc/ahbot/README.md` (crafted minimum stock and value curve presets, both in our code), `INSTALL-BOTS.md` (the client folder is `_forever_`), `NOTICE.md` (ike3 link) | | Never taken. |
| **Example and setup files**: `support_site.example.json` (placeholder certificate paths; ours still had a personal Windows path), `CascDecrypt.cpp` key comments (same keys), `.gitignore` (makes no tracked file ignored), `.gitmodules` (empty), `build-playerbot.sh`, `check-playerbot-syntax.sh`, `config/my.ini.template`, `sql/custom/apply_mysql_config.ps1`, `sql/custom/corpse_table_deadlock_optimization.sql`, `sql/custom/mysql_deadlock_prevention.cnf` | | Never taken. The two SQL files sit outside every updater folder: run by hand only. |
| **`sql/reserve/`** (`forever-launch`, `full-forever`): switches to live Forever values, run by hand only | 14 files | Never taken. Nothing applies them. |

## Left out on purpose (decided here)

- **`sql/updates/auth/master/2026_10_08_00_auth_player_summon.sql`**: gives the Player role (195) the `.summon` command (528). Its
  comment says the handler lets players summon only their own bots (`cs_misc.cpp` -> `PlayerbotV2TrySummon`), but that handler
  is in neither Karrz's git at `9fe2e33df0`, his 0.1.35 zip nor here. `HandleSummonCommand` would let every player pull any
  online player to themselves. Not taken; worth telling Karrz.
- **`2026_10_26_53` (Obsidian Eradicator, Mana Fiend), `2026_10_26_54` (boss mechanics), `2026_10_26_56` (Touch of the Grave)**:
  their rows are already here through advocaite#310's `2026_11_06_00_..._boss_and_undead_rows` (see `advocaite-310.md`).
- **`CONTRIBUTING.md`, `pull_request_template.md`**: Karrz's contributor rules for his project. Same call as #47 made for his
  `README.md`: this fork keeps its own.
- **SQL files where Karrz changed only comments** ("AnoCore v10" -> "the other Forever server" in 7 trainer and NPC files, the
  AnoCore credit lines in `2026_11_02_29`, comment wording in the 70634/70658/70840 auth files and the 70840 TACT key file):
  karrz-data-1a's rule, a new hash makes the updater run the file again.

## Already recorded (no change)

| Difference | Where it is recorded |
|---|---|
| `Unit::UpdateSpeed`; falling out of the world (`MovementHandler`); `Map` encounter check; talent rate (`TraitMgr`); bot battleground lookups (`BattlegroundMgr.h`, `PlayerbotV2.cpp`, `BotPopulationManager.cpp`, `BotQueueFiller.cpp`, `BotInspector.cpp`); `Trinity::VendorPrice` (`Player.cpp`); `RenownProgress::Walk`; `Mail::SplitRecipient`; `IsGuildRankSetValid`; full-name `CHAR_SEL_FREE_NAME` and rename (`CharacterDatabase.cpp`, `CharacterHandler.cpp`); `CanUseBank` (`ItemHandler.cpp`); aura 557; `IsCastToTeach` (`Trainer.cpp`) | `karrz-0135.md`, Kept ours |
| Debug logs left out or lowered: warrior combo points (`Unit.cpp`), `[missile]` and `[certain_crit]` (`Spell.cpp`), `[addon_targeted]`; `GetCrtZoneOffsetAt` Windows-only (`Timezone.cpp`); `2026_11_11_01/02` dropped | `karrz-0135.md`, Fixed after the merge |
| Zip newer than his git: bot hiring, Mak'gora and the arena queue (`PlayerbotAPI.cpp`, `ArenaScript.cpp`, `State_Idle.cpp`, `BotSnapshot*.{h,cpp}`, `cs_playerbot_v2.cpp`, `LfgBotFill.h`, the add-on's Lua, `BOT_COMMANDS.md`), `BotGroupBuilder` reasons | `karrz-0135.md`, Release-only |
| Karrz commits after `9fe2e33df0`: Banes (`SpellInfo.cpp`), water bed (`PathGenerator.cpp`), camp sitting (`MiscHandler.cpp`), channel and guild lines per reader (`BotLanguage.*`, `BotIntentExecutor.cpp`, `PlayerbotAPI.cpp`, `BotLocale*`), cornered flee (`State_InCombat.cpp`), Zephras loot delete (`2026_11_11_10`), Linux data extraction (`doc/LinuxServerSetup.md`) | `karrz-git-2026-11-12.md` |
| `Playerbot.World.Pvp.Enable = 1` | `karrz-bots-0134.md` (owner decision 2026-11-10) |
| Auth and characters files, realm 70-73 build rows, `spell_duration_per_level` and 70790 TACT key duplicates, quest 5727, Resupplying the Excavation, `classic_spell_values` / `spell_twins` / `creature_melee` / `spell_info` | `karrz-data-1a.md`, `karrz-data-1b.md` |
| Warrior Overpower / Execute probes | `karrz-scripts.md` |
| `IsAutoShot()` | `trinitycore-7b7de79d54.md` |
| `GR_RIGHT_LEAVE` on new guild ranks | `trinitycore-3283d1a87b.md` |
| `InitialPhaseShift` in `CreateGameObject` (Arathi Basin, Warsong Gulch, herb twins) | `trinitycore-39609ed894.md` |
| Aura 217 / 319 names (`SpellInfo.cpp`) | `trinitycore-e3916b2adc.md` |
| `Item::GetRetailSellPrice` | `advocaite-283.md` |
| `TranslateClientOpcodeForBuild`, the `bnetserver.conf.dist` build example | `advocaite-274.md` |
| `Playerbot.AccountPrefix` (`BotAccountMgr.cpp`), bot surnames (`BotCharacterFactory.cpp`) | fork PR #4; full-name commits `4ed828c61d`, `f284a158cf` |
| Signed/unsigned casts and unused-code markers for `-Werror` (`BattlegroundMgr.cpp`, `battleground_alterac_valley.cpp`, `TokenHandler.cpp`, `AdtTextureReader.cpp`, `road_*.cpp`, `mmaps_generator/PathGenerator.cpp`, `map_extractor` `ConvertADT`) | our CI fixes `393f51e632`, `bd0b497852`, `9194ca1a27`, scripts batch |
| `Item.cpp` `GetSpellChargesSlotForEffect` not static | TrinityCore `bff7ac4eea` |
| Comments only: `SharedDefines.h` level cap, `DB2Structure.h` `DurationPerLevel`, `BotLanguage.h`, `BotLocaleRu.cpp` | ours, wording only |

## Changes players will notice

- **Buffs and debuffs stop stacking where Classic did not let them** (`2026_10_26_55`, checked by Karrz against VMaNGOS): two
  casters' ranks of the same buff or debuff no longer both stay on a target. 127 spell groups: the stronger one stays (Power Word:
  Fortitude, Blessings, Sunder Armor and Expose Armor, Demoralizing Shout and Roar, Polymorph, Frost Nova and more), or the newer
  one for exclusive effects. Over-time heals and damage are left out: different casters' Renew, Rejuvenation and DoTs still stack.
  Six more food buffs join Well Fed (group 1001). Vanilla elixirs leave the Battle and Guardian elixir groups (1 and 2), so they
  stack with each other as in Classic Era; the four flasks stay in them, one flask at a time.
- **Molten Core:** `Instance.MoltenCoreRagnarosReady = 0` is now written in `worldserver.conf.dist`. A realm that builds its
  config from the dist file and has `Instance.MoltenCoreSkipRunes = 1` used to get Ragnaros ready too (the option followed
  SkipRunes when missing); with the line present it needs `Instance.MoltenCoreRagnarosReady = 1` as well.

## Fixed here on top of Karrz

- **Eclipse after a relog:** Karrz's buff script sets the modifier from `GetAmountAsInt()`, which `AuraEffect::CalculateAmount`
  multiplies by the stack count. A player who logs in with Eclipse at 2-4 stacks got 2-4 charges' worth off every Starfire until
  the buff ended. It now uses `GetBaseAmount()` (one charge), as his Starfire script does for other casters. Worth telling Karrz.

## Notes

- **Eclipse needs one look in game:** the server applies the modifier only if 408255 is a druid-family spell
  (`SpellInfo::IsAffectedBySpellMod` compares families); the client shows it in the tooltip either way. If 408255 is not druid
  family in the 70862/70888 data, players' Starfire would stay at 3.0 sec on the server while the tooltip says 2.5. PTR check:
  cast bar of Starfire with Eclipse up.
- **The Sentinel Hill road rows are not read.** `2026_10_17_00` creates `handcrafted_road` in the world database, but
  `HandcraftedRoadStorage` (ours and Karrz's) reads `<Playerbot.SharedDatabase>.handcrafted_road` (`playerbot` by default), which
  `sql/playerbot_shared/` already creates. The rows only count where the shared database is the world database. Taken as Karrz
  has it; putting the 37 segments into the shared playerbot data is a follow-up.
- The aura exclusivity spell ids were checked by Karrz on the 70532 client data; they were not checked here against 70862/70888.
  `SpellMgr` logs and skips a group row whose spell does not exist.
- Karrz's own tree has the `.summon` problem above.

## How it was checked

- **Build:** the #45/#47 build directory (Ubuntu 24.04, clang-17, Debug, `-DWITH_WARNINGS_AS_ERRORS=1 -DUSE_COREPCH=0
  -DUSE_SCRIPTPCH=0 -DSCRIPTS=dynamic -DBUILD_PLAYERBOT_V2=1 -DBUILD_TESTING=1`), incremental (2,314 steps): everything compiles and links.
- **Tools:** the same build with `-DTOOLS=1`: `mapextractor`, `mmap_probe` (usage now lists `--crumbs`), `walk_link_check` and
  `dungeon_reach_check` compile and link under `-Werror`. Not run on client data.
- **Tests:** all 198 test cases pass (37,293 assertions).
- **SQL:** `2026_10_26_55` and `2026_10_17_00` on a scratch MySQL 8.0 with the tables from `sql/base/dev/world_database.sql`,
  applied twice: no error; the second run changes nothing (560 `spell_group` rows, 127 stack rules, 37 road segments). Not run
  on a full world database: the deletes from groups 1, 2 and 1001 and the new groups were not checked against TDB's rows.
- **Review:** a reviewer subagent read the staged change: the 14 files taken whole are byte-identical to `9fe2e33df0` and
  dropped nothing of ours; the comment rewording touches comments only; nothing in this repo checks the map extractor's exit code;
  the `.summon` handler is missing in both trees; no private paths or keys added. It found the Eclipse relog problem (fixed above)
  and the family question (Notes).
- **Not checked:** worldserver start, anything in game, gcc and the sanitizers (this PR's CI), the world editor (needs Qt 6).
