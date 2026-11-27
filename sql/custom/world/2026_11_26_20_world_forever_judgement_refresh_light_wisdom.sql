-- WoW Forever hotfix 1.60.1.71139 (25 November 2026): "Paladin: Fixed an issue where Judgements on enemies failed to refresh from attacks
-- if they dropped below a 20 second duration." Only Judgement of the Crusader had its refresh (25942 swing proc -> 25943, 2026_10_06_04).
-- Judgement of Light and Wisdom get the same from their own client pair: the judgement puts 25752 (Light) / 25757 (Wisdom) on the paladin,
-- a landed melee swing procs 25753 / 25758, and classic_spell_pal_judgement_of_the_crusader_refresh casts the paladin's judgement on the
-- target again. The proc rows copy 25942's (melee swings, normal or critical hit). Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` IN (25753, 25758);
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(25753, 'classic_spell_pal_judgement_of_the_crusader_refresh'),
(25758, 'classic_spell_pal_judgement_of_the_crusader_refresh');
DELETE FROM `spell_proc` WHERE `SpellId` IN (25752, 25757);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(25752, 0, 0, 0, 0, 0, 0, 0x4, 0, 0, 0, 0x3, 0, 0, 0, 100, 0, 0),
(25757, 0, 0, 0, 0, 0, 0, 0x4, 0, 0, 0, 0x3, 0, 0, 0, 100, 0, 0);
