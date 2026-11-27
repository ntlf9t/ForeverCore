# TrinityCore 67816ef39a: formations follow a leader on an exact spline path

Shauren, 2026-11-08. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** A creature whose waypoint path has the `ExactSplinePath` flag moves along all its points as one spline;
when it passed a point and started the next, its formation members were not told, so they stopped following.

**Check.** True: the continuous-segment branch of `WaypointMovementGenerator::DoUpdate` called `WaypointStarted` but
not `SignalFormationMovement`, which the normal branch calls when a new point starts. The fix adds the call there.
Live on Everlake: 572 of the 13,173 `waypoint_path` rows in `forever-tdb-2026-10-14` have flag 2 (`ExactSplinePath`).

**Test.** None in `tests/`: it needs a map, a creature group and a moving leader. PTR check: find a creature group
(`creature_formations`) whose leader walks a path with `waypoint_path.Flags & 2`, and watch it pass two points: the
members keep following.

**Verdict:** take.
