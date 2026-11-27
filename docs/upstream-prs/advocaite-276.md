# advocaite/TrinityCore#276: Guilds: the server no longer crashes at start after a guild rank was deleted

Karrz1, 2026-11-06, commit 883e17f83d. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Deleting a guild rank leaves a gap in the rank ids (0, 1, 3) while the orders close up (0, 1, 2).
`Guild::Validate` looked the ranks up by id 0..count-1, got a null pointer for the gap and crashed the world server at
every start. Also: the guild master rank can't be removed, and a rank with an empty name gets a default name.

**Check.**
- True for our code, and for TrinityCore `master` too (same `Validate` loop). `HandleRemoveRank` deletes by id and only
  renumbers the orders, so one rank delete from the guild window is enough; the next start crashes until the database is
  fixed by hand.
- Removing the guild master rank: the client doesn't offer it, but a crafted packet could, and the next start would then
  rebuild every rank. Blocking it is right.
- Default names: `GetDefaultRankName` falls back to "Rank N" when the string is empty, but `GetTrinityString` returns
  `<error>`, never empty, so the fallback can't happen. Harmless: rows 811-815 are in `trinity_string`.

**Our change on top.** The rank check moves into `IsGuildRankSetValid` (Guild.h), which takes (id, order) pairs, so it
can be tested without a guild or a database. Same rule as the pull request. Tabs are made only once the set is known
good.

**Test.** `tests/game/GuildRankSet.cpp`: a new guild's ranks, ranks after a delete (ids 0, 1, 3, 4; orders 0-3), load
order, no guild master, a gap or double in the order. Run against the old rule (ids 0..count-1 must exist) on 2026-11-08, every
delete case fails, and so do the gap and double checks: the old check never looked at the orders at all. With the
change all pass.

**Verdict:** take, with our change on top.
