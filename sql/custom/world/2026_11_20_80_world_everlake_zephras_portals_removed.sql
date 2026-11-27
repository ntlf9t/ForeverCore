-- Zephras Isle (map 2991), Valanaar auction house: remove the two city
-- portals the AnoCore restore (2026_11_05_99) added. Both stood side by side
-- with no faction gate, so Alliance players saw the Orgrimmar portal too.
-- Live Forever has no city portals on the isle (Stormwind/Orgrimmar portals
-- are in Dalaran), and 8380101/8380102 are invented entries, not Forever ones.
DELETE FROM `gameobject` WHERE `id` IN (8380101,8380102);
DELETE FROM `gameobject_addon` WHERE `guid` IN (838010100,838010200);
DELETE FROM `gameobject_template_addon` WHERE `entry` IN (8380101,8380102);
DELETE FROM `gameobject_template` WHERE `entry` IN (8380101,8380102);
