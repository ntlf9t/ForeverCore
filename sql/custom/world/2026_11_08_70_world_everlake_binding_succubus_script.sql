-- advocaite/TrinityCore#181 on Everlake: its file (2026_10_26_06_world_classic_warlock_binding_demons_hostile.sql) replaces
-- Summoned Succubus (5677) SmartAI row 2. 2026_10_26_20_world_quest_summons_hostile.sql already gave her the VMaNGOS script
-- (rows 2-4: 4 s after the summon, faction 14 and attack the summoner). On a fresh world 2026_10_26_06 runs first and
-- 2026_10_26_20 puts row 2 back; on a world that already ran 2026_10_26_20, 2026_10_26_06 runs last and leaves rows 3-4 with
-- no timed event to start them. Running the 2026_10_26_20 rows again here gives both the same result. Safe to run again.
DELETE FROM `smart_scripts` WHERE `entryorguid`=5677 AND `source_type`=0 AND `id` IN (2,3,4);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(5677,0,2,0,54,0,100,0,0,0,0,0,67,1,4000,4000,0,0,100,1,0,0,0,0,0,0,0,'Summoned Succubus - On Just Summoned - Create Timed Event 1 (4 s)'),
(5677,0,3,4,59,0,100,0,1,0,0,0,2,14,0,0,0,0,0,1,0,0,0,0,0,0,0,'Summoned Succubus - On Timed Event 1 - Set Faction Hostile'),
(5677,0,4,0,61,0,100,0,0,0,0,0,49,0,0,0,0,0,0,23,0,0,0,0,0,0,0,'Summoned Succubus - On Link - Attack Summoner');
