# TrinityCore edabc454d0: remove outdated hunter scripts

Aqua Deus, 2026-09-28, TrinityCore PR #32029. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Removes `spell_hun_multi_shot` (2643, gave focus 213363 to Marksmanship) and `spell_hun_last_stand_pet` (53478) with their `spell_script_names` rows; Misdirection's aura hooks move from effect 1 to effect 2.

**Check.**
- **Multi-Shot 2643 is live** and Forever's DB binds `spell_hun_multi_shot` to it. But the script's `Validate` needs 213363, absent from 70862, so it has never been added to Multi-Shot on Everlake; removing it changes nothing.
- 53478, 53479 absent. Misdirection 34477 / 35079 absent from 70862 (Forever DB binds the scripts to them), so the effect index change is inert.
- SQL deletes Forever rows (2643, spell_hun_multi_shot) and (53478, spell_hun_last_stand_pet): both scripts were never active on Everlake.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take. No change on Everlake (removed scripts never passed `Validate` on 70862).
