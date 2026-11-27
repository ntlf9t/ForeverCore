# advocaite/TrinityCore#150: Talents: the Legacy perk Talented counts its rank (replaced by #151)

krakenunbound (The Kraken), 2026-10-27, commit 6e19e5dcd0. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** With Talented 5/5 the talent window offers the extra points but Apply Changes fails: the server read the start
level from the aura amount, which stays at the rank 1 value (9). The pull request reads the rank from the trait configs
and adds info logs at the three `NotEnoughTalentsInPrimaryTree` returns of `TraitMgr::ValidateConfig`.

**Check.** Upstream merged its own fix instead, #151 (2c85af52d8, crediting this pull request), and `everlake` already
has it: `GetClassicTalentedStartLevel` reads every entry granting 1225474 from the trait configs and takes the start
level from TraitDefinitionEffectPoints (the 5-rank node and the single-rank nodes alike), where #150 assumed start level
= 10 - rank. The three log lines are in `everlake` too (TraitMgr.cpp, `ValidateConfig`). Merging #150 conflicts in
`GetClassicTalentedStartLevel` and would bring nothing new.

**Test.** None needed. #319 (Rate.Talent) is checked against #151's rule; see advocaite-319.md.

**Verdict:** drop (replaced by #151, already in `everlake`).
