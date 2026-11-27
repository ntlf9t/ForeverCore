# advocaite/TrinityCore#285: Movement: a player who falls out of the world goes to the graveyard alive

Karrz1, 2026-11-06, commit 201398618c. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Falling below the map's minimum height with no floor under the player killed the character. Now the player
is sent to the nearest graveyard instead, once per teleport.

**Check.**
- The path: `HandleMovementOpcode` → under the map (our fork already ignores it when a WMO floor holds the player up) →
  battleground hook → was `EnvironmentalDamage(DAMAGE_FALL_TO_VOID)` + `KillPlayer`, now `RepopAtGraveyard()` while alive
  and not already teleporting. `UpdatePosition(movementInfo.pos)` runs before this block, so `RepopAtGraveyard` sees the
  under-map Z: it marks the teleport `TELE_REVIVE_AT_TELEPORT` (a no-op for a living player) and, with no graveyard,
  teleports home. `IsBeingTeleported()` stops the flood of falling packets from starting a second teleport.
- TrinityCore `master` still kills the player. This is a design change, not a bug fix.
- **Risk:** a free escape. A player who can get under the world (wall-climb, a known hole) on purpose now lands at the
  graveyard alive, out of combat, with no death and no durability loss. Inside a dungeon `RepopAtGraveyard` uses the
  instance entrance, so falling out of a dungeon puts the player outside it alive. Before, the same fall cost a death.
- Players only: bots send no movement packets, as the pull request says.

**Test.** None in `tests/`: it needs a session and a map. In-game test for the PTR realm: `.go xyz` far below the ground in
Elwynn (for example 0 0 -1000 0). Expected: you appear at the nearest graveyard alive, once, with no death; in a
battleground the battleground's own under-map handling still runs.

**Verdict:** take. The user may want to decide on the escape risk (a death in combat, a repop out of combat would close it).

**Decision (user, 2026-11-09): taken with a split** (fork PR "decisions 2026-11-09"). Out of combat in the open world the
player goes back to the graveyard alive, as #285 does. In combat, or inside any instance (dungeon, raid, arena; battlegrounds
handle it first), the player dies as before #285, so a deliberate fall is no free escape. The rule is
`Trinity::FallOutOfWorld::For` (`Entities/Player/FallOutOfWorld.h`), tested in `tests/game/FallOutOfWorld.cpp`
(`[FallOutOfWorld]`). PTR: fall through a hole out of combat (graveyard, alive); again with a mob attacking (dead); and in a
dungeon (dead).
