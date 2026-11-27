# TrinityCore 83f2822c10: Ashenvale Outrunner movement speed

Aokromes, 2026-10-07, closes TrinityCore issue #31840 (by enkrii). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. World
data: Forever world DB release `forever-tdb-2026-10-14` (file not in its `updates` table).

**Claim.** Ashenvale Outrunner (12856) gets `speed_walk` 1 and `speed_run` 1.142857.

**Check.** 12856 is live Classic content: 20 spawns in Ashenvale in the release, and in QuestieDB's Forever NPC list
(level 23-24). The release already has `speed_walk` 1 and `speed_run` 1.14286 (the column's 8/7 default,
`VerifiedBuild` 69497). Applying the file on a scratch MySQL 8.0 changes only the float's last digits (1.1428600549...
-> 1.1428569555..., both 8/7); the dump of the table is identical before and after. No gameplay change on Everlake.

**Test.** None: no code.

**Verdict:** take. Forever's values already match; the file is a no-op here and keeps `sql/updates/world` in line with
TrinityCore.
