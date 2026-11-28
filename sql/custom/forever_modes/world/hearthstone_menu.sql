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
  type    TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT '0=主城, 1=地下城, 2=团队副本, 3=战场',
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

-- 已经创建过旧版表时补充 type 字段（原记录自动归为主城）
SET @hs_type_exists = (
  SELECT COUNT(*)
  FROM information_schema.COLUMNS
  WHERE TABLE_SCHEMA = 'world'
    AND TABLE_NAME = 'Hearthstone_teleport'
    AND COLUMN_NAME = 'type'
);
SET @hs_type_sql = IF(
  @hs_type_exists = 0,
  'ALTER TABLE world.Hearthstone_teleport ADD COLUMN type TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''0=主城, 1=地下城, 2=团队副本, 3=战场'' AFTER team',
  'ALTER TABLE world.Hearthstone_teleport MODIFY COLUMN type TINYINT UNSIGNED NOT NULL DEFAULT 0 COMMENT ''0=主城, 1=地下城, 2=团队副本, 3=战场'' AFTER team'
);
PREPARE hs_type_stmt FROM @hs_type_sql;
EXECUTE hs_type_stmt;
DEALLOCATE PREPARE hs_type_stmt;

INSERT INTO world.Hearthstone_teleport (idx, team, type, map, x, y, z, o, comment) VALUES
  -- 联盟主城
  (1, 469, 0, 0, -8833.07,   622.778,   93.9317, 0.6771,   '暴风城'),
  (2, 469, 0, 0, -4918.88,  -940.406,  501.564,  5.42347,  '铁炉堡'),
  (3, 469, 0, 1,  9949.56,  2284.21,  1341.40,   1.59587,  '达纳苏斯'),
  -- 部落主城
  (4, 67, 0, 1,  1569.97, -4397.41,    16.0472, 0.543025, '奥格瑞玛'),
  (5, 67, 0, 1, -1277.37,   124.804,  131.287,  5.22274,  '雷霆崖'),
  (6, 67, 0, 0,  1584.07,   241.987,  -52.1534, 0.049647, '幽暗城'),
  -- 中立城市
  (7, 0, 0, 1,  6725.69, -4619.44,   720.909,  4.66802,  '永望镇'),
  (8, 0, 0, 1,  -956.664, -3754.71,    5.33239, 0.996637, '棘齿城'),
  (9, 0, 0, 1, -7177.15, -3785.34,     8.36981, 6.10237,  '加基森'),
  (10, 0, 0, 0, -14297.20,   530.993,   8.77916, 3.98863,  '藏宝海湾'),

  -- 地下城副本
  (11, 0, 1, 389,     0.797643,   -8.23429, -15.5288, 4.71239, '怒焰裂谷'),
  (12, 0, 1, 43,   -158.441,    131.601,   -74.2552, 5.84685, '哀嚎洞穴'),
  (13, 0, 1, 36,    -14.5732,  -385.475,    62.4561, 1.57080, '死亡矿井'),
  (14, 0, 1, 33,   -228.191,   2111.41,     76.8904, 1.22173, '影牙城堡'),
  (15, 0, 1, 34,     48.9849,     0.483882, -16.3942, 0.00000, '暴风城监狱'),
  (16, 0, 1, 48,   -150.234,    106.594,   -39.7790, 4.45059, '黑暗深渊'),
  (17, 0, 1, 90,   -329.098,     -3.20722,-152.851,  2.96706, '诺莫瑞根'),
  (18, 0, 1, 47,   1942.27,    1544.23,     83.3055, 1.308997, '剃刀沼泽'),
  (19, 0, 1, 189,  1687.27,    1050.09,     18.6773, 1.57080, '血色修道院·墓地'),
  (20, 0, 1, 189,   853.179,   1319.18,     18.6714, 1.57080, '血色修道院·大教堂'),
  (21, 0, 1, 189,  1608.10,    -318.919,    18.6714, 4.71239, '血色修道院·军械库'),
  (22, 0, 1, 189,   253.672,   -206.624,    18.6773, 4.71239, '血色修道院·图书馆'),
  (23, 0, 1, 129,  2593.68,    1111.23,     50.9518, 4.71239, '剃刀高地'),
  (24, 0, 1, 70,   -228.859,     46.1018,  -46.0186, 1.57080, '奥达曼'),
  (25, 0, 1, 209,  1212.67,     842.04,      8.93346, 0.00000, '祖尔法拉克'),
  (26, 0, 1, 349,  1016.83,    -458.52,    -43.4737, 0.00000, '玛拉顿'),
  (27, 0, 1, 109,  -315.903,    100.197,  -131.849,  3.14159, '沉没的神庙'),
  (28, 0, 1, 230,   456.929,     34.0923,  -68.0896, 4.71239, '黑石深渊'),
  (29, 0, 1, 229,    78.3534,  -226.841,    49.7662, 4.71239, '黑石塔'),
  (30, 0, 1, 329,  3590.87,   -3643.22,    138.491,  5.49779, '斯坦索姆'),
  (31, 0, 1, 289,   190.819,    126.329,   137.227,  0.00000, '通灵学院'),
  (32, 0, 1, 429,    47.4501,  -153.665,    -2.71439,5.49779, '厄运之槌'),

  -- 团队副本
  (33, 0, 2, 249,    30.8916,   -54.079,     -5.02784, 4.71239, '奥妮克希亚的巢穴'),
  (34, 0, 2, 409,  1091.89,    -466.985,  -105.084,   3.14159, '熔火之心'),
  (35, 0, 2, 469, -7672.32,   -1107.05,    396.651,   0.78540, '黑翼之巢'),
  (36, 0, 2, 309,-11916.60,   -1243.52,     92.5338,  4.71239, '祖尔格拉布'),
  (37, 0, 2, 509, -8436.53,    1519.17,     31.907,   2.61799, '安其拉废墟'),
  (38, 0, 2, 531, -8221.35,    2014.34,    129.071,   0.87266, '安其拉神殿'),
  (39, 0, 2, 533,  3005.87,   -3435.01,    293.882,   0.00000, '纳克萨玛斯'),

  -- 战场（入口按阵营分别显示）
  (40, 469, 3, 30,   942.930,  -507.627,    94.4662, 1.57080, '奥特兰克山谷'),
  (41, 67,  3, 30, -1504.520,  -711.542,    47.9798, 0.78540, '奥特兰克山谷'),
  (42, 469, 3, 489, 1523.810,  1481.760,   352.008,  3.14159, '战歌峡谷'),
  (43, 67,  3, 489,  933.331,  1433.720,   345.536,  0.00000, '战歌峡谷'),
  (44, 469, 3, 529, 1313.900,  1310.740,    -9.01043,3.83972, '阿拉希盆地'),
  (45, 67,  3, 529,  684.014,   681.220,   -12.9159, 0.80500, '阿拉希盆地')
ON DUPLICATE KEY UPDATE
  team = VALUES(team), type = VALUES(type), map = VALUES(map),
  x = VALUES(x), y = VALUES(y), z = VALUES(z), o = VALUES(o), comment = VALUES(comment);
