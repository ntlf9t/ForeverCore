# TrinityCore d30a7e0912: Mechanar, Gatewatcher Gyro-Kill and Iron-Hand updated

offl, 2026-09-30, TrinityCore#31976. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Timer changes; Gyro-Kill's Saw Blade goes on a random target instead of the tank; parameter renames.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. Code only, no SQL; both scripts are bound by ScriptName to TBC creatures that Forever never spawns.

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
