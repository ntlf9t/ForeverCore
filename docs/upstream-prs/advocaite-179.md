# advocaite/TrinityCore#179: SmartAI: healers only heal allies while they are in combat themselves

dqhoang, 2026-10-27, commit a9c1c7d2fe. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Healer mobs that are near a fight but not in it heal the mobs fighting the player.

**Check.** True. `SMART_EVENT_FRIENDLY_HEALTH_PCT` used to need `me->IsEngaged()`. TrinityCore commit 1248bdffcb
("Allow SMART_EVENT_HEALTH_PCT to be triggered out of combat", 2025-04-18) changed it to `!me->IsInEvadeMode()`, so an
idle healer heals any friendly in range that is in combat and low on health, without joining the fight. TrinityCore
`master` still has the retail behaviour. The pull request puts back the old check for this event only;
`SMART_EVENT_HEALTH_PCT` (own health) keeps the retail rule. This is the behaviour TrinityCore had for years before
2025, so the risk is low. 339 `smart_scripts` rows in the 2026-10-14 world release use this event (Riverpaw Mystic
453, Murloc Oracle 517, Bloodscalp Mystic 701, ...); with the change none of them heals until it is in the fight itself.
A script that wants an idle NPC to heal others (a medic as scenery) would stop healing.

**Test.** None in `tests/`: the check sits in `SmartScript::ProcessEvent` and needs a creature with a script. In-game test for
the PTR realm: in Westfall pull one gnoll next to a Riverpaw Mystic (453) without pulling the Mystic. Expected: the
Mystic does not heal the pulled gnoll until it joins the fight; once it is in the fight it heals as before.

**Verdict:** take.
