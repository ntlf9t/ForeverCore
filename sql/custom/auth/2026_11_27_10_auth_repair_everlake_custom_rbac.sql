-- Repair collisions from earlier custom auth updates that were also merged from Everlake.
-- 1002 is BattleTag, 1004 is DeathRecap, and 1008 is Profession; preserve mode at 1005.
DELETE FROM `rbac_linked_permissions`
WHERE `id` = 195 AND `linkedId` = 1004
  AND EXISTS (SELECT 1 FROM `rbac_permissions` WHERE `id` = 1004 AND `name` = 'Command: battletag');

INSERT INTO `rbac_permissions` (`id`, `name`) VALUES
  (1002, 'Command: battletag'),
  (1004, 'Command: deathrecap'),
  (1008, 'Command: profession')
ON DUPLICATE KEY UPDATE `name` = VALUES(`name`);

INSERT IGNORE INTO `rbac_linked_permissions` (`id`, `linkedId`) VALUES
  (195, 1002),
  (197, 1004),
  (195, 1008);
