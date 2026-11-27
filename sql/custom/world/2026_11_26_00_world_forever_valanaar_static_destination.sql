-- The fixed Portal to Valanaar (617085) casts 1273010, which triggers 1273009.
-- Like the scripted exit's 1273006, 1273009 needs a TARGET_DEST_DB position.
-- Use the configured Valanaar landing and the fixed portal spell's DB2 facing.
INSERT INTO `spell_target_position`
    (`ID`, `EffectIndex`, `OrderIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`, `VerifiedBuild`)
SELECT 1273009, `scene`.`EffectIndex`, `scene`.`OrderIndex`, `scene`.`MapID`,
    `scene`.`PositionX`, `scene`.`PositionY`, `scene`.`PositionZ`, 4.29351, 0
FROM `spell_target_position` AS `scene`
WHERE `scene`.`ID` = 1273006 AND `scene`.`EffectIndex` = 0 AND `scene`.`OrderIndex` = 0
    AND `scene`.`MapID` = 2991
    AND NOT EXISTS (
        SELECT 1 FROM `spell_target_position` AS `fixed`
        WHERE `fixed`.`ID` = 1273009 AND `fixed`.`EffectIndex` = 0
    );
