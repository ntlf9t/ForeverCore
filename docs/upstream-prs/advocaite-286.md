# advocaite/TrinityCore#286: Area triggers: polygon triggers facing north get their corners

Karrz1, 2026-11-06, commit 36fe3975d0. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A new area trigger remembers "no rotation" as the rotation already applied, so `UpdatePolygonVertices` returns
early and the vertex list stays empty for every polygon trigger with orientation 0. Quest 98319 Secure the Mountain
(trigger 44117) can never complete.

**Check.** True, also in TrinityCore `master`. `_verticesUpdatePreviousRotation` is default-constructed as
`QuaternionData()`, which is the identity (0, 0, 0, 1). A trigger facing 0 gets `_rotation` = `fromYPRAngles(0, 0, 0)`,
also the identity, so the "rotation didn't change" shortcut fires on the first call and `_polygonVertices` stays empty;
`IsInPolygon2D` with no vertices is never true, so nobody enters. Morphing polygons (`VerticesTarget`) skip the
shortcut and were fine. The fix starts the previous rotation at (0, 0, 0, 0), which no rotation can equal, so the
first update always fills the vertices. Nothing else reads the member.

**Test.** None in `tests/`: the member and `UpdatePolygonVertices` are private and need the trigger's shape update fields. In-game
test for the PTR realm: take quest 98319 Secure the Mountain and walk into the area of trigger 44117. Expected: the
objective completes.

**Verdict:** take.
