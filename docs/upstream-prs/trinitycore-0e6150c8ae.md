# TrinityCore 0e6150c8ae: soul fragments from Consume for Devourer demon hunters: `spell_dh_shattered_souls_base_lesser` moved up and a third proc check on `spell_dh_shattered_souls_devourer`

Aqua Deus, 2026-11-05, TrinityCore PR #32091. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Soul fragments from Consume for Devourer demon hunters: `spell_dh_shattered_souls_base_lesser` moved up and a third proc check on `spell_dh_shattered_souls_devourer`.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: 1227619 is not in the 70862 `SpellName` (32,482 rows). No SQL; it changes existing demon hunter scripts only (`spell_dh_shattered_souls_devourer`, on 1227619 Shattered Souls). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
