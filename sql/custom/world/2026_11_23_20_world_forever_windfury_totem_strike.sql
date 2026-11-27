-- Windfury Totem's strike (8516, 10608, 10610): a main hand weapon damage hit on the enemy since the 2026-11-14 live hotfix (client 71037).
-- C++: Custom/Classic/world/talents/classic_talents_mage_shaman.cpp. classic_spell_sha_weapon_totem_aura (already bound to the totem auras
-- 8515, 10609, 10612) now casts it at the enemy with rank 3's attack power; this script gives a landed strike the rage of a main hand
-- white swing (wowsims/forever, MIT, docs/evidence EV-0138). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_sha_windfury_totem_strike';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(8516, 'classic_spell_sha_windfury_totem_strike'),
(10608, 'classic_spell_sha_windfury_totem_strike'),
(10610, 'classic_spell_sha_windfury_totem_strike');
