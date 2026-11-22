-- Templar's Bulwark (1311015): the client describes its 100-point effect as 100% of maximum health
-- and applies the 50-second Forbearance aura (25771), which also blocks recasting it.
-- Safe to run again.
DELETE FROM `spell_script_names`
WHERE `spell_id` = 1311015
  AND `ScriptName` IN ('classic_spell_pal_templars_bulwark', 'classic_spell_pal_forbearance');

INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1311015, 'classic_spell_pal_templars_bulwark'),
(1311015, 'classic_spell_pal_forbearance');
