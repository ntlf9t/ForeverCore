# advocaite/TrinityCore#267: Remove duplicate Mokvar npc

dqhoang, 2026-10-29, commit a28816178d. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The import put a second copy of three Orgrimmar NPCs on the same spots: Mokvar twice in Thrall's room, and two
mount props at the mount vendor. Keeps the vanilla entries (Mokvar 16012, Swift Blue Raptor 14545, Swift Gray Wolf 14541)
and deletes the newer ones (230317, 276803, 276805; guids 21200548, 21200670, 21200671).

**Check.**
- The doubles are real: on `everlake` each pair stands on the same point (the raptor pair exactly, the wolf pair within
  1 yd).
- But the pull request keeps the wrong half. The three it deletes come from the Forever sniff (`VerifiedBuild` 70170); the
  three it keeps are VMaNGOS spawns (`VerifiedBuild` 0). Live Forever's creature answers (EG Link `creature_details`, builds
  70790 and 70862, 2,000-2,600 creatures each) include 230317 Mokvar, 276803 Swift Blue Raptor and 276805 Swift Gray Wolf
  (players' games asked the server about them because they saw them); 16012, 14545 and 14541 never appear. So live spawns
  the newer entries.
- Mokvar 16012 starts and ends 27/34 quests on `everlake` (8913-9032, the dungeon set 0.5 chain); 230317 has none. The right
  fix deletes the VMaNGOS spawns and decides which of those quests live Forever has on 230317, which public data doesn't show
  yet (no recorded window for him).

**Test.** SQL. Load test (as in advocaite-123.md): 3 creature rows deleted, no addon rows, no error.

**Verdict:** hold. Keep the sniffed spawns, remove the VMaNGOS ones, and move Mokvar's quest rows to 230317 once their
live giver is known.
