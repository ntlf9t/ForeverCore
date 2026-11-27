# TrinityCore 946bb2934e: Botanica boss scripts updated

offl, 2026-09-30, TrinityCore#31974. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Timer and event clean-ups for Commander Sarannis, High Botanist Freywinn, Laj, Thorngrin and Warp Splinter;
Sarannis' reinforcements are cast with no target; Freywinn starts Tree Form work from `OnSpellCast`; five
`spell_target_position` rows (34673, 34681, 34682, 34684, 34685) get an orientation.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. No new spell id in these files exists in 70862. The five `spell_target_position` rows are TrinityCore's
TBC rows on map 553 in Forever's release (Orientation NULL before); only Orientation changes.

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
