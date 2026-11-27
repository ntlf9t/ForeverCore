# advocaite/TrinityCore#302: Login: a plain account name works without @domain

Karrz1, 2026-11-07, commit 54ad15b950. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The login screen sends what the player typed; accounts are stored as name@domain, so a plain "name" found no
account. bnetserver now adds "@" + `LoginREST.DefaultAccountDomain` (default "local", empty = off) to a name without "@".

**Check.**
- Applied at all three places our `LoginRESTService.cpp` reads `account_name` (password login, SRP challenge, SRP
  answer), so the SRP username (SHA-256 of the login, sent to the client in the challenge) and `SrpLogin == login` stay
  consistent.
- No bypass: the name only picks which account is looked up; the password or SRP proof is still checked against that
  account's verifier, failed-login counting and bans are unchanged, and the authenticator step works from session state.
  Typing "bob" is the same as typing "bob@local", which anyone could already do.
- An account whose stored name has no "@" can no longer be reached by typing it. `bnetaccount create` refuses such names
  and the bot module uses "@playerbot-v2.local"; `CreateBattlenetAccount` itself doesn't check, so look for rows without
  "@" before deploy: `SELECT id, email FROM battlenet_accounts WHERE email NOT LIKE '%@%'`.
- Everlake accounts are e-mail addresses, so with the default nothing changes for them.
- TrinityCore `master` has the same three plain upper-casing calls.

**Test.** No unit test: the function lives in bnetserver, which `tests` doesn't link. PTR: log in with "name@local" and
with "name" for a name@local account (same account), with a wrong password for both (refused, failed-login count goes
up), and with a normal e-mail account (unchanged).

**Verdict:** take.
