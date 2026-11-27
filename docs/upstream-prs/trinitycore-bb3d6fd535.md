# TrinityCore bb3d6fd535: follow-up to b75afc756f, no database name in the SQL

Naddley, 2026-11-07 (no pull request number). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools export of 1.60.1.70862 (Map). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables batch I's SQL touches) with every batch I world file applied in TrinityCore order and the tables dumped before and after.

**Claim.** b75afc756f's DELETE and INSERT named the schema `world`; this drops the prefix so the file works on any world
database name.

**Check.** Needed: Everlake's world database is not necessarily called `world`, and our updater applies the file to
whatever the configured world database is. Same file name as b75afc756f (2026_11_07_00_world.sql), both in this PR,
so Everlake only ever applies the fixed version.

Taken together with dc5955decd, 5a58175f49, b75afc756f and bb3d6fd535 (the Earthen start-area chain): 5a58175f49 without b75afc756f breaks every conversation ScriptName.

**Test.** Applied (fixed version) on the scratch database without errors.

**Verdict:** take.
