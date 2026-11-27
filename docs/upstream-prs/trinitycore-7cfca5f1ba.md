# TrinityCore 7cfca5f1ba: Rundok (Orgrimmar portal trainer)

Foldor1, 2026-10-03, TrinityCore#32038. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. World data: Forever world DB
release `forever-tdb-2026-10-14` (file not in its `updates` table, so it would be applied).

**Claim.** Rundok (47253) moves (`creature` guid 310938), gets `npcflag` 49 (gossip + trainer + vendor bits as sniffed),
gossip menu 12235 gets class conditions (text 17181 and the "Please teach me." option for mages only, text 17180 for
everyone else), and trainer 12 (the shared portal-trainer list) gets new prices and `ReqLevel` 21/24 on some teleports.

**Check.** Against the release, on a scratch MySQL 8.0 with its tables, before and after:
- `creature` guid 310938: not in the release (0 rows matched). Rundok has **no spawn** in Forever.
- `creature_template` 47253: `npcflag` 1 -> 49, `VerifiedBuild` 69497 -> 69933.
- `gossip_menu_option` 12235/0: `GossipOptionID` -3132160 -> 39057; `gossip_menu`, `creature_template_gossip` only
  `VerifiedBuild`.
- `conditions` 14/15 for menu 12235: none before, 3 rows after.
- `trainer` 12 and its 26 `trainer_spell` rows: prices 5% lower (e.g. 3567 Teleport: Orgrimmar 5100 -> 4845),
  `ReqLevel` 0 -> 21 on 3563, 3566, 32272, 49358 and 0 -> 24 on 11418, 11420, 32267.
Trainer 12 is used (`creature_trainer`) by 45139 Zirazi, 47253 Rundok, 88255 Samaeli Roseblade and 174164 Lathysra
Goldenstar; none of the four is spawned in the release. So no player can reach trainer 12 or menu 12235 on Everlake.

**Test.** None: no code. Before/after diff as above.

**Verdict:** take. Inert on Everlake (no spawned NPC uses these rows); keeps `sql/updates/world` in line with TrinityCore.
If Forever ever spawns a portal trainer that uses trainer 12, re-check the `ReqLevel` values against Classic then.
