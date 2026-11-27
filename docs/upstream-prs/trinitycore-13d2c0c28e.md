# TrinityCore 13d2c0c28e: Explosive Shot script update

Aqua Deus, 2026-09-27, TrinityCore PR #32014. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** `spell_hun_explosive_shot` (212431) now deals its damage on removal instead of each period tick.

**Check.**
- 212431 and 212680 absent from 70862 (Forever DB binds the script to 212431 only). All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- No SQL.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
