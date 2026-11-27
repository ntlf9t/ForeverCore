# TrinityCore d31d97169f: death knight talent Grip of the Dead

Aqua Deus, 2026-10-25, TrinityCore PR #32057. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_dk_grip_of_the_dead` (on 43265 Death and Decay), `_periodic` (273980) and `_snare` (on 52212); `at_dk_death_and_decay` reworked.

**Check.**
- 43265, 52212, 273952, 273977, 273980, 273984 absent from 70862. `at_dk_death_and_decay` (create properties 4485 in Forever's DB) is not created by any 70862 spell. Forever's warlock "Death & Decay" 11433 is a different spell: a persistent area aura (effect 27), no area trigger, no script. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL: only `spell_script_names` / `spell_proc` rows for those absent ids. Forever's world DB has no rows for them; the new rows are skipped at load (spell does not exist).

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
