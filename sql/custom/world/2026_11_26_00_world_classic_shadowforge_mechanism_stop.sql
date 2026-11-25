-- The Giant Door Mechanism opens with the Shadowforge Lock, but its animation
-- must return to READY after the 12 second mechanism cycle.
UPDATE `gameobject_template`
SET `Data2` = 12000
WHERE `entry` = 161461;

DELETE FROM `smart_scripts`
WHERE `entryorguid` = 940000002 AND `source_type` = 9 AND `id` = 4;

INSERT INTO `smart_scripts`
    (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`,
     `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`,
     `event_param2`, `event_param3`, `event_param4`, `event_param5`,
     `event_param_string`, `action_type`, `action_param1`, `action_param2`,
     `action_param3`, `action_param4`, `action_param5`, `action_param6`,
     `action_param7`, `action_param_string`, `target_type`, `target_param1`,
     `target_param2`, `target_param3`, `target_param4`, `target_param_string`,
     `target_x`, `target_y`, `target_z`, `target_o`, `comment`)
VALUES
    (940000002, 9, 4, 0, '', 0, 0, 100, 0, 12000, 12000, 0, 0, 0, '',
     118, 1, 0, 0, 0, 0, 0, 0, '', 14, 30015639, 161461, 0, 0, '',
     0.0, 0.0, 0.0, 0.0,
     'Blackrock Depths Shadowforge Lock - stop giant door mechanism');
