# advocaite/TrinityCore#321: PvP rank: battlegrounds give rank points, and each rank costs what the client shows

Karrz1, 2026-11-07, commit 6b7bd29e5b. Reviewed 2026-11-08 against `everlake` dab8f8aa45, together with #182 and #296.

**Claim.** PvP rank points stayed at 0 for everyone. The Forever PvP rank is the renown of faction 2800; nothing gave
reputation to it, and the server priced every rank at the flat ReputationMax (20000) while the client reads
RenownThresholdCurveID 103650 (750 for rank 1 up to 3000 for rank 14). Now each renown level costs the curve's value, and
a battleground's players get rank points when it ends: `Classic.PvPRank.PointsBattlegroundWin` (250) and
`...Loss` (100).

**Check.**
- Data (client build 70862): faction 2800 "PvP Rank Points", RenownCurrencyID 3473 (MaxQty 14), RenownThresholdCurveID
  103650, ReputationMax 20000. Curve 103650 is type 5 (Step); its points are 750, 900, 1050, 1200, 1350, 1500, 1650,
  1800, 1950, 2100, 2350, 2500, 2650, 3000 at x = 1..14, 24750 in all. `GetCurveValueAt` with Step at x = n gives point n.
  Right.
- The only other renown track, 2802 "Legacy Track", has no curve and keeps the flat cost; the walk gives the same result
  as the old division for a flat cost (checked in the test).
- The level walk (down through levels on a loss, stopping at 0; up while the next level is paid for; the rest above the
  top discarded and taken out of the shown change) is right. The old code divided, and a loss below 0 left a negative
  standing.
- Not paid twice: rank points are only given in `EndBattleground` and only for battlegrounds (not arenas), to the players
  still in it. They are reputation of faction 2800, separate from honor (#182, #296).
- **The defaults change behaviour.** With the two settings missing, every battleground now gives 250/100 rank points.
  These numbers are the pull request's own; no public source gives Forever's rank point rewards, and the weekly cap is not
  done. The two `GetIntDefault` calls also run (and warn "Missing name ... in config file" if the realm config lacks them)
  at each battleground end.

**Our change on top.** The walk moves into `Trinity::RenownProgress::Walk` (Reputation/RenownProgress.h), unchanged, so a
test can call it.

**Test.** `tests/game/RenownProgress.cpp` (`[RenownProgress]`): 800 points reach rank 1 with 50 over (the old flat
20000 left rank 0); a win of 250 at rank 3 + 1000; 2700 = rank 3; past rank 14 is discarded; losses walk down and stop at
0; a flat-cost track gives what the old division gave. PTR: finish a Warsong Gulch win and a loss: the reputation pane
shows "250 of 750" then "350 of 750" for PvP Rank Points; at 750 the rank goes to 1.

**Verdict:** take, with our change on top. Decide whether Everlake keeps the 250/100 defaults (invented, uncapped) or sets
both to 0 until there is a source.

**Decision (user, 2026-11-09): keep 250 / 100.** No public source gives the real numbers; they are realm settings
(`Classic.PvPRank.*`), so they change without a rebuild when one turns up. Set both in the realm config so the worldserver
does not warn about a missing setting at each battleground end.
