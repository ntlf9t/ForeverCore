# advocaite/TrinityCore#271: Classic 1.60.1.70707 / 70755: auth support and the 70755 opcode shifts

ablohme86, 2026-11-03, commit 097e3eec6d. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Client 70755 added two client messages (between 70755 index 0x63 and 0xA7) and one server message (at 0x125)
to the main groups; this shifts both from realm build 70755 on, with `build_info` rows for 70707 and 70755.

**Check.**
- Written before `forever` had the 70790 rules. Our `ClassicOpcodes.cpp` already shifts for 70790+ (client: two new
  messages at 0x71/0x72, everything from 0x73 two lower; server: one new message, see #274). The new 70755 rules are
  added on top with `build >= 70755`, so on our 70862 realm both apply: client messages from 0x65 on would move by 2 and
  then those from 0x73 by 2 again, and server messages from 0x125 on would move by one more. That breaks every 70862
  client.
- The numbers also disagree with what we have: the 70790 packet logs put the client insert at 0x71 (CREATE_CHARACTER
  0x70 unchanged, the name check moved from 0x71 to 0x73), and EmuForever's 70755 map (independent, GPL) shifts client
  0x440071+ by 2 and server 0x4700EC+ by 1, not 0x63 and 0x125.
- The SQL applies cleanly to a scratch auth database after our chain; the realm update doesn't touch realms on 70862.
- Doesn't merge: conflicts with #274 in `ClassicOpcodes.cpp`.

**Test.** None.

**Verdict:** drop. Superseded by the 70790 rules; taken as is it would double the shifts on 70862.
