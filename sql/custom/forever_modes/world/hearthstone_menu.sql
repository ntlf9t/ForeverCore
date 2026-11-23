-- ============================================================
-- 炉石对话菜单：脚本绑定 + 世界主城传送表
-- ============================================================
SET NAMES utf8mb4;

-- 炉石（物品 6948）绑定脚本（如之前绑定过其他脚本如 item_horadric_cube，将被替换）
DELETE FROM world.item_script_names WHERE Id = 6948;
INSERT INTO world.item_script_names (Id, ScriptName) VALUES (6948, 'item_hearthstone_menu');

-- 世界主城传送表
CREATE TABLE IF NOT EXISTS world.Hearthstone_teleport (
  idx     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  team    INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=中立, 469=联盟, 67=部落',
  map     INT UNSIGNED NOT NULL DEFAULT 0,
  x       FLOAT NOT NULL DEFAULT 0,
  y       FLOAT NOT NULL DEFAULT 0,
  z       FLOAT NOT NULL DEFAULT 0,
  o       FLOAT NOT NULL DEFAULT 0,
  comment VARCHAR(100) NOT NULL DEFAULT '',
  PRIMARY KEY (idx)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 已经创建过旧版表时补充 team 字段
SET @hs_team_exists = (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'world'
    AND TABLE_NAME = 'Hearthstone_teleport'
    AND COLUMN_NAME = 'team'
);
SET @hs_team_sql = IF(
  @hs_team_exists = 0,
  'ALTER TABLE world.Hearthstone_teleport ADD COLUMN team INT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''0=中立, 469=联盟, 67=部落'' AFTER idx',
  'ALTER TABLE world.Hearthstone_teleport MODIFY COLUMN team INT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''0=中立, 469=联盟, 67=部落'' AFTER idx'
);
PREPARE hs_team_stmt FROM @hs_team_sql;
EXECUTE hs_team_stmt;
DEALLOCATE PREPARE hs_team_stmt;

DELETE FROM world.Hearthstone_teleport;
INSERT INTO world.Hearthstone_teleport (team, map, x, y, z, o, comment) VALUES
  -- 联盟主城
  (469, 0, -8833.07,   622.778,   93.9317, 0.6771,   '暴风城'),
  (469, 0, -4918.88,  -940.406,  501.564,  5.42347,  '铁炉堡'),
  (469, 1,  9949.56,  2284.21,  1341.40,   1.59587,  '达纳苏斯'),
  -- 部落主城
  (67, 1,  1569.97, -4397.41,    16.0472, 0.543025, '奥格瑞玛'),
  (67, 1, -1277.37,   124.804,  131.287,  5.22274,  '雷霆崖'),
  (67, 0,  1584.07,   241.987,  -52.1534, 0.049647, '幽暗城'),
  -- 中立城市
  (0, 1,  6725.69, -4619.44,   720.909,  4.66802,  '永望镇'),
  (0, 1,  -956.664, -3754.71,    5.33239, 0.996637, '棘齿城'),
  (0, 1, -7177.15, -3785.34,     8.36981, 6.10237,  '加基森'),
  (0, 0, -14297.20,   530.993,   8.77916, 3.98863,  '藏宝海湾');
