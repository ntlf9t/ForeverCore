# TrinityCore 761b1a2f5f: demon hunter talents Burn It Out / Soul Cleanse

Aqua Deus, 2026-10-31, TrinityCore PR #32084. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_dh_burn_it_out` and `spell_dh_soul_cleanse` on Immolation Aura (258920, 427912-427915, 1241937).

**Check.**
- All bound ids and 1266316, 1266496, 1266617, 1266618 absent from 70862. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL: only `spell_script_names` / `spell_proc` rows for those absent ids. Forever's world DB has no rows for them; the new rows are skipped at load (spell does not exist).
- **Rebased onto batch H** (#30, sorted `spell_dh.cpp`): conflict resolved by taking TrinityCore a766fe19ac's `spell_dh.cpp` (every TrinityCore commit touching the file up to master is now in `everlake` or this branch) plus our Soulmonger null check; `diff` against a766fe19ac shows only that check.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
