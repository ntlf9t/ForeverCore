SET NAMES utf8mb4;

-- 自定义角色数据元素：重生天赋点
DELETE FROM hotfixes.hotfix_data WHERE TableHash = 1237546057 AND RecordId = 9001;
DELETE FROM hotfixes.player_data_element_character WHERE ID = 9001;
INSERT INTO hotfixes.player_data_element_character
  (ID, StorageIndex, Type, Unknown1125, Field_12_1_5_69594_004, VerifiedBuild)
VALUES
  (9001, 7, 0, 0, 0, 70938);

-- 天赋货币 3820 改为由数据元素提供
DELETE FROM hotfixes.hotfix_data WHERE TableHash = 2205979106 AND RecordId = 3820;
DELETE FROM hotfixes.trait_currency WHERE ID = 3820;
INSERT INTO hotfixes.trait_currency
  (ID, Type, CurrencyTypesID, Flags, Icon, PlayerDataElementAccountID, PlayerDataElementCharacterID, SourcedMax, VerifiedBuild)
VALUES
  (3820, 3, 0, 0, 0, 0, 9001, 0, 70938);

SET @hid = (SELECT IFNULL(MAX(Id),0) FROM hotfixes.hotfix_data);
INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild) VALUES
(@hid := @hid + 1, @hid, 1237546057, 9001, 1, 70938),
(@hid := @hid + 1, @hid, 2205979106, 3820, 1, 70938);

SELECT ID,StorageIndex,Type FROM hotfixes.player_data_element_character WHERE ID=9001;
SELECT ID,Type,PlayerDataElementCharacterID,SourcedMax FROM hotfixes.trait_currency WHERE ID=3820;
