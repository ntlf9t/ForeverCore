# advocaite/TrinityCore#278: Lookup commands: quest lookups with no player in the world no longer crash

Karrz1, 2026-11-06, commit c8aac8c67c. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** `.lookup quest` (by name, by id, and the id lookup) crashes when run from a session with no player in the
world, such as Battle.net club chat.

**Check.** True: the three branches tested `handler->GetSession()` and then dereferenced `GetSession()->GetPlayer()`.
`ChatHandler::GetPlayer()` returns null for both no session and no player, so testing it covers both, and the existing
`else` prints the console line. TrinityCore `master` has the same code. Other commands use `GetSession()->GetPlayer()`
too, but most are player-only commands (`Console::No`); not checked one by one here.

**Test.** None in `tests/` (scripts are not linked into the test binary). In-game test: `.lookup quest Kobold` from the
worldserver console and from in game, both print the list; from a Battle.net club chat channel, no crash.

**Verdict:** take.
