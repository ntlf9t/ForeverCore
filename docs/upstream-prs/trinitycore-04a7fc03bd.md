# TrinityCore 04a7fc03bd: demon hunter talent Scythe's Embrace (1246558) on Reap, Eradicate and Cull

Aqua Deus, 2026-11-02, TrinityCore PR #32093. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent Scythe's Embrace (1246558) on Reap, Eradicate and Cull.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 1225826, 1226019, 1245453, 1246558, 1261679 is in the 70862 `SpellName` (32,482 rows). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
