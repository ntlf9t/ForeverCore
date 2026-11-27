# advocaite/TrinityCore#300: Guilds: 70790 client reads a surname in member left and new leader messages

Karrz1, 2026-11-07, commit d5da05b39d. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Kicking a guild member or a member leaving crashed every guild member's 70790 client: the client reads a
surname after each name in SMSG_GUILD_EVENT_PLAYER_LEFT and SMSG_GUILD_EVENT_NEW_LEADER and ran past the end.

**Check.**
- True for our code: both messages write the retail layout, while `GuildEventPlayerJoined` and the roster already write
  the Classic surname (9 bit length after the name). The change does the same, with surnames from the character cache
  (empty for an unknown guid), and flushes the bit block before the remover's guid. Not build-gated, like PLAYER_JOINED.
- Callers: `Guild::SendEventPlayerLeft` (leave, kick, and the old leader leaving) and `Guild::SendEventNewLeader` (set
  leader, leader change on leave, guild master replaced) in `Guild.cpp`. Nothing else builds these messages; the bot
  module doesn't read them.
- TrinityCore `master` has no surnames (retail).

**Test.** `tests/game/GuildEventSurname.cpp` `[GuildEventSurname]`: kicked (remover and leaver), left, and new leader,
read back in the order the client's reader does as the pull request describes it, all bytes used. The old writer fails
(13 bits instead of 31, the reads run off the end). PTR: kick a member, have one leave, pass leadership, with another
70862 client in the guild; no crash, names shown.

**Verdict:** take.
