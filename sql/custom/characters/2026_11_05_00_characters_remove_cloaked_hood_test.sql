-- Item 19743 "Cloaked Hood TEST" is a developer test item that ships in the client data; nobody can get it in the real game.
-- Bots wore it from their gear pool before the pool dropped test items (20 Oct, "Fast Test Thrown"), and kept it: on the dev
-- realm 130 bot characters held one (73 on the head, the rest in bags and bank). Take it from every character's bags, bank and
-- equipment, with the side rows of those items. Copies on the auction house or in a guild bank are left alone (their own
-- tables point at them). A bot whose head slot empties picks a real helm at its next gear check. Safe to run again.
DROP TEMPORARY TABLE IF EXISTS `tmp_cloaked_hood_test`;
CREATE TEMPORARY TABLE `tmp_cloaked_hood_test` (`guid` bigint unsigned NOT NULL PRIMARY KEY)
SELECT ci.`item` AS `guid` FROM `character_inventory` ci JOIN `item_instance` ii ON ii.`guid` = ci.`item` WHERE ii.`itemEntry` = 19743;

DELETE FROM `item_instance_transmog` WHERE `itemGuid` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);
DELETE FROM `item_instance_modifiers` WHERE `itemGuid` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);
DELETE FROM `item_instance_gems` WHERE `itemGuid` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);
DELETE FROM `item_soulbound_trade_data` WHERE `itemGuid` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);
DELETE FROM `item_refund_instance` WHERE `item_guid` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);
DELETE FROM `character_inventory` WHERE `item` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);
DELETE FROM `item_instance` WHERE `guid` IN (SELECT `guid` FROM `tmp_cloaked_hood_test`);

DROP TEMPORARY TABLE `tmp_cloaked_hood_test`;
