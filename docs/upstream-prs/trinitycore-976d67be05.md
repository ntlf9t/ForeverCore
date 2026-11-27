# TrinityCore 976d67be05: Black Rook Hold, Swirling Scythe area trigger rotates with RollPitchYaw

Aqua Deus, 2026-10-01, TrinityCore#32033. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Amalgam of Souls' Swirling Scythe (create properties 5167) gets its rotation from the new Roll/Pitch/Yaw
columns (Yaw 370.01) instead of a script that built a path to its own position; the script's `OnInitialize` goes.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. The SQL replaces one row, `areatrigger_create_properties` 5167 (not custom), which Forever's release
has with TrinityCore's own values (AreaTrigger 9899, script `at_amalgam_of_souls_swirling_scythe`); after the file
the row differs only in `TargetYaw` = 370.01 and `VerifiedBuild`. Forever uses no 5167 elsewhere (no `areatrigger`
spawn points at it). The columns exist since batch B (TrinityCore bbded1b3ee). Applied cleanly on the scratch database.

**Test.** None: Legion dungeon, not in the Forever client.

**Verdict:** take (unreachable; keeps the script and SQL in line with TrinityCore).
