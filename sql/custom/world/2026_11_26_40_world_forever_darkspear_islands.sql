-- WoW Forever: Darkspear Islands battleground (map 2997, BattlemasterList 1157), script battleground_darkspear_islands.
-- The map's capture points, flag and doors are already spawned (map 2997 rows of the world DB). This file adds what the
-- client data does not have:
--   battleground_template 1157 with start points 1129970 (Alliance, behind the north gate 661005) and 1129971 (Horde,
--     behind the south gate 661004); heights from the server's maps (terrain).
--   graveyards 1129970-1129975 for zone 16606: each start area for its own team, and one beside each base for the team
--     that has captured it (capture point world state 5 = Alliance captured, 4 = Horde captured). Spirit guides for them
--     are world data (spawn groups on the same world states), as are the battlemasters (wow-everlake-world-data).
--   world states map-scoped to 2997 (without a map they would be realm-wide and leak between battles).
--   the dropped flag 633862 the flag 633863 names (type 37; not in the world DB), same model and lock as the flag.
-- Base positions: Shipwreck Cove 637677 / Abandoned Tower 637675 on the north (Alliance) island, Camp 637673 / Ruins 637674
-- on the south (Horde) island (compass positions from foreverbattlegrounds.com, matched to the capture points).

-- battleground map script
DELETE FROM `battleground_scripts` WHERE `MapId` = 2997 AND `BattlemasterListId` = 0;
INSERT INTO `battleground_scripts` (`MapId`, `BattlemasterListId`, `ScriptName`) VALUES
(2997, 0, 'battleground_darkspear_islands');

-- start points and graveyards (Facing in degrees)
DELETE FROM `world_safe_locs` WHERE `ID` BETWEEN 1129970 AND 1129975;
INSERT INTO `world_safe_locs` (`ID`, `MapID`, `LocX`, `LocY`, `LocZ`, `Facing`, `Comment`) VALUES
(1129970, 2997, 78, 1970, 43.79, 180, 'Darkspear Islands - Alliance start (north)'),
(1129971, 2997, -555, 1898, 43.79, 0, 'Darkspear Islands - Horde start (south)'),
(1129972, 2997, -80, 2120, 3.06, 148, 'Darkspear Islands - Shipwreck Cove graveyard'),
(1129973, 2997, -90, 1740, 46.49, 166, 'Darkspear Islands - Abandoned Tower graveyard'),
(1129974, 2997, -368, 2145, 48.04, 302, 'Darkspear Islands - Camp graveyard'),
(1129975, 2997, -365, 1715, 3.95, 57, 'Darkspear Islands - Ruins graveyard');

DELETE FROM `battleground_template` WHERE `ID` = 1157;
INSERT INTO `battleground_template` (`ID`, `AllianceStartLoc`, `HordeStartLoc`, `StartMaxDist`, `Weight`, `ScriptName`, `Comment`) VALUES
(1157, 1129970, 1129971, 75, 1, '', 'Darkspear Islands');

DELETE FROM `graveyard_zone` WHERE `ID` BETWEEN 1129970 AND 1129975 AND `GhostZone` = 16606;
INSERT INTO `graveyard_zone` (`ID`, `GhostZone`, `Comment`) VALUES
(1129970, 16606, 'Darkspear Islands - Alliance start'),
(1129971, 16606, 'Darkspear Islands - Horde start'),
(1129972, 16606, 'Darkspear Islands - Shipwreck Cove'),
(1129973, 16606, 'Darkspear Islands - Abandoned Tower'),
(1129974, 16606, 'Darkspear Islands - Camp'),
(1129975, 16606, 'Darkspear Islands - Ruins');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 27 AND `SourceGroup` = 16606 AND `SourceEntry` BETWEEN 1129970 AND 1129975;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(27, 16606, 1129970, 0, 0, 6, 0, 469, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129970 (Darkspear Islands Alliance start) - Alliance only'),
(27, 16606, 1129971, 0, 0, 6, 0, 67, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129971 (Darkspear Islands Horde start) - Horde only'),
(27, 16606, 1129972, 0, 0, 6, 0, 469, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129972 (Shipwreck Cove) - Alliance'),
(27, 16606, 1129972, 0, 0, 11, 0, 30840, 5, 0, '', 0, 0, 0, '', 'Graveyard 1129972 (Shipwreck Cove) - Alliance captured'),
(27, 16606, 1129972, 0, 1, 6, 0, 67, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129972 (Shipwreck Cove) - Horde'),
(27, 16606, 1129972, 0, 1, 11, 0, 30840, 4, 0, '', 0, 0, 0, '', 'Graveyard 1129972 (Shipwreck Cove) - Horde captured'),
(27, 16606, 1129973, 0, 0, 6, 0, 469, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129973 (Abandoned Tower) - Alliance'),
(27, 16606, 1129973, 0, 0, 11, 0, 30839, 5, 0, '', 0, 0, 0, '', 'Graveyard 1129973 (Abandoned Tower) - Alliance captured'),
(27, 16606, 1129973, 0, 1, 6, 0, 67, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129973 (Abandoned Tower) - Horde'),
(27, 16606, 1129973, 0, 1, 11, 0, 30839, 4, 0, '', 0, 0, 0, '', 'Graveyard 1129973 (Abandoned Tower) - Horde captured'),
(27, 16606, 1129974, 0, 0, 6, 0, 469, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129974 (Camp) - Alliance'),
(27, 16606, 1129974, 0, 0, 11, 0, 30837, 5, 0, '', 0, 0, 0, '', 'Graveyard 1129974 (Camp) - Alliance captured'),
(27, 16606, 1129974, 0, 1, 6, 0, 67, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129974 (Camp) - Horde'),
(27, 16606, 1129974, 0, 1, 11, 0, 30837, 4, 0, '', 0, 0, 0, '', 'Graveyard 1129974 (Camp) - Horde captured'),
(27, 16606, 1129975, 0, 0, 6, 0, 469, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129975 (Ruins) - Alliance'),
(27, 16606, 1129975, 0, 0, 11, 0, 30838, 5, 0, '', 0, 0, 0, '', 'Graveyard 1129975 (Ruins) - Alliance captured'),
(27, 16606, 1129975, 0, 1, 6, 0, 67, 0, 0, '', 0, 0, 0, '', 'Graveyard 1129975 (Ruins) - Horde'),
(27, 16606, 1129975, 0, 1, 11, 0, 30838, 4, 0, '', 0, 0, 0, '', 'Graveyard 1129975 (Ruins) - Horde captured');

-- world states: the score widget 7467 shares Arathi Basin / Eye of the Storm's 1776/1777/1780; the rest are the map's own
UPDATE `world_state` SET `MapIDs` = CONCAT(`MapIDs`, ',2997') WHERE `ID` IN (1776, 1777, 1780) AND `MapIDs` IS NOT NULL AND `MapIDs` <> '' AND FIND_IN_SET('2997', `MapIDs`) = 0;
DELETE FROM `world_state` WHERE `ID` IN (30837, 30838, 30839, 30840, 30851, 30852, 30853, 30854, 30855, 30856, 30857, 30858, 31175, 51172, 51173);
INSERT INTO `world_state` (`ID`, `DefaultValue`, `MapIDs`, `AreaIDs`, `ScriptName`, `Comment`) VALUES
(30837, 1, '2997', NULL, '', 'Darkspear Islands - Camp capture point state'),
(30838, 1, '2997', NULL, '', 'Darkspear Islands - Ruins capture point state'),
(30839, 1, '2997', NULL, '', 'Darkspear Islands - Abandoned Tower capture point state'),
(30840, 1, '2997', NULL, '', 'Darkspear Islands - Shipwreck Cove capture point state'),
(30851, 0, '2997', NULL, '', 'Darkspear Islands - Shipwreck Cove Horde (1 assaulted, 2 captured)'),
(30852, 0, '2997', NULL, '', 'Darkspear Islands - Shipwreck Cove Alliance (1 assaulted, 2 captured)'),
(30853, 0, '2997', NULL, '', 'Darkspear Islands - Camp Horde (1 assaulted, 2 captured)'),
(30854, 0, '2997', NULL, '', 'Darkspear Islands - Camp Alliance (1 assaulted, 2 captured)'),
(30855, 0, '2997', NULL, '', 'Darkspear Islands - Ruins Alliance (1 assaulted, 2 captured)'),
(30856, 0, '2997', NULL, '', 'Darkspear Islands - Ruins Horde (1 assaulted, 2 captured)'),
(30857, 0, '2997', NULL, '', 'Darkspear Islands - Abandoned Tower Alliance (1 assaulted, 2 captured)'),
(30858, 0, '2997', NULL, '', 'Darkspear Islands - Abandoned Tower Horde (1 assaulted, 2 captured)'),
(31175, 1, '2997', NULL, '', 'Darkspear Islands - flag state'),
(51172, 0, '2997', NULL, '', 'Darkspear Islands - Alliance has taken the flag'),
(51173, 0, '2997', NULL, '', 'Darkspear Islands - Horde has taken the flag');

-- the dropped flag (633863 Data9); it despawns after the flag's 10 s expire duration and the flag goes home
DELETE FROM `gameobject_template` WHERE `entry` = 633862;
INSERT INTO `gameobject_template` (`entry`, `type`, `displayId`, `name`, `IconName`, `castBarCaption`, `unk1`, `size`, `Data0`, `Data1`, `Data2`, `ContentTuningId`, `AIName`, `ScriptName`, `VerifiedBuild`) VALUES
(633862, 37, 122880, 'Darkspear Islands Flag', '', '', '', 2.5, 4574, 0, 0, 0, '', '', 0);

