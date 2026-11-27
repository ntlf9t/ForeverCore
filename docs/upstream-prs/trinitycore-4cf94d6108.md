# TrinityCore 4cf94d6108: Arcatraz, Zereketh and Harbinger Skyriss updated

offl, 2026-10-03, TrinityCore#31992. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Shorter timers and changed target selection (random target other than the tank, mana users for Mana Burn)
for Harbinger Skyriss; Skyriss' illusions set their corpse delay on init; Zereketh's aggro line moves.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. Code only, no SQL; no new spell id in these files exists in 70862.

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
