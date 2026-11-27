# TrinityCore ff69ba62fe: demon hunter talent Infernal Armor (320331) on Immolation Aura and Soul Immolation, with `spell_proc` rows

Aqua Deus, 2026-11-04, TrinityCore PR #32099. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent Infernal Armor (320331) on Immolation Aura and Soul Immolation, with `spell_proc` rows.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 258920, 320331, 320334, 427912, 427913, 427914, 427915, 1241937 is in the 70862 `SpellName` (32,482 rows). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
