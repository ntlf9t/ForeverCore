-- ============================================================
-- 装备随机词条：每条词条的预算
-- 不再使用 item enchant 的 duration/charges，避免装备时被清空
-- 或客户端把它显示成“使用次数”。
-- ============================================================
CREATE TABLE IF NOT EXISTS characters.item_score_affix_budget (
  item_guid BIGINT UNSIGNED NOT NULL,
  slot      TINYINT UNSIGNED NOT NULL,
  budget    INT UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (item_guid, slot)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
