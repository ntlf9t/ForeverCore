# TrinityCore 3395c1f863: hunter talent Trailblazer

Aqua Deus, 2026-09-26, TrinityCore PR #32008. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New aura script `spell_hun_trailblazer` (199921) for the retail Survival/Beast Mastery talent: out-of-combat movement speed buff (231390) that drops when the hunter attacks.

**Check.**
- Ids: 199921 Trailblazer, 231390 Trailblazer speed: both absent from 70862 SpellName. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL: only `spell_script_names` / `spell_proc` rows for those absent ids (one row, 199921). Forever's world DB has no rows for them; the new rows are skipped at load (spell does not exist).
- Also edits `areatrigger_hun_tar_trap_activate` context only; Tar Trap (187699/187700) is absent too.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
