# TrinityCore e5c9acdf34: battlegrounds found by their full queue id

Shauren, 2026-10-25. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** A battleground instance remembers the queue that made it (`Battleground::m_QueueID`; arena type and rated
are read from it). `BattlegroundMgr::GetBattleground(instanceId, queueId)` only returns an instance made by that queue,
and the free-slot lists are one per queue instead of one per map, so a queue only invites into its own instances (a
player queued for Warsong Gulch is no longer put into a Warsong Gulch match the random queue made). Templates are found
by map plus the solo-shuffle / brawl / solo-RBG flags; start locations are read for single-map templates only.

**Check.**
- Conflicts, both resolved keeping Forever's code:
  - `BattlegroundMgr.cpp` (template loader): Forever logs a template with no map (Karrz, advocaite #280); kept, after
    TrinityCore's new map key.
  - `BattlegroundQueue.cpp` (`BattlegroundQueueUpdate`): Forever's bot ordering (real players invited first; instances
    with a real player filled first) kept as it was, now over the queue's own free-slot list instead of a loop over the
    template's maps.
- Forever code that would not build, fixed in our commit right after ("Forever code: battleground lookups by queue"):
  the invite reminder's `OnPlayerBattlegroundInvite` hook used the removed `m_BgTypeId` (now
  `m_QueueId.BattlemasterListId`, the same value); the bot module walked per-map free-slot lists in four places and
  looked instances up by type in three. Two small additions to `BattlegroundMgr` for it: `GetAllBGFreeSlotQueues()`
  and `FindBattlegroundByInstanceId()`. Because a queue now only fills its own instances, the bot top-up queues bots
  in the instance's own queue and the "make room for a real player" search only looks at instances of that player's
  queue; for instances made by their own battleground's queue nothing changes.
- 70862 data: Forever's `battleground_template` rows that exist in 70862 BattlemasterList are 1, 2, 3 and 32 (Random
  Battleground). BattlemasterList flags in 70862 are 0, 8 and 24; none has the bits the new map key uses (0x4, 0x20,
  0x200), and none had the old 0x4 (`ObsoleteDoNotList`, now `IsSoloShuffle`). Nothing in our code used the old name.
- Found while checking, fixed in our own commit: `.appear` / `.summon` into a battleground set the queue id to none, so
  the moved player's `GetBattleground()` would now find nothing; they take the other player's battleground queue id.
  TrinityCore master has the same two lines.
- Login inside a battleground looks the instance up by the saved queue id (`character_battleground_data.queueId`,
  already saved), so a relog still finds it.

**Test.** None in `tests/` (needs live battlegrounds). Build with the bot module objects (named in the UBSan run).
PTR checks: queue Warsong Gulch alone and with bots, get invited, enter, leave and requeue; relog inside the match;
queue the Random Battleground and see that bots fill that match too; `.appear` to a player inside a battleground, then
leave the battleground: the GM is sent back to where they came from.

**Verdict:** take, with our fixes for Forever's code and for `.appear` / `.summon`.
