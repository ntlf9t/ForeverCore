# TrinityCore e247b0bcfd: hot swap: queued reloader messages deleted at unload as well

Shauren, 2026-11-09. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** On Windows the hot swap script cache was not deleted at shutdown; queued reloader messages are now freed
when the script modules unload, not only in the destructor, and the script directory path is built in one place.

**Check.** Only the hot swap reloader (`HotSwapScriptReloadMgr`, compiled with dynamic linking and used with
`HotSwap.Enabled`). Everlake's Dockerfile builds with the default static scripts, so this code is not in its binary. The change is self-contained:
`RemoveAllQueuedMessages` is the old destructor loop, also called from `Unload`; the added `QueueLink` member is
unused by our code. Taken to stay in line with TrinityCore.

**Test.** None: not in Everlake's build. The fork's CI builds with `-DSCRIPTS=dynamic`, so it compiles this code.

**Verdict:** take.
