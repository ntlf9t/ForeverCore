# TrinityCore ce26a7133f: hunter talent Horsehair Tether

Aqua Deus, 2026-09-26, TrinityCore PR #32009. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Binding Shot's area trigger also pulls the stunned unit to the trap centre (472731) when the hunter has Horsehair Tether (472729).

**Check.**
- Ids 472729, 472731 absent from 70862; the changed area trigger `at_hun_binding_shot` (create properties 1524) is not created by any 70862 spell (no SpellEffect 179 with misc 1524). All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- **Conflict** in the `HunterSpells` enum: `SPELL_HUNTER_HIGH_EXPLOSIVE_TRAP` and `SPELL_HUNTER_IMPLOSIVE_TRAP` were already removed by 545be4dddc (batch B, taken out of TrinityCore order); resolved by adding only the two Horsehair Tether ids.
- No SQL.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
