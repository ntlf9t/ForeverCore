# TrinityCore 914a6f655c: reduce differences between branches (who, mail, items)

Shauren, 2026-10-08. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Clean-up to bring `master` and 3.3.5 closer. Besides renames and casts, it changes behaviour in three places:
(1) `/who` search words are read into `Array<WhoWord, 4>` (at most 4; the handler's own "more than 10 zones / more than
4 words" checks go); (2) mail subject and body become `String<256, NoHyperlinks>` / `String<2000, NoHyperlinks>`, so a
mail with any `|` in them is refused while reading (before: hyperlinks were checked and valid links allowed);
(3) deleting a mail now needs the mailbox the player opened (`CanOpenMailBox` on the interaction GUID), and the mail
result always carries the bag result, attachment and count.

**Check.**
- **(1) Wrong for the Forever client, fixed on top.** Forever's who reader (`WhoPackets.cpp`, Classic 1.60 layout) reads a
  3 bit word count: up to 7 words, with a 6 bit area count (up to 63, already `Array<int32, 63>`). With 4 as the bound a
  /who with 5 to 7 words threw while reading and was dropped. Our commit "Forever code: who request keeps Classic's 7
  search words" makes it `Array<WhoWord, 7>`. Conflict in `MiscHandler.cpp`: Forever's who log line (zones, words,
  origin) sat where TrinityCore removed the 10 / 4 checks; kept Forever's line, took the removal.
- (2) The 70862 reader keeps its sizes (9 bit subject, 11 bit body), so up to 511 / 2047 bytes arrive and the new
  bounds refuse longer text. TrinityCore's 3.3.5 branch uses the same `NoHyperlinks` mail strings (255 / 7999), and
  Forever's guild texts already use `NoHyperlinks`. Not checked: whether the Forever mail window can put an item link or
  a `|` in the text. If it can, that mail is now refused (and the player kicked only if
  `ChatStrictLinkChecking.Kick` is on).
- (3) The mailbox interaction is started by `HandleGetMailList`, which the client sends when the mailbox opens;
  `HandleMailReturnToSender` already used the same check on `everlake`. `MailCommandResult::Write` is unchanged; the
  three fields were zero in the cases that now get values.

**Test.** `tests/game/ClassicWhoWords.cpp` ([ClassicWhoWords]): a Classic who request with 7 words is read whole (with
TrinityCore's bound of 4 put back it fails: "Attempted to read more array elements from packet 7 than allowed 4"), and one word still works. PTR checks: `/who`
with five words; send a mail with plain text; shift-click an item while typing a mail body and send; delete a read mail.

**Verdict:** take, with our fix for the who word count.
