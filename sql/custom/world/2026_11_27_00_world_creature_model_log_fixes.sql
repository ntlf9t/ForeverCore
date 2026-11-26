-- Restore creature display variants that have valid client data and server collision metadata.

DELETE FROM `creature_template_model`
WHERE (`CreatureID` = 38 AND `CreatureDisplayID` IN (129962, 129963))
   OR (`CreatureID` = 3083 AND `CreatureDisplayID` = 147939)
   OR (`CreatureID` = 277055 AND `CreatureDisplayID` = 149025);

INSERT IGNORE INTO `creature_template_model`
    (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
VALUES
    (38, 0, 5035, 1, 1, 0),
    (38, 1, 5036, 1, 1, 0),
    (277055, 0, 148768, 1, 1, 70124);

-- Farholde Scout variants 140488 and 140490 share the same humanoid model
-- dimensions as the other two variants already present in the database.
DELETE FROM `creature_model_info`
WHERE `DisplayID` IN (114451, 114452, 140488, 140490);
INSERT INTO `creature_model_info`
    (`DisplayID`, `BoundingRadius`, `CombatReach`, `DisplayID_Other_Gender`, `VerifiedBuild`)
VALUES
    (114451, 0.306, 1.5, 0, 71139),
    (114452, 0.306, 1.5, 0, 71139),
    (140488, 0.306, 1.5, 0, 71139),
    (140490, 0.306, 1.5, 0, 71139);

-- The Classic client has no death knight, monk, demon hunter or evoker class
-- definitions. Retail requirement rows for these classes are always skipped.
DELETE FROM `class_expansion_requirement` WHERE `ClassID` IN (6, 10, 12, 13);
