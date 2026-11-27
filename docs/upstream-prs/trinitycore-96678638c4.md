# TrinityCore 96678638c4: hunter talents Flare / Kindling Flare

Aqua Deus, 2026-09-27, TrinityCore PR #32011. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_hun_flare` on 1543 Flare (plays the missile visual 214000 with travel time), `at_hun_flare` (area triggers 510 and 35958: enemies inside get 132951, the stealth dispel aura) and `spell_hun_kindling_flare` on 132950 (picks one of two area triggers when the hunter has Kindling Flare 459506). SQL: new create properties row 35958, `ScriptName` on row 510, script names for 1543 and 132950.

**Check.**
- **Flare 1543 is live in 70862** but Forever's Flare is a different spell from retail's: effect 0 = `SPELL_EFFECT_DUMMY` (3), effect 1 = `SPELL_EFFECT_CREATE_AREATRIGGER` (179) with create properties **41236** (Forever row `IsAreatriggerCustom` 1, no ScriptName). Retail Flare 1543 has a trigger-missile effect 0 instead (the hook the new script uses).
- `spell_hun_flare` will be bound to 1543 by the new row, but its `Validate` needs 214000, absent from 70862: `SpellScriptBase::_Validate` logs "did not pass Validate()" and the script is not added. Even if it passed, its hook is on `EFFECT_0 SPELL_EFFECT_TRIGGER_MISSILE`, which 70862 Flare does not have. So **Forever's Flare is unchanged**: same 41236 trigger, same behaviour as today.
- 132950, 132951, 214000, 459506 absent from 70862. No 70862 spell creates area trigger create properties 510 or 35958, so `at_hun_flare` never runs.
- SQL on Forever's world DB: row 510 exists in `forever-tdb-2026-10-14` (AreaTriggerId 3678, empty ScriptName) and gets `at_hun_flare`: harmless since nothing creates it. Row 35958 is new. Forever has no `spell_script_names` row for 1543 or 132950 (checked) and no Classic script uses Flare (grep of `src/server/scripts/Custom`).
- All batch G world SQL files, applied in name order with batch B's 2026_10_19_00 on a scratch MySQL 8.0 holding Forever's own `spell_script_names`, `spell_proc` and area trigger tables, run without errors; afterwards 1543 is the only 70862 spell id with a new script row.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take. Live spell id, but no change for Forever's Flare (script fails `Validate` on 70862, hook does not match its effects).
