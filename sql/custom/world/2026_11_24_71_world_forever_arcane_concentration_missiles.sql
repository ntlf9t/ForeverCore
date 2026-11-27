-- Arcane Concentration (11213), WoW Forever hotfix of 9 Nov 2026: "activation chance now correctly splits across the cast and every
-- bolt", with a 1 sec cooldown. classic_spell_mage_arcane_concentration (classic_talents_mage_shaman.cpp) rolls each Arcane Missiles
-- missile at a share of the chance and each Flamestrike ground tick once; classic_spell_mage_arcane_missiles_concentration rolls the
-- channel start's share. Evidence: MythicSim docs/mechanics.md (Forever combat logs: 8.9% of 347 channel starts, 13 of 82 Flamestrike
-- ticks) and wowsims/forever EV-0098 (both MIT).
-- The row: harmful spell damage hits as before, plus PROC_ATTR_TRIGGERED_CAN_PROC (0x2) so the triggered missiles reach the script
-- (it turns away every other triggered spell), and the talent's 1 sec cooldown. Safe to run again.
DELETE FROM `spell_proc` WHERE `SpellId` = 11213;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(11213, 0, 0, 0, 0, 0, 0, 0x10000, 0, 1, 2, 0, 0x2, 0, 0, 100, 1000, 0); -- harmful spell damage hits, triggered missiles included, 1 s cooldown

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_mage_arcane_missiles_concentration';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(5143, 'classic_spell_mage_arcane_missiles_concentration'),
(5144, 'classic_spell_mage_arcane_missiles_concentration'),
(5145, 'classic_spell_mage_arcane_missiles_concentration'),
(8416, 'classic_spell_mage_arcane_missiles_concentration'),
(8417, 'classic_spell_mage_arcane_missiles_concentration'),
(10211, 'classic_spell_mage_arcane_missiles_concentration'),
(10212, 'classic_spell_mage_arcane_missiles_concentration'),
(25345, 'classic_spell_mage_arcane_missiles_concentration');
