# advocaite/TrinityCore#263: Horde Quest 5727 "Hidden Enemies"

dqhoang, 2026-10-29, commit 591f23bd18. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Hidden Enemies (5727, Thrall) has one map blob, on Thrall's hall, so the map doesn't show Neeru Fireblade (3216),
whom the player has to see. Moves the blob to Neeru in the Cleft of Shadow (1801, -4375, -17) with `ObjectiveIndex` -1 and
`Flags` 1, the shape quest 5729's blob uses.

**Check.**
- On `everlake`: one `quest_poi` row (WotLK data, build 12340, `ObjectiveIndex` -1, `Flags` 3, UiMap 1454) at
  1929, -4159 = Thrall. 5729's blob is at 1801, -4375, the same spot the pull request uses; Neeru's live position
  (EG Link) is 1801.1, -4378.4. Two UPDATEs, one row each; nothing else changes.
- The quest completes through Neeru's gossip (VMaNGOS SmartAI on 3216, quest flag 2 = completion event); no objective.
  Live Forever's quest answer (EG Link 70862) has one: 480284, type 0, Neeru (3216), "Gauge Neeru Fireblade's reaction",
  quest flags 0. `everlake` has no objective for 5727 at all. That gap is older than this pull request and is the world
  import's to fill; once 480284 is in, the POI should have an objective blob at Neeru and the turn-in at Thrall.
- Trade-off: with one blob, the map now points at Neeru also after the talk, when the player has to go back to Thrall.
  Thrall gave the quest, so that is the smaller loss.

**Test.** SQL. Load test (as in advocaite-123.md): 2 rows changed, no error; same result in fresh-world order. PTR check:
with 5727, the Orgrimmar map marks the Cleft of Shadow.

**Verdict:** take. Note for the world import: objective 480284 is missing.
