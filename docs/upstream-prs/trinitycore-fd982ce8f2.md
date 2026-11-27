# TrinityCore fd982ce8f2: demon hunter Devourer talent Feast of Souls (1237270) on Consume Soul (1223628)

Aqua Deus, 2026-11-02, TrinityCore PR #32088. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter Devourer talent Feast of Souls (1237270) on Consume Soul (1223628).

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 1223628, 1232310, 1237270 is in the 70862 `SpellName` (32,482 rows). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
