-- Stratholme Service Entrance Gate (175368) runs classic_go_strat_service_entrance (Custom/Classic/world/classic_dbscript_spells.cpp).
-- Karrz's 2026_11_05_99_world_forever_restore_forever_quest_data (a row diff between two of Karrz's worlds) writes the template
-- again with no ScriptName, which leaves the gate without its script although the script is still built. Safe to run again.
UPDATE `gameobject_template` SET `ScriptName` = 'classic_go_strat_service_entrance' WHERE `entry` = 175368 AND `ScriptName` = '';
