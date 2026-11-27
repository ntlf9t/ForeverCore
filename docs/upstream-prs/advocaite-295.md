# advocaite/TrinityCore#295: SmartAI: a completed follow credits the followed player

Karrz1, 2026-11-06, commit ee6a8ba8f8. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** `SmartAI::StopFollow` cleared the follow target and the credit type before using them, so a completed
`SMART_ACTION_FOLLOW` never credited anyone and Follow Completed had no invoker.

**Check.** True, and TrinityCore `master` has the same order: `_followGUID.Clear()` and `_followCreditType = 0` run first,
then `ObjectAccessor::GetPlayer(*me, _followGUID)` looks up an empty guid and always gets null. `followCredit` was
already saved with `std::exchange`; the pull request saves the guid and the credit type the same way. Only caller with
`complete = true`: `UpdateFollow`, when the follower reaches a creature of `_followArrivedEntry`.

**Our change on top.** With the player found again, a follow row with credit 0 (follow only, used just to fire Follow
Completed) would call `RewardPlayerAndGroupAtEvent(0, me)`. `KilledMonsterCredit(0, guid)` takes the follower's own
entry from the guid and counts it as a kill for achievement criteria. The reward is now skipped when the credit is 0;
Follow Completed still gets the player as invoker.

**Test.** None in `tests/`: it needs a creature with SmartAI, a player and a grid search. In the 2026-10-14 world release 99
rows use `SMART_ACTION_FOLLOW`; 2 have a credit (Proto-Drake 23689, Enraged Kodo 36094, both retail content), 97 have
none and are the ones our change keeps from giving the follower's entry as a kill. In-game test for the PTR realm: any
follow script with an end creature (`SELECT entryorguid, action_param3 FROM smart_scripts WHERE action_type = 29 AND
action_param3 <> 0`), walked to the end. Expected: the NPC's Follow Completed actions run with the player as invoker
(its talk names the player); with a credit, the objective completes for the player and the group nearby.

**Verdict:** take, with our change on top.
