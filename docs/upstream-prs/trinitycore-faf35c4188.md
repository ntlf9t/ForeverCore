# TrinityCore faf35c4188: Windows CI uses MySQL 8.4

Shauren, 2026-10-31. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** `win-x64-build.yml` points `MYSQL_ROOT_DIR` at `MySQL Server 8.4` instead of 8.0 (the hosted Windows
runner's MySQL changed).

**Check.** Our `win-x64-build.yml` is TrinityCore's file except the trigger: Everlake runs it only by hand
(`workflow_dispatch`); our pull-request CI is `linux-build.yml`. The commit applies cleanly (the hunk does not touch
the trigger). It does not change any build that runs on our PRs. Not run by hand for this review.

**Test.** None.

**Verdict:** take. Keeps the hand-run Windows job working on the current runner image and keeps the file in line so
ee6fcc9e24 applies.
