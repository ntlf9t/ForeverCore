# TrinityCore 7a9c5b8d15: Immolation Aura energize: only the energize effect of the player's spec (Havoc / Vengeance) gives Fury

Shauren, 2026-11-05. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Immolation Aura energize: only the energize effect of the player's spec (Havoc / Vengeance) gives Fury.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 258920, 258922, 427908, 427910, 427911, 427912, 427913, 427914, 427915, 427916 is in the 70862 `SpellName` (32,482 rows). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
