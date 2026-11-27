# TrinityCore 3a89e8c80c: access requirements keyed by (map, difficulty) instead of MAKE_PAIR64

Shauren, 2026-10-20 (from TrinityCore 3.3.5 6922ac1636). Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `ObjectMgr::_accessRequirementStore` used `MAKE_PAIR64(mapid, difficulty)` as its key; it becomes
`std::pair<uint32, Difficulty>`.

**Check.** A refactor. On `master` the 64-bit key could not collide (map id in the low 32 bits, difficulty in the high
32), so no access requirement was wrong before; "unsafe" is about the 3.3.5 branch's narrower keys. Both users
(`GetAccessRequirement`, `LoadAccessRequirements`) change together; no other code reads the container. Everlake's
`ObjectMgr` has no change of its own in these lines. Taken so later TrinityCore changes to the same code apply.

**Test.** None (no change in behaviour). Built in CI.

**Verdict:** take.
