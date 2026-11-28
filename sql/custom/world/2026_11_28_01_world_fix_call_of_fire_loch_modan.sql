-- Call of Fire (94467): restore the complete Loch Modan shrine setup.
DELETE FROM `gameobject` WHERE `guid` IN (21311081,21311082);
INSERT INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`VerifiedBuild`) VALUES
(21311081,61934,0,0,0,'0',0,0,0,-1,-5674.4,-2870.6,477.6707,0.2269,0,0,0.113203,0.993572,900,100,1,'',0),
(21311082,63674,0,0,0,'0',0,0,0,-1,-5701.62,-2876.42,457.478,0,0,0,0,1,120,255,1,'',0);

DELETE FROM `creature` WHERE `guid`=21311080;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`VerifiedBuild`) VALUES
(21311080,5893,0,0,0,'0',0,0,0,-1,0,0,-5672.6,-2875.3,477.4125,3.5,10,0,0,100,0,NULL,NULL,NULL,NULL,'',0);

INSERT IGNORE INTO `creature_template_addon` (`entry`,`PathId`,`mount`,`MountCreatureID`,`StandState`,`AnimTier`,`VisFlags`,`SheathState`,`PvPFlags`,`emote`,`aiAnimKit`,`movementAnimKit`,`meleeAnimKit`,`visibilityDistanceType`,`auras`) VALUES
(5893,0,0,0,0,0,0,1,0,0,0,0,0,0,'8203');

INSERT IGNORE INTO `gameobject_questender` (`id`,`quest`,`VerifiedBuild`) VALUES
(61934,94467,0);
INSERT IGNORE INTO `gameobject_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES
(61934,94468,0);
