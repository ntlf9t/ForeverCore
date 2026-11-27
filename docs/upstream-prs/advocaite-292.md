# advocaite/TrinityCore#292: Chat: read the Classic layout of add-on whispers (CMSG_CHAT_ADDON_MESSAGE_TARGETED)

Karrz1, 2026-11-06, commit 6f34989e8f. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The 1.60 client sends a second 9 bit sized string after the target name in add-on whispers, as it does in
CMSG_CHAT_MESSAGE_WHISPER. Read as retail, the bit block was one byte short and the name started a byte early, so every
add-on whisper went to a player that doesn't exist.

**Check.**
- True for our code: `ChatAddonMessageTargeted::Read` reads the retail layout, while our `ChatMessageWhisper::Read`
  already reads the second string. Same fix, same place in the bit block.
- Decoded the pull request's sample packet (70685 client, add-on prefix FBOTS, "hello" to "Karrz") by hand: prefix
  length 5, text length 5, type 7 (whisper), two empty guids, realm 0, then bits `03 00 00 00` = name length 6
  ("Karrz" + NUL), second string 0, channel 0; 34 bytes, all read. Under the old reader the name length is 6 but the bit
  block is 3 bytes, so the name reads from the last bit byte.
- Add-ons that whisper (the bot module's FBOTS, DBM, WeakAuras and so on) work again.

**Test.** The pull request's `tests/game/ChatAddonTargetedLayout.cpp` `[ChatAddonTargetedLayout]` with that packet.

**Verdict:** take.
