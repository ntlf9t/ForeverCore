# TrinityCore 0c7967d4ba: LaunchQuest bit only when there is no next quest to offer

Ovahlord, 2026-09-27. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** In `SMSG_QUEST_GIVER_QUEST_COMPLETE`, `LaunchQuest` (open the quest giver's list again) was set together with
`UseQuestReward` (show the next quest of the chain). For chain quests with `QUEST_FLAGS_AUTO_ACCEPT` the client then
opened both, and the quest window misbehaved. Now `LaunchQuest` is set only when `UseQuestReward` is not.

**Check.** Only which bit is set changes; the writer (`QuestGiverQuestComplete::Write`, four bits after the item reward)
is the one Everlake already sends to the 70862 client, with no Classic branch. Classic content has many chains that the
same NPC continues (`GetNextQuest` from the quest giver), so this is live on Everlake. Applied without conflict;
Forever's `SendQuestReward` around it is unchanged.

**Test.** None in `tests/` (needs a player and a creature). PTR check: turn in a quest whose follow-up the same NPC
gives (e.g. a Northshire chain): the next quest's text opens once, no second quest list behind it; turn in a quest with
no follow-up at an NPC with other quests: the list opens as before.

**Verdict:** take.
