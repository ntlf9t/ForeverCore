-- WoW Forever: Inner Focus 14751 restarts its cooldown when the buff is spent or runs out (wowsims/forever, MIT, docs/rulings R-0015).
-- Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_pri_inner_focus';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (14751, 'classic_spell_pri_inner_focus');
