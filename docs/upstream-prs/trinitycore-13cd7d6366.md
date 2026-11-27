# TrinityCore 13cd7d6366: hunter talent Focused Aim

Aqua Deus, 2026-10-01, TrinityCore PR #32032. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** New `spell_hun_focused_aim` on 260242 Precise Shots (Aimed Shot cooldown reduced when Focused Aim 378767 is known) and a `spell_proc` row for 260242.

**Check.**
- 260242 and 378767 absent from 70862. The script touches Aimed Shot's cooldown (19434 exists in 70862) only from a proc of 260242, which no Everlake player can have. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL replaces Forever's `spell_proc` row for 260242 (absent spell, skipped at load either way).

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
