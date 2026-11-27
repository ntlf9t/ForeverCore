# TrinityCore af3220f000: spline asserts print the value that failed

Shauren, 2026-10-02. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** The three `ASSERT`s in `Spline<length_type>::computeIndex` / `computeIndexInBounds` now print `t` and
`out_idx`.

**Check.** Message only; the conditions are unchanged. Useful for us: a spline assert in a crash log now says which
value was out of range.

**Test.** None (no change in behaviour). Built in CI with `-Werror` (format strings checked).

**Verdict:** take.
