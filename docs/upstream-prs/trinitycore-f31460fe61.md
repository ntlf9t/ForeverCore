# TrinityCore f31460fe61: Mechanar, Pathaleon the Calculator updated

offl, 2026-10-02, TrinityCore#31984. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Pathaleon gets a spawn line and Ethereal Teleport on appearing, new timers, a one-time frenzy flag, and
Arcane Explosion (15453) in every difficulty; texts regrouped (9 rows for 19220, was 8).

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. Of the new spell ids only 15453 (Arcane Explosion) is in 70862, and only Pathaleon's own AI casts it.
The 8 old `creature_text` rows for 19220 in Forever's release are TrinityCore's (TBC).

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
