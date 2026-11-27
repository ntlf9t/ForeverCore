# advocaite/TrinityCore#178: Pets: a flight path dismisses the pet and landing brings it back

dqhoang (Duy Hoang), 2026-10-27, commit 4e77041552. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Taking a flight left the pet behind; it fell out of visibility range and was removed, with its reagent (a soul
shard) refunded. Classic dismisses the pet for the flight and brings it back on landing.

**Check.** True: `StartTaxiMovement` mounts and moves the player but leaves the pet, and `Pet::Update` removes a pet past
the visibility range (`Remove(PET_SAVE_NOT_IN_SLOT, true)`). TrinityCore `master` has the same `StartTaxiMovement`. The
fix calls `UnsummonPetTemporaryIfAny()` (pet saved as current, number kept) before mounting. On landing,
`FlightPathMovementGenerator::DoFinalize` calls `Dismount()`, which calls `ResummonPetTemporaryUnSummonedIfAny()`; the
landing teleport then moves the pet with the player. A multi-leg flight (`ContinueTaxiFlight`) passes through
`StartTaxiMovement` again with no pet out, which is harmless.

**Test.** None in `tests/`: it needs a flight. PTR: fly with a hunter pet and with a warlock demon (count soul shards);
on landing the same pet is back, with no shard used or refunded. Also log out mid-flight and back in: the pet must come
back on landing, not be left at the start.

**Verdict:** take.
