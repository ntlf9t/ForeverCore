# advocaite/TrinityCore#274: Classic 70790: the new server message is at 0xED, not 0xDF (mail window freezes)

Karrz1, 2026-11-06, commit fd24fd22fb. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** On 70790+ the mail window freezes after Send: `Classic.MainGroupInsertIndex70790` defaults to 0xDF, so the
mail results (0xE5, 0xE6) and scene messages (0xE0, 0xE1) go out one too high. Moving the default to 0xED fixes it.

**Check.**
- True for our code: 70862 >= 70790, so every main-group server message from 0xDF (70291..70658 numbering) on is sent one
  higher. Computed from our tables: 0xDF CONSOLE_WRITE, 0xE0/0xE1 PLAY_SCENE/CANCEL_SCENE, 0xE2-0xE4 pet battle,
  0xE5 MAIL_COMMAND_RESULT, 0xE6 NOTIFY_RECEIVED_MAIL, 0xE7 ADD_BATTLENET_FRIEND_RESPONSE, 0xEC ADDON_LIST_REQUEST, 0xED
  ACHIEVEMENT_EARNED.
- Independent check: EmuForever's client map (GPL, from the 70425 binary, with a 70755 rule "verified against 70755's
  message getters") moves server messages from 0x4700EC (ADDON_LIST_REQUEST) on and says the mail responses don't move.
  0xEC vs 0xED differs only for ADDON_LIST_REQUEST, which the core never sends. So for everything we send, both agree.
- An existing `worldserver.conf` with `Classic.MainGroupInsertIndex70790 = 223` overrides the new default; Everlake's
  config does not set it.

**Our change on top.** `TranslateServerOpcodeForBuild` / `TranslateClientOpcodeForBuild` in `ClassicOpcodes.h` take the
build instead of reading the realm's, so a test can check 70862 numbers. The old functions pass the realm's build, read
once as before.

**Test.** `tests/game/ClassicOpcodeNumbers.cpp` `[ClassicOpcodes]`: on 70862 INSTANCE_INFO 0x4700DE, PLAY_SCENE 0x4700E0,
CANCEL_SCENE 0x4700E1, MAIL_COMMAND_RESULT 0x4700E5, NOTIFY_RECEIVED_MAIL 0x4700E6, ACHIEVEMENT_EARNED 0x4700EE; on 70658
the last is 0x4700ED. With the old default (0xDF) the scene and mail checks fail (one too high). PTR: send a mail and
check the window closes with "Mail sent".

**Verdict:** take, with our change on top.
