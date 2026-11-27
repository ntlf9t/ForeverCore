-- WoW Forever: a creature 3 or more levels above the warrior is immune to Intercept's stun and its damage (script
-- classic_spell_warr_intercept_stun; wowsims/forever, MIT, docs/rulings R-0004, evidence pending). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_warr_intercept_stun';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(20253, 'classic_spell_warr_intercept_stun'),
(20614, 'classic_spell_warr_intercept_stun'),
(20615, 'classic_spell_warr_intercept_stun');
