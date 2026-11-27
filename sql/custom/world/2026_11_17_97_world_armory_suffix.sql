-- Classic 1.60: random suffixes on the website armory (contrib/support_site). ".armory export" now writes, per item, the random property
-- points its suffix stats scale with (randPropPoints) and the damage range a caster-reducing suffix gives a weapon (casterDmgMin/Max,
-- WoW Forever's 2/3 or 29/39 share, EV-0110), and every suffix bonus list into armory_suffix: its name ("of the Physician"), its stats as
-- "statType:allocation,..." (value = allocation x randPropPoints / 10000, as Item::GetItemStatValue) and whether it reduces caster
-- damage (ItemBonus type 54). The site reads the equipped item's random bonus list and shows the item as the game does.
-- armory_item is export data, filled again by ".armory export" (the site runs it when the table is empty). Safe to run again.
DROP TABLE IF EXISTS `armory_item`;
CREATE TABLE `armory_item` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `quality` tinyint unsigned NOT NULL DEFAULT '0',
  `itemLevel` smallint unsigned NOT NULL DEFAULT '0',
  `requiredLevel` smallint NOT NULL DEFAULT '0',
  `class` tinyint unsigned NOT NULL DEFAULT '0',
  `subclass` tinyint unsigned NOT NULL DEFAULT '0',
  `inventoryType` tinyint unsigned NOT NULL DEFAULT '0',
  `bonding` tinyint unsigned NOT NULL DEFAULT '0',
  `armor` int unsigned NOT NULL DEFAULT '0',
  `dmgMin` float NOT NULL DEFAULT '0',
  `dmgMax` float NOT NULL DEFAULT '0',
  `delay` int unsigned NOT NULL DEFAULT '0',
  `stats` varchar(255) NOT NULL DEFAULT '',
  `effects` varchar(2048) NOT NULL DEFAULT '',
  `description` varchar(1024) NOT NULL DEFAULT '',
  `iconFileDataId` int NOT NULL DEFAULT '0',
  `sellPrice` int unsigned NOT NULL DEFAULT '0',
  `allowableClass` int NOT NULL DEFAULT '-1',
  `itemSet` smallint unsigned NOT NULL DEFAULT '0',
  `requiredSkill` smallint unsigned NOT NULL DEFAULT '0',
  `requiredSkillRank` smallint unsigned NOT NULL DEFAULT '0',
  `flags` int unsigned NOT NULL DEFAULT '0',
  `randPropPoints` float NOT NULL DEFAULT '0',
  `casterDmgMin` float NOT NULL DEFAULT '0',
  `casterDmgMax` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
CREATE TABLE IF NOT EXISTS `armory_suffix` (
  `id` int unsigned NOT NULL,
  `name` varchar(255) NOT NULL DEFAULT '',
  `reducedCasterDps` tinyint unsigned NOT NULL DEFAULT '0',
  `stats` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
