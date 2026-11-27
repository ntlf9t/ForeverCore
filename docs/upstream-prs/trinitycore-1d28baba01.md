# TrinityCore 1d28baba01: monk Soothing Mist channel healing on Vivify / Enveloping Mist / Sheilun's Gift

Aqua Deus, 2026-11-07, TrinityCore PR #29151. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Monk Soothing Mist (115175): casting Vivify (116670), Enveloping Mist (124682) or Sheilun's Gift
(399491) while channelling Soothing Mist on a target sends them to that target; the visual (117899) script, Peer into
Peace (440008).

**Check.** 70862 has no Monk class (`ChrClasses`: 1-5, 7-9, 11), and none of 115175, 116670, 117899, 124682, 399491,
440008 is in its `SpellName`. The SQL deletes by these two script names only. No Forever spell changes.

**Test.** None possible. Builds in the local UBSan build (`spell_monk.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake.
