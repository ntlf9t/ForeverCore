-- WoW Forever: Scented Runewood Brooch 269741 (aura 1318323) procs 1.2 times a minute on the weapon's speed, against Furbolgs only (script
-- classic_spell_item_scented_runewood_brooch). The client chance reads 100 and nothing limited the target, so it struck on every hit
-- against anything (wowsims/forever, MIT, tools/database/overrides/spell_overrides.go; a log fit not yet validated, EV-0136). ProcFlags
-- 0 keeps the client's melee, ranged and harmful spell hits. Safe to run again.
DELETE FROM `spell_proc` WHERE `SpellId` = 1318323;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1318323, 0, 0, 0, 0, 0, 0, 0, 0, 1, 2, 0, 0, 0, 1.2, 0, 0, 0);
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_item_scented_runewood_brooch';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (1318323, 'classic_spell_item_scented_runewood_brooch');
