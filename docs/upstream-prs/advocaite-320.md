# advocaite/TrinityCore#320: World config: Rate.MoveSpeed.Player and Rate.MoveSpeed.Creature

Karrz1, 2026-11-07, commit 3ed935e928. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Server owners set `Rate.MoveSpeed.Player` and `Rate.MoveSpeed.Creature` and nothing happened: the server only
read `Rate.MoveSpeed`, and that never changed NPCs or mobs.

**Change.** `Rate.MoveSpeed.Creature` (default 1, min 0.01) scales `baseMoveSpeed` (NPCs and mobs). `Rate.MoveSpeed.Player`
is read as `Rate.MoveSpeed` and wins when both are set. Both multiply a new constant table `defaultBaseMoveSpeed`, so a
config reload sets the speeds again instead of stacking. `worldserver.conf.dist` lists both.

**Check.**
- **Defaults keep the old behaviour:** `defaultBaseMoveSpeed` has the same nine values as the two old tables, and with
  both rates at 1 both tables come out unchanged. Before, `baseMoveSpeed` was never written, so it stays the same.
- Readers: `Unit::GetSpeed`/`SetSpeed`, `UpdateSpeed` (the normalisation and minimum speed), and the charge speed in
  `MotionMaster` choose the table by `IsControlledByPlayer()`, so pets, guardians and charmed mobs use the player rate,
  everything else the creature rate. Nothing in the bot module reads either table.
- `creature_template` speeds are rates and get scaled. A script that sets an absolute speed with `SetSpeed(type, value)`
  is unaffected (the rate divides out).
- The `.Player` alias is probed with `GetFloatDefault(..., -1, quiet)`, so a realm without it logs nothing.
- After a reload units keep their current speed until something recalculates it (`UpdateSpeed` on an aura change, a
  mount); same as `Rate.MoveSpeed` before.
- The new `RATE_MOVESPEED_CREATURE` value shifts the later `Rates` enum values; they are not stored anywhere.

**Test.** `tests/game/MoveSpeedDefaults.cpp` (`[MoveSpeedDefaults]`): the default table holds the nine retail speeds and
equals both working tables, so a realm that sets neither option moves exactly as before. It guards the defaults; it
can't fail on the old code, which has no default table. The rates themselves need `World::LoadConfigSettings`: PTR
test with `Rate.MoveSpeed.Creature = 1.5`: mobs run 1.5x (a wolf chasing you), players unchanged; `.reload config`
twice: still 1.5x, not 2.25x; `Rate.MoveSpeed.Player = 1.2` beside `Rate.MoveSpeed = 1`: players at 1.2x.

**Verdict:** take.
