-- ============================================================
-- 模式系统：角色模式数据 + RBAC 权限
-- ============================================================
SET NAMES utf8mb4;

CREATE TABLE IF NOT EXISTS characters.character_modes (
  guid            INT UNSIGNED NOT NULL,
  chosen          TINYINT UNSIGNED NOT NULL DEFAULT 0,   -- 是否已选择过模式
  lone            TINYINT UNSIGNED NOT NULL DEFAULT 0,   -- 孤勇
  lone_damage     INT NOT NULL DEFAULT 0,                -- 孤勇增伤 %
  lone_health     INT NOT NULL DEFAULT 0,                -- 孤勇生命 %
  lone_taken      INT NOT NULL DEFAULT 0,                -- 孤勇承伤 %（负面）
  rebirths        INT UNSIGNED NOT NULL DEFAULT 0,       -- 重生次数
  rebirth_active  TINYINT UNSIGNED NOT NULL DEFAULT 0,   -- 当前是否在重生流程中
  updated_at      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (guid)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- RBAC：.mode 命令，所有玩家可用
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1001, 'Command: mode')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT IGNORE INTO auth.rbac_linked_permissions (id, linkedId) VALUES (199, 1001);

-- Dungeon difficulty is registered separately and not granted to the player role.
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1002, 'Command: dungeon')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);

INSERT INTO world.command (name, help) VALUES
('mode', 'Syntax: .mode [lone|rebirth|info]\n查看/选择角色模式：lone=孤勇，rebirth=重生。')
ON DUPLICATE KEY UPDATE help = VALUES(help);

SELECT COUNT(*) AS table_ready FROM information_schema.tables
 WHERE table_schema='characters' AND table_name='character_modes';
