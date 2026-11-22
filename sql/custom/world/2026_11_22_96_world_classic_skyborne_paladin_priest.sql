-- Classic 1.60: enable Paladin and Priest for both Skyborne races (95 and 96).
-- They start on Zephras Isle with the corresponding Classic class loadout.
REPLACE INTO `class_expansion_requirement`
    (`ClassID`, `RaceID`, `ActiveExpansionLevel`, `AccountExpansionLevel`)
VALUES
(2, 95, 0, 0),
(5, 95, 0, 0),
(2, 96, 0, 0),
(5, 96, 0, 0);

DELETE FROM `playercreateinfo` WHERE `race` IN (95, 96) AND `class` IN (2, 5);
INSERT INTO `playercreateinfo`
    (`race`, `class`, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
     `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
     `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`)
SELECT 96, 2, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
    `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
    `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`
FROM `playercreateinfo` WHERE `race` = 96 AND `class` = 1;

INSERT INTO `playercreateinfo`
    (`race`, `class`, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
     `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
     `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`)
SELECT 96, 5, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
    `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
    `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`
FROM `playercreateinfo` WHERE `race` = 96 AND `class` = 1;

INSERT INTO `playercreateinfo`
    (`race`, `class`, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
     `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
     `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`)
SELECT 95, 2, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
    `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
    `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`
FROM `playercreateinfo` WHERE `race` = 95 AND `class` = 1;

INSERT INTO `playercreateinfo`
    (`race`, `class`, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
     `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
     `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`)
SELECT 95, 5, `map`, `position_x`, `position_y`, `position_z`, `orientation`,
    `npe_map`, `npe_position_x`, `npe_position_y`, `npe_position_z`, `npe_orientation`,
    `npe_transport_guid`, `intro_movie_id`, `intro_scene_id`, `npe_intro_scene_id`
FROM `playercreateinfo` WHERE `race` = 95 AND `class` = 1;

DELETE FROM `playercreateinfo_action` WHERE `race` IN (95, 96) AND `class` IN (2, 5);
INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`)
SELECT 96, `class`, `button`, `action`, `type`
FROM `playercreateinfo_action` WHERE (`race` = 1 AND `class` = 2) OR (`race` = 5 AND `class` = 5);
INSERT INTO `playercreateinfo_action` (`race`, `class`, `button`, `action`, `type`)
SELECT 95, `class`, `button`, `action`, `type`
FROM `playercreateinfo_action` WHERE (`race` = 1 AND `class` = 2) OR (`race` = 1 AND `class` = 5);

DELETE FROM `playercreateinfo_item` WHERE `race` IN (95, 96) AND `class` IN (2, 5);
INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`)
SELECT 96, `class`, `itemid`, `amount`
FROM `playercreateinfo_item` WHERE (`race` = 1 AND `class` = 2) OR (`race` = 5 AND `class` = 5);
INSERT INTO `playercreateinfo_item` (`race`, `class`, `itemid`, `amount`)
SELECT 95, `class`, `itemid`, `amount`
FROM `playercreateinfo_item` WHERE (`race` = 1 AND `class` = 2) OR (`race` = 1 AND `class` = 5);
