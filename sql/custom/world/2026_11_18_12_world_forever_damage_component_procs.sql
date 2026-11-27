-- WoW Forever: melee procs whose tooltips name no trigger condition hear only hits with a damage component, a hit that deals damage or the
-- landing of a damage-over-time effect (Rend); damage-free melee abilities (Sunder Armor, Disarm) roll nothing (script
-- classic_spell_item_proc_damage_component; wowsims/forever, MIT, ProcHintDamage, its maintainers' ruling in PR #99, not a measurement).
-- Blazefury Medallion 7711, Fiery Plate Gauntlets 7721, Storm Gauntlets 16615 (every such hit, the client's 100), Darkmoon Card: Maelstrom
-- 23686 (1 a minute) and Badge of the Swarmguard 26480 (10 a minute), as 2026_10_11_09 set them. ProcFlags 0 keeps the client's hits;
-- spell type damage or none, the script deciding. Safe to run again.
DELETE FROM `spell_proc` WHERE `SpellId` IN (7711, 7721, 16615, 23686, 26480);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(7711, 0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 0, 100, 0, 0),
(7721, 0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 0, 100, 0, 0),
(16615, 0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 0, 100, 0, 0),
(23686, 0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 1, 0, 0, 0),
(26480, 0, 0, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 10, 0, 0, 0);
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_item_proc_damage_component';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(7711, 'classic_spell_item_proc_damage_component'), (7721, 'classic_spell_item_proc_damage_component'),
(16615, 'classic_spell_item_proc_damage_component'), (23686, 'classic_spell_item_proc_damage_component'),
(26480, 'classic_spell_item_proc_damage_component');
