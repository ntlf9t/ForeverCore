-- Player modes: older manual installations may predate the legacy inheritance flag.
-- Create the table for fresh installs and add the column only when it is absent.
CREATE TABLE IF NOT EXISTS `character_modes` (
  `guid` int unsigned NOT NULL,
  `chosen` tinyint unsigned NOT NULL DEFAULT 0,
  `lone` tinyint unsigned NOT NULL DEFAULT 0,
  `lone_damage` int NOT NULL DEFAULT 0,
  `lone_health` int NOT NULL DEFAULT 0,
  `lone_taken` int NOT NULL DEFAULT 0,
  `rebirths` int unsigned NOT NULL DEFAULT 0,
  `rebirth_active` tinyint unsigned NOT NULL DEFAULT 0,
  `legacy_given` tinyint unsigned NOT NULL DEFAULT 0,
  `updated_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

SET @player_modes_add_legacy = IF(
  EXISTS (
    SELECT 1
    FROM information_schema.columns
    WHERE table_schema = DATABASE()
      AND table_name = 'character_modes'
      AND column_name = 'legacy_given'
  ),
  'DO 0',
  'ALTER TABLE `character_modes` ADD COLUMN `legacy_given` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER `rebirth_active`'
);
PREPARE player_modes_stmt FROM @player_modes_add_legacy;
EXECUTE player_modes_stmt;
DEALLOCATE PREPARE player_modes_stmt;
