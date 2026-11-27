# advocaite/TrinityCore#125: DB/Quest: Secure the Mountain finds Mountaineer Cornelius

finelam, 2026-10-24, commit 11ecaa5c74. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Secure the Mountain (98319) never progresses. Its only objective is `QUEST_OBJECTIVE_AREA_TRIGGER_ENTER` (19) on
area trigger 44117, and no area trigger 44117 exists. Adds a server-side trigger template 44117, a custom 8 yd sphere and a
static spawn on Mountaineer Cornelius's body (gameobject 672497) in the Grizzled Den.

**Check.**
- True here: objective 477368 is type 19 on 44117; `everlake` has no `areatrigger_template` 44117 and 8 static
  `areatrigger` spawns, none for it. Live Forever's quest answer (EG Link 70862) has the same objective: 477368, type 19,
  object 44117, amount 0. So the server-side trigger is the live mechanism, only its size and spot are guessed.
- Code path: `AreaTrigger::HandleUnitEnter` calls `UpdateQuestObjectiveProgress(QUEST_OBJECTIVE_AREA_TRIGGER_ENTER,
  GetEntry(), 1)`; type 19 stores a flag, so amount 0 is fine (`IsStoringFlag`). `ObjectMgr` accepts the objective once a
  template with id 44117 exists. Template flag 1 = `AreaTriggerFlag::IsServerSide`, not sent to the client.
- The spawn sits exactly on gameobject 672497's spawn (-5506.33, -317.141, 352.31, map 0).
- Ids: create properties and spawn 1310000 (custom). Free on `everlake`; #270's fix on this branch uses 1310001.

**Test.** SQL. Load test (as in advocaite-123.md): no error; 1 template, 1 create-properties and 1 spawn row inserted; same
result in fresh-world order. The author tested it in game (70450). PTR check: with 98319, walk to Cornelius's body in the
Grizzled Den; "Mountaineer Cornelius found" completes within about 8 yd.

**Verdict:** take.
