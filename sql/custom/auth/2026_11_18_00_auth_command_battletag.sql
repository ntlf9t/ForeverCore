-- .battletag [name] (cs_battlenet_account.cpp): every player may pick their account's BattleTag name; the number is drawn.
-- 1002 = Command: battletag (RBAC_PERM_COMMAND_BATTLETAG), 195 = Role: Player. 1001 is Command: module on Trixx34's branches.
-- Safe to run again.
INSERT IGNORE INTO `rbac_permissions` (`id`, `name`) VALUES (1002, 'Command: battletag');
INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES (195, 1002);
