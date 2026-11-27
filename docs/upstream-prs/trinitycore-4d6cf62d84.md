# TrinityCore 4d6cf62d84: no entering dungeons while a boss fight is on

Thor1423, 2026-10-01, TrinityCore#31980 (cherry-picked from e490cad2b0). Reviewed 2026-11-09 against `everlake`
029c5dd9ca.

**Claim.** `InstanceMap::CannotEnter` refused entry with `TRANSFER_ABORT_ZONE_IN_COMBAT` only in raids while a boss was
`IN_PROGRESS`. The commit drops `IsRaid()`, so 5-player dungeons refuse it too (relogging inside stays allowed).

**Check.** A gameplay rule, not a bug fix, and it touches Forever's own line: Forever lets companion bots in during a
fight (`!player->GetSession()->IsBot()`, so a bot group is not left outside while its owner fights). With the change,
a player who dies, releases and runs back cannot enter a dungeon while the rest of the group is still fighting a boss
with an instance script (`InstanceScript::IsEncounterInProgress`: any boss state `IN_PROGRESS`). Not checked what
Classic Era or live Forever do for 5-player dungeons. Held at first; the user chose on 2026-11-09 to block dungeons
too. Conflict in `Map.cpp` resolved as Forever's line without `IsRaid()`, keeping the bot exception and its comment.

**Test.** None in `tests/` (needs a map and an instance script). PTR check: in a dungeon with a scripted boss (e.g.
Deadmines), pull the boss, have a group member outside try to enter: "zone in combat" refusal; after the fight they
can enter; a companion bot called in during the fight still enters.

**Verdict:** take (user decision: dungeons too), bot exception kept.
