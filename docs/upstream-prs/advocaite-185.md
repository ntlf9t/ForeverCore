# advocaite/TrinityCore#185: Talents: a level-up no longer resets the talents of a level 5-14 character

dqhoang (Duy Hoang), 2026-10-26, commit 5715438530. Reviewed 2026-11-08 against `everlake` dab8f8aa45, together with #319.

**Claim.** Characters under level 15 lost their talents on every level-up.

**Check.** True, and worse than the title says. `Player::InitTalentForLevel` still had retail's "level < 15:
`ResetTalents(true)`". In `everlake`, `ResetTalents` also clears the Classic talent config (every purchased rank of the
active combat config) and calls `RemovePet`. `InitTalentForLevel` runs on every level-up (`GiveLevel`), on spec
activation (`ActivateTalentGroup`, right after the config is applied), at login (before the trait configs load, so harmless
there) and at character creation. So a character with talent points below 15 (from level 10, or from level 5 with the
Legacy perk Talented) lost every point it spent at each ding, and a hunter or warlock got its pet dismissed at each ding
below 15. TrinityCore `master` keeps the reset (retail has no talents below 10 at all). The fix keeps only the tier
cleanup at 15 and above; retail TalentEntry talents are not used by the Classic tree.

**Agrees with #319 and IncrementalTalentCommit.** No overlap: #185 only removes a reset, #319 changes how many points the
currency rows give, and `tests/game/IncrementalTalentCommit.cpp` checks `TraitMgr::ValidateConfig`, which neither touches.
A level-down (GM `.level`) now keeps spent points above what the level allows; the next talent change then asks for a
reset, the same as lowering Rate.Talent.

**Test.** None in `tests/`: it needs a Player. PTR: a level 10 character spends its point, levels to 11 (`.levelup`):
the point stays spent and a second one is free. With Talented 5/5, the same from level 5. A level 11 hunter with its pet
out levels up: the pet stays.

**Verdict:** take.
