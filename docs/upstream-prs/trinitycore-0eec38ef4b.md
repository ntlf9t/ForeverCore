# TrinityCore 0eec38ef4b: demon hunter talent Wings of Wrath (1266493): Glide casts the enhanced knockback (1266494) when talented

Aqua Deus, 2026-11-04, TrinityCore PR #32101. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent Wings of Wrath (1266493): Glide casts the enhanced knockback (1266494) when talented.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 131347, 1266493, 1266494 is in the 70862 `SpellName` (32,482 rows). The changed script is `spell_dh_glide` (Glide 131347, also absent). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
