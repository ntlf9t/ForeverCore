# advocaite/TrinityCore#316: Quests: A Light in the Darkness after The Damned, Divine Grace/Confounding Flash exclusive

Karrz1, 2026-11-07, commit 6d7cad76e2. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** From QuestieDB's Forever corrections of 5 November: A Light in the Darkness (98389) needs The Damned (376);
Divine Grace (94774) and Confounding Flash (94817) get exclusive groups 94773 and 94817 so the rest of each set joins
them when added.

**Check.** QuestieDB `master` c1b50fefb1 (GPL-3.0, public): 98389 `preQuestSingle` {376}; 94774 `exclusiveTo`
94773 and 94775-94779; 94817 `exclusiveTo` 94821-94826. The rows match. In our world 98389, 376, 94774 and 94817 exist;
98389 had no addon row, so it was offered before 376. Only 94774 and 94817 of the two sets exist here, so the groups do
nothing yet, as the pull request says. The `UPDATE`s on 94774 and 94817 only work when the addon row exists: in our
world it does for both (checked after applying).

**Test.** Applied twice to a scratch MySQL 8.0 world (TDB + `everlake` updates): no errors; 98389 PrevQuestID 376,
94774 ExclusiveGroup 94773, 94817 ExclusiveGroup 94817. PTR: Aramis Hammerhand in Deathknell offers 98389 only after
The Damned is turned in.

**Verdict:** take.
