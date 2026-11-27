-- "A Sealed Crate" for Expert and Artisan crates: Marcy Baker <Inventory Intake> (256390, Lakeshire) and Dokimi <Inventory Intake>
-- (256386, the Crossroads) now also take Sealed Expert and Sealed Artisan crates, white and green, for Merchant's Favor. Before this,
-- only Apprentice / Journeyman crates had a hand-in (2026_11_09_30), so 2026_11_20_41 took the 16 Expert / Artisan labels out of
-- Read Label (1247168): they come back here, as 2026_11_04_50 had them.
-- Source: Wowhead Forever item and quest pages (each Sealed crate's "objective of" quest, and the quest's reward):
--   white  248765 Apprentice 91899  5 Favor | 248766 Journeyman 91900 10 | 248767 Expert 91901 15 | 248768 Artisan 91902 20
--   green  248770 Apprentice 91904 10       | 248771 Journeyman 91905 20 | 248772 Expert 91906 30 | 248773 Artisan 91907 40
-- So 91900 and 91904 were the other way round in 2026_11_09_30 (it said they might be; same reward, so players saw no difference):
-- 91900 takes the white Journeyman crate and 91904 the green Apprentice one.
-- 91901, 91902, 91906 and 91907 were not in our world: they are copies of 91899 (same title, texts, givers, flags, level) with their
-- own crate and Favor. Like the others: repeatable, offered only while you carry that crate, at both depot NPCs.
-- Not covered (no data): Elite crates (91903 shows no reward on Wowhead and nothing makes an Elite crate) and the blue crates (no
-- quest on Wowhead; 2026_11_20_41 keeps Stock Crate from making them). A Wowhead comment says 91906 also gives 15 silver: not added.
-- Safe to run again.

-- 1) 91900 / 91904: the right crate
UPDATE `quest_objectives` SET `ObjectID` = 248766 WHERE `ID` = 9190000 AND `QuestID` = 91900;
UPDATE `quest_objectives` SET `ObjectID` = 248770 WHERE `ID` = 9190400 AND `QuestID` = 91904;
UPDATE `conditions` SET `ConditionValue1` = 248766, `Comment` = 'A Sealed Crate (10 Favor) - only with a Sealed Journeyman Crate (white)'
  WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 91900 AND `ConditionTypeOrReference` = 2;
UPDATE `conditions` SET `ConditionValue1` = 248770, `Comment` = 'A Sealed Crate (10 Favor) - only with a Sealed Apprentice Crate (green)'
  WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 91904 AND `ConditionTypeOrReference` = 2;

-- 2) the four Expert / Artisan quests, copied from 91899
DELETE FROM `quest_template` WHERE `ID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_template_addon` WHERE `ID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_classic_level` WHERE `ID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_template_classic_level` WHERE `ID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_offer_reward` WHERE `ID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_request_items` WHERE `ID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_poi` WHERE `QuestID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_poi_points` WHERE `QuestID` IN (91901, 91902, 91906, 91907);
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_template` WHERE `ID` = 91899;
UPDATE `tmp_sealed_crate` SET `ID` = 91901, `RewardCurrencyQty1` = 15; INSERT INTO `quest_template` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91902, `RewardCurrencyQty1` = 20; INSERT INTO `quest_template` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91906, `RewardCurrencyQty1` = 30; INSERT INTO `quest_template` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91907, `RewardCurrencyQty1` = 40; INSERT INTO `quest_template` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_template_addon` WHERE `ID` = 91899;
UPDATE `tmp_sealed_crate` SET `ID` = 91901; INSERT INTO `quest_template_addon` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91902; INSERT INTO `quest_template_addon` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91906; INSERT INTO `quest_template_addon` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91907; INSERT INTO `quest_template_addon` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_classic_level` WHERE `ID` = 91899;
UPDATE `tmp_sealed_crate` SET `ID` = 91901; INSERT INTO `quest_classic_level` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91902; INSERT INTO `quest_classic_level` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91906; INSERT INTO `quest_classic_level` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91907; INSERT INTO `quest_classic_level` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_template_classic_level` WHERE `ID` = 91899;
UPDATE `tmp_sealed_crate` SET `ID` = 91901; INSERT INTO `quest_template_classic_level` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91902; INSERT INTO `quest_template_classic_level` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91906; INSERT INTO `quest_template_classic_level` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91907; INSERT INTO `quest_template_classic_level` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_offer_reward` WHERE `ID` = 91899;
UPDATE `tmp_sealed_crate` SET `ID` = 91901; INSERT INTO `quest_offer_reward` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91902; INSERT INTO `quest_offer_reward` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91906; INSERT INTO `quest_offer_reward` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91907; INSERT INTO `quest_offer_reward` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_request_items` WHERE `ID` = 91899;
UPDATE `tmp_sealed_crate` SET `ID` = 91901; INSERT INTO `quest_request_items` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91902; INSERT INTO `quest_request_items` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91906; INSERT INTO `quest_request_items` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `ID` = 91907; INSERT INTO `quest_request_items` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_poi` WHERE `QuestID` = 91899;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91901; INSERT INTO `quest_poi` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91902; INSERT INTO `quest_poi` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91906; INSERT INTO `quest_poi` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91907; INSERT INTO `quest_poi` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
CREATE TEMPORARY TABLE `tmp_sealed_crate` SELECT * FROM `quest_poi_points` WHERE `QuestID` = 91899;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91901; INSERT INTO `quest_poi_points` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91902; INSERT INTO `quest_poi_points` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91906; INSERT INTO `quest_poi_points` SELECT * FROM `tmp_sealed_crate`;
UPDATE `tmp_sealed_crate` SET `QuestID` = 91907; INSERT INTO `quest_poi_points` SELECT * FROM `tmp_sealed_crate`;
DROP TEMPORARY TABLE IF EXISTS `tmp_sealed_crate`;
UPDATE `quest_template_addon` SET `SpecialFlags` = `SpecialFlags` | 1 WHERE `ID` IN (91901, 91902, 91906, 91907);

-- required crate
DELETE FROM `quest_objectives` WHERE `QuestID` IN (91901, 91902, 91906, 91907);
DELETE FROM `quest_objectives` WHERE `ID` IN (9190100, 9190200, 9190600, 9190700);
INSERT INTO `quest_objectives` (`ID`, `QuestID`, `Type`, `Order`, `StorageIndex`, `ObjectID`, `Amount`, `Flags`, `Visible`, `Description`, `VerifiedBuild`) VALUES
(9190100, 91901, 1, 0, 0, 248767, 1, 0, 1, NULL, 0),
(9190200, 91902, 1, 0, 0, 248768, 1, 0, 1, NULL, 0),
(9190600, 91906, 1, 0, 0, 248772, 1, 0, 1, NULL, 0),
(9190700, 91907, 1, 0, 0, 248773, 1, 0, 1, NULL, 0);

-- offered only while the player carries the matching crate
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` IN (91901, 91902, 91906, 91907) AND `ConditionTypeOrReference` = 2;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(19, 0, 91901, 0, 0, 2, 0, 248767, 1, 0, 0, 0, 0, '', 'A Sealed Crate (15 Favor) - only with a Sealed Expert Crate (white)'),
(19, 0, 91902, 0, 0, 2, 0, 248768, 1, 0, 0, 0, 0, '', 'A Sealed Crate (20 Favor) - only with a Sealed Artisan Crate (white)'),
(19, 0, 91906, 0, 0, 2, 0, 248772, 1, 0, 0, 0, 0, '', 'A Sealed Crate (30 Favor) - only with a Sealed Expert Crate (green)'),
(19, 0, 91907, 0, 0, 2, 0, 248773, 1, 0, 0, 0, 0, '', 'A Sealed Crate (40 Favor) - only with a Sealed Artisan Crate (green)');

-- both depot NPCs offer and take them
DELETE FROM `creature_queststarter` WHERE `id` IN (256386, 256390) AND `quest` IN (91901, 91902, 91906, 91907);
INSERT INTO `creature_queststarter` (`id`, `quest`, `VerifiedBuild`) VALUES
(256386, 91901, 0), (256390, 91901, 0), (256386, 91902, 0), (256390, 91902, 0), (256386, 91906, 0), (256390, 91906, 0), (256386, 91907, 0), (256390, 91907, 0);
DELETE FROM `creature_questender` WHERE `id` IN (256386, 256390) AND `quest` IN (91901, 91902, 91906, 91907);
INSERT INTO `creature_questender` (`id`, `quest`, `VerifiedBuild`) VALUES
(256386, 91901, 0), (256390, 91901, 0), (256386, 91902, 0), (256390, 91902, 0), (256386, 91906, 0), (256390, 91906, 0), (256386, 91907, 0), (256390, 91907, 0);

-- 3) Read Label gives the Expert / Artisan labels again (rows as in 2026_11_04_50)
DELETE FROM `spell_loot_template` WHERE `Entry` = 1247168 AND `ItemType` = 0 AND `Item` IN (248690, 248691, 248692, 248693, 248694, 248695, 248696, 248697, 248698, 248699, 248708, 248709, 248710, 248711, 248712, 248713);
INSERT INTO `spell_loot_template` (`Entry`, `ItemType`, `Item`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(1247168, 0, 248690, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Earthly Expert Herbs'),
(1247168, 0, 248691, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Flowering Expert Herbs'),
(1247168, 0, 248692, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Expert Ore'),
(1247168, 0, 248693, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Expert Textiles'),
(1247168, 0, 248694, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Expert Curiosities'),
(1247168, 0, 248695, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Earthly Artisan Herbs'),
(1247168, 0, 248696, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Flowering Artisan Herbs'),
(1247168, 0, 248697, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Artisan Ore'),
(1247168, 0, 248698, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Artisan Textiles'),
(1247168, 0, 248699, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Artisan Curiosities'),
(1247168, 0, 248708, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Expert Fabrics'),
(1247168, 0, 248709, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Expert Ingots'),
(1247168, 0, 248710, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Expert Parts'),
(1247168, 0, 248711, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Artisan Fabrics'),
(1247168, 0, 248712, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Artisan Ingots'),
(1247168, 0, 248713, 0, 0, 1, 1, 1, 1, 'Read Label - Waylaid Crate: Artisan Parts');
