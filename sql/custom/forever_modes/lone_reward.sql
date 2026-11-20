-- ============================================================
-- 孤勇 60 级奖励：36 格背包 + 10000 金
-- 物品 242710 = 孤勇者的背包（36 格，基于 242709 克隆）
-- ============================================================
SET NAMES utf8mb4;

-- 1. 角色模式表加奖励标记（已有则跳过）
SET @has_col := (SELECT COUNT(*) FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'characters' AND TABLE_NAME = 'character_modes'
    AND COLUMN_NAME = 'lone_reward_given');
SET @ddl := IF(@has_col = 0,
  'ALTER TABLE characters.character_modes ADD COLUMN lone_reward_given TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''孤勇 60 级奖励是否已发放''',
  'SELECT 1');
PREPARE stmt FROM @ddl;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

USE hotfixes;

-- 2. 克隆物品基础行
CREATE TEMPORARY TABLE tmp_item AS SELECT * FROM hotfixes.item WHERE ID = 242709;
UPDATE tmp_item SET ID = 242710;
DELETE FROM hotfixes.item WHERE ID = 242710;
INSERT INTO hotfixes.item SELECT * FROM tmp_item;

-- 3. 克隆物品稀疏行，改成 36 格并命名
CREATE TEMPORARY TABLE tmp_sparse AS SELECT * FROM hotfixes.item_sparse WHERE ID = 242709;
UPDATE tmp_sparse
   SET ID = 242710,
       Display = '孤勇者的背包',
       ContainerSlots = 36,
       ItemLevel = 30,
       OverallQualityID = 4,
       RequiredLevel = 0;
DELETE FROM hotfixes.item_sparse WHERE ID = 242710;
INSERT INTO hotfixes.item_sparse SELECT * FROM tmp_sparse;

DROP TEMPORARY TABLE tmp_item;
DROP TEMPORARY TABLE tmp_sparse;

-- 4. 热推记录（客户端需要）
DELETE FROM hotfixes.hotfix_data
 WHERE RecordId = 242710 AND TableHash IN (1344507586, 1397625698);
SET @hid = (SELECT IFNULL(MAX(Id), 0) + 1 FROM hotfixes.hotfix_data);
INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
VALUES (@hid, @hid, 1344507586, 242710, 1, 70959);
SET @hid = @hid + 1;
INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
VALUES (@hid, @hid, 1397625698, 242710, 1, 70959);

SELECT ID, Display, ContainerSlots, OverallQualityID, RequiredLevel
FROM hotfixes.item_sparse WHERE ID = 242710;
