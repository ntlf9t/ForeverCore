-- WoW Forever: Demonic Brand (1293695). Searing Pain puts the brand 1293696 on the target (classic_spell_warl_demonic_brand); the warlock's
-- demon consumes it (classic_talent_warl_demonic_brand_mark). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('classic_spell_warl_demonic_brand', 'classic_talent_warl_demonic_brand_mark');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(5676, 'classic_spell_warl_demonic_brand'),
(17919, 'classic_spell_warl_demonic_brand'),
(17920, 'classic_spell_warl_demonic_brand'),
(17921, 'classic_spell_warl_demonic_brand'),
(17922, 'classic_spell_warl_demonic_brand'),
(17923, 'classic_spell_warl_demonic_brand'),
(1293696, 'classic_talent_warl_demonic_brand_mark');
