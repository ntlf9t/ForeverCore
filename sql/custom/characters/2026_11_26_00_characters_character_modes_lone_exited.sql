-- 孤勇退出：记录已退出状态，保留固定 +30% 伤害/生命，不再随重生增长
SET @has_column := (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = DATABASE()
    AND TABLE_NAME = 'character_modes'
    AND COLUMN_NAME = 'lone_exited'
);

SET @ddl := IF(
  @has_column = 0,
  'ALTER TABLE `character_modes` ADD COLUMN `lone_exited` TINYINT UNSIGNED NOT NULL DEFAULT 0 AFTER `lone`',
  'SELECT 1'
);

PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
