# advocaite/TrinityCore#186: Quest: The Forgotten Pools

dqhoang, 2026-10-28, commit 0249b30d49. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Exploration quests complete by an area trigger and have no `quest_objectives` row, so the log line never ticks.
Adds one display-only objective (type 10, `QUEST_OBJECTIVE_AREATRIGGER`) to The Forgotten Pools (870, trigger 216) and 18
more (ObjectID -1, "whichever trigger completes it"), with made-up ids 9000xxx0.

**Check.**
- Code: `WorldSession::HandleAreaTriggerOpcode` sets every incomplete type 10 objective whose `ObjectID` is -1 or the
  trigger, then calls `AreaExploredOrEventHappens`. `CanCompleteQuest` needs every objective done, so an objective that
  nothing sets would block the quest. Checked: no SmartAI (`CALL_AREAEXPLOREDOREVENTHAPPENS` / group event) or C++ script
  completes any of the 19 quests another way, so for quests whose trigger works nothing breaks.
- But live Forever has real objectives for 15 of the 19 (its own quest answers, EG Link 70790/70862), with other ids, and
  for three of them another kind:
  - type 10 with the trigger id: 870 -> 385484 (216), 76 -> 385473 (87), 201 -> 385476 (98), 944 -> 385489 (223),
    1149 -> 385491 (246), 1265 -> 385516 (1667), 1448 -> 385492 (362), 1699 -> 385494 (482), 2240 -> 385513 (822),
    4811 -> 385519 (2486);
  - 62 The Fargodeep Mine -> 385474, type 19 (area trigger entity 44590), quest flags 8;
  - 273 Resupplying the Excavation -> 385478, type 19 (entity 45628), flags 8;
  - 984 How Big a Threat? -> 385490, type 0 (credit NPC 277995), flags 8;
  - 578, 1658, 2989, 4842, 6025, 8286: not seen by EG Link yet.
- For 62, 273 and 984 the old triggers (88/197, 171, 231-238) aren't in the 70862 client's AreaTrigger table, so those
  quests can't complete on `everlake` now, and a type 10 objective doesn't change that.
- The made-up ids would collide with the world import (wow-project-everlake, slice 1 adds objective rows from live data):
  a quest would get both 9000xxx0 and live's 3854xx, and the one never credited would block it. 273 also conflicts with
  #270 (taken here, with live's 385478).

**Test.** SQL. Load test (as in advocaite-123.md): 1 + 18 rows inserted, no error (8 warnings: `VALUES()` in ON DUPLICATE
KEY UPDATE is deprecated in MySQL 8.0).

**Verdict:** hold. The right rows are live's objective ids and trigger ids above; they belong in the world import (which
already writes objective rows from these sources), with 62, 273 and 984 needing their area trigger entities or credit NPC.
