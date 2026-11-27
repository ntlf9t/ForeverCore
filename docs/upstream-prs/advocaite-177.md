# advocaite/TrinityCore#177: Pets: a following pet left behind catches up to its owner

dqhoang (Duy Hoang), 2026-10-27, commit ffa26444f4. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A pet that cannot path to its owner (the Undercity lifts) stays where it is. Out of combat, on follow, with
neither on a transport and more than 40 yards away, it now teleports to its owner.

**Check.** True: `Pet::Update` only removes a pet past the visibility range; nothing brings a stuck pet back. TrinityCore
`master` has nothing for it either. The check sits after the owner-lost and wrong-owner checks, so `owner` is valid.
Excluded, rightly: possessed pets (Eyes of the Beast), pets on stay or in combat, either side on a transport (the lift is a
transport while they ride it), the owner on a flight path or falling. It teleports to the owner's exact spot (not the
follow offset), once: the next update the distance is 0. A fast owner (a mount on a road where the pet lags) could see a
pet blink now and then; a pet keeps the owner's speed, so it should not.

**Test.** None in `tests/`: it needs a map and a moving owner. PTR: take the Undercity lift up with a hunter pet or a
warlock demon; at the top the pet must appear beside you within a second. Ride a mount for a minute on open ground: the
pet must not blink.

**Verdict:** take.
