-- Weapon procs that "deal $s2 times as much damage" to one kind of enemy, the multiplier being a second effect (a dummy) nothing read:
-- Drain Life 16414, Corpse Eater 1299869, Smite 1299631 (Undead), Lightning Bolt 1292851 (Mechanical), Holy Cleaver 1293787 (Undead,
-- boars), Blazewind Blast 1282503 (wolves). Script classic_spell_item_versus_bonus (classic_spell_scripts.cpp). The rows of these six
-- from Karrz 0.1.39's 2026_11_21_44_world_classic_item_proc_bonuses.sql; the rest of that file is not taken. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_item_versus_bonus';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(16414,'classic_spell_item_versus_bonus'),(1299869,'classic_spell_item_versus_bonus'),(1299631,'classic_spell_item_versus_bonus'),
(1292851,'classic_spell_item_versus_bonus'),(1293787,'classic_spell_item_versus_bonus'),(1282503,'classic_spell_item_versus_bonus');
