-- WoW Forever: Vampiric Embrace's heal 15290 heals the party for the share of the Shadow damage, and the priest for that share raised by
-- 15286 effect 1 (Blizzard's 16 November hotfix: party 10%, the priest's own heal +100%; the records are in the hotfixes file
-- 2026_11_24_50_hotfixes_forever_live_pushes_71037.sql). classic_spell_pri_vampiric_embrace_heal raises the priest's heal. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName`='classic_spell_pri_vampiric_embrace_heal';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(15290,'classic_spell_pri_vampiric_embrace_heal');
