-- ============================================================
-- 随身商店：基础箭矢 / 弹药
-- 商人模板 3625，召唤后临时设为全阵营友好
-- ============================================================
SET NAMES utf8mb4;

-- 商品
DELETE FROM world.npc_vendor WHERE entry = 3625 AND item IN (274387, 274388);
INSERT INTO world.npc_vendor
  (entry, slot, item, maxcount, incrtime, ExtendedCost, type, BonusListIDs, PlayerConditionID, IgnoreFiltering, VerifiedBuild)
VALUES
  (3625, 100, 274387, 0, 0, 0, 1, NULL, 0, 0, 70959),
  (3625, 101, 274388, 0, 0, 0, 1, NULL, 0, 0, 70959);

-- 改成 1 级可用的基础箭矢 / 弹药，价格 10 铜
UPDATE hotfixes.item_sparse
   SET Display = '简易箭矢', ItemLevel = 1, RequiredLevel = 1,
       OverallQualityID = 1, BuyPrice = 10, SellPrice = 1
 WHERE ID = 274387;

UPDATE hotfixes.item_sparse
   SET Display = '简易弹药', ItemLevel = 1, RequiredLevel = 1,
       OverallQualityID = 1, BuyPrice = 10, SellPrice = 1
 WHERE ID = 274388;

-- 热推 ItemSparse 更新
DELETE FROM hotfixes.hotfix_data
 WHERE RecordId IN (274387, 274388) AND TableHash = 1397625698;
SET @hid = (SELECT IFNULL(MAX(Id), 0) + 1 FROM hotfixes.hotfix_data);
INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
VALUES (@hid, @hid, 1397625698, 274387, 1, 70959);
SET @hid = @hid + 1;
INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
VALUES (@hid, @hid, 1397625698, 274388, 1, 70959);

SELECT v.entry, v.item, s.Display, s.ItemLevel, s.RequiredLevel, s.BuyPrice
FROM world.npc_vendor v
JOIN hotfixes.item_sparse s ON s.ID = v.item
WHERE v.entry = 3625 AND v.item IN (274387, 274388);
