# TrinityCore d7831d8714: The Call for Allies (49929) no longer required

Kevin Xu, 2026-10-15, TrinityCore#32064. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. World data: Forever world DB
release `forever-tdb-2026-10-14` (file not in its `updates` table). Client data: wago.tools export of 1.60.1.70862
(QuestV2).

**Claim.** A Choice of Allies (50239) no longer needs the retired The Call for Allies (49929); the Void Elf banner in the
Stormwind embassy (`gameobject` guid 6000625) spawns ready (`state` 1).

**Check.** Release: `quest_template_addon` 50239 has `PrevQuestID` 49929; after the file it is 0. Guid 6000625 is not
in the release (0 rows matched). Quests 49929 and 50239 (Battle for Azeroth allied races) are not in the 70862
`QuestV2` table, so the Forever client has neither quest.

**Test.** None: no code.

**Verdict:** take. Inert on Everlake; keeps `sql/updates/world` in line with TrinityCore.
