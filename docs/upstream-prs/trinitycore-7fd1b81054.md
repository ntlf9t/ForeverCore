# TrinityCore 7fd1b81054: spell id argument for SendMirrorTimer

Aqua Deus, 2026-09-27, TrinityCore#32018. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Taken with 270f1397ac and
34cd48e6f9, which rewrite the same code two days later.

**Claim.** `Player::SendMirrorTimer` gets a spell id and passes it into `SMSG_START_MIRROR_TIMER` instead of 0.

**Check.** Every caller in this commit passes 0, so the bytes sent are the same as before. The writer
(`StartMirrorTimer::Write`: uint8 timer, int32 value, max, scale, spell id, 1 bit paused) is not touched and is the one
Everlake already sends to the 70862 client for the breath and fatigue bars. No Forever code calls `SendMirrorTimer`
(grep of `src/`, including `src/server/scripts/Custom` and `src/modules`).

**Test.** None for this step on its own; see 270f1397ac (`tests/game/MirrorTimer.cpp`).

**Verdict:** take (no change in what is sent).
