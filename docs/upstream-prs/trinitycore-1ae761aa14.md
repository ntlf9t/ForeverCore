# TrinityCore 1ae761aa14: base stats set, not added, on level change

Ovahlord, 2026-10-03 (closes TrinityCore issue 32042). Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** `Unit::SetCreateStat` added the new level's base stat on top of the old one (`HandleStatFlatModifier(...,
true)`), so stats grew with every level. It now sets them (`SetStatFlatModifier`).

**Check.** Already in `everlake`: advocaite made the same one-line fix in 8e3507db41 ("Classic 1.60: base stats are set,
not added, on level up", 2026-10-05), with a comment. The cherry-pick only conflicted on that comment; the code is
identical, so the pick was skipped (it would have been empty).

**Test.** None needed; already in.

**Verdict:** already in (8e3507db41).
