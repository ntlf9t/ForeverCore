# TrinityCore 3c57626881: demon hunter talent Spontaneous Immolation (1246556): proc restores a Soul Immolation charge

Aqua Deus, 2026-11-03, TrinityCore PR #32087. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent Spontaneous Immolation (1246556): proc restores a Soul Immolation charge.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 1241937, 1246556 is in the 70862 `SpellName` (32,482 rows). Conflict: TrinityCore's context had batch G's Swallowed Anger script next to the new one; resolved by adding only this commit's lines (the +/- lines of the result equal TrinityCore's commit exactly). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
