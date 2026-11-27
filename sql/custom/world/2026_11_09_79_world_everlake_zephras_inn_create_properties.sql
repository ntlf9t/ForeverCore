-- TrinityCore dc5955decd on Everlake: its file (2026_10_26_01_world.sql) takes custom area trigger create properties 182
-- for the Earthen start area (Awakening Machine, map 2739, not in the Forever client) with DELETE + INSERT. Forever's
-- world already uses custom 182 for the Zephras Isle inn rest areas (area trigger spawns 3 and 4, map 2991): a cylinder,
-- radius 22, height 15, on custom area trigger 137. After TrinityCore's file those two spawns would get the Awakening
-- Machine's shape and trigger. This gives Forever's inn shape its own id (1310002, next in Everlake's 1310000 block) and
-- moves spawns 3 and 4 to it. Works before or after TrinityCore's file. Safe to run again.
DELETE FROM `areatrigger_create_properties` WHERE `Id` = 1310002 AND `IsCustom` = 1;
INSERT INTO `areatrigger_create_properties` (`Id`, `IsCustom`, `AreaTriggerId`, `IsAreatriggerCustom`, `Flags`, `MoveCurveId`,
`ScaleCurveId`, `MorphCurveId`, `FacingCurveId`, `AnimId`, `AnimKitId`, `DecalPropertiesId`, `SpellForVisuals`, `PositionalSoundKitId`,
`TimeToTargetScale`, `Speed`, `SpeedIsTime`, `Shape`, `ShapeData0`, `ShapeData1`, `ShapeData2`, `ShapeData3`, `ShapeData4`,
`ShapeData5`, `ShapeData6`, `ShapeData7`, `Roll`, `Pitch`, `Yaw`, `TargetRoll`, `TargetPitch`, `TargetYaw`, `ScriptName`,
`VerifiedBuild`) VALUES
(1310002, 1, 137, 1, 0, 0, 0, 0, 0, -1, 0, 0, NULL, 0, 0, 0, 0, 4, 22, 22, 15, 15, 0, 0, 0, 0, 0, 0, 0, NULL, NULL, NULL, '', 0);

UPDATE `areatrigger` SET `AreaTriggerCreatePropertiesId` = 1310002 WHERE `SpawnId` IN (3, 4) AND `IsCustom` = 1 AND `MapId` = 2991;
