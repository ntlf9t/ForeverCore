# TrinityCore c19adebd44: object rotations from angles via G3D::Quat::fromYPRAngles; QuaternionData::fromOrientation

Shauren, 2026-10-03. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `QuaternionData::fromEulerAnglesZYX` / `toEulerAnglesZYX` use `G3D::Quat`'s yaw-pitch-roll functions
instead of a round trip through `G3D::Matrix3`; the many callers that only have an orientation use the new
`fromOrientation` (a turn about Z).

**Check.** Every summoned or spawned game object's rotation goes through these (spell summons, duels, fishing bobbers,
`.gobject add`, scripts), so the rotation must not change. Yaw-pitch-roll in G3D is Z, then Y, then X, the same order
as `fromEulerAnglesZYX`; the test below compares the two over a grid of angles. `GetWorldRotation` returns the same
value as before (only written differently). Forever's own code calls `fromEulerAnglesZYX` (Warsong Gulch dropped flag)
with orientation only, which keeps working.

**Test.** `tests/game/QuaternionData.cpp` ([QuaternionData]): for 15 x 9 x 11 angle triples the new quaternion is a
unit quaternion and gives the same rotation matrix as `Matrix3::fromEulerAnglesZYX` (within 1e-5); `toEulerAnglesZYX`
gives angles of the same rotation back; `fromOrientation` is a unit quaternion about Z equal to the old
`fromEulerAnglesZYX(o, 0, 0)`. This guards against a change; it passes before and after, since none is intended.

**Verdict:** take.
