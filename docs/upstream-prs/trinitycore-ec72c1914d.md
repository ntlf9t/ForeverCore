# TrinityCore ec72c1914d: demon hunter talent Hungering Slash: four scripts, a `spell_proc` row for Voidstep and a target cap in `SpellMgr::LoadSpellInfoTargetCaps` for 1239127

Aqua Deus, 2026-11-03, TrinityCore PR #32096. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Demon hunter talent Hungering Slash: four scripts, a `spell_proc` row for Voidstep and a target cap in `SpellMgr::LoadSpellInfoTargetCaps` for 1239127.

**Check.** Demon hunter only: 70862 `ChrClasses` has 9 classes (1-5, 7-9, 11); there is no Demon Hunter (12), so no player can have these talents or cast these spells. Spell ids in the change: none of 1223157, 1239123, 1239127, 1239507, 1239519, 1239525, 1245412, 1245470, 1245483, 1245523, 1246167, 1259431 is in the 70862 `SpellName` (32,482 rows). The `SpellMgr.cpp` change is one `ApplySpellFix({ 1239127 }, ...)`: for a spell that doesn't exist `ApplySpellFix` logs "Spell info correction specified for non-existing spell" and skips it, so it touches no Forever spell. `spell_script_names` and
`spell_proc` rows for spells that don't exist are logged and skipped at load (`ObjectMgr::LoadSpellScriptNames`,
`SpellMgr::LoadSpellProcs`). Nothing else in `src/` (Custom, modules, playerbots)
uses the names this commit changes (`rg`).

**Test.** None possible in game. Builds in the local UBSan build (`spell_dh.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake (keeps `spell_dh.cpp` in line with TrinityCore so later fixes apply).
