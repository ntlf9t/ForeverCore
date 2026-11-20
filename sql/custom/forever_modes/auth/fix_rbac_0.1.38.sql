-- ============================================================
-- 0.1.38 RBAC 修正：.bug 占用 1001，.mode/.dungeon 顺延
-- 适用：已经跑过旧版 player_modes.sql 的数据库
-- ============================================================
SET NAMES utf8mb4;

INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1001, 'Command: bug')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1002, 'Command: mode')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1003, 'Command: dungeon')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);

INSERT IGNORE INTO auth.rbac_linked_permissions (id, linkedId) VALUES
  (199, 1000), (199, 1001), (199, 1002), (199, 1003);

SELECT Id, Name FROM auth.rbac_permissions WHERE Id BETWEEN 1000 AND 1003 ORDER BY Id;
SELECT linkedId FROM auth.rbac_linked_permissions WHERE id = 199 AND linkedId BETWEEN 1000 AND 1003 ORDER BY linkedId;
