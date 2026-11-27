# TrinityCore fc1af00330: demon hunter talent Burning Hatred (320374) on the Immolation Aura ticks

Aqua Deus, 2026-11-04, TrinityCore PR #32103. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent Burning Hatred (320374) on the Immolation Aura ticks.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 258922, 320374, 427908, 427910, 427911, 427916 is in the 70862 `SpellName` (32,482 rows). Conflict: TrinityCore's context had batch G's Burn It Out script and registration next to the new ones; resolved by adding only this commit's lines (the +/- lines of the result equal TrinityCore's commit exactly). `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
