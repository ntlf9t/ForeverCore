# advocaite/TrinityCore#288: Login: a character saved on a boat or zeppelin between two continents logs in on it

Karrz1, 2026-11-04, commit cdb8530d98. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A character that logs out on a zeppelin or boat and logs in after it has crossed to the other continent is sent
to its hearthstone: the ship is not on the saved map any more.

**Check.** True. `Player::LoadFromDB` looks for the transport only on the saved map (and follows it to its next map when
it is about to leave); a ship that has already moved to the other map is not found, and the player goes home
(`RelocateToHomebind`). TrinityCore `master` has the same code. The fix looks up the transport spawn
(`sTransportMgr->GetTransportSpawn(transguid)`: the saved guid is the spawn id, as `Map::GetTransport` uses it) and its
template's route maps, and takes the first one that has the ship. These are continents, which `CreateMap` returns without
creating an instance. It runs in the login callback like the existing lookup on the saved map, so it touches maps the same
way. The usual transport-offset checks then apply.

**Test.** None in `tests/`: it needs live transports on two maps. PTR: board the Orgrimmar - Undercity zeppelin (or the
Menethil - Theramore boat), log out on deck before it leaves, wait until it has crossed (2-3 minutes), log in: you are on
the ship at the far dock, not at your inn.

**Verdict:** take.
