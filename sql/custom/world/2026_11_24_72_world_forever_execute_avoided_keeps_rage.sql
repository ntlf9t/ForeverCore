-- Execute's damage spell 20647: classic_spell_warr_execute_damage (classic_talents_warrior_rogue_hunter.cpp) takes the warrior's extra rage
-- when the hit lands, so an Execute that misses, is dodged or parried costs its base rage alone and the extra rage stays (WoW Forever
-- combat logs, MythicSim docs/mechanics.md, MIT: 36 of 36 avoided Executes from 14 warriors). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_warr_execute_damage';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(20647, 'classic_spell_warr_execute_damage');
