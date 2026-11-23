-- 1007 = Command: reload gameobject_template, 196 = Role: Administrator. Safe to run again.
INSERT IGNORE INTO `rbac_permissions` (`id`, `name`) VALUES
(1007, 'Command: reload gameobject_template');

INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
(196, 1007);
