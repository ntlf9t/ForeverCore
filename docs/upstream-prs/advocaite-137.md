# advocaite/TrinityCore#137: Quests: completing a tracking quest no longer closes the open gossip window

krakenunbound (The Kraken), 2026-10-26, commit 262cc4a8e4. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A hidden tracking quest (QUEST_FLAGS_TRACKING_EVENT) completed during a gossip conversation (a SmartAI gossip
select that marks a step done) closed the conversation: the next gossip page or the vendor did not open.

**Check.** True. `Player::CompleteQuest` rewards a tracking quest at once with `RewardQuest(..., this, ...)`. With the
player as quest giver, `RewardQuest` takes the `questGiver->IsWorldObject()` branch: it looks for a next quest from the
player and calls `PlayerTalkClass->ClearMenus()`, which drops the open menu. With `nullptr` that branch is skipped; LFG and
scenario rewards already pass `nullptr`. TrinityCore `master` has the same `this`.
- One thing that would break: `RewardQuest` sends a reward mail with `MailSender(questGiver)` when the quest has a mail
  template but no `quest_mail_sender` row, and `MailSender(Object*)` dereferences the sender. In the world release
  (`forever-tdb-2026-10-14`), none of the 4643 tracking quests has a reward mail, so it can't happen today; a tracking quest
  given a reward mail later would crash. Same latent risk as the LFG path.

**Test.** None in `tests/`: it needs a player in a gossip conversation. PTR: an NPC whose gossip completes a tracking
quest and then opens a vendor or a next page (the pull request's case); the vendor/page must open.

**Verdict:** take.
