# advocaite/TrinityCore#299: Classic 70790: guild window invites reach the server

Karrz1, 2026-11-07, commit 27944e3346. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The guild window's Invite sends CMSG_GUILD_INVITE_BY_NAME as 0x440034, which our table read as
PARTY_INVITE_RESPONSE. The pull request swaps the pair: 0x440034 = GUILD_INVITE_BY_NAME, 0x440035 = PARTY_INVITE_RESPONSE.

**Check.**
- The 0x440034 half is right: the packet log shows a 9 bit name length + 1 bit + the name, the GuildInviteByName layout,
  and EmuForever's client map (independent) also has GUILD_INVITE_BY_NAME at 0x440034. Index 0x34 is below every
  70291/70790 insert, so the wire number is the table key.
- The 0x440035 half is a guess ("not seen on the wire yet"). EmuForever puts PARTY_INVITE_RESPONSE at 0x440032 and
  DF_PROPOSAL_RESPONSE at 0x440035. 0x440032 is not in our table, so the group rule already maps it to
  PARTY_INVITE_RESPONSE (0x430032), before and after this change: party invite answers keep working if EmuForever is
  right. If it is, 0x440035 (a dungeon finder answer) is now read as a party invite answer; the handler ignores it when
  no invite is pending.
- `/ginvite` working before is odd if both send the same message; not explained in the pull request.

**Test.** `tests/game/ClassicOpcodeNumbers.cpp` `[ClassicOpcodes]`: 0x440034 on 70862 is CMSG_GUILD_INVITE_BY_NAME (was
PARTY_INVITE_RESPONSE), 0x440032 is PARTY_INVITE_RESPONSE. PTR: invite from the guild window; accept and decline a party
invite and check the server log shows CMSG_PARTY_INVITE_RESPONSE, and note which wire number it came in on.

**Verdict:** take. Follow-up once the PTR log shows the party answer's number: set 0x440035 to what it really is.
