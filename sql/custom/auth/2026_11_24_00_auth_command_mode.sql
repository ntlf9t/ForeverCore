-- 允许普通玩家和管理员使用 .mode / .mode lone / .mode rebirth
INSERT INTO `rbac_permissions` (`Id`, `Name`)
VALUES (1005, 'Command: mode')
ON DUPLICATE KEY UPDATE `Name` = VALUES(`Name`);

INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
(195, 1005),
(196, 1005),
(199, 1005);
