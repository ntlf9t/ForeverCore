-- Revelation enchant 1248806 was bound to two scripts: classic_spell_item_revelation (2026_11_16_41_world_forever_bugs_revelation_enchant.sql)
-- and classic_spell_enchant_revelation (2026_11_17_10_world_forever_revelation.sql). The 11-17 file deleted only its own binding, so
-- both ran: both CheckProcs had to pass and each proc cast the class buff twice. The old binding goes; its in-combat, no melee-class
-- spell checks moved into classic_spell_enchant_revelation, and the old C++ class is removed. Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` = 1248806 AND `ScriptName` = 'classic_spell_item_revelation';
