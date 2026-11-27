# Karrz 0.1.38 merge

Merges Karrz1/TrinityCore `forever-bots` 8e679df0e1 (release 0.1.38, 2026-11-18) into `everlake`. Three commits after
4d331615c3 (0.1.37.6, already in through #91): right-click cosmetic appearance unlocks, starting-zone beast skinning
(Jay Oliver, Karrz PR #349), and the 0.1.38 bulk commit (Naxxramas bots, Scourge Invasion, AH market prices, class fixes,
bot pathing, quest and world data from 16-18 Nov). 166 files, +17,244 / -294.

0.1.37.4, .5 and 0.1.38.1 are launcher-only releases; nothing to port. 0.1.38 says the git branches match the release.

## Conflicts (11)

- `NOTICE.md`: ours (this fork's).
- `tests/game/ClassicGrindSpot.cpp`, `ClassicGroupFight.cpp`, `ClassicHealCover.cpp`, `ClassicHealScope.cpp`,
  `ClassicRaidHealSlots.cpp`, `ClassicScenarioMonitor.cpp`: Karrz tests we do not carry (dropped in the 0.1.37 merge,
  `karrz-0137.md`); kept deleted.
- RBAC: both sides added a player command. Karrz `.bug` = 1001 (`RBAC_PERM_COMMAND_BUG`), ours `.battletag` = 1002.
  No clash: both kept in `RBAC.h` and `sql/base/auth_database.sql`; both custom auth files apply as they are. Our
  `2026_11_18_00_auth_command_battletag.sql` comment still says 1001 is Trixx34's `.module`; left as is, since editing an
  applied update file changes its hash.
- `worldserver.conf.dist`: both blocks kept (our `Classic.FirstTagOwnsMob`, Karrz's `Classic.ScourgeInvasion*`).
- `classic_talents_mage_shaman.cpp`, Missile Barrage: **Karrz's** version. Both sides fixed the same bug (the halved
  Arcane Missiles channel and its 0.5 s missiles) in different ways. Karrz's comes with
  `2026_11_17_17_world_classic_missile_barrage_missiles_faster.sql`, which moves the 400589 proc to the hit phase so the
  buff is still up when the channel takes its length. Our version halved the duration itself at cast time; with that SQL
  the channel would be halved twice. Our `classic_spell_mage_arcane_missiles_barrage_aura` class goes; the script name in
  `spell_script_names` is the same on both sides.

## Checked

- `docs/everlake-changes.md` hooks still there (`ItemStackSize::Apply`, `GetStockMaxStackSize`, `StackSize.Enable`).
- New SQL (39 world/hotfix/auth files + 2 playerbot_v2): nothing touches `creature_classic_melee` / `classic_spell_info`,
  rebinds Windfury / Flametongue, or touches spawn groups; no table-wide deletes. Three targeted `smart_scripts` deletes
  (Ulag / Ancient Leaf summons, Morridune, Counterattack). Scourge Invasion guids 29000001-29005000 (creatures) and
  35170001-35175000 (objects) do not collide with world data (Forge guids are 900000000+); the event is off by default
  (`Classic.ScourgeInvasion = 0`).
- Quest text: 0.1.38 adds none (only rewards, races, XP difficulty, `quest_v2`, one objective).
- Duplicate `#include` lines in five PlayerbotV2 files are on both sides already, not from this merge.
- Local `clang++ -fsyntax-only` (with `TRINITY_PLAYERBOT_V2` and `DT_VIRTUAL_QUERYFILTER`) on all 89 changed `.cpp`
  files: clean.
- **Build, link and tests: this PR's CI.** No scratch database run, no worldserver start, nothing in game.
