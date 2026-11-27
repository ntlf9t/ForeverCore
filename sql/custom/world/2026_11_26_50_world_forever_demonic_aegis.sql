-- WoW Forever, 20 November 2026 (71037+1): "Fixed a bug where the effects of the Demonic Aegis talent could be snapshotted into your
-- Demon Armor or Demon Skin and then untalented to retain the effects. Demonic Aegis and Demon Skin are removed when your talents are
-- unlearned." classic_talent_warl_demonic_aegis (classic_talents_warlock_druid.cpp) removes the warlock's Demon Skin and Demon Armor
-- when the talent's aura 1235316 leaves. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_talent_warl_demonic_aegis';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1235316, 'classic_talent_warl_demonic_aegis');
