# advocaite/TrinityCore#280: Battlegrounds: do not read the map of a template that has none

Karrz1, 2026-11-06, commit 17c66ac5eb. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The Classic client data has no `BattlemasterListXMap` row for "all arenas" (battleground type 6), so its
template has an empty map list, and arena join called `MapIDs.front()` on it: a crash on Karrz's dev realm.

**Check.** The code side is true: `MapIDs.front()` on an empty vector is undefined behaviour, and the five places the
pull request guards (join, arena join, port, status, `CreateNewBattleground`) are all the places that call it. TrinityCore
`master` has the same unguarded calls; retail data always has the rows. Not checked yet: whether our 70862 client data
also lacks the row. The new start-up log line answers that ("has no map in BattlemasterListXMap").

**Test.** None in `tests/` (templates load from the database and client data). PTR check: after deploy, look for
"has no map in BattlemasterListXMap" in the worldserver start-up log, and queue for a battleground from the PvP window.

**Verdict:** take.
