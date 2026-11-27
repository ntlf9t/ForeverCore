-- WoW Forever: two spell focus stand-ins that stand on the real object. 2026_11_05_99_world_forever_restore_forever_quest_data.sql
-- added focus objects (entries 8380001-8380210) where quests needed one and none was spawned. Two of them now stand
-- beside a Forever object that gives the same focus (SpellFocusObject), within its 10 yard radius:
--   8380001 Offering Stone (spell focus), focus 2332, 1.7 yd from 679433 Offering Stone (focus 2332)
--   8380005 Brazier of Offering (spell focus), focus 2308, 4 yd from 661086 Eternal Flame (focus 2308)
-- The stand-in's spawn goes only while such an object still stands within 10 yards on its map; its template goes once
-- nothing spawns it. The other stand-ins stay: no Forever object with their focus is spawned (8380210's Ritual Site
-- 629694 has a template, but no source places it). Safe to run again.

DROP TEMPORARY TABLE IF EXISTS `everlake_focus_go`;
CREATE TEMPORARY TABLE `everlake_focus_go` (`guid` bigint unsigned NOT NULL PRIMARY KEY);
INSERT IGNORE INTO `everlake_focus_go` (`guid`)
SELECT s.`guid` FROM `gameobject` s
JOIN `gameobject_template` st ON st.`entry` = s.`id` AND st.`type` = 8
JOIN `gameobject_template` rt ON rt.`type` = 8 AND rt.`Data0` = st.`Data0` AND rt.`entry` < 1000000
JOIN `gameobject` r ON r.`id` = rt.`entry` AND r.`map` = s.`map`
  AND (r.`position_x` - s.`position_x`) * (r.`position_x` - s.`position_x`) + (r.`position_y` - s.`position_y`) * (r.`position_y` - s.`position_y`)
    + (r.`position_z` - s.`position_z`) * (r.`position_z` - s.`position_z`) <= 100
WHERE s.`id` IN (8380001, 8380005);
DELETE a FROM `gameobject_addon` a JOIN `everlake_focus_go` t ON t.`guid` = a.`guid`;
DELETE g FROM `game_event_gameobject` g JOIN `everlake_focus_go` t ON t.`guid` = g.`guid`;
DELETE o FROM `gameobject` o JOIN `everlake_focus_go` t ON t.`guid` = o.`guid`;
DROP TEMPORARY TABLE `everlake_focus_go`;
DELETE FROM `gameobject_template` WHERE `entry` IN (8380001, 8380005) AND NOT EXISTS (SELECT 1 FROM `gameobject` o WHERE o.`id` = `gameobject_template`.`entry`);
