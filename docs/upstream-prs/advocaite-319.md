# advocaite/TrinityCore#319: Talents: Rate.Talent sets talent points per level

Karrz1, 2026-11-07, commit aa33b9cfe1. Reviewed 2026-11-08 against `everlake` dab8f8aa45, together with #185 and #150/#151.

**Claim.** Server owners want a talent point rate. Classic 1.60 talent points are trait currency 3820, worked out by the
client from TraitCurrencySource, so the server had none. `Rate.Talent` (default 1) multiplies the level rows and raises
the currency cap, on the server and through hotfixes. Hotfixes made at startup went out as Invalid and were ignored; they
are Valid now. `.modify talentpoints` says it can't instead of doing nothing.

**Check.**
- Data (client build 70862): currency 3820 has 51 level rows (levels 10-60, 1 point each), `SourcedMax` 51, and five rows
  behind a trait node: 37163-37167, one point at each level 9..5, each behind a Talented node entry (136852,
  137371-137374, TraitDefinition spell 1225474).
- The level rows: handed out level by level (the running total is round-down(base so far x rate)), so 1.5 gives
  1, 2, 1, 2 and 76 by 60. Right. `SourcedMax` is raised to the new total when it is higher.
- **The Talented rows: a mismatch.** #319 multiplied every non-level row, the Talented rows too, and sent them to the
  client. The server never counts those rows (`hasTraitNodeEntry` looks in the talent config being checked; the Talented
  nodes are in the Legacy config) and adds Talented's points itself in `FillOwnedCurrenciesMap`, one a level from
  `GetClassicTalentedStartLevel` (#151), not multiplied. At Rate.Talent 2 a Talented 5/5 character would be offered 5
  more points than the server allows, and Apply Changes fails, the #150 symptom.
- Hotfix status: `DB2Manager::InsertNewHotfix` left `HotfixStatus` at its default, Invalid, so `HandleHotfixRequest`
  never sent the record. Valid is right. Nothing else in `everlake` calls `AddClientHotfix` (the one generator in
  AchievementMgr does not notify the client), so no other startup fix starts going out. TrinityCore `master` has the same
  default.
- Default 1 returns before touching anything: no change unless the realm sets it. `TraitMgr::Load` in
  `tests/game/IncrementalTalentCommit.cpp` runs it with no config, which reads 1.
- #185 and #319 agree: #185 removes a reset below level 15, #319 only changes the rows. Lowering the rate below what a
  character spent asks for a reset at its next talent change.

**Our change on top.** The Talented rows stay as they are (`TraitMgr::GetClassicTalentRateRow` returns Unchanged for a row
behind a trait node), so client and server agree as at rate 1: Talented gives one point a level, whatever the rate. Quest
and achievement rows (none for 3820 today) are still multiplied. The arithmetic moves into
`TraitMgr::ScaleClassicTalentLevelPoints`, unchanged.

**Test.** `tests/game/ClassicTalentRate.cpp` (`[ClassicTalentRate]`): rate 1 unchanged; rate 2 = 2 a level, 102 by 60;
1.5 = 1, 2, 1... and 76; 0.5 = 0, 1... and 25; the five Talented rows are Unchanged, level rows Level, quest rows Scaled.
Under #319's rule (every row that is not a level row is multiplied) the five Talented rows would be Scaled, so those
five checks fail against it. PTR (realm with `Rate.Talent = 2`): a level 12 character has 6 points and can spend them
all; with Talented 5/5 at level 10, 2 + 5 = 7 and Apply Changes succeeds; the worldserver log shows ">> Rate.Talent = 2:
102 talent points by the level cap instead of 51".

**Verdict:** take, with our change on top.
