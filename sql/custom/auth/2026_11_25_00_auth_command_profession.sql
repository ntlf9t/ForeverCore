-- .profession [show <name>] (cs_misc.cpp): every player picks which 2 of their primary professions the client shows.
-- 1008 = Command: profession (RBAC_PERM_COMMAND_PROFESSION), 195 = Role: Player. Safe to run again.
INSERT IGNORE INTO `rbac_permissions` (`id`, `name`) VALUES (1008, 'Command: profession');
INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES (195, 1008);
