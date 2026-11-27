# advocaite/TrinityCore#281: bnetserver: per-connection request limit and one login at a time

Karrz1, 2026-11-06, commit 2dc7c3af8c. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A Battle.net connection can send requests without limit, and every logon request with an auth token queues a
new chain of login database queries, even while one is running or after the connection is logged in.

**Change.** `Network.RequestsPerSecond` (default 10, burst of 10 seconds' worth, 0 = off): a connection over it is closed.
Per connection, not per address, so players behind one address don't share it. One login at a time per connection; a
logon request while one runs or after login gets `ERROR_DENIED`.

**Check.**
- Both login paths (v1 `VerifyWebCredentials` and v2 `VerifyAuthToken`) go through `Shared::Authentication::HandleVerifyAuthToken`, so
  the one guard covers both.
- Every way the check ends calls `sendResponse`, which the pull request wraps to end the login. On success,
  `sendResponse(ERROR_OK)` runs just before `OnLogonSuccess` sets `_authed`, in the same callback, so there is no window
  for a second login.
- The lambda keeps a raw `Session*`; it runs from the session's own query queue, so the session is alive.
- Risk: a client that sends more than 100 requests in a burst gets cut off. A normal login sends a few dozen. Watch the
  bnetserver log for "sent more than Network.RequestsPerSecond" after deploy.

**Test.** The pull request's own `tests/common/RequestRateLimit.cpp` (6 cases: burst, refill, no banking past the burst, a
normal login, limit 0, a clock stepping back). The one-login rule needs a live `Session`: PTR test is logging in with the
launcher and switching realms twice, then a wrong password followed by the right one (the failed try must not block the
next).

**Verdict:** take.
