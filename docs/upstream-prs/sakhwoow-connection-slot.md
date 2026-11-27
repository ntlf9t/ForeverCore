# Sakhwoow/WoWForever 2e10d8b714: the address's connection place is given back when the connection closes

Sakhwoow/WoWForever `forever` (the Azeroth project's hardcore realm, GPL-2.0), commit 2e10d8b714 by PlayDargoon, 2026-11-15.
Reviewed 2026-11-16 against `everlake` 0d9a4b9145.

**Claim** (translated). `WorldSocket` held its place in `Network.ConnectionsPerIp` for as long as the socket object lived, and the
object outlives its connection. On their live realm on 2026-11-15 a player was refused with no connection open: 16 "places" had
piled up. The place is now given back in `OnClose`, and the refusal logs the count.

**Check.**
- The limit is ours (`ff04fe72fa`, `Trinity::Net::IpConnectionLimit`); their tree has it through the advocaite merge.
- True in `everlake`. `WorldSocket::Start` takes a `Slot` into `_ipConnectionSlot`, and only `~WorldSocket` gave it back.
  `WorldSession::Update` keeps its closed sockets (`m_Socket`, both realm and instance) until the reconnect window (`expireTime`)
  runs out or the player leaves the world. So every drop of an in-world player held two places for up to that long, and a player
  who dropped and came back a few times, or several players behind one address, could be refused while nothing was open.
- `Socket::CloseSocket` calls `OnClose` exactly once (`_openState.exchange`), and the destructor only runs after every owner is gone,
  so resetting the `unique_ptr` in `OnClose` cannot race the destructor. A refused connection (`Start` closes it) resets an empty
  pointer.
- bnetserver's `Battlenet::Session` holds a slot the same way but is not affected: the session is dropped by its socket manager as
  soon as it is closed, nothing keeps it.
- Their second change in the same commit, game rule 42 (EncounterJournalDisabled) = 0 to open the Adventure Guide, is a realm
  choice (live has it off) and is not taken.

**Change.** `WorldSocket::OnClose` resets `_ipConnectionSlot`; the refusal message names the count. The comment in
`IpConnectionLimit.h` says the slot is held while the connection is open.

**Test.** `tests/common/IpConnectionLimit.cpp`: a place given back on close is not given back again when the socket goes (the
pointer is reset twice), and a reconnect gets it. This tests the limit's side of the contract and passes before the change too: the
`OnClose` call itself has no unit test, because a `WorldSocket` needs a connected socket from a non-loopback address (loopback is
never counted) and a login database for its ban check. PTR check: log in, kill the client and log in again, three times within a
minute, with `Network.ConnectionsPerIp = 4` (a player uses two); before, the third login is refused with the count in the log;
after, all three get in.

**Verdict:** taken (WorldSocket part).
