# TrinityCore 3283d1a87b: refactors ported from 3.3.5

Shauren, 2026-10-20. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Brings over clean-ups first made on 3.3.5: `/roll` and the dice items use `int32` (`irand`); guild rank right
0x40 is renamed `GR_RIGHT_ROSTER` -> `GR_RIGHT_LEAVE`, and new ranks (default ranks of a new guild and ranks added later)
get it; `CancelAutoRepeat` moves up in `CombatPackets`; small tidy-ups (petition signatures built in place,
`ClearTarget` buffer size, `GossipMenu`, `Spline`).

**Check.**
- `/roll`: `CMSG_RANDOM_ROLL` carries `int32` min and max and the handler only checks `Min > Max` and `Max > 1000000`. The
  old `DoRandomRoll(uint32, uint32)` turned a negative minimum into a huge one and called `urand` with min > max, which
  is `ASSERT(max >= min)` in `Random.cpp`: a roll packet with Min < 0 <= Max stopped the worldserver. With `irand` it
  rolls normally. Not tried in game whether the client lets `/roll -5 5` through.
- Guild right 0x40: nothing in the server checks it (grep of `src/`). It is part of the rank rights the client gets; with
  it set, the Forever client's handling is not known (its meaning in the Classic UI was not checked). Only new guilds and
  newly added ranks get it; existing ranks keep their rights. Conflict in `Guild.cpp`: Forever's
  `HandleAddNewRank` gives an empty rank name the default name; kept that and added `GR_RIGHT_LEAVE` to its rights.
- Conflict in `CombatPackets.h/.cpp`: Forever still has `HealthUpdate` next to `CancelAutoRepeat` (blocked for the Classic
  client in `ClassicOpcodes`, kept); took TrinityCore's move of `CancelAutoRepeat`, left `HealthUpdate` where it was.
  Same bytes for both messages.
- No Forever code used `GR_RIGHT_ROSTER` or calls `DoRandomRoll` besides the roll handler and the two dice scripts.

**Test.** None in `tests/` (needs a player). PTR checks: `/roll`, `/roll 1 6`, a dice toy; make a new guild and add a
rank: members can still leave the guild.

**Verdict:** take.
