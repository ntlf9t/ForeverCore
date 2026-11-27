# TrinityCore c1f15d145f: macOS file name in the "legacy provider cannot be loaded" error

Shauren, 2026-10-16. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** On macOS the error message names `legacy.dylib` instead of `legacy.so`.

**Check.** Only the `#define` used in the error text; nothing is loaded by that name. Everlake runs on Linux, where
nothing changes.

**Test.** None (message only).

**Verdict:** take.
