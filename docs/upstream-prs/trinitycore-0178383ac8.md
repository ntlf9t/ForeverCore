# TrinityCore 0178383ac8: SMSG_PETITION_DECLINED back

Shauren, 2026-10-24. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Declining to sign a charter tells the charter's owner again (`SMSG_PETITION_DECLINED`, retail 0x4501F7, one
GUID). It had been commented out as "not handled by the client".

**Check.** The 70862 number comes from `ClassicOpcodes`' rules: retail index 0x1F7 is above the 0x17E..0x1C0 range that
moves one down, so it keeps its index, plus the 70291 and 70790 main-group shifts. The comment there puts a Classic-only
message somewhere between 0x1C1 and 0x267. Messages on both sides of 0x1F7 already reach the Forever client at their
unchanged index every day: `SMSG_INIT_WORLD_STATES` (0x1F0), `SMSG_UPDATE_WORLD_STATE` (0x1F2) and
`SMSG_MAIL_LIST_RESULT` (0x200). So the extra message is below 0x1F0 and 0x1F7 is very likely the Classic
`PETITION_DECLINED` too. Not seen in a sniff. Charters are live on Everlake (guild charters, advocaite/TrinityCore#298
fixed the client's "Request Signature").

**Test.** None in `tests/` (`ClassicOpcodeNumbers.cpp` pins numbers from sniffs; there is none for this one). PTR check:
offer a guild charter, decline it on the other character: the owner gets a "declined" message (or nothing) and no client error.

**Verdict:** take.
