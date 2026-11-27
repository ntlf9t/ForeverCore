DELETE FROM `creature_template_model`
WHERE `CreatureID` = 2332;

INSERT INTO `creature_template_model`
    (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
VALUES
    (2332, 0, 36418, 1.0, 1.0, 69497);

UPDATE `creature`
SET `modelid` = 36418
WHERE `guid` = 20019150
  AND `id` = 2332;
