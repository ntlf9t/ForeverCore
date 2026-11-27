-- Revelation weapon enchant (8217, equip aura 1248806): the aura names no trigger spell, so it did nothing (forever-bugs #163, #357,
-- #374, #401, #526, #528). classic_spell_item_revelation casts the class's buff (mage 1248808, priest 1323377, warlock 1323392,
-- druid 1323400, hunter 1323410, shaman 1323418, paladin 1323419) in combat, off non-melee spells.
-- spell_proc: spell damage or heal hits (0x14000), on hit, only non-crit hits (HitMask 0x1), 8% a hit as measured on live
-- (wowsims evidence EV-0129: 8.5% druid, 7.4% mage at about 10% crit). Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` = 1248806 AND `ScriptName` = 'classic_spell_item_revelation';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1248806, 'classic_spell_item_revelation');

DELETE FROM `spell_proc` WHERE `SpellId` = 1248806;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1248806, 0, 0, 0, 0, 0, 0, 0x14000, 0, 3, 2, 0x1, 0, 0, 0, 8, 0, 0);
