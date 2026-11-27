-- WoW Forever mage, checked against the live client data (Blizzard's hotfix cache of build 70707) and wowsims/forever (MIT,
-- https://github.com/wowsims/forever). Scripts in src/server/scripts/Custom/Classic/world/talents/classic_talents_mage_shaman.cpp.
--  * Heating Up 400624: "Fire Blast grants an additional stack every time it deals damage." The proc row took critical hits only; it now
--    takes every hit of Fireball, Fire Blast, Scorch and Frostfire Bolt, and classic_spell_mage_heating_up keeps critical hits and Fire
--    Blast hits (a Fire Blast gives one stack, two when it crits).
--  * Missile Barrage 400589: the Arcane Missiles channels get classic_spell_mage_arcane_missiles_barrage, which makes a Missile Barrage
--    channel last half as long with a missile every 0.5 sec (5 missiles, as live).
--  * Heating Up buff 400625: classic_spell_mage_heating_up_buff keeps the stacks when Presence of Mind makes the Pyroblast instant.
-- Safe to run again.

DELETE FROM `spell_proc` WHERE `SpellId` = 400624;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`, `ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(400624, 0, 3, 0x13, 0x1000, 0, 0, 0x10000, 0, 1, 2, 0x3, 0, 0, 0, 0, 0, 0); -- Heating Up: Fireball, Fire Blast, Scorch, Frostfire Bolt hits and critical hits

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_mage_arcane_missiles_barrage';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(5143, 'classic_spell_mage_arcane_missiles_barrage'),
(5144, 'classic_spell_mage_arcane_missiles_barrage'),
(5145, 'classic_spell_mage_arcane_missiles_barrage'),
(8416, 'classic_spell_mage_arcane_missiles_barrage'),
(8417, 'classic_spell_mage_arcane_missiles_barrage'),
(10211, 'classic_spell_mage_arcane_missiles_barrage'),
(10212, 'classic_spell_mage_arcane_missiles_barrage'),
(25345, 'classic_spell_mage_arcane_missiles_barrage');

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_mage_heating_up_buff';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(400625, 'classic_spell_mage_heating_up_buff');
