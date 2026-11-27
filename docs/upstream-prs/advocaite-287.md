# advocaite/TrinityCore#287: Quests: reward choices show again when the quest has a package id

Karrz1, 2026-10-31, commit 05bd034468. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Harvesting Windstones (93552) offered no book: with a QuestPackageID in quest details and offer reward, the
client looks for package items instead of the quest's own reward choices, finds none and completes with nothing picked.
The sniff import put a value there that is not a package id.

**Check.** True for our data. The world release (`forever-tdb-2026-10-14`) gives 93552 `QuestPackageID` 2; 3153 quests
have a non-zero package id and 150 of them have reward choices (the pull request counted 146 on its data). The Forever
client's QuestPackageItem.db2 (build 70399 header, 220 bytes) holds no rows, and the hotfix release has none either, so
no package id can mean anything to this client. The server side is unchanged and still right: `CanRewardQuest`, the
CHOOSE_REWARD handler and `RewardQuest` accept a quest's own choice item first and only fall back to package items, which
are empty. The quest query answer (`QuestDef.cpp`) still sends the sniffed value; if the quest log also hides choices,
that slot needs the same 0. TrinityCore `master` sends the package id (retail has packages).

**Test.** None in `tests/`: packet content. PTR: take and turn in Harvesting Windstones (93552): the reward screen shows the
book choices, the chosen book arrives. Also open the quest in the quest log before turning it in: the choices must show
there too (if not, the query answer needs the same change).

**Verdict:** take.
