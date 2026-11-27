# TrinityCore d325728ec7: rogue talent Zero In: `spell_proc` rows

Aqua Deus, 2026-11-05, TrinityCore PR #32116. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** SQL only: `spell_proc` rows for Zero In (1259485, 1259486; family 8 = rogue).

**Check.** Neither 1259485 nor 1259486 is in the 70862 `SpellName`; the proc loader reports and skips rows for spells
that don't exist. The DELETE is by those two ids only. No rogue spell of 70862 changes.

**Test.** None needed (SQL rows for absent spells).

**Verdict:** take, unreachable on Everlake.
