# TrinityCore 209d6d51d1: shaman talent Encasing Cold

Aqua Deus, 2026-10-26, TrinityCore PR #32061. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_sha_encasing_cold` (462762) and its `spell_proc` row.

**Check.**
- 462762, 1258862 absent from 70862. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL: only `spell_script_names` / `spell_proc` rows for those absent ids. Forever's world DB has no rows for them; the new rows are skipped at load (spell does not exist).

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
