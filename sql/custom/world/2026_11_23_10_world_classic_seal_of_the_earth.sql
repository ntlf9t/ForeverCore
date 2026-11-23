-- Restore the Seal of the Earth event for quests 779 (Alliance) and 795 (Horde).
-- The timed summon scripts survived the vanilla SmartAI conversion, but the gameobject
-- was never assigned SmartGameObjectAI and the quest-reward triggers were lost.
UPDATE `gameobject_template`
SET `AIName` = 'SmartGameObjectAI'
WHERE `entry` = 2933
  AND `ScriptName` = '';

DELETE FROM `smart_scripts`
WHERE (`entryorguid` = 2933 AND `source_type` = 1)
   OR (`entryorguid` = 293300 AND `source_type` = 9);

INSERT INTO `smart_scripts`
(`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,
 `event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,
 `action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,
 `target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
VALUES
(2933,1,0,0,20,0,100,0,779,0,0,0,80,293300,0,0,0,0,0,1,0,0,0,0,0,0,0,
 'Seal of the Earth - On Quest Seal of the Earth Rewarded (Alliance) - Run Script'),
(2933,1,1,0,20,0,100,0,795,0,0,0,80,293300,0,0,0,0,0,1,0,0,0,0,0,0,0,
 'Seal of the Earth - On Quest Seal of the Earth Rewarded (Horde) - Run Script'),
(293300,9,0,0,0,0,100,0,2000,2000,0,0,12,2759,1,300000,0,0,0,8,0,0,0,-6703,-4094,264.235,2.83,
 'Seal of the Earth - After 2 Seconds - Summon Hematus'),
(293300,9,1,0,0,0,100,0,2000,2000,0,0,12,2757,1,300000,0,0,0,8,0,0,0,-6718,-4125,264.235,2.683,
 'Seal of the Earth - After 2 Seconds - Summon Blacklash');
