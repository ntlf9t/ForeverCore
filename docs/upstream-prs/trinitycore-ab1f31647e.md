# TrinityCore ab1f31647e: monk talent Vivacious Vivification: proc rows

Aqua Deus, 2026-11-07, TrinityCore PR #32119. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** SQL only: corrected `spell_proc` rows for Vivacious Vivification (388812, 392883; family 53 = monk).

**Check.** 70862 has no Monk class (`ChrClasses`: 1-5, 7-9, 11) and neither id is in its `SpellName`. Forever's
world DB release already has both rows (retail data carried along); this replaces them by id only.

**Test.** None needed.

**Verdict:** take, unreachable on Everlake.
