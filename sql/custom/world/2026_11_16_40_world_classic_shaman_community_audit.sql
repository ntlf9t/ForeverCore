-- Shaman community audit (2026-11-16), two client spells the core left unscripted. Safe to run again.
-- Water Shield 408510 (Restoration talent): the client row hears hits taken and every helpful or harmful spell the shaman lands, with no
-- hit mask, so each landed spell spent a globe. Live 70938 tooltip: "... or when one of the caster's spells gets a critical result".
-- classic_spell_sha_water_shield keeps hits taken as they are and lets the shaman's own spells spend a globe on a crit only.
-- Totemic Call 437009 (level 22): "Relocates your active totems to your location." Its only effect summons NPC 15214, which moved
-- nothing; classic_spell_sha_totemic_call moves the shaman's totems to the shaman instead.
DELETE FROM `spell_script_names` WHERE (`spell_id`, `ScriptName`) IN
((408510, 'classic_spell_sha_water_shield'),
 (437009, 'classic_spell_sha_totemic_call'));
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(408510, 'classic_spell_sha_water_shield'),
(437009, 'classic_spell_sha_totemic_call');
