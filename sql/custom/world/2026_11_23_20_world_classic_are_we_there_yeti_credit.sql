-- Quest 5163 "Are We There, Yeti?".
-- Umi's Mechanical Yeti casts spell 17166 at each target.  The target NPCs
-- must turn that hit into quest objective credit for the summoner.
DELETE FROM `smart_scripts`
WHERE `source_type` = 0
  AND `entryorguid` IN (7583, 10977, 10978)
  AND `event_type` = 8
  AND `event_param1` = 17166;

INSERT INTO `smart_scripts` (
    `entryorguid`, `source_type`, `id`, `link`, `Difficulties`,
    `event_type`, `event_phase_mask`, `event_chance`, `event_flags`,
    `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`,
    `event_param_string`,
    `action_type`, `action_param1`, `action_param2`, `action_param3`,
    `action_param4`, `action_param5`, `action_param6`, `action_param7`,
    `action_param_string`,
    `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`,
    `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`
) VALUES
(7583, 0, 100, 0, '', 8, 0, 100, 0, 17166, 0, 0, 0, 0, '',
 33, 7583, 0, 0, 0, 0, 0, 0, NULL,
 7, 0, 0, 0, 0, NULL, 0, 0, 0, 0,
 'Sprinkle - On Spellhit Release Umi''s Yeti - Quest Credit'),
(10977, 0, 100, 0, '', 8, 0, 100, 0, 17166, 0, 0, 0, 0, '',
 33, 10977, 0, 0, 0, 0, 0, 0, NULL,
 7, 0, 0, 0, 0, NULL, 0, 0, 0, 0,
 'Quixxil - On Spellhit Release Umi''s Yeti - Quest Credit'),
(10978, 0, 100, 0, '', 8, 0, 100, 0, 17166, 0, 0, 0, 0, '',
 33, 10978, 0, 0, 0, 0, 0, 0, NULL,
 7, 0, 0, 0, 0, NULL, 0, 0, 0, 0,
 'Legacki - On Spellhit Release Umi''s Yeti - Quest Credit');
