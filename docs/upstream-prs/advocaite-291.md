# advocaite/TrinityCore#291: Social: read the 1.60 contact list request with its leading byte

Karrz1, 2026-11-06, commit f25eabdf16. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The 1.60 client sends CMSG_SEND_CONTACT_LIST as 5 bytes, a 0 byte before the flags. Read as a uint32 the flags
came out as 0x1500, no social flag matched, and the friend list was sent empty every time it was opened.

**Check.**
- True for our code: `SendContactList::Read` reads the retail layout (as TrinityCore `master`).
- The change skips one byte when the message is longer than 4 bytes, so a 4-byte message still reads as before.
- **Word for word Everlake's own `docker/patches/0003-classic-contact-list-request.patch`.** Drop that patch when Everlake
  builds from this fork, or it fails to apply.

**Test.** `tests/game/ContactListRequest.cpp` `[ContactListRequest]`: `00 15 00 00 00` and `00 11 00 00 00` give 0x15 and
0x11, a 4-byte `15 00 00 00` gives 0x15, and the whole message is read. The old reader gives 0x1500 and 0x1100.

**Verdict:** take.
