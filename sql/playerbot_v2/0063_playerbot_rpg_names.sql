-- Migration: 0063_playerbot_rpg_names
-- Date:    2026-11-23
-- Purpose: Schema for race/sex-appropriate RPG names for V2 bot characters
--          (the "RPG names" feature; code in Fleet/BotNamePool.cpp):
--
--            playerbots_race_names    curated lore first names, consumed like
--                                     the playerbots_names pool (is_used /
--                                     used_by_guid); `race` gates which race
--                                     may draw the name (0 = any race).
--                                     First names stay unique server-wide -
--                                     only eligibility is per-race.
--            playerbots_surnames      whole surnames, race-keyed (0 = any),
--                                     gender like the name pools. Reusable -
--                                     never consumed; last names repeat
--                                     freely.
--            playerbots_surname_parts combinable halves (half 0 = prefix,
--                                     1 = suffix) for generated compound
--                                     surnames ("Hammer"+"fist").
--
--          `race` is the ChrRaces id (1 Human, 2 Orc, 3 Dwarf, 4 NightElf,
--          5 Undead, 6 Tauren, 7 Gnome, 8 Troll, 95 Skyborne-A, 96 Skyborne-H).
--          A plain column, not a bitmask: 32 bits can't hold races > 32.
--
--          No bak_ tables: only new tables are created; nothing existing is
--          changed or removed. Idempotent, safe to re-run.
-- Reverts: yes (DROP TABLE playerbots_race_names, playerbots_surnames,
--          playerbots_surname_parts).

-- @target: shared

CREATE TABLE IF NOT EXISTS {SHARED}.`playerbots_race_names` (
  `name_id` int unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(12) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `race` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'ChrRaces id, 0 = any race',
  `gender` tinyint unsigned NOT NULL DEFAULT '2' COMMENT '0=male, 1=female, 2=neutral',
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  `used_by_guid` bigint unsigned DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`name_id`),
  UNIQUE KEY `idx_unique_name` (`name`),
  KEY `idx_available` (`is_used`,`race`,`gender`),
  KEY `idx_used` (`is_used`,`used_by_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS {SHARED}.`playerbots_surnames` (
  `surname_id` int unsigned NOT NULL AUTO_INCREMENT,
  `surname` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `race` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'ChrRaces id, 0 = any race',
  `gender` tinyint unsigned NOT NULL DEFAULT '2' COMMENT '0=male, 1=female, 2=neutral',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`surname_id`),
  UNIQUE KEY `uk_surname_race` (`surname`,`race`),
  KEY `idx_race` (`race`,`gender`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE IF NOT EXISTS {SHARED}.`playerbots_surname_parts` (
  `part_id` int unsigned NOT NULL AUTO_INCREMENT,
  `part` varchar(24) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `half` tinyint unsigned NOT NULL COMMENT '0=prefix, 1=suffix',
  `race` tinyint unsigned NOT NULL DEFAULT '0' COMMENT 'ChrRaces id, 0 = any race',
  PRIMARY KEY (`part_id`),
  UNIQUE KEY `uk_part` (`part`,`half`,`race`),
  KEY `idx_race` (`race`,`half`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Seed data is in 0064_playerbot_rpg_names_data.sql
-- 

INSERT INTO {SHARED}.playerbot_v2_schema_version (version, sha256) VALUES
    (63, REPEAT('0', 64))
ON DUPLICATE KEY UPDATE applied_at = CURRENT_TIMESTAMP;
