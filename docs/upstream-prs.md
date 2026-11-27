# Upstream changes taken into `everlake`

Every change from advocaite's branches or TrinityCore that goes into `everlake`, with what it claims, how it was
checked, and the verdict. Plan: `docs/core-fork.md` in buildthehomelab/wow-project-everlake.

From the first batch of advocaite pull requests (#276-#282) on, each review is its own file in `docs/upstream-prs/`
(`advocaite-<number>.md`), so pull requests reviewed side by side don't clash in this file. TrinityCore `master` commits
come in by `git cherry-pick -x`, one file per commit: `trinitycore-<first 10 characters of the commit>.md`. A commit
already in `everlake` under another hash (same `git patch-id`, or the same fix made by advocaite) gets a file too, so
the daily upstream check counts it as sorted.

Before a merge from upstream goes in, check that Everlake's own changes survived it: `docs/everlake-changes.md` lists
each one with the lines a conflict could silently drop.

## 2026-11-08: advocaite `forever-bots` @ 19bdc6af66 (the bot module)

**What:** fast-forward of `forever` to `forever-bots`: 80 commits (35 merges), 919 files, +384,979 / -287 lines.
`everlake` was `2ae1313e9f`, which `forever-bots` already contains, so no conflicts. Non-merge authors: Karrz1 26,
Advocaite 18, Lauris 1.

- `src/modules/PlayerbotV2/`: WoW Forever Bots (Karrz1, after agatho's PlayerbotV2), built only with
  `-DBUILD_PLAYERBOT_V2=1`. This is Karrz's module as of 2026-10-27 (commit 9df935eed5 "bot module update", last
  Karrz PRs #194-#197 on 10-28), plus Advocaite's ScriptMgr hooks that load it (af808e1492, 0bc03e79ab).
- 216 files outside the module (+128,564), including:
  - pathfinding: road graph, `PathGenerator`, `dtQueryFilterTC`, `TileBuilder`, `MMapManager`, Detour;
  - new tools: road extractor, `mmap_probe`, `mmap_world_dump`, navmesh audit;
  - game code: groups, battlegrounds and their queue, LFG, trainers, auction house bot, spells, maps;
  - 3 new unit test files (`tests/game/ClassicBotGroupRules.cpp`, `ClassicDrinkSay.cpp`, `ClassicRidingTier.cpp`);
  - bot SQL in `sql/playerbot_v2` and `sql/playerbot_shared`.
- No change to the map, vmap or mmap file versions (`MMapDefines.h`, `MapDefines.h`, `VMapDefinitions.h`), so data
  extracted for `forever` still loads. Untested: whether the new road and off-mesh data needs a fresh extraction for
  bots to path well.

**Not reviewed line by line.** At this size the check is: the build with the bots on under CI's warnings-as-errors,
both sanitizers, the unit tests, and then the module's own scenario runner (`Diagnostics/ScenarioRunner`) on a test
realm. Karrz's newer module work (his 0.1.33 release, 185 files, +20,109 / -1,124 against this copy) comes later, in
reviewed batches by subsystem.

**Verdict:** pending the first CI run with `-DBUILD_PLAYERBOT_V2=1`.
