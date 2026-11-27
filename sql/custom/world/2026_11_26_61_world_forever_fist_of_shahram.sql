-- Fist of Shahram (16601), cast by Shahram (10718, summoned by the Blackblade of Shahram's 16602): WoW Forever note of 71139
-- (2026-11-25, Blizzard's notes in the tracker's timeline): "The Blackblade of Shahram will now correctly perform its haste buff, but
-- only to the wielder of the Blackblade." The live spell effect (693406, 2026_11_26_00 hotfixes) targets the caster's master; Shahram
-- has no owner, so classic_spell_fist_of_shahram points it at the player who summoned him.
-- Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` = 16601 AND `ScriptName` = 'classic_spell_fist_of_shahram';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (16601, 'classic_spell_fist_of_shahram');
