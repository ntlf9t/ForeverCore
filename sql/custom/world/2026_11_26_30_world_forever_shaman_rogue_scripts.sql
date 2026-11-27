-- WoW Forever shaman and rogue fixes from Blizzard's notes (server side):
--   16257 Flurry (shaman buff): Windfury Totem strikes spend no charge (hotfix 17 Nov, build 70959).
--   17364 Stormstrike debuff: only the casting shaman spends its charge (build 70450 notes).
--   8178 Grounding Totem Effect: the totem is destroyed after it redirects a spell (build 70450 notes).
--   1329286 Boot Knife: no proc of its own, only the Shank roll (build 70755 notes).
--   2070, 6770, 11297 Sap: Quick Getaway 1310728 speed buff 1329282 after a landed Sap (build 70755 notes).
-- C++: Custom/Classic/world/talents/classic_talents_mage_shaman.cpp (classic_spell_sha_flurry_buff, classic_spell_sha_stormstrike_debuff,
-- classic_spell_sha_grounding_totem_effect) and classic_rogue_abilities.cpp (classic_spell_rog_boot_knife,
-- classic_spell_rog_sap_quick_getaway). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('classic_spell_sha_flurry_buff', 'classic_spell_sha_stormstrike_debuff',
'classic_spell_sha_grounding_totem_effect', 'classic_spell_rog_boot_knife', 'classic_spell_rog_sap_quick_getaway');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(16257, 'classic_spell_sha_flurry_buff'),
(17364, 'classic_spell_sha_stormstrike_debuff'),
(8178, 'classic_spell_sha_grounding_totem_effect'),
(1329286, 'classic_spell_rog_boot_knife'),
(2070, 'classic_spell_rog_sap_quick_getaway'),
(6770, 'classic_spell_rog_sap_quick_getaway'),
(11297, 'classic_spell_rog_sap_quick_getaway');
