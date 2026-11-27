# TrinityCore a766fe19ac: demon hunter talent The Hunt: area trigger script `at_dh_the_hunt` (create properties 24961 on custom template 192) dealing Havoc / Devourer damage

Aqua Deus, 2026-11-09, TrinityCore PR #32092. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent The Hunt: area trigger script `at_dh_the_hunt` (create properties 24961 on custom template 192) dealing Havoc / Devourer damage.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 370967, 370969, 1246167, 1246168 is in the 70862 `SpellName` (32,482 rows). The SQL adds `areatrigger_create_properties` 24961 (IsCustom 0) and a custom `areatrigger_template` 192 (IsCustom 1). Neither id is in Forever's world DB release (`forever-tdb-2026-10-14`, grep of the INSERT rows) nor in any `sql/updates` or `sql/custom` file of the fork, so the rows collide with nothing; no 70862 spell effect creates property 24961 (`SpellEffect`: no effect 179 with misc value 24961). (A grep hit on 24961 in `SpellName` is the unrelated spell "Honor Points +82": not an area trigger id.) All of batch H's SQL (20 files) ran without error on a scratch MySQL 8.0 holding Forever's `spell_script_names`, `spell_proc`, `areatrigger_template` and `areatrigger_create_properties` (schema and rows from `forever-tdb-2026-10-14`, plus 545be4dddc's columns). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
