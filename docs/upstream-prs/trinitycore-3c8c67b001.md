# TrinityCore 3c8c67b001: skyriding banking and pitch rates sent in radians

Oreocide, 2026-10-29 (TrinityCore PR 32067). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** The FlightCapability banking and pitching rates are degrees in the DB2; the client wants radians.

**Check.** Unreachable on Everlake: wago.tools has no FlightCapability table for 70862 (the request fails), all 27
MountCapability rows have FlightCapabilityID 0, no 70862 spell has the skyriding auras (446, 520, 521, 522), and our
`Unit::UpdateAdvFlyingSpeed` already returns early because "Classic 1.60 data has no default flight capability".

**Test.** None.

**Verdict:** take (inert).
