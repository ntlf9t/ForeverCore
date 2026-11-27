# advocaite/TrinityCore#298: Classic 70790: guild charter Request Signature reaches the server

Karrz1, 2026-11-07, commit 0a44263c57. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The 70790 client sends the charter offer ("Request Signature") as 0x3E028C, which our table mapped to the
unhandled CMSG_CHROMIE_TIME_SELECT_EXPANSION, so nobody was ever offered a charter.

**Check.**
- True for our code: `ClassicClientOpcodes.inc` has `{ 0x3E028C, 0x3D028A }` (CHROMIE_TIME). Group 0x3E is not moved by
  the 70291 or 70790 rules, so the 70862 wire number is the table key.
- EmuForever's client map (independent, from the 70425 binary) also has OFFER_PETITION at 0x3E028C, CHROMIE_TIME at
  0x3E028D and ACTIVATE_SOULBIND at 0x3E028E; our table is one off for the last two too, but Classic has neither.
- The comment says an earlier guess 0x3E028B "is removed": that line was never in our tree. Harmless.

**Test.** `tests/game/ClassicOpcodeNumbers.cpp` `[ClassicOpcodes]`: 0x3E028C on 70862 is CMSG_OFFER_PETITION (was
CHROMIE_TIME_SELECT_EXPANSION). PTR: buy a guild charter, target a player, Request Signature; they get the sign window.

**Verdict:** take.
