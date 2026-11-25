-- Restore the Blackrock Depths relic coffer encounter. Opening all twelve
-- coffer doors activates the nearby Warbringer Constructs and summons
-- Watchman Doomgrip.

UPDATE `gameobject_template`
SET `AIName` = 'SmartGameObjectAI'
WHERE `entry` IN (174554, 174555, 174556, 174557, 174558, 174559, 174560,
                  174561, 174562, 174563, 174564, 174566);

UPDATE `creature_template`
SET `AIName` = 'SmartAI'
WHERE `entry` = 9476;

DELETE FROM `smart_scripts`
WHERE `source_type` = 1
  AND `entryorguid` IN (174554, 174555, 174556, 174557, 174558, 174559,
                       174560, 174561, 174562, 174563, 174564, 174566);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_chance`,
 `event_param1`, `action_type`, `action_param1`, `action_param2`,
 `target_type`, `target_param1`, `target_param2`, `comment`)
SELECT `entry`, 1, 0, 1, 70, 100, 2, 45, 0, 1, 11, 8905, 30,
       'Relic Coffer Door - On opened - Notify Warbringer Constructs'
FROM `gameobject_template`
WHERE `entry` IN (174554, 174555, 174556, 174557, 174558, 174559, 174560,
                  174561, 174562, 174563, 174564, 174566);

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `event_type`, `event_chance`,
 `action_type`, `action_param1`, `target_type`, `target_param1`,
 `target_param2`, `comment`)
SELECT `entry`, 1, 1, 61, 100, 147, 17, 20, 160836, 10,
       'Relic Coffer Door - On opened - Unlock nearby relic coffer'
FROM `gameobject_template`
WHERE `entry` IN (174554, 174555, 174556, 174557, 174558, 174559, 174560,
                  174561, 174562, 174563, 174564, 174566);

-- Keep the converted vanilla attack scripts (IDs 0 and 1) and add the
-- missing encounter state transitions to the other three constructs.
DELETE FROM `smart_scripts`
WHERE `source_type` = 0 AND `entryorguid` = 8905 AND `id` BETWEEN 2 AND 7;

DELETE FROM `smart_scripts`
WHERE (`source_type` = 0 AND `entryorguid` = -20046610)
   OR (`source_type` = 9 AND `entryorguid` IN (890500, 890501));

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_param1`,
 `event_param2`, `event_flags`, `action_type`, `action_param1`,
 `action_param2`, `action_param3`, `target_type`, `comment`) VALUES
(8905, 0, 2, 0, 38, 0, 1, 0, 63, 1, 1, 0, 1,
 'Warbringer Construct - On coffer opened - Increment counter'),
(8905, 0, 3, 0, 77, 1, 12, 1, 80, 890500, 2, 0, 1,
 'Warbringer Construct - At twelve coffers - Run activation list'),
(8905, 0, 4, 5, 25, 0, 0, 0, 8, 0, 0, 0, 1,
 'Warbringer Construct - On reset - Become passive'),
(8905, 0, 5, 6, 61, 0, 0, 0, 144, 1, 0, 0, 1,
 'Warbringer Construct - On reset - Become immune to players'),
(8905, 0, 6, 7, 61, 0, 0, 0, 146, 1, 0, 0, 1,
 'Warbringer Construct - On reset - Become uninteractible'),
(8905, 0, 7, 0, 61, 0, 0, 0, 63, 1, 0, 1, 1,
 'Warbringer Construct - On reset - Reset coffer counter');

-- This spawn has a GUID-specific script, which replaces the entry script.
-- Include the normal construct behavior and summon Doomgrip on activation.
INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `link`, `event_type`, `event_param1`,
 `event_param2`, `event_param3`, `event_param4`, `event_flags`,
 `action_type`, `action_param1`, `action_param2`, `action_param3`,
 `target_type`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(-20046610, 0, 0, 0, 38, 0, 1, 0, 0, 0, 63, 1, 1, 0, 1,
 0, 0, 0, 0, 'Warbringer Construct - On coffer opened - Increment counter'),
(-20046610, 0, 1, 2, 25, 0, 0, 0, 0, 0, 8, 0, 0, 0, 1,
 0, 0, 0, 0, 'Warbringer Construct - On reset - Become passive'),
(-20046610, 0, 2, 3, 61, 0, 0, 0, 0, 0, 144, 1, 0, 0, 1,
 0, 0, 0, 0, 'Warbringer Construct - On reset - Become immune to players'),
(-20046610, 0, 3, 4, 61, 0, 0, 0, 0, 0, 146, 1, 0, 0, 1,
 0, 0, 0, 0, 'Warbringer Construct - On reset - Become uninteractible'),
(-20046610, 0, 4, 0, 61, 0, 0, 0, 0, 0, 63, 1, 0, 1, 1,
 0, 0, 0, 0, 'Warbringer Construct - On reset - Reset coffer counter'),
(-20046610, 0, 5, 0, 77, 1, 12, 0, 0, 1, 80, 890501, 2, 0, 1,
 0, 0, 0, 0, 'Warbringer Construct - At twelve coffers - Run Doomgrip list'),
(-20046610, 0, 6, 0, 0, 4000, 4000, 8000, 8000, 0, 11, 15621, 0, 0, 2,
 0, 0, 0, 0, 'Warbringer Construct - In combat - Cast Skull Crack');

INSERT INTO `smart_scripts`
(`entryorguid`, `source_type`, `id`, `action_type`, `action_param1`,
 `action_param2`, `target_type`, `target_x`, `target_y`, `target_z`, `target_o`,
 `comment`) VALUES
(890500, 9, 0, 144, 0, 0, 1, 0, 0, 0, 0,
 'Warbringer Construct - Activation - Remove player immunity'),
(890500, 9, 1, 146, 0, 0, 1, 0, 0, 0, 0,
 'Warbringer Construct - Activation - Make interactible'),
(890500, 9, 2, 8, 2, 0, 1, 0, 0, 0, 0,
 'Warbringer Construct - Activation - Become aggressive'),
(890501, 9, 0, 144, 0, 0, 1, 0, 0, 0, 0,
 'Warbringer Construct - Activation - Remove player immunity'),
(890501, 9, 1, 146, 0, 0, 1, 0, 0, 0, 0,
 'Warbringer Construct - Activation - Make interactible'),
(890501, 9, 2, 8, 2, 0, 1, 0, 0, 0, 0,
 'Warbringer Construct - Activation - Become aggressive'),
(890501, 9, 3, 12, 9476, 7, 8, 813.737915, -347.550354, -50.578030, 0.670515,
 'Warbringer Construct - Activation - Summon Watchman Doomgrip');
