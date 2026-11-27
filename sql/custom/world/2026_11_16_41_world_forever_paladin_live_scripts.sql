-- WoW Forever paladin: script bindings and proc data from the community paladin audit (2026-11-16).
-- C++: Custom/Classic/world/classic_spell_scripts.cpp and talents/classic_talents_priest_paladin.cpp. Safe to run again.

-- Judgement of Command (damage spells of Seal of Command ranks 1-5): the spells hold the "stunned or incapacitated" amount; half of it
-- on any other target, as the Seal of Command tooltip says.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_pal_judgement_of_command_damage';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(20467, 'classic_spell_pal_judgement_of_command_damage'),
(20963, 'classic_spell_pal_judgement_of_command_damage'),
(20964, 'classic_spell_pal_judgement_of_command_damage'),
(20965, 'classic_spell_pal_judgement_of_command_damage'),
(20966, 'classic_spell_pal_judgement_of_command_damage');

-- Lay on Hands: "Drains all of the Paladin's remaining Mana when used, but does not interrupt Mana regeneration." Nothing drained it.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_pal_lay_on_hands_drain';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(633, 'classic_spell_pal_lay_on_hands_drain'),
(2800, 'classic_spell_pal_lay_on_hands_drain'),
(10310, 'classic_spell_pal_lay_on_hands_drain');

-- Illumination: the 1.60 tooltip names Flash of Light, Holy Light, Light's Vigil and the Holy Shock heal. The row of 2026_10_22_73 only
-- had Holy Light and Flash of Light (mask 0 0xC0000000); the Holy Shock heals (mask 1 0x10000) and the Light's Vigil heals (mask 3
-- 0x4000000) are added. Both are triggered spells, hence PROC_ATTR_TRIGGERED_CAN_PROC (AttributesMask 0x2). Critical heals only.
DELETE FROM `spell_proc` WHERE `SpellId` = 20210;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(20210, 0, 10, 0xC0000000, 0x10000, 0, 0x4000000, 0x4000, 0, 2, 2, 0x2, 0x2, 0, 0, 0, 0, 0);
