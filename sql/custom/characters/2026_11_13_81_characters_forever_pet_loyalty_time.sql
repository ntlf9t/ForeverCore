-- Classic 1.60 (WoW Forever) hunter pet loyalty: a rank needs XP earned since the last rank (loyalty_points) plus time out (loyalty_time,
-- seconds). C++: Pet::AddLoyaltyProgress. Ranks are kept; the old vanilla loyalty points mean nothing under the new rule, so they start
-- from 0 when the column is added. Safe to run again.
SET @col := (SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'character_pet_loyalty' AND COLUMN_NAME = 'loyalty_time');
SET @sql := IF(@col = 0, 'ALTER TABLE `character_pet_loyalty` ADD COLUMN `loyalty_time` int unsigned NOT NULL DEFAULT ''0'' COMMENT ''seconds out toward the next rank'' AFTER `loyalty_points`', 'SELECT 1');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
UPDATE `character_pet_loyalty` SET `loyalty_points` = 0 WHERE @col = 0;
