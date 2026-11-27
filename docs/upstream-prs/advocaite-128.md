# advocaite/TrinityCore#128: DB/Quest: Father Gavin quests at Misty Pine Refuge

finelam, 2026-10-25, commit acbdc22c83. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Father Gavin (1253, Misty Pine Refuge, Dun Morogh) has `npcflag` 0, so Dawn in the Mountains (99158) can't be
turned in, and his four quests (99159 Finding Warmth, 99160 and 99161 Rime's Wrath, 99162 Treacherous Cold) have no giver,
ender or map points. What they need is missing too: Minor Ice Elemental (276003) has no spawns, loot or level and is
friendly; Avala (276009) doesn't exist; the three rifle objects (695222, 695223, 695277) don't exist.

**Check.**
- Mostly true on `everlake`. Not the first point: 2026_10_26_21_world_quest_missing_credits.sql already gives 1253 `npcflag` 2 (questgiver), so
  99158 can be turned in here; this file adds the gossip bit. The rest holds: 1253 starts and ends none of 99159-99162; 276003 has faction 35, no spawn, no `creature_classic_level`, `LootID` 0; 276009 and the three
  object templates are absent; no `quest_poi` for the four quests.
- The quests' objectives on `everlake` already match live Forever's quest answers (EG Link 70862): 479520 (14 Mostly Dry
  Firewood 286339), 479482 (10 Minor Ice Elemental), 479481 (Avala's Core 286325), 479527-479529 (the three rifles
  286358-286360). Every item is in the 70862 client's ItemSparse.
- Wowhead Forever tooltips agree on what can be checked: Avala "The Lost Rime", level 8 elemental; Minor Ice Elemental
  level 7-8; Father Gavin, The Argent Dawn; the three rifles are containers. Quest givers, spawn points and drop rates are
  in Wowhead's script data, which can't be read from here, so the spawn coordinates (converted from Wowhead map points) and
  loot chances are the author's and not checked. The 99160 -> 99161 order is the author's choice (no source gives one).
- Ids: creature guids 26300000-26300053 and gameobject guids 34100000-34100002, pool 1310000. Free on `everlake` (highest
  creature guid 26209144, gameobject 33998642, pool 1302286). The world import (docs/forever-import.md in
  wow-project-everlake) plans its own spawn guid block "above the fork's"; that block has to start above these.
- Reference loot 30017/30019 exist; `creature_template_difficulty` for Avala is copied from 276003 with `SELECT *`, which
  works because it is the same table.
- Not fixed, said in the pull request: only 4 Fallen Logs (144513) drop the 14 firewood.

**Test.** SQL. Load test (as in advocaite-123.md): no error; 21 + 4 creatures, 3 objects, 1 pool, 8 loot rows, 14
`quest_poi` and 36 points inserted; same result in fresh-world order. Tested in game by the author (70450). PTR check:
Father Gavin offers 99159, 99160 and 99162 (99161 after 99160), the elementals are hostile and level 7-8, one Avala is up,
the rifles can be looted on 99162.

**Verdict:** take. The import's guid block must start above 26300053 / 34100002.
