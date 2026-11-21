-- ============================================================
-- 孤勇 60 级奖励：10000 金
-- 已有库执行本脚本；新库直接用 player_modes.sql（已包含该列）
-- ============================================================
SET NAMES utf8mb4;

SET @has_col := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'characters' AND TABLE_NAME = 'character_modes'
    AND COLUMN_NAME = 'lone_reward_given');
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE characters.character_modes ADD COLUMN lone_reward_given TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''孤勇 60 级奖励是否已发放''',
  'SELECT 1');
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SELECT COUNT(*) AS column_ready FROM information_schema.COLUMNS
 WHERE TABLE_SCHEMA = 'characters' AND TABLE_NAME = 'character_modes'
   AND COLUMN_NAME = 'lone_reward_given';
