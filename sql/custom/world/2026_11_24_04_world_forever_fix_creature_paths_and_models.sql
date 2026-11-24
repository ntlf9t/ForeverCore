-- Restore the three source paths that were imported without their creature_addon
-- links. The other four spawns have MovementType=2 but no path data at all.
DELETE FROM `creature_addon` WHERE `guid` IN (20003343,20003344,20084028);
INSERT INTO `creature_addon` (`guid`,`PathId`) VALUES
(20003343,800033430),
(20003344,800033440),
(20084028,810035130);

UPDATE `creature` SET `MovementType`=0
WHERE `guid` IN (20079720,20079721,20086157,20090439);

-- These DisplayIDs are absent from the 12.x client data. Keep the original
-- creature types by using equivalent display records that are still present.
UPDATE `creature_template_model`
SET `CreatureDisplayID`=CASE `CreatureID`
    WHEN 583    THEN 4276
    WHEN 10979  THEN 2709
    WHEN 221267 THEN 1269
    WHEN 221334 THEN 17654
END
WHERE `CreatureID` IN (583,10979,221267,221334);
