-- WoW Forever, 25 November 2026: Dreamstate (408258) replaces Moonfury and now gives the druid 20/40/60/80/100% of Innervate when
-- it is cast on someone else. The script moves from Dreamstate's old effect (spell critical strikes giving mana regeneration while
-- casting, 2026_10_11_33) to Innervate itself. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_talent_dru_dreamstate';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(29166, 'classic_talent_dru_dreamstate');
