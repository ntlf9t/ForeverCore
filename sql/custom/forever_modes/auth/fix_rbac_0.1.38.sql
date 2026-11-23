-- ============================================================
-- 0.1.39 RBAC 修正：battletag/gm combatlog/deathrecap 占用 1002-1004
-- .mode = 1005, .dungeon = 1006
-- 适用：已经跑过旧版 player_modes.sql 的数据库
-- ============================================================
SET NAMES utf8mb4;

INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1002, 'Command: battletag')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1003, 'Command: gm combatlog')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1004, 'Command: deathrecap')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1005, 'Command: mode')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);
INSERT INTO auth.rbac_permissions (Id, Name) VALUES (1006, 'Command: dungeon')
  ON DUPLICATE KEY UPDATE Name = VALUES(Name);

INSERT IGNORE INTO auth.rbac_linked_permissions (id, linkedId) VALUES
  (195, 1005), (196, 1005),
  (199, 1000), (199, 1001), (199, 1002), (199, 1005), (199, 1006);

SELECT Id, Name FROM auth.rbac_permissions WHERE Id BETWEEN 1000 AND 1006 ORDER BY Id;
SELECT linkedId FROM auth.rbac_linked_permissions WHERE id = 199 AND linkedId BETWEEN 1000 AND 1006 ORDER BY linkedId;
