-- Classic 1.60 Legacy perk reset at class trainers (forever-bugs #503): the last price paid and when, so the next reset costs
-- more and the price drops again over time (Player::GetNextClassicLegacyResetCost). Safe to run again.
CREATE TABLE IF NOT EXISTS `character_legacy_reset` (
  `guid` bigint unsigned NOT NULL COMMENT 'characters.guid',
  `cost` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'copper paid for the last reset',
  `time` bigint unsigned NOT NULL DEFAULT '0' COMMENT 'unix time of the last reset',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Legacy perk resets';
