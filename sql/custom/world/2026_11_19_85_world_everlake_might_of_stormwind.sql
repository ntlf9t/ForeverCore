-- Might of Stormwind (460939), the Alliance buff for Rend Blackhand's head: live's chain is End of the Dark Horde 84377 (head to
-- Master Mathias Shaw), then 97883 (Shaw sends you to Major Mattingly at the city gates, "He and his men will proclaim the great
-- victory"; Wowhead and Icy Veins quest 97883). The quests come from wow-everlake-world-data, but nothing gave the buff. Mattingly
-- now casts it when 97883 is turned in, the way he casts Rallying Cry for Onyxia's head (quest 7496); the spell reaches the
-- allies around him. No yell: no source has his line for Rend. Safe to run again.
DELETE FROM `smart_scripts` WHERE `entryorguid` = 14394 AND `source_type` = 0 AND `id` = 2;
INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(14394, 0, 2, 0, '', 20, 0, 100, 0, 97883, 0, 0, 0, 0, '', 11, 460939, 2, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Major Mattingly - On quest 97883 rewarded - Cast Might of Stormwind');
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 14394 AND `AIName` = '';

-- Might of Stormwind counts as a boss celebration buff for the Legacy perks (ClassicLegacyPerks::IsBossCelebrationBuff), so it
-- needs the script that clears Second Chance's mark 1262777 when the last such buff ends (2026_10_25_94 lists the others).
DELETE FROM `spell_script_names` WHERE `spell_id` IN (460939, 460940, 1304678) AND `ScriptName` = 'classic_spell_legacy_boss_celebration_buff';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(460939, 'classic_spell_legacy_boss_celebration_buff'),
(460940, 'classic_spell_legacy_boss_celebration_buff'),
(1304678, 'classic_spell_legacy_boss_celebration_buff');
