-- ============================================================
-- 炉石对话菜单：角色绑定点 + 解卡冷却表
-- ============================================================
SET NAMES utf8mb4;

-- 炉石绑定点（每角色一条，由「绑定炉石」写入）
CREATE TABLE IF NOT EXISTS characters.Hearthstone_teleport_home (
  idx     INT UNSIGNED NOT NULL AUTO_INCREMENT,
  guid    BIGINT UNSIGNED NOT NULL,
  account INT UNSIGNED NOT NULL DEFAULT 0,
  name    VARCHAR(12) NOT NULL DEFAULT '',
  map     INT UNSIGNED NOT NULL DEFAULT 0,
  x       FLOAT NOT NULL DEFAULT 0,
  y       FLOAT NOT NULL DEFAULT 0,
  z       FLOAT NOT NULL DEFAULT 0,
  o       FLOAT NOT NULL DEFAULT 0,
  comment VARCHAR(100) NOT NULL DEFAULT '',
  PRIMARY KEY (idx),
  UNIQUE KEY uk_guid (guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 炉石菜单操作冷却：随身商人 15 分钟，绑定炉石 10 分钟
CREATE TABLE IF NOT EXISTS characters.Hearthstone_cooldown (
  guid             BIGINT UNSIGNED NOT NULL,
  last_vendor_time INT UNSIGNED NOT NULL DEFAULT 0,
  last_bind_time   INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 角色解卡冷却（2 小时）
CREATE TABLE IF NOT EXISTS characters.character_cardunlock_cooldown (
  guid             BIGINT UNSIGNED NOT NULL,
  last_unlock_time INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
