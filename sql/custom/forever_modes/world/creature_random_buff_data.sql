-- ============================================================
-- 怪物随机附魔：creature_random_buff 数据 + 全局难度配置
--
-- percent 计入掉落倍率与体型：
--   掉落倍率 = 1 + Σ percent/100 + (宝藏 ? 9 : 0)
--   单条 300% + 300% + 宝藏 = 1 + 6 + 9 = ×16（上限 16）
--   体型：percent 之和 0-99 / 100-299 / 300-599 / 600+ => 1.0 / 1.2 / 1.5 / 2.0
--
-- 权重按“越猛越稀有”配置，宝藏最低
-- 可重复执行（先删后插）
-- ============================================================
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS world.creature_random_buff (
  id            INT UNSIGNED NOT NULL,
  name          VARCHAR(32) NOT NULL,
  category      TINYINT UNSIGNED NOT NULL COMMENT '1伤害 2攻速 3减伤 4复合 5宝藏',
  buffSpellId   INT UNSIGNED NOT NULL,
  weight        INT UNSIGNED NOT NULL DEFAULT 100,
  percent       INT NOT NULL DEFAULT 0 COMMENT '计入掉落倍率与体型，300=300%',
  treasure      TINYINT UNSIGNED NOT NULL DEFAULT 0,
  enabled       TINYINT UNSIGNED NOT NULL DEFAULT 1,
  PRIMARY KEY (id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS world.creature_random_buff_config (
  setting VARCHAR(32) NOT NULL PRIMARY KEY,
  value   INT NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO world.creature_random_buff_config (setting, value)
VALUES ('dungeon_difficulty', 0)
ON DUPLICATE KEY UPDATE value = value;

DELETE FROM world.creature_random_buff;

INSERT INTO world.creature_random_buff
  (id, name, category, buffSpellId, weight, percent, treasure, enabled) VALUES
-- 1 伤害
( 1, '伤害提高 10%',   1, 930001, 120,  10, 0, 1),
( 2, '伤害提高 20%',   1, 930002, 100,  20, 0, 1),
( 3, '伤害提高 50%',   1, 930003,  70,  50, 0, 1),
( 4, '伤害提高 100%',  1, 930004,  40, 100, 0, 1),
( 5, '伤害提高 150%',  1, 930005,  25, 150, 0, 1),
( 6, '伤害提高 200%',  1, 930006,  15, 200, 0, 1),
( 7, '伤害提高 300%',  1, 930007,   8, 300, 0, 1),
-- 2 攻速
( 8, '攻速提高 10%',   2, 930008, 120,  10, 0, 1),
( 9, '攻速提高 20%',   2, 930009, 100,  20, 0, 1),
(10, '攻速提高 50%',   2, 930010,  70,  50, 0, 1),
(11, '攻速提高 100%',  2, 930011,  40, 100, 0, 1),
(12, '攻速提高 200%',  2, 930012,  25, 200, 0, 1),
(13, '攻速提高 300%',  2, 930013,   8, 300, 0, 1),
-- 3 减伤（全系）
(14, '受到伤害降低 10%', 3, 930014, 90,  10, 0, 1),
(15, '受到伤害降低 20%', 3, 930015, 70,  20, 0, 1),
(16, '受到伤害降低 50%', 3, 930016, 35,  50, 0, 1),
(17, '受到伤害降低 80%', 3, 930017, 12,  80, 0, 1),
-- 3 减伤（单系）
(18, '物理伤害降低 50%', 3, 930018, 35,  50, 0, 1),
(19, '神圣伤害降低 50%', 3, 930019, 35,  50, 0, 1),
(20, '火焰伤害降低 50%', 3, 930020, 35,  50, 0, 1),
(21, '自然伤害降低 50%', 3, 930021, 35,  50, 0, 1),
(22, '冰霜伤害降低 50%', 3, 930022, 35,  50, 0, 1),
(23, '暗影伤害降低 50%', 3, 930023, 35,  50, 0, 1),
(24, '奥术伤害降低 50%', 3, 930024, 35,  50, 0, 1),
-- 4 复合
(25, '狂暴',     4, 930025, 25,  60, 0, 1),
(26, '铁壁',     4, 930026, 25,  50, 0, 1),
(27, '嗜血',     4, 930027, 15, 100, 0, 1),
(28, '迅捷',     4, 930028, 20,  80, 0, 1),
(29, '元素灌注', 4, 930029, 20,  60, 0, 1),
-- 5 宝藏
(30, '宝藏',     5, 930030,  6,   0, 1, 1);

SELECT COUNT(*) AS buffs, SUM(weight) AS total_weight,
       SUM(percent) AS total_percent, SUM(treasure) AS treasures
FROM world.creature_random_buff;

SELECT * FROM world.creature_random_buff_config;
