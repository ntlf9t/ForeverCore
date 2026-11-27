# TrinityCore b2f8a02ffb: Felfire Haste proc includes Shift

Aqua Deus, 2026-10-02, TrinityCore PR #32036. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** One `spell_proc` UPDATE: 389846 Felfire Haste gets `SpellFamilyMask3` 0x20.

**Check.**
- 389846 absent from 70862; the Forever row exists and is skipped at load either way. Inert.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
