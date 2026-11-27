-- Arenas 2v2 / 3v3 move from the open Hyjal Crater bowl (map 2995) to the Ring of Law of Blackrock Depths (owner request 2026-11-08:
-- "we need some gates, doors, or something"). The Classic 1.60 client has no TBC arena maps, so the arena is a copy of the
-- Blackrock Depths map: new map 3200 with the same WDT (780172, terrain and buildings of map 230), type arena (4), its own
-- id, so Blackrock Depths itself does not change and no dungeon spawns load in the arena. The server also needs the map 230
-- data files copied as 3200 (maps, vmaps, mmaps): see the arena-ring-of-law-1108 notes.
-- Row 3200 goes to the client too (hotfix_data), because the client has no map 3200 of its own.
-- All values other than ID, names, InstanceType, MaxPlayers and the corpse spot are the client's own map 230 row (Map.db2).
DELETE FROM `map` WHERE `ID` = 3200;
INSERT INTO `map` (`ID`,`Directory`,`MapName`,`MapDescription0`,`MapDescription1`,`PvpShortDescription`,`PvpLongDescription`,
  `CorpseX`,`CorpseY`,`MapType`,`InstanceType`,`ExpansionID`,`AreaTableID`,`LoadingScreenID`,`TimeOfDayOverride`,`ParentMapID`,
  `CosmeticParentMapID`,`TimeOffset`,`MinimapIconScale`,`CorpseMapID`,`MaxPlayers`,`WindSettingsID`,`ZmpFileDataID`,`WdtFileDataID`,
  `OceanLiquidTypeID`,`NavigationMaxDistance`,`PreloadFileDataID`,`Flags1`,`Flags2`,`Flags3`,`VerifiedBuild`) VALUES
(3200,'BlackrockDepths','Ring of Law','','','','',0,0,2,4,0,1584,103,-1,-1,-1,0,1,-1,10,0,0,780172,2,0,0,67073,0,130,0);

-- Send row 3200 to every client (Map.db2 table hash 0xBD84CD62). Id 3200001 is free.
DELETE FROM `hotfix_data` WHERE `Id` = 3200001;
INSERT INTO `hotfix_data` (`Id`,`UniqueId`,`TableHash`,`RecordId`,`Status`,`VerifiedBuild`) VALUES
(3200001,1611080001,3179597154,3200,1,0);

-- Mak'gora Arena (BattlemasterList 1169) and the "All Arenas" queue (6) play on map 3200 now. Server side only: 1208 is the
-- client's own row (1169 -> 2995); the client keeps it, the arena pop and frames come from the battleground packets.
DELETE FROM `battlemaster_list_x_map` WHERE `ID` IN (1208,1500);
INSERT INTO `battlemaster_list_x_map` (`ID`,`MapID`,`BattlemasterListID`,`VerifiedBuild`) VALUES
(1208,3200,1169,0),
(1500,3200,6,0);

-- Level brackets for map 3200, the same as on 2995 (10-19 ... 60). Ids 32000+: far above the client's own rows.
DELETE FROM `pvp_difficulty` WHERE `ID` BETWEEN 32000 AND 32005;
INSERT INTO `pvp_difficulty` (`ID`,`RangeIndex`,`MinLevel`,`MaxLevel`,`MapID`,`VerifiedBuild`) VALUES
(32000,0,10,19,3200,0),
(32001,1,20,29,3200,0),
(32002,2,30,39,3200,0),
(32003,3,40,49,3200,0),
(32004,4,50,59,3200,0),
(32005,5,60,60,3200,0);
