# TrinityCore cd29c358ac: proc of warlock talent Abyss Walker

Aqua Deus, 2026-10-18, TrinityCore PR #32074. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Adds a `spell_proc` row for 389609 Abyss Walker.

**Check.**
- 389609 absent from 70862; no Forever row. Inert.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
