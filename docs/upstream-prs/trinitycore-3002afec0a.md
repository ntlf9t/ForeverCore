# TrinityCore 3002afec0a: proc of hunter talent Moment of Opportunity

Aqua Deus, 2026-09-26, TrinityCore PR #32010. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Adds a `spell_proc` row for 459488 Moment of Opportunity (family mask on the trigger spells).

**Check.**
- 459488 absent from 70862; no Forever `spell_proc` row for it. The row is skipped at load. Inert.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
