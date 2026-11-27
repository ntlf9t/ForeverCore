# TrinityCore c3c20aacfb: use after free of m_originalCaster in Spell::cancel

Gildor, 2026-10-07, TrinityCore#32047. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `Spell::cancel` used `m_originalCaster` after it could be freed.

**Check.** Already in `everlake` as 4c8c16ddb9 (same patch id), picked into `forever` by advocaite (merge e100433dcf,
advocaite/TrinityCore#153).

**Test.** None needed; already in.

**Verdict:** already in (4c8c16ddb9).
