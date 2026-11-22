-- Classic 1.60: enable Tauren Paladins (race 6, class 2).
-- Start in the normal Tauren location, with Classic Paladin equipment and action bars.
REPLACE INTO `class_expansion_requirement`
    (`ClassID`, `RaceID`, `ActiveExpansionLevel`, `AccountExpansionLevel`)
VALUES (2, 6, 0, 0);

DELETE FROM `playercreateinfo` WHERE `race` = 6 AND `class` = 2;
INSERT INTO `playercreateinfo`
    (`race`, `class`, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
     `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
     `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`)
SELECT 6, 2, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
    `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
    `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`
FROM `playercreateinfo` WHERE `race` = 6 AND `class` = 1;

DELETE FROM `playercreateinfo_action` WHERE `race` = 6 AND `class` = 2;
INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`)
SELECT 6, 2, `button`, `action`, `type`
FROM `playercreateinfo_action` WHERE `race` = 1 AND `class` = 2;

DELETE FROM `playercreateinfo_item` WHERE `race` = 6 AND `class` = 2;
INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`)
SELECT 6, 2, `itemid`, `amount`
FROM `playercreateinfo_item` WHERE `race` = 1 AND `class` = 2;
