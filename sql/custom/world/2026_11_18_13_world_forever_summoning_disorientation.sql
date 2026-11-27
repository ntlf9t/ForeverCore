-- WoW Forever: the demon out is stunned by Summoning Disorientation (1249755, 6 sec) from the start of the warlock's next demon summon
-- (script classic_spell_warl_summoning_disorientation; wowsims/forever, MIT, sim/warlock/summon.go). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_warl_summoning_disorientation';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(688, 'classic_spell_warl_summoning_disorientation'),
(691, 'classic_spell_warl_summoning_disorientation'),
(697, 'classic_spell_warl_summoning_disorientation'),
(712, 'classic_spell_warl_summoning_disorientation'),
(713, 'classic_spell_warl_summoning_disorientation');
