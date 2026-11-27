-- Karrz scripts batch: who owns the Classic talent procs.
-- advocaite/TrinityCore#325 (MAXIMUS, reviewed and merged into everlake 2026-11-08, with our per-talent rules in ClassicProcRules.h)
-- and Karrz's talent scripts (classic_talents_*.cpp, ported in this batch) both handle some of the same spells. Karrz's world never had
-- #325, so a spell carrying both scripts is a combination nobody has run. Rule: where Karrz's data gives a spell a script of its own,
-- Karrz's design owns it and the #325 script comes off; #325 stays on every spell Karrz leaves alone (Grave Touch, Flametongue,
-- Windfury and the proc-chance script on the other talents).
-- Lightning Shield, Reckoning and Missile Barrage: same script names in both, Karrz's implementation is the one compiled now.
-- Nightfall (18094) and Reckoning's attack counter (1326084): Karrz's classic_talent_warl_nightfall / classic_spell_pal_reckoning_stored
-- replace #325's classes, which are no longer built. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('classic_spell_proc_chance_from_effect', 'classic_spell_proc_chance_from_effect_dummy') AND `spell_id` IN (
  11071,  -- Frostbite (Karrz: classic_spell_mage_frostbite)
  11180,  -- Winter's Chill (classic_spell_mage_winters_chill)
  11213,  -- Arcane Concentration (classic_spell_mage_arcane_concentration)
  12322,  -- Unbridled Wrath (classic_spell_warr_unbridled_wrath)
  13754,  -- Improved Kick (classic_spell_rog_improved_kick)
  13976,  -- Initiative (classic_spell_rog_initiative)
  14156,  -- Ruthlessness (classic_spell_rog_ruthlessness)
  16850,  -- Improved Starfire (classic_spell_dru_improved_starfire)
  20210   -- Illumination (classic_spell_pal_illumination)
);
DELETE FROM `spell_script_names` WHERE `spell_id` = 18094 AND `ScriptName` = 'classic_spell_warl_nightfall';
DELETE FROM `spell_script_names` WHERE `spell_id` = 1326084 AND `ScriptName` = 'classic_spell_pal_reckoning_attacks';
