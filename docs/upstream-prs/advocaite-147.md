# advocaite/TrinityCore#147: .modify speed all also sets the backwards speeds

krakenunbound, 2026-10-27, commit 86408e7348. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** `.modify speed all <n>` leaves moving backwards at normal speed.

**Check.** True: `HandleModifyASpeedCommand` sets walk, run, swim and flight, not `MOVE_RUN_BACK`, `MOVE_SWIM_BACK` or
`MOVE_FLIGHT_BACK`. TrinityCore `master` is the same. The same handler also serves the bare `.modify speed <n>` (the
`""` entry of the speed table), so that one changes the backwards speeds too now. `.modify speed backwalk` is unchanged.
GM command only, needs `RBAC_PERM_COMMAND_MODIFY_SPEED_ALL` or `_SPEED`.

**Test.** None in `tests/`: three `SetSpeedRate` calls on a live player. In-game test for the PTR realm: `.modify speed all 3`,
then walk backwards, swim backwards and fly backwards. Expected: all three at 3x; `.modify speed all 1` puts them back.

**Verdict:** take.
