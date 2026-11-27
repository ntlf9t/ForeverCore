# TrinityCore 35f88291b8: hunter talent Take Aim

Aqua Deus, 2026-09-27, TrinityCore PR #32013. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Take Aim (1273132) raises Rapid Fire damage; `spell_hun_rapid_fire` / `spell_hun_rapid_fire_damage` reworked to pass it on, new `spell_hun_take_aim` on 257045.

**Check.**
- Ids 257044, 257045 (retail Rapid Fire, bound to the scripts in Forever's DB) and 1273132 are absent from 70862. Forever's Classic Rapid Fire 3045 is a different id and has no script. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- **Conflict** in the `HunterSpells` enum: `SPELL_HUNTER_TAR_TRAP` was already removed by 545be4dddc (batch B); resolved by adding only `SPELL_HUNTER_TAKE_AIM`.
- SQL: only `spell_script_names` / `spell_proc` rows for those absent ids (257045). Forever's world DB has no rows for them; the new rows are skipped at load (spell does not exist).

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
