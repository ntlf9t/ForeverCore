# TrinityCore 15e0ed76e2: Learn Toy and Learn Transmog criteria count what was learned before

Shauren, 2026-10-28. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** Fix to ac4ffc3294: at login (miscValue 0) Learn Toy and Learn Transmog check the account's collection, and
Learn Any Toy is set to the number of account toys, so achievements count toys and appearances learned earlier.

**Check.** Same as ac4ffc3294: 70862 has no criteria of types 185, 186 or 192, so the login pass loops over nothing.

**Test.** None.

**Verdict:** take (inert).
