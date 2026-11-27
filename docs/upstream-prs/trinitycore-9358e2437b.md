# TrinityCore 9358e2437b: unix socket connections keep the pool's connection info intact

Julian, 2026-10-20, TrinityCore#32081. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `MySQLConnection::Open` rewrote the host "." (unix socket) in the pool's shared `MySQLConnectionInfo` to
"localhost". Every later connection of the pool then took the TCP branch, read the socket path as a port (0) and fell
back to the client library's default socket, so a server with any other socket path could not open its other
connections.

**Check.**
- True: all connections of a `DatabaseWorkerPool` hold a reference to the pool's one `MySQLConnectionInfo`, and `Open`
  assigned to `m_connectionInfo.host`. The fix uses a local copy of the host and makes the stored info `const`, so the
  compiler now refuses any other write to it. Everlake's own code has no other writer (it builds).
- The `DBUpdater.cpp` part does not apply to `everlake`: our updater no longer starts the mysql command line client
  but connects itself (`DBUpdater<T>::ApplyFile`, advocaite d0dde7b468), and it already turns "." into "localhost" +
  socket in a local variable. That updater read the pool's info too, so it also got "localhost" + a socket path as
  port after the first connection; with this fix it gets "." again. Conflict resolved by keeping our `DBUpdater.cpp`.
- Everlake connects over TCP to its MySQL container, so the live realm never hit this; anyone running the fork against
  a local socket did.

**Test.** `tests/common/MySQLConnectionSocket.cpp` ([MySQLConnectionSocket]): opens two connections from one info
with host "." and a socket path nobody listens on (Open fails after it has picked host and socket), and one over TCP
to a closed port, and requires the shared info unchanged afterwards. Without the fix the first `Open` leaves the host
as "localhost" and the test fails.

**Verdict:** take (our `DBUpdater.cpp` kept).
