# TrinityCore 7eb9610ae3: Mechanar, Nethermancer Sepethrea updated

offl, 2026-10-01, TrinityCore#31975. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Text groups reordered (7 `creature_text` rows for 19221 replaced), Arcane Blast gets a spell script (35314),
Raging Flames lose their hand-made fixate, Quell Raging Flames cast without "triggered" on evade.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. 35314 is not in 70862, so `spell_nethermancer_sepethrea_arcane_blast` never binds. The 7 text rows
in Forever's release are TrinityCore's (Sepethrea, TBC) and are replaced with the same 7 lines in the new order.
`mechanar.h` change is a `constexpr`.

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
