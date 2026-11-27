# advocaite/TrinityCore#68: Make character creation unique to the full name

PixelCattt, 2026-10-17, commit 3957ccdf85. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Character names are unique by name + surname, not by name alone: two characters may both be "Bob" if their
surnames differ.

**Change.** `characters.idx_name` (unique on `name`) is replaced by a unique key on (`name`, `surname`); the name cache
becomes a multimap with `GetCharacterCacheByFullName`; create and the name availability check use the new
`CHAR_SEL_CHECK_NAME_SURNAME`.

**Check.**
- This is a rule change, not a fix. Everlake's rule is the opposite: patch 0008 (name reservation,
  wow-project-everlake PR #8) gives a first name to one Battle.net account on every realm. With both, another account
  still can't take "Bob", so #68 would only let the same account (or an exempt bot account) hold two "Bob"s with
  different surnames on one realm.
- Incomplete: rename (`CHAR_SEL_FREE_NAME`), customize, faction change and undelete (`CHAR_SEL_CHECK_NAME`) still check
  the name alone, and 12 callers of `GetCharacterGuidByName` (whisper, invite, mail without a surname, GM commands) would
  get an arbitrary one of several characters with the same name.
- Patch 0008 changes the same lines of `HandleCharCreateOpcode` and `HandleCheckCharacterNameAvailability`; the two
  would conflict when Everlake moves to the fork. Patch 0009 (random surname) does not touch these lines.
- The SQL applies to a scratch MySQL 8.0 (characters base + our `sql/custom/characters`), twice. `surname` is NOT NULL
  with default '', so characters without a surname stay unique by name.

**Test.** None (held).

**Verdict:** hold. A naming policy for the user to decide; if wanted, it needs the rename, customize, faction change
and name-lookup paths too, and it has to be squared with name reservation.
