# advocaite/TrinityCore#275: Mail: a recipient written Name-Realm or Name Surname is found (70790 client)

Karrz1, 2026-11-06, commit 3b2fda3a0a. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The 70790 client sends the To box as "Name-Realm" or "Name Surname-Realm"; older 1.60 clients send what the
player typed, often "Name Surname". `HandleSendMail` looked the whole text up as a name, so the recipient was "not found".

**Check.**
- True for our code (TrinityCore `master` has the same whole-text lookup; retail has no surnames).
- The change drops a "-Realm" suffix only when it names this realm (spaces and case ignored), splits at the first space,
  looks up the name and requires the surname to match the cache's. A suffix for another realm stays and the lookup fails
  as before. Names stay unique here, so no table change (unlike #70, which needs #68).
- Character names can't contain "-", so splitting at the last "-" is safe; a hyphenated surname ("Smith-Jones") is kept
  because "Jones" is not the realm name. A realm whose name has a "-" in it would not match; ours don't.

**Our change on top.** The text handling moves into `Trinity::Mail::SplitRecipient` (`Mails/MailRecipient.h`), same rule;
the cache lookup and surname match stay in the handler.

**Test.** `tests/game/MailRecipient.cpp` `[MailRecipient]`: plain name, "Name Surname" (extra spaces too), this realm's
suffix with spaces and case ignored ("-EverlakeTwo" for "Everlake Two"), another realm's suffix kept, a hyphenated
surname, no realm known. Under the old rule (whole text = name) the split and suffix checks fail. PTR: mail a character
by "Name", "Name Surname" and by the client's own "Name-Realm" autocomplete; a wrong surname must still fail.

**Verdict:** take, with our change on top.
