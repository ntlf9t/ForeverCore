# TrinityCore ee6fcc9e24: Windows CI picks the MySQL path from CMake

jackpoz, 2026-10-31 (cherry-picked from d33c9a4564). Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Instead of a hard-coded `MYSQL_ROOT_DIR`, the "Copy Dependencies" step reads `MySQL_LIBRARY` from
`CMakeCache.txt` and copies `libmysql.dll` and MySQL's OpenSSL DLLs from that install, so a runner MySQL upgrade
does not break the job again.

**Check.** Same file as faf35c4188: on Everlake `win-x64-build.yml` runs only by hand (`workflow_dispatch`); our PR
builds are Linux. Applies cleanly on top of faf35c4188. Not run by hand for this review.

**Test.** None.

**Verdict:** take. No effect on PR CI; keeps the hand-run Windows job in line with TrinityCore.
