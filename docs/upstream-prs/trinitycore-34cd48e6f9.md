# TrinityCore 34cd48e6f9: MirrorTimer in its own file

Shauren, 2026-09-29. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Moves the `MirrorTimer` class from 270f1397ac to `Entities/Player/MirrorTimer.h/.cpp`, no change in what it
does (`MirrorTimerType` becomes `uint8`, the 1 s tick a `Milliseconds` constant).

**Check.** Compared the moved code with 270f1397ac's: same members and logic. The new files are picked up by the
game library's source glob. Nothing outside `Player` includes the class.

**Test.** `tests/game/MirrorTimer.cpp` (see 270f1397ac) includes `MirrorTimer.h` directly.

**Verdict:** take.
