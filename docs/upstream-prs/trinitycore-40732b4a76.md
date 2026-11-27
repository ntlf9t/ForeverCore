# TrinityCore 40732b4a76: hunter talent Bleak Powder

Aqua Deus, 2026-10-04, TrinityCore PR #32041. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_hun_bleak_powder` (467911), `spell_hun_bleak_powder_areatrigger_summon` (467912) and `at_hun_bleak_powder` (create properties 35089), a sqrt target limit fix in `SpellMgr::LoadSpellInfoTargetCaps` for 467914 / 472084, and the Focused Aim proc handler made static.

**Check.**
- 467911, 467912, 467914, 472084 absent from 70862. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- Core part: `ApplySpellFix` on absent ids does nothing but log an error at start; no other spell affected.
- SQL: new area trigger template 37291 and create properties 35089 (with 4 polygon vertices), none in Forever's DB and not created by any 70862 spell; script names and `spell_proc` for absent ids.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
