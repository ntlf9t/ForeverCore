# TrinityCore bbded1b3ee: area trigger roll, pitch and yaw are no longer folded into 0..2π

Shauren, 2026-09-27. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `Roll`, `Pitch`, `Yaw` (and the target ones) of `areatrigger_create_properties` were passed through
`Position::NormalizeOrientation`, which folds them into [0, 2π); negative angles are valid and now kept.

**Check.** The fold keeps the rotation itself (−0.5 and 2π − 0.5 are the same turn), so it can only matter where the
angles are interpolated, from `RollPitchYaw` to `TargetRollPitchYaw`. Forever's world release
`forever-tdb-2026-10-14` has 407 `areatrigger_create_properties` rows: every `Roll`, `Pitch`, `Yaw` is 0, and the 23
rows with target angles have 0, 0, 0. Nothing changes for Everlake's data. Taken to stay in line (later area trigger
commits touch the same loader).

**Test.** None: no Forever row is affected.

**Verdict:** take.
