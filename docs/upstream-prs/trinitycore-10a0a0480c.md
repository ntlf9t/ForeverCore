# TrinityCore 10a0a0480c: Zul'Aman, Hex Lord Malacrass changes

offl, 2026-10-03, TrinityCore#31991. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Malacrass' Lifebloom spell script moves from `spell_generic.cpp` (generic `spell_gen_lifebloom` registered
as `spell_hexlord_lifebloom` with final heal 43422) into `boss_hexlord.cpp` as `spell_malacrass_lifebloom`, and the
`spell_script_names` row is renamed. Siphon Soul no longer cuts its target list to one.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. The `scripts/Spells` part: 43421 (the Lifebloom row in Forever's release) and 43422 are not in
70862, and the other users of `spell_gen_lifebloom` in `spell_generic.cpp` are untouched. Forever's Lifebloom-type
spells don't use `spell_hexlord_lifebloom` (only row: 43421). The UPDATE changes that one row's ScriptName.

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
