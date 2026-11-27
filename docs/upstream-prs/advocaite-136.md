# advocaite/TrinityCore#136: Area triggers: an attached trigger whose target is not on the map yet starts at its caster

krakenunbound, 2026-10-27, commit 65a0312564. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Walking through an Energizing Vortex (Zephras Isle) never gives Blessing of Zephras (1258510). Energizing Winds
(1299003) creates an attached area trigger while the vortex is being added to the map. `GetTarget()` can't find the vortex
yet, so `CalculateWorldPositionAndRotation` keeps the trigger's local offset as its world position: the trigger is
created at 0, 0, 0, a cell no player is in, so it never updates and never follows the vortex.

**Check.** True for our code, and TrinityCore `master` has the same branch (attached, target found: move; target not
found: nothing). `GetTarget()` is `ObjectAccessor::GetUnit(*this, _targetGuid)`, which only finds units already in the
map's object store, so an aura applied during `AddToMap` misses it. The fix falls back to
`GetStationaryPosition()` plus the offset, the same origin the non-attached stationary branch uses; once the target is
found, `UpdatePositionAndRotation` moves the trigger to it and relocates the stationary position. The fallback skips the
target's facing, which only matters until the first update. Two callers: the create path (initial position) and
`UpdatePositionAndRotation`; both are fine with the fallback.

**Test.** None in `tests/`: the method is private and needs an `AreaTrigger` with update fields and a target. In-game test
for the PTR realm: walk through the Energizing Vortices near Valanaar on Zephras Isle. Expected: Blessing of Zephras
(+40% run speed); `.debug` area trigger list shows the vortex triggers next to their vortex, not at 0, 0, 0.

**Verdict:** take.
