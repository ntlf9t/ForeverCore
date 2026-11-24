-- Custom Paladin and Priest trainers for Tauren and Skyborne starter areas.
-- Re-run safe: trainer templates, spawns, mappings and referral quests are replaced.

DROP TEMPORARY TABLE IF EXISTS `_trainer_template`;
CREATE TEMPORARY TABLE `_trainer_template` AS SELECT * FROM `creature_template` WHERE `entry` = 925;
UPDATE `_trainer_template` SET `entry` = 8102001, `name` = 'Sunwalker Dawnhoof', `subname` = 'Paladin Trainer',
    `faction` = 104, `unit_class` = 2;
DELETE FROM `creature_template` WHERE `entry` = 8102001;
INSERT INTO `creature_template` SELECT * FROM `_trainer_template`;

DROP TEMPORARY TABLE `_trainer_template`;
CREATE TEMPORARY TABLE `_trainer_template` AS SELECT * FROM `creature_template` WHERE `entry` = 925;
UPDATE `_trainer_template` SET `entry` = 8102002, `name` = 'Auralin Dawnfeather', `subname` = 'Paladin Trainer',
    `faction` = 35, `unit_class` = 2;
DELETE FROM `creature_template` WHERE `entry` = 8102002;
INSERT INTO `creature_template` SELECT * FROM `_trainer_template`;

DROP TEMPORARY TABLE `_trainer_template`;
CREATE TEMPORARY TABLE `_trainer_template` AS SELECT * FROM `creature_template` WHERE `entry` = 375;
UPDATE `_trainer_template` SET `entry` = 8102003, `name` = 'Sera Windwhisper', `subname` = 'Priest Trainer',
    `faction` = 35, `unit_class` = 8;
DELETE FROM `creature_template` WHERE `entry` = 8102003;
INSERT INTO `creature_template` SELECT * FROM `_trainer_template`;
DROP TEMPORARY TABLE `_trainer_template`;

DELETE FROM `creature_template_model` WHERE `CreatureID` IN (8102001, 8102002, 8102003);
INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`) VALUES
(8102001, 0, 10180, 1, 100, 0),
(8102002, 0, 136975, 1, 1, 0),
(8102003, 0, 136974, 1, 1, 0);

DELETE FROM `creature_trainer` WHERE `CreatureID` IN (8102001, 8102002, 8102003);
INSERT INTO `creature_trainer` (`CreatureID`, `TrainerID`, `MenuID`, `OptionID`) VALUES
(8102001, 28, 4663, 0),
(8102002, 28, 4663, 0),
(8102003, 7, 4665, 0);

DELETE FROM `creature` WHERE `guid` IN (920014002, 920014003, 920014004);
INSERT INTO `creature`
    (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`,
     `terrainSwapMap`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`,
     `spawntimesecs`, `wander_distance`, `currentwaypoint`, `curHealthPct`, `MovementType`, `npcflag`,
     `unit_flags`, `unit_flags2`, `unit_flags3`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(920014002, 8102001, 1, 0, 0, '0', 0, 0, 0, -1, 0, 1, -2905.50, -260.50, 54.00, 3.70, 120, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 0),
(920014003, 8102002, 2991, 0, 0, '0', 0, 0, 0, -1, 0, 1, 4088.00, 1855.00, 976.80, 3.57, 120, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 70124),
(920014004, 8102003, 2991, 0, 0, '0', 0, 0, 0, -1, 0, 1, 4093.00, 1857.00, 976.50, 2.80, 120, 0, 0, 100, 0, NULL, NULL, NULL, NULL, '', NULL, 70124);

-- Tauren Paladin referral from Grull Hawkwind.
DROP TEMPORARY TABLE IF EXISTS `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_template` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99500, `AllowableRaces` = 32, `QuestSortID` = -141,
    `LogTitle` = 'Consecrated Note',
    `LogDescription` = 'Read the Consecrated Note and speak to Sunwalker Dawnhoof in Camp Narache.',
    `QuestDescription` = 'A message has arrived for you, $N. Sunwalker Dawnhoof, the paladin trainer of Camp Narache, has asked that you seek her guidance. Read the consecrated note and report to her near the village center.';
DELETE FROM `quest_template` WHERE `ID` = 99500;
INSERT INTO `quest_template` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_template_addon` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99500, `AllowableClasses` = 2, `PrevQuestID` = 747;
DELETE FROM `quest_template_addon` WHERE `ID` = 99500;
INSERT INTO `quest_template_addon` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_offer_reward` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99500, `RewardText` = 'The Light has found a place among our people, $N. Walk its path with courage, protect the weak and return when you are ready to continue your training.';
DELETE FROM `quest_offer_reward` WHERE `ID` = 99500;
INSERT INTO `quest_offer_reward` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_request_items` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99500, `CompletionText` = 'You have come, $c. The Sun will rise over our people, and together we will walk the path of the Light.';
DELETE FROM `quest_request_items` WHERE `ID` = 99500;
INSERT INTO `quest_request_items` SELECT * FROM `_custom_quest`;

-- Skyborne Paladin referral from Rorian the Dayseeker.
DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_template` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99501, `AllowableRaces` = 12884901888, `QuestSortID` = -141,
    `LogTitle` = 'A Calling of the Light',
    `LogDescription` = 'Read the Consecrated Letter and speak with Auralin Dawnfeather in Thendal Grove.',
    `QuestDescription` = 'Our order has welcomed a new champion of the Light. Auralin Dawnfeather waits nearby to begin your instruction as a paladin. Read the consecrated letter and seek her in the village.';
DELETE FROM `quest_template` WHERE `ID` = 99501;
INSERT INTO `quest_template` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_template_addon` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99501, `AllowableClasses` = 2, `PrevQuestID` = 92461;
DELETE FROM `quest_template_addon` WHERE `ID` = 99501;
INSERT INTO `quest_template_addon` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_offer_reward` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99501, `RewardText` = 'The Light reaches even the highest winds, $N. Carry it with discipline, and return when you are ready to learn more.';
DELETE FROM `quest_offer_reward` WHERE `ID` = 99501;
INSERT INTO `quest_offer_reward` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_request_items` WHERE `ID` = 3101;
UPDATE `_custom_quest` SET `ID` = 99501, `CompletionText` = 'You carry the letter of Rorian? Then your path begins here, paladin.';
DELETE FROM `quest_request_items` WHERE `ID` = 99501;
INSERT INTO `quest_request_items` SELECT * FROM `_custom_quest`;

-- Skyborne Priest referral from Rorian the Dayseeker.
DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_template` WHERE `ID` = 3103;
UPDATE `_custom_quest` SET `ID` = 99502, `AllowableRaces` = 12884901888, `QuestSortID` = -262,
    `LogTitle` = 'A Calling of the Spirit',
    `LogDescription` = 'Read the Hallowed Letter and speak with Sera Windwhisper in Thendal Grove.',
    `QuestDescription` = 'Sera Windwhisper has heard of your calling and left this letter for you. The priesthood of the Skyborne now has much to teach. Read the hallowed letter and seek Sera in the village.';
DELETE FROM `quest_template` WHERE `ID` = 99502;
INSERT INTO `quest_template` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_template_addon` WHERE `ID` = 3103;
UPDATE `_custom_quest` SET `ID` = 99502, `AllowableClasses` = 16, `PrevQuestID` = 92461;
DELETE FROM `quest_template_addon` WHERE `ID` = 99502;
INSERT INTO `quest_template_addon` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_offer_reward` WHERE `ID` = 3103;
UPDATE `_custom_quest` SET `ID` = 99502, `RewardText` = 'The spirit moves through every living breath, $N. Listen carefully, heal willingly, and return whenever you are ready to continue your training.';
DELETE FROM `quest_offer_reward` WHERE `ID` = 99502;
INSERT INTO `quest_offer_reward` SELECT * FROM `_custom_quest`;

DROP TEMPORARY TABLE `_custom_quest`;
CREATE TEMPORARY TABLE `_custom_quest` AS SELECT * FROM `quest_request_items` WHERE `ID` = 3103;
UPDATE `_custom_quest` SET `ID` = 99502, `CompletionText` = 'Rorian sent you to me? Good. Let us begin your studies, priest.';
DELETE FROM `quest_request_items` WHERE `ID` = 99502;
INSERT INTO `quest_request_items` SELECT * FROM `_custom_quest`;
DROP TEMPORARY TABLE `_custom_quest`;

DELETE FROM `creature_queststarter` WHERE `quest` IN (99500, 99501, 99502);
INSERT INTO `creature_queststarter` (`id`, `quest`) VALUES
(2980, 99500),
(251361, 99501),
(251361, 99502);

DELETE FROM `creature_questender` WHERE `quest` IN (99500, 99501, 99502);
INSERT INTO `creature_questender` (`id`, `quest`) VALUES
(8102001, 99500),
(8102002, 99501),
(8102003, 99502);
