# TrinityCore 81912bbcb0: rogue Acrobatic Strikes script removed

Aqua Deus, 2026-11-01, TrinityCore PR #32115. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** The script for rogue talent Acrobatic Strikes (455143, cast 455144) is outdated; script and its
`spell_script_names` row go.

**Check.** Rogue exists in 70862, but neither 455143 nor 455144 is in the 70862 `SpellName`, so the script never
attached on Everlake. Nothing else in `src/` uses `spell_rog_acrobatic_strikes` or
`SPELL_ROGUE_ACROBATIC_STRIKES_PROC` (`rg`). The SQL deletes by script name only.

**Test.** Builds in the local UBSan build (`spell_rogue.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake.
