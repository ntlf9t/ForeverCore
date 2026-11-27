-- WoW Forever mage: Frost Armor's and Ice Armor's Chilled (6136, 7321) roll Frostbite and Fingers of Frost like the mage's other Chill
-- effects (client Chill flag 0x100000 on both; patch 4.1.0 "The Chilled proc from Frost Armor can no longer proc Fingers of Frost").
-- Script classic_spell_mage_armor_chill in src/server/scripts/Custom/Classic/world/talents/classic_talents_mage_shaman.cpp. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_mage_armor_chill';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(6136, 'classic_spell_mage_armor_chill'),
(7321, 'classic_spell_mage_armor_chill');
