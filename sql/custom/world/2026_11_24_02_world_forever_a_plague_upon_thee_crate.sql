-- A Plague Upon Thee (5902/5904 -> 6390/6389): the Termite Barrel only lasts
-- 60 seconds. If the final quest is already in the log, the crate used to be
-- hidden permanently after the barrel despawned.

DELETE FROM `conditions`
WHERE `SourceTypeOrReferenceId` = 15
  AND `SourceGroup` = 4362
  AND ((`SourceEntry` = 0 AND `ElseGroup` = 4)
    OR (`SourceEntry` = 1 AND `ElseGroup` = 5));

INSERT INTO `conditions`
    (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`,
     `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`,
     `ScriptName`, `Comment`)
VALUES
    (15, 4362, 0, 0, 4, 9, 0, 6390, 0, 0, '', 0, 0, 0, '', 'Horde crate - A Plague Upon Thee release quest is in the log'),
    (15, 4362, 0, 0, 4, 30, 0, 177491, 10, 0, '', 1, 0, 0, '', 'Horde crate - hide while the Termite Barrel is nearby'),
    (15, 4362, 1, 0, 5, 9, 0, 6389, 0, 0, '', 0, 0, 0, '', 'Alliance crate - A Plague Upon Thee release quest is in the log'),
    (15, 4362, 1, 0, 5, 30, 0, 177491, 10, 0, '', 1, 0, 0, '', 'Alliance crate - hide while the Termite Barrel is nearby');

-- Recreate the normal release event when a player has already accepted the
-- final quest and is using the crate as a recovery path.
DELETE FROM `conditions`
WHERE `SourceTypeOrReferenceId` = 22
  AND `SourceGroup` = 1
  AND `SourceEntry` = 177490
  AND `SourceId` IN (3, 33);

DELETE FROM `smart_scripts`
WHERE `entryorguid` = 177490
  AND `source_type` = 1
  AND `id` BETWEEN 3 AND 62;

INSERT INTO `smart_scripts`
    (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
     `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`,
     `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`,
     `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`,
     `target_x`, `target_y`, `target_z`, `target_o`, `comment`)
SELECT
    177490, 1, base.base_id + sequence.number,
    CASE WHEN sequence.number = 29 THEN 0 ELSE base.base_id + sequence.number + 1 END,
    '', CASE WHEN sequence.number = 0 THEN 62 ELSE 61 END, 0, 100, 0,
    CASE WHEN sequence.number = 0 THEN 4362 ELSE 0 END,
    CASE WHEN sequence.number = 0 THEN base.option_id ELSE 0 END,
    0, 0, 0, '',
    12, 12120, 3, 60000, 0, 0, 0, 0, '',
    1, 0, 0, 0, 0, '',
    0, 0, 0, 0,
    CONCAT('Northridge Lumber Mill Crate - Recover A Plague Upon Thee - Summon Plagueland Termite ', sequence.number + 1)
FROM
    (SELECT 3 AS `base_id`, 0 AS `option_id` UNION ALL SELECT 33, 1) base
CROSS JOIN
    (
     SELECT tens.value * 10 + ones.value AS `number`
     FROM
         (SELECT 0 AS `value`
          UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4
          UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) ones
     CROSS JOIN
         (SELECT 0 AS `value`
          UNION ALL SELECT 1 UNION ALL SELECT 2) tens
     WHERE tens.value * 10 + ones.value < 30
    ) sequence
;

INSERT INTO `conditions`
    (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`,
     `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`,
     `ScriptName`, `Comment`)
VALUES
    (22, 1, 177490, 3, 0, 9, 0, 6390, 0, 0, '', 0, 0, 0, '', 'Horde crate recovery summons termites only while quest 6390 is in the log'),
    (22, 1, 177490, 33, 0, 9, 0, 6389, 0, 0, '', 0, 0, 0, '', 'Alliance crate recovery summons termites only while quest 6389 is in the log');
