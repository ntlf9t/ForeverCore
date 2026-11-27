-- WoW Forever: a druid's change of form keeps the current health percentage (Cat 768, Bear 5487, Dire Bear 9634, Moonkin 24858;
-- wowsims/forever, MIT, docs/rulings R-0019, evidence pending). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_dru_form_keeps_health_pct';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(768, 'classic_spell_dru_form_keeps_health_pct'),
(5487, 'classic_spell_dru_form_keeps_health_pct'),
(9634, 'classic_spell_dru_form_keeps_health_pct'),
(24858, 'classic_spell_dru_form_keeps_health_pct');
