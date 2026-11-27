# TrinityCore 69e5a228a8: SMSG_LFG_PROPOSAL_UPDATE layout for 12.1.0

Kevin Xu, 2026-10-03, TrinityCore#32040. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** In retail 12.1.0 the player list of the dungeon finder proposal comes before the three flag bits, not after.

**Check.** Whether the 70862 client reads it the 12.1.0 way or the old way is **not known**: no Forever packet code or
test covers this message, and the client was not disassembled for it. It does not matter today: Classic 1.60 has no
Dungeon Finder. Forever's `WorldSession::SendLfgPlayerLockInfo` sends empty lists (the retail entries crashed the
client at log-in), so a player cannot queue from the client. Bots queue through `LFGMgr::JoinLfg`
(`PlayerbotAPI::lfg_queue`), but a proposal is only written to a session with a client. So the message is not sent to
a Forever client. Taken to keep `LFGPackets.cpp` in line with TrinityCore; for the retail realm it is the right layout.

**Test.** None.

**Verdict:** take (not reachable on Everlake). If a Forever dungeon finder is ever switched on, check this layout first.
