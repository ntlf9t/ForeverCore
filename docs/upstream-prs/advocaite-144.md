# advocaite/TrinityCore#144: DB/Quest: Josephine Carson gives the Goldshire hunter taming quests

krakenunbound, 2026-10-27, commit 3764c48e7b. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Josephine Carson (251507, Goldshire hunter trainer) should give Taming the Beast 94792 -> 94863 -> 94864 ->
Training the Beast 94793 and take the three taming quests, but has no starter or ender rows.

**Check.**
- Already on `everlake`: 2026_10_24_61_world_forever_missing_quest_givers.sql (added upstream 2026-10-27) makes 251507 the starter of all four and the ender of the three taming quests, and also gives 94793 its ender,
  Isaac Chan (258930, from the quest text "speak to Isaac Chan in Goldshire"), which this pull request leaves out. It also
  limits the four quests to hunters.
- Applied on top, the file deletes and re-inserts the same 7 rows; no change.

**Test.** SQL. Load test (as in advocaite-123.md): applies with no error, the rows it writes already exist. Nothing to test
in game beyond what 2026_10_24_61 already does.

**Verdict:** drop (replaced by 2026_10_24_61).
