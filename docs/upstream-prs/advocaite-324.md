# advocaite/TrinityCore#324: World map: offer only Classic quests as available

Karrz1, 2026-11-07, commit f70f12a30a. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The world map showed many quests as available that nobody gives in this world (88 Cataclysm quests in Eastern
Plaguelands); the map lists come from retail data and those quests have no Classic level, so any level could take them.

**Check.** True for our data. `HandleUiMapQuestLinesRequest` lists every quest of `ui_map_quest` and of the quest lines in
`ui_map_quest_line` that `CanTakeQuest` allows. In the world release (`forever-tdb-2026-10-14`), `ui_map_quest` has 291 rows
for 61 quests, none with a row in `quest_classic_level` or `quest_template_classic_level` and none with a quest starter in
the world; the client's QuestLineXQuest.db2 has 22 rows, none on a line in `ui_map_quest_line`. So the filter hides only
retail quests. The other way round: of the 4241 quests some NPC or object starts, 9 have no Classic level row (92421,
95216, 96340-96342, 97289, 97290, 97292, 97891, Forever quests); none is on a map list, so none is hidden. A Forever quest
added to a map list later needs a Classic level row to show. TrinityCore `master` has no filter (retail data).

**Test.** None in `tests/`: the handler needs a session and the map tables. PTR: a level 16 character opens the Eastern
Plaguelands map: no "!" for quests nobody gives. Open Elwynn Forest: no change from before.

**Verdict:** take.
