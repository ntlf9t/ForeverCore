-- Backfill the account collection for characters that learned the trainee turtle
-- before its Mount.db2 row existed. INSERT IGNORE preserves existing mount flags.
INSERT IGNORE INTO `battlenet_account_mounts`
    (`battlenetAccountId`, `mountSpellId`, `flags`)
SELECT DISTINCT a.`battlenet_account`, 1399990, 0
FROM characters.`characters` AS c
JOIN characters.`character_spell` AS cs ON cs.`guid` = c.`guid`
JOIN `account` AS a ON a.`id` = c.`account`
WHERE cs.`spell` = 1399990
  AND a.`battlenet_account` IS NOT NULL;
