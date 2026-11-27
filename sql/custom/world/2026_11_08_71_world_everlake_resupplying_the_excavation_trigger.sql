-- advocaite/TrinityCore#270 on Everlake: Resupplying the Excavation (273) is completed the way live Forever does it.
-- #270 (2026_10_31_00) made the quest completable with a made-up objective (9000273, kill credit for Huldar 2057) given by a
-- SmartAI line-of-sight event. Live Forever (the server's own quest answer, EG Link build 70862) has one objective there:
-- 385478, QUEST_OBJECTIVE_AREA_TRIGGER_ENTER (19) on area trigger 45628, amount 0, and quest flags 8 (no
-- QUEST_FLAGS_COMPLETION_AREA_TRIGGER), which #270 already sets. So the objective gets its live id and kind, and a
-- server-side area trigger 45628 stands on Huldar, as 2026_10_24_02 does for "Secure the Mountain" (44117). The 20 yd
-- radius is #270's; the real trigger's size and spot are not known. Safe to run again.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 2057 AND `source_type` = 0 AND `id` = 0;
UPDATE `creature_template` SET `AIName` = '' WHERE `entry` = 2057;

DELETE FROM `quest_objectives` WHERE `ID` IN (9000273, 385478);
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(385478,273,19,0,0,45628,0,1,'',0);

DELETE FROM `areatrigger_template` WHERE `Id` = 45628 AND `IsCustom` = 0;
INSERT INTO `areatrigger_template` (`Id`, `IsCustom`, `Flags`, `ActionSetId`, `ActionSetFlags`, `VerifiedBuild`) VALUES
(45628, 0, 1, 0, 0, 0);

DELETE FROM `areatrigger_create_properties` WHERE `Id` = 1310001 AND `IsCustom` = 1;
INSERT INTO `areatrigger_create_properties` (`Id`, `IsCustom`, `AreaTriggerId`, `IsAreatriggerCustom`, `Shape`, `ShapeData0`, `ShapeData1`, `VerifiedBuild`) VALUES
(1310001, 1, 45628, 0, 0, 20, 20, 0);

DELETE FROM `areatrigger` WHERE `SpawnId` = 1310001;
INSERT INTO `areatrigger` (`SpawnId`, `AreaTriggerCreatePropertiesId`, `IsCustom`, `MapId`, `SpawnDifficulties`, `PosX`, `PosY`, `PosZ`, `Orientation`, `PhaseUseFlags`, `PhaseId`, `PhaseGroup`, `ScriptName`, `Comment`, `VerifiedBuild`) VALUES
(1310001, 1310001, 1, 0, '0', -5762.77, -3433.36, 305.765, 0, 1, 0, 0, '', 'Loch Modan - Huldar - Resupplying the Excavation (quest 273)', 0);
