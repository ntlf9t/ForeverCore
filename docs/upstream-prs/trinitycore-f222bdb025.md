# TrinityCore f222bdb025: Starfire's splash hits at most 8 targets (sqrt scaling)

Aqua Deus, 2026-10-03, TrinityCore#32045. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** Retail Starfire (194153) gets a target cap.

**Check.** Only spell 194153, which is not in the 70862 client (Forever's Starfire is 2912 and ranks, single target).
Unreachable on Everlake; taken so `LoadSpellInfoTargetCaps` stays in line for later changes.

**Test.** None.

**Verdict:** take.
