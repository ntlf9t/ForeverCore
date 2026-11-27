-- Dark Inspiration (priest talent 1326159): "Your Mind Blast and fully channeled Mind Flay causes Dark Inspiration, increasing yours and
-- your party's Spirit by 15% for 10 sec." (1326168). The talent is a dummy aura with no proc data, so it never did anything
-- (forever-bugs #372). classic_spell_pri_dark_inspiration casts the buff on a Mind Blast hit (priest family 0x2000, every rank);
-- a fully channeled Mind Flay casts it from classic_spell_pri_mind_flay. Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` = 1326159 AND `ScriptName` = 'classic_spell_pri_dark_inspiration';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1326159, 'classic_spell_pri_dark_inspiration');

DELETE FROM `spell_proc` WHERE `SpellId` = 1326159;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1326159, 0, 6, 0x2000, 0, 0, 0, 0x10000, 0, 1, 2, 0, 0, 0, 0, 100, 0, 0);
