# TrinityCore 1e7fddbf36: Death and Decay hits around the area trigger

Shauren, 2026-10-25. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** `spell_dk_death_and_decay`'s periodic tick casts the damage (52212) at the aura's destination instead of on the caster.

**Check.**
- 43265 and 52212 absent from 70862; Forever's DB binds the script to 43265 only. Forever's warlock Death & Decay 11433 is a different id with no script (checked `spell_script_names`). All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game.
- No SQL.
- **Needs c8c3514884** ("Implement sending destination coords in aura update packets", batch F): it uses `Aura::GetDst()`, which that commit adds. Without it `spell_dk.cpp` does not compile (seen in the batch G local build: "no member named 'GetDst' in 'Aura'").

**Test.** None: no reachable code on Everlake.

**Update 2026-11-10.** Batch F (c8c3514884, `Aura::GetDst()`) is in `everlake` (134d3d8b17); the pick applies cleanly there
and `spell_dk.cpp` builds (local UBSan build, batch K).

**Verdict:** take (batch K). Unreachable on Everlake.
