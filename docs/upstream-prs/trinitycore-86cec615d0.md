# TrinityCore 86cec615d0: area trigger spline set-up takes any contiguous range

Shauren, 2026-11-07. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `InitSplineOffsets` and `InitSplines` take `std::span` instead of `std::vector const&`, so callers can pass
arrays or part of a vector.

**Check.** Signature only; every existing caller passes a vector, which converts. Forever's own code has no caller
(`src/server/scripts/Custom`, `src/modules`). Taken because later TrinityCore script commits call these with arrays.

**Test.** None (no change in behaviour); built.

**Verdict:** take.
