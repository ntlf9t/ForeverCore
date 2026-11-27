-- Silithus Wind Stones (Lesser Wind Stone, Wind Stone, Greater Wind Stone): the Classic script classic_go_wind_stone (classic_silithus.cpp,
-- after VMaNGOS go_wind_stoneAI) replaces TrinityCore's go_wind_stone. It uses up the Crest, Signet or Scepter of Beckoning a chosen summon
-- needs (TrinityCore's kept it, so one Crest summoned forever), raises the Templar, Duke or Lord on the open ground VMaNGOS gives three stones,
-- keeps it unattackable for the 8 second summon while it speaks to the summoner, then sends it at the summoner. Same 12 stones as
-- TrinityCore's 2011_07_05_03_world_go_script_names.sql; all 12 are spawned (baseline 01).
UPDATE `gameobject_template` SET `ScriptName` = 'classic_go_wind_stone'
WHERE `entry` IN (180456, 180461, 180466, 180518, 180529, 180534, 180539, 180544, 180549, 180554, 180559, 180564);
