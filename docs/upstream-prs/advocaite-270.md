# advocaite/TrinityCore#270: DB/Quest: Resupplying the Excavation completes at Huldar

finelam, 2026-10-31, commit 9fdec093c3. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Resupplying the Excavation (273) has `QUEST_FLAGS_COMPLETION_AREA_TRIGGER` (0x4) and relies on area trigger 171,
which is not in the client's AreaTrigger table, so the quest never completes and Huldar (2057) shows an empty window,
blocking the chain to 454. Clears the flag (flags 8), adds objective 9000273 "Find Huldar, Miran, and Saean" (kill credit
2057) and gives Huldar a SmartAI out-of-combat line-of-sight event (20 yd) that gives the credit.

**Check.**
- True here: 273 has flags 12 and `areatrigger_involvedrelation` 171 only; 171 is not in the 70862 client's AreaTrigger
  table. Huldar has no AI and no SmartAI rows, so the DELETE removes nothing else.
- Live Forever's quest answer (EG Link 70862) shows how live does it: flags 8 (as this pull request sets), and one objective,
  385478, type 19 (`QUEST_OBJECTIVE_AREA_TRIGGER_ENTER`) on area trigger 45628, amount 0. The pull request's objective id and
  kind are made up; the world import (slice 1 adds live objective rows) would add 385478 next to 9000273, and 385478 would
  then block the quest.

**Our change on top.** `sql/custom/world/2026_11_08_71_world_everlake_resupplying_the_excavation_trigger.sql` keeps the
flag change and replaces the rest with live's objective 385478 (type 19, object 45628) and a server-side area trigger 45628
(template flag 1, custom create properties 1310001, 20 yd sphere, static spawn 1310001 on Huldar's spawn at -5762.77,
-3433.36, 305.765), the same setup #125 uses for Secure the Mountain and its author tested in game. Huldar's SmartAI row and
AIName go back to what `everlake` had. Type 19 stores a flag, so amount 0 completes on entry. The trigger's real size and
spot are not known.

**Test.** SQL. Load test (as in advocaite-123.md): #270's file: 1 quest changed, 1 objective and 1 SmartAI row inserted;
then ours: 1 SmartAI row and objective 9000273 deleted, objective 385478, template, create properties and spawn inserted, no
error. The branch's files give the same checksum for every world table in both orders. PTR check: with 273, walk up to
Huldar on the Loch Modan road; the objective completes within 20 yd and Huldar takes the quest and offers 454. A
character who already has 273 needs to walk away and back.

**Verdict:** take, with our change on top.
