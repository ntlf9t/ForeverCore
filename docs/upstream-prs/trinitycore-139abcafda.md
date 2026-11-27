# TrinityCore 139abcafda: Gruul's Lair, Maulgar's ogres respawn through spawn groups

offl, 2026-10-03, TrinityCore#31986. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Maulgar's four council ogres move into spawn groups 419-422 (group flag 4), and Maulgar respawns them with
`SpawnGroupSpawn` instead of the instance script storing their spawn ids (`GLDataTypes` and four `NPC_*` ids removed
from `gruuls_lair.h`).

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. Forever's release has no `spawn_group_template` 419-422 (no id clash) and no `spawn_group` row or
creature for spawn ids 81651, 81652, 81643, 48348, so the four UPDATEs match 0 rows and the groups stay empty. Pending
`sql/custom/world` files that touch `spawn_group` only delete other rows. No other code uses the removed names (grep
`src/`).

**Test.** None: raid not in the Forever client.

**Verdict:** take (unreachable).
