-- Call of Water 94494 ends at Norric Lochthane, who gives the next Forever quest 94495.
UPDATE `quest_template`
SET `RewardNextQuest` = 94495
WHERE `ID` = 94494
  AND `RewardNextQuest` <> 94495;

INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`)
VALUES (94495,94494)
ON DUPLICATE KEY UPDATE `PrevQuestID` = 94494;

-- Archaic Rune ends with Teo, so open his Call of Earth directly.
UPDATE `quest_template`
SET `RewardNextQuest` = 94373
WHERE `ID` = 98581
  AND `RewardNextQuest` <> 94373;

-- The Westfall ritual used only the old Silverpine spawn. Add both ritual
-- manifestations at the Forgotten Shrine using client terrain heights.
DELETE FROM `creature` WHERE `guid` IN (21311083,21311084);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`VerifiedBuild`) VALUES
(21311083,5894,0,0,0,'0',0,0,0,-1,0,0,-10805.0,1424.0,34.8382,2.8,30,0,0,100,0,NULL,NULL,NULL,NULL,'',0),
(21311084,5895,0,0,0,'0',0,0,0,-1,0,0,-10800.0,1424.2,33.9895,1.483,300,0,0,100,0,NULL,NULL,NULL,NULL,'',0);

-- Fire Sapta is repeatable only while the ritual quest is active and no sapta remains.
UPDATE `quest_template_addon`
SET `SpecialFlags` = `SpecialFlags` | 1
WHERE `ID` = 94473;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 94473;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,94473,0,0,9,0,94467,0,0,0,0,0,'','Fire Sapta - Call of Fire 94467 in the log'),
(19,0,94473,0,0,2,0,6636,1,0,1,0,0,'','Fire Sapta - no Fire Sapta in the bags');

-- Reuse the existing Water Sapta recovery quest instead of creating a duplicate.
UPDATE `quest_template_addon`
SET `PrevQuestID` = 94501, `AllowableClasses` = 64, `SpecialFlags` = `SpecialFlags` | 1
WHERE `ID` = 94616;
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 94616;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`,`SourceGroup`,`SourceEntry`,`SourceId`,`ElseGroup`,`ConditionTypeOrReference`,`ConditionTarget`,`ConditionValue1`,`ConditionValue2`,`ConditionValue3`,`NegativeCondition`,`ErrorType`,`ErrorTextId`,`ScriptName`,`Comment`) VALUES
(19,0,94616,0,0,9,0,94502,0,0,0,0,0,'','Water Sapta - Call of Water 94502 in the log'),
(19,0,94616,0,0,2,0,6637,1,0,1,0,0,'','Water Sapta - no Water Sapta in the bags');

DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 19 AND `SourceEntry` = 94504;
DELETE FROM `creature_queststarter` WHERE `quest` = 94504;
DELETE FROM `creature_questender` WHERE `quest` = 94504;
DELETE FROM `quest_template_addon` WHERE `ID` = 94504;
DELETE FROM `quest_template` WHERE `ID` = 94504;

-- Restore the Alliance branch that 79358 explicitly points to.
DELETE FROM `quest_template` WHERE `ID` = 96135;
CREATE TEMPORARY TABLE `tmp_quest_96135` AS SELECT * FROM `quest_template` WHERE `ID` = 79366;
UPDATE `tmp_quest_96135`
SET `ID` = 96135,
    `RewardNextQuest` = 0,
    `AllowableRaces` = 4294967373,
    `QuestDescription` = 'Now that you have the twisted totems, we must wield them to summon forth the corrupted elementals the quilboar are calling upon. Defeat them to cleanse these lands and put an end to the Razormane''s abominable ritual, then report back to Veyric in Arathi Highlands.',
    `QuestCompletionLog` = 'Return to Veyric Thunderhame in Arathi Highlands and report what happened.',
    `VerifiedBuild` = 0;
INSERT INTO `quest_template` SELECT * FROM `tmp_quest_96135`;
DROP TEMPORARY TABLE `tmp_quest_96135`;

INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`,`AllowableClasses`)
VALUES (96135,79358,64)
ON DUPLICATE KEY UPDATE `PrevQuestID` = 79358, `AllowableClasses` = 64;
DELETE FROM `creature_queststarter` WHERE `quest` = 96135;
INSERT INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (259023,96135,0);
DELETE FROM `creature_questender` WHERE `quest` = 96135;
INSERT INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (259023,96135,0);
DELETE FROM `quest_objectives` WHERE `QuestID` = 96135;
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`)
SELECT `ID` + 514575,96135,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,0
FROM `quest_objectives`
WHERE `QuestID` = 79366;

INSERT INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`)
VALUES (96135,40,30,0)
ON DUPLICATE KEY UPDATE `QuestLevel` = 40, `MinLevel` = 30, `MaxLevel` = 0;
INSERT INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`)
VALUES (96135,2,40)
ON DUPLICATE KEY UPDATE `LevelType` = 2, `QuestLevel` = 40;
INSERT INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`)
VALUES (96135,5000,0)
ON DUPLICATE KEY UPDATE `RewardMoney` = 5000, `RewardMoneyMaxLevel` = 0;
DELETE FROM `quest_offer_reward` WHERE `ID` = 96135;
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`EmoteDelay4`,`RewardText`,`VerifiedBuild`) VALUES
(96135,0,0,0,0,0,0,0,0,'Thank you, $n.',0);

-- Rogue classification was lost when these class quests were imported.
INSERT INTO `quest_template_addon` (`ID`,`AllowableClasses`) VALUES
(80453,8),
(80454,8)
ON DUPLICATE KEY UPDATE `AllowableClasses` = 8;

-- These imported quests reference absent follow-up rows. Keep them completable
-- instead of making clients request nonexistent quest templates.
UPDATE `quest_template` SET `RewardNextQuest` = 0
WHERE (`ID`,`RewardNextQuest`) IN ((78092,78093),(79939,79940),(84318,84319),(36719,36795));

-- The custom 265xxx waterskins have no client item records or effects. Use the
-- equivalent classic quest waterskins, which retain the empty-to-filled spell
-- behavior at the target water source.
UPDATE `quest_template` SET `StartItem` = 7766 WHERE `ID` = 94497;
UPDATE `quest_template` SET `StartItem` = 7768 WHERE `ID` = 94499;
UPDATE `quest_template` SET `StartItem` = 7767 WHERE `ID` = 94500;
UPDATE `quest_objectives` SET `ObjectID` = 7769 WHERE `QuestID` = 94497 AND `ObjectID` = 265734;
UPDATE `quest_objectives` SET `ObjectID` = 7771 WHERE `QuestID` = 94499 AND `ObjectID` = 265748;
UPDATE `quest_objectives` SET `ObjectID` = 7770 WHERE `QuestID` = 94500 AND `ObjectID` = 265773;

-- Hunter classification and the three Zephras taming steps.
UPDATE `quest_template` SET `QuestSortID` = -261 WHERE `ID` = 92479;
UPDATE `quest_template` SET `RewardNextQuest` = 94979 WHERE `ID` = 94978;
UPDATE `quest_template` SET `RewardNextQuest` = 94013 WHERE `ID` = 94979;
UPDATE `quest_template` SET `RewardNextQuest` = 94050 WHERE `ID` = 94013;

-- Death knight class tasks were never assigned their class mask.
INSERT INTO `quest_template_addon` (`ID`,`AllowableClasses`) VALUES
(12781,32),
(58877,32),
(58902,32),
(58903,32),
(58989,32)
ON DUPLICATE KEY UPDATE `AllowableClasses` = 32;
