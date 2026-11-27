# advocaite/TrinityCore#326: SmartAI: an instant timed action list called from inside a list runs at once

MShkolenko, 2026-11-08, commit 5a9fa2a48f. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The VMaNGOS import has timed action lists that start another list (action 80 or 87 inside source type 9). The
core refuses every such call ("trying to overwrite timed action list from a timed action"), so the called talk or
summon never happens: 1144 such log lines in 2 hours with 250 bots. In VMaNGOS the called script ran at once.

**Change.** When `SetTimedActionList` is called while a list is being iterated and the called list is instant (every entry an
update event with min and max 0 and no link), its entries run right there as update events, with the running list's
invoker when the action had none. Delayed lists still log the error. Nesting is capped at 4 with a `thread_local`
counter, so a cycle in the data stops.

**Check.**
- World release 2026-10-14: 66 rows in 48 lists call another list, as claimed. Of the 66 calls, 47 call only instant
  lists (now run) and 19 call lists with delays (still refused, still logged).
- Why the old code refuses: `mTimedActionList` is being iterated, and replacing it would free the holder being run. The
  pull request never touches `mTimedActionList`; it runs copies from `GetScript`, so that hazard is avoided.
- The copies get the event type from the caller's timer type (or the running list's for the random actions 87/88),
  so `ProcessEvent` keeps its in/out-of-combat checks; phase masks and conditions are checked as usual.
  `RecalcTimer` only touches the copies.
- A list that targets another creature runs on that creature's own script, which isn't iterating, so it takes the
  normal path as before.
- Thread safety: maps update on their own threads and one script is only run by its map's thread, so a per-thread depth
  counter is right.

**Test.** None in `tests/`: it needs a creature running SmartAI on a map. In-game test for the PTR realm: watch creature 5662's
waypoint 2 (list 950000645 calls the random talk 950000643/644), or any of the 47. Expected: the talk happens, and
`grep -c "overwrite timed action list" Server.log` over an hour drops to the 19 delayed callers.

**Verdict:** take.
