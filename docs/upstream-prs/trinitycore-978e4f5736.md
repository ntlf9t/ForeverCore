# TrinityCore 978e4f5736: Frostscythe hits at most 5 targets (sqrt scaling)

Aqua Deus, 2026-10-11, TrinityCore#32059. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** Retail Frostscythe (207230) gets a target cap.

**Check.** Only spell 207230, not in the 70862 client. Unreachable on Everlake; taken to stay in line.

**Test.** None.

**Verdict:** take.
