# TrinityCore 6ebe044cbb: demon hunter talent Swallowed Anger

Aqua Deus, 2026-10-02, TrinityCore PR #32037. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_dh_swallowed_anger` on 278326 Consume Magic (Swallowed Anger 320313 gives fury per dispel).

**Check.**
- 278326, 320313, 1277738 absent from 70862 (no demon hunter class in 70862). All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL: only `spell_script_names` / `spell_proc` rows for those absent ids (278326). Forever's world DB has no rows for them; the new rows are skipped at load (spell does not exist).
- **Rebased onto batch H** (#30, which sorted `spell_dh.cpp` with TrinityCore e062b71ce8): conflict resolved by putting `spell_dh_swallowed_anger` after `spell_dh_spontaneous_immolation`, its place in TrinityCore's sorted file (that stretch checked identical to TrinityCore a766fe19ac).

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
