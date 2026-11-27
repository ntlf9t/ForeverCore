# advocaite/TrinityCore#180: sql/world: "That Shadowvale Green Elixir" bottles go into the bags

dqhoang, 2026-10-27, commit f61d0dc8a9. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Objective 470252 of That Shadowvale Green Elixir (95314) is quest-bound (`Flags2` & 1), so looted Bottles of
Whispering Elixir (268801) count but never reach the bags. Clears the flag.

**Check.**
- The flag is what live Forever does, not a data error: 470252 comes from the 70124 sniff of Forever, and 175 of the 206
  item objectives in the sniff have `QUEST_OBJECTIVE_FLAG_2_QUEST_BOUND_ITEM`. Live's quest answer (EG Link 70862) has the
  same objective id, item, count and storage index.
- The core supports it: `QUEST_OBJECTIVE_FLAG_2_QUEST_BOUND_ITEM` is "not stored in inventory" by design;
  `Player::CanRewardQuest` skips the bag count for such objectives, `AdjustQuestObjectiveProgress` keeps the counter, and
  loot only bumps the counter. "Never reach the bags" is the intended behaviour.
- The pull request doesn't say anything failed besides that (its test: "quest completable" after the change). If the quest
  can't be turned in with the bottles quest-bound, that is a core bug to fix for all 175 objectives, not this one row.

**Test.** SQL. Load test (as in advocaite-123.md): 1 row changed, no error. PTR check worth doing before anything else:
loot 8 bottles in Shadowvale and turn 95314 in to Carolai Anise with the bottles counted but not in the bags.

**Verdict:** drop (changes sniffed live data to fix intended behaviour).

**Later note (same day).** #310 (group F batch, file `2026_11_06_60_world_forever_quest_items_in_bags.sql`) clears the
quest-bound bit on every item objective, after a player report on Karrz1's realm: with the bit our core only counts the
item in the quest log, the 1.60 client does not show that counter, and 11 Zephras Isle quests could not be finished.
That covers this quest too, so dropping #180 loses nothing. If #310 is held instead, revisit this one. PTR check for
both: loot a quest item for one of those Zephras quests and for this quest; it must land in the bags and count.
