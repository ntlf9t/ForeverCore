-- WoW Forever quests missing on Everlake, from Karrz1/ForeverCore 0.1.39 (forever-bots b441bf74e0), rows taken one by one.
-- 45 quests here (the Duskwood, Hinterlands and Feralas incursion missions, An Epic Ride and the other epic mount quests,
-- Brawl at the Maul, Alcaz Prison's 95483 and 96335, and more); the Dead Drop quests 78307 and 78699 are
-- 2026_11_21_86_world_forever_rogue_dead_drop.sql. Karrz's sources: EG Link live records (CC BY 4.0), Wowhead WoW Forever
-- pages, QuestieDB (GPL-3.0); spawn spots from Wowhead map pins and heights from nearby spawns are his estimates.
-- Taken from each Karrz file: only the rows keyed on these quests (quest_template, _addon, objectives, classic level and
-- money, starters, enders, texts), on the quest NPCs and objects this world does not have (templates, models, levels,
-- spawns), and the drop rows of quest items nothing here drops. Karrz's files carry many other rows, including copies of
-- Everlake's own data; those are left out. Spawn inserts skip a spawn that is already there; the guids
-- (creature 47600010-47600479, 48120078; gameobject 47500xxx-47501xxx) were free on the PTR on 2026-11-22.
-- Safe to run again.

-- from Karrz 2026_11_14_40_world_forever_alcaz_prison_npc_templates.sql
DELETE FROM `creature_template` WHERE `entry` IN (264770);
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(264770,0,0,'Mason Connery',NULL,NULL,NULL,NULL,0,0,35,2,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,0);
DELETE FROM `creature_template_difficulty` WHERE `Entry` IN (264770);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(264770,0,0,0,0,0,1.0,1.0,1.0,1.0,348271,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (264770);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(264770,0,144257,1.0,1.0,0);
DELETE FROM `creature_classic_level` WHERE `entry` IN (264770);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(264770,50,50);

-- from Karrz 2026_11_14_42_world_forever_alcaz_prison_quests.sql
DELETE FROM `quest_template` WHERE `ID`=96335;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`LogTitle`,`VerifiedBuild`) VALUES (96335,2,'The Man in the Iron Chains',-1);
UPDATE `quest_template` SET `QuestDescription`='Wow! That was impressive. The way you took down that dragon was really something!\n\nWhile you are here... do you think you might be able to help me get out of this ball and chain?\n\nIf he hasn''t fled or been killed already, the torturer they call ''The Questioner'' should have the keys to these shackles. Get the key from that sadist and bring it to me.\n\nI promise that I''ll make it well worth your while if you do.', `LogDescription`='Recover the Alcaz Shackle Key from The Questioner in Alcaz Prison.', `QuestSortID`=16620, `QuestInfoID`=81, `RewardNextQuest`=95263, `RewardXPDifficulty`=2, `RewardXPMultiplier`=2.2, `StartItem`=0, `Flags`=2097152, `AllowableRaces`=18446744073709551615, `VerifiedBuild`=70888 WHERE `ID`=96335;
DELETE FROM `quest_classic_level` WHERE `ID`=96335;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (96335,53,48,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=96335;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (96335,2,53);
DELETE FROM `quest_template_addon` WHERE `ID`=96335;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (96335,0,0,0);
DELETE FROM `quest_offer_reward` WHERE `ID`=96335;
INSERT IGNORE INTO `quest_offer_reward` (`ID`,`RewardText`,`VerifiedBuild`) VALUES (96335,'Well done, $n. Thank you.',-1);
DELETE FROM `quest_classic_money` WHERE `ID`=96335;
DELETE FROM `quest_objectives` WHERE `QuestID`=96335;
DELETE FROM `quest_objectives` WHERE `ID` IN (472871);
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES (472871,96335,1,0,2,274029,1,0,32,1,0.0,0,1,NULL,70888);
DELETE FROM `creature_queststarter` WHERE `quest`=96335;
DELETE FROM `creature_questender` WHERE `quest`=96335;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (264770,96335,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (264770,96335,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (264770,264770);
DELETE FROM `quest_template` WHERE `ID`=95483;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`LogTitle`,`VerifiedBuild`) VALUES (95483,2,'Thrall Needs to Know',-1);
UPDATE `quest_template` SET `QuestDescription`='Thrall needs to know what happened here. I will meet up with Ulka and see to it that he is fit to travel before returning to Orgrimmar, so I am trusting you to bring this information to the warchief in my stead.\n\nGo now, soldier of the Horde. Tell our warchief what fate befell Varian Wrynn.', `LogDescription`='Bring word of Varian Wrynn''s fate to Thrall in Orgrimmar.', `QuestSortID`=16620, `QuestInfoID`=81, `RewardNextQuest`=0, `RewardXPDifficulty`=2, `RewardXPMultiplier`=1.85, `StartItem`=0, `Flags`=2097160, `AllowableRaces`=12261800583900083122, `VerifiedBuild`=70862, `RewardChoiceItemID1`=279831, `RewardChoiceItemQuantity1`=1, `RewardChoiceItemID2`=279833, `RewardChoiceItemQuantity2`=1, `RewardChoiceItemID3`=279474, `RewardChoiceItemQuantity3`=1, `RewardFactionID1`=76, `RewardFactionValue1`=5 WHERE `ID`=95483;
DELETE FROM `quest_classic_level` WHERE `ID`=95483;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (95483,53,48,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=95483;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (95483,2,53);
DELETE FROM `quest_template_addon` WHERE `ID`=95483;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (95483,0,0,0);
DELETE FROM `quest_offer_reward` WHERE `ID`=95483;
INSERT IGNORE INTO `quest_offer_reward` (`ID`,`RewardText`,`VerifiedBuild`) VALUES (95483,'Well done, $n. Thank you.',-1);
DELETE FROM `quest_classic_money` WHERE `ID`=95483;
DELETE FROM `quest_objectives` WHERE `QuestID`=95483;
DELETE FROM `creature_queststarter` WHERE `quest`=95483;
DELETE FROM `creature_questender` WHERE `quest`=95483;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (260386,95483,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (4949,95483,0);

-- from Karrz 2026_11_20_70_world_forever_eg_live_npc_templates.sql
DELETE FROM `creature_template` WHERE `entry` IN (215643,221333,221575,221985);
DELETE FROM `creature_template_difficulty` WHERE `DifficultyID`=0 AND `Entry` IN (215643,221333,221575,221985);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (215643,221333,221575,221985);
DELETE FROM `creature_classic_level` WHERE `entry` IN (215643,221333,221575,221985);
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(215643,0,0,'Tokal',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(221333,0,0,'Doomkin','Fury of Elune',NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(221575,0,0,'Elrick',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(221985,0,0,'Tyrisius',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(215643,0,0,0,0,0,1.05,1.0,1.0,1.0,265120,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221333,0,0,0,0,0,25.0,15.0,1.0,1.0,271036,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221575,0,0,0,0,0,1.2,1.0,1.0,1.0,271384,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221985,0,0,0,0,0,1.35,1.0,1.0,1.0,271801,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(215643,0,116412,1.0,1.0,-1),
(221333,0,118604,1.0,0.0,-1),
(221575,0,118686,1.0,1.0,-1),
(221985,0,118930,1.0,0.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(215643,35,35);

-- from Karrz 2026_11_20_71_world_forever_eg_live_new_quests.sql
DELETE FROM `quest_template` WHERE `ID`=80453;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (80453,2,-162,0,80454,1,1.0,0,1.0,0,217609,35651840,0,0,0,18446744073709551615,'Best Laid Plans','Bring the Talisman of Kazdor to Zan Shivsprocket in the basement of Ravenholdt Manor.','Take the talisman down to Zan Shivsprocket, in the basement. I''ve asked him to rig the artifact with a mechanism that will detect any attempt to channel magic energy into, or out of, it.

The mechanism is all but invisible to the naked eye, and will detonate when triggered. With any luck, Caius will be killed in the blast. At the very least, his plans for the talisman will be foiled.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=80453;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448196,80453,1,0,0,217609,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=80453;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (80453,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=80453;
DELETE FROM `quest_classic_level` WHERE `ID`=80453;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (80453,50,45,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=80453;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (80453,2,50);
DELETE FROM `creature_queststarter` WHERE `quest`=80453;
DELETE FROM `gameobject_queststarter` WHERE `quest`=80453;
DELETE FROM `creature_questender` WHERE `quest`=80453;
DELETE FROM `gameobject_questender` WHERE `quest`=80453;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (6707,80453,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (6777,80453,0);
DELETE FROM `quest_template` WHERE `ID`=80454;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (80454,2,-162,0,80455,5,1.0,0,1.0,0,217737,35651840,0,0,0,18446744073709551615,'One Last Drop','Take the Modified Talisman to Caius'' dead drop near Pyrewood Village.','The bait is ready, now we must lay the trap. I''ve modified the talisman per Fahrad''s instructions. All that''s left is for you to deliver it as you have the other artifacts before.

Go to the cabin near Pyrewood Village, and put this modified talisman into Caius'' dead drop.

What follows is out of our hands, for now.','','',70938);
DELETE FROM `quest_objectives` WHERE `QuestID`=80454;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448014,80454,1,0,1,217737,1,0,1,NULL,70938);
DELETE FROM `quest_template_addon` WHERE `ID`=80454;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (80454,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=80454;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (80454,8225,0);
DELETE FROM `quest_classic_level` WHERE `ID`=80454;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (80454,50,45,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=80454;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (80454,2,50);
DELETE FROM `creature_queststarter` WHERE `quest`=80454;
DELETE FROM `gameobject_queststarter` WHERE `quest`=80454;
DELETE FROM `creature_questender` WHERE `quest`=80454;
DELETE FROM `gameobject_questender` WHERE `quest`=80454;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (6777,80454,0);
INSERT IGNORE INTO `gameobject_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (410369,80454,0);

-- from Karrz 2026_11_20_77_world_forever_wowhead_quest_npcs.sql
DELETE FROM `creature_template` WHERE `entry` IN (218160,221171,221172,221174,221175,221176,221200,221210,221215,221216,221325,221326,221328,221330,221367,221369,221370,221371,221375,221377,221471,221479,221928,221933,221935,228619);
DELETE FROM `creature_template_difficulty` WHERE `DifficultyID`=0 AND `Entry` IN (218160,221171,221172,221174,221175,221176,221200,221210,221215,221216,221325,221326,221328,221330,221367,221369,221370,221371,221375,221377,221471,221479,221928,221933,221935,228619);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (218160,221171,221172,221174,221175,221176,221200,221210,221215,221216,221325,221326,221328,221330,221367,221369,221370,221371,221375,221377,221471,221479,221928,221933,221935,228619);
DELETE FROM `creature_classic_level` WHERE `entry` IN (218160,221171,221172,221174,221175,221176,221200,221210,221215,221216,221325,221326,221328,221330,221367,221369,221370,221371,221375,221377,221471,221479,221928,221933,221935,228619);
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(218160,0,0,'Aeonas the Vindicated',NULL,NULL,NULL,NULL,0,0,12,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221171,0,0,'Nightmare Runner',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221172,0,0,'Nightmare Weaver',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221174,0,0,'Deranged Ogre',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221175,0,0,'Demented Fire Weaver',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221176,0,0,'Nightterror Whelp',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221200,0,0,'Wyrmkin Terrorwalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221210,0,0,'Kroll Mountainshade',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221215,0,0,'Alara Grovemender',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221216,0,0,'Elenora Marshwalker',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221325,0,0,'Wyrmkin Starhunter',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221326,0,0,'Wrath Whelp',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221328,0,0,'Dreamwater Vicejaw',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221330,0,0,'Fallen Moonkin',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221367,0,0,'Wyrmkin Berserker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221369,0,0,'Frenzied Whelp',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221370,0,0,'Dreamspring Roguefeather',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221371,0,0,'Dreamspring Stormcaller',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221375,0,0,'Lost Daughter',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221377,0,0,'Vengeful Son',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221471,0,0,'Field Captain Palandar',NULL,NULL,NULL,NULL,0,0,35,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221479,0,0,'Field Captain Korlian',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221928,0,0,'Hippogryph Avatar',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221933,0,0,'Moonkin Avatar',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221935,0,0,'Treant Avatar',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(228619,0,0,'Orthas',NULL,NULL,NULL,NULL,0,0,35,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(218160,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221171,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221172,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221174,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221175,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221176,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221200,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221210,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221215,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221216,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221325,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221326,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221328,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221330,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221367,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221369,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221370,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221371,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221375,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221377,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221471,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221479,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221928,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221933,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221935,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228619,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(218160,0,117330,1.0,1.0,-1),
(221171,0,563,1.0,1.0,-1),
(221172,0,563,1.0,1.0,-1),
(221174,0,655,1.0,1.0,-1),
(221175,0,118567,1.0,1.0,-1),
(221176,0,621,1.0,1.0,-1),
(221200,0,118584,1.0,1.0,-1),
(221210,0,10858,1.0,1.0,-1),
(221215,0,2034,1.0,1.0,-1),
(221216,0,2034,1.0,1.0,-1),
(221325,0,118584,1.0,1.0,-1),
(221326,0,621,1.0,1.0,-1),
(221328,0,7046,1.0,1.0,-1),
(221330,0,12237,1.0,1.0,-1),
(221367,0,7903,1.0,1.0,-1),
(221369,0,621,1.0,1.0,-1),
(221370,0,10874,1.0,1.0,-1),
(221371,0,10871,1.0,1.0,-1),
(221375,0,2722,1.0,1.0,-1),
(221377,0,11906,1.0,1.0,-1),
(221471,0,10858,1.0,1.0,-1),
(221479,0,1703,1.0,1.0,-1),
(221928,0,3210,1.0,1.0,-1),
(221933,0,12236,1.0,1.0,-1),
(221935,0,14354,1.0,1.0,-1),
(228619,0,121693,1.0,1.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(218160,40,40),
(221171,26,26),
(221172,26,26),
(221174,26,26),
(221175,26,26),
(221176,26,26),
(221200,26,26),
(221210,25,25),
(221215,25,25),
(221216,25,25),
(221325,51,51),
(221326,51,51),
(221328,51,51),
(221330,51,51),
(221367,51,51),
(221369,51,51),
(221370,51,51),
(221371,49,50),
(221375,51,51),
(221377,51,51),
(221471,25,25),
(221479,50,50),
(221928,50,50),
(221933,50,50),
(221935,50,50),
(228619,60,60);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47600010,221172,0,0,0,'0',0,0,0,-1,0,0,-11073.86,-813.66,58.197,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600011,221172,0,0,0,'0',0,0,0,-1,0,0,-11077.46,-813.66,58.197,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600012,221174,0,0,0,'0',0,0,0,-1,0,0,-10965.86,-41.45,14.695,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600013,221174,0,0,0,'0',0,0,0,-1,0,0,-10965.86,-46.85,14.695,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600014,221174,0,0,0,'0',0,0,0,-1,0,0,-10969.46,-63.05,15.549,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600015,221175,0,0,0,'0',0,0,0,-1,0,0,-10980.26,-30.65,14.990,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600016,221175,0,0,0,'0',0,0,0,-1,0,0,-10980.26,-79.25,14.893,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600017,221175,0,0,0,'0',0,0,0,-1,0,0,-11063.06,-79.25,14.937,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600018,221200,0,0,0,'0',0,0,0,-1,0,0,-11019.86,-446.45,30.632,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600019,221200,0,0,0,'0',0,0,0,-1,0,0,-11023.46,-451.85,30.632,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600020,221200,0,0,0,'0',0,0,0,-1,0,0,-10983.86,-457.26,31.906,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600021,221210,0,0,0,'0',0,0,0,-1,0,0,-10962.26,-948.66,71.188,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600022,221215,0,0,0,'0',0,0,0,-1,0,0,-11109.87,-489.66,32.973,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600023,221216,0,0,0,'0',0,0,0,-1,0,0,-10965.86,-41.45,14.695,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600033,221325,0,0,0,'0',0,0,0,-1,0,0,373.35,-3308.94,116.333,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600034,221325,0,0,0,'0',0,0,0,-1,0,0,470.89,-3324.33,120.236,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600035,221325,0,0,0,'0',0,0,0,-1,0,0,455.49,-3339.71,119.650,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600036,221326,0,0,0,'0',0,0,0,-1,0,0,414.42,-3308.94,135.292,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600037,221326,0,0,0,'0',0,0,0,-1,0,0,368.22,-3308.94,116.333,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600038,221326,0,0,0,'0',0,0,0,-1,0,0,470.89,-3324.33,120.236,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600039,221328,0,0,0,'0',0,0,0,-1,0,0,481.16,-3785.82,121.812,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600040,221330,0,0,0,'0',0,0,0,-1,0,0,419.56,-3647.37,122.935,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600041,221330,0,0,0,'0',0,0,0,-1,0,0,465.76,-3655.06,121.602,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600045,221370,1,0,0,'0',0,0,0,-1,0,0,-2847.82,2788.80,94.479,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600046,221371,1,0,0,'0',0,0,0,-1,0,0,-3005.42,2886.17,95.996,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600047,221375,1,0,0,'0',0,0,0,-1,0,0,-3061.05,2566.22,41.845,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600048,221375,1,0,0,'0',0,0,0,-1,0,0,-3079.59,2552.31,41.845,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600049,221377,1,0,0,'0',0,0,0,-1,0,0,-3079.59,2566.22,41.845,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600050,221377,1,0,0,'0',0,0,0,-1,0,0,-3079.59,2552.31,41.845,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600052,221928,1,0,0,'0',0,0,0,-1,0,0,3691.78,-5021.09,136.467,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600053,221928,1,0,0,'0',0,0,0,-1,0,0,3685.02,-5031.24,136.467,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600054,221935,1,0,0,'0',0,0,0,-1,0,0,-4776.15,1383.81,106.601,0,300,5,0,100,1,0,0,0,0,'',NULL,-1);

-- from Karrz 2026_11_20_80_world_forever_wowhead_quest_npcs_spawn_fix.sql
UPDATE `creature` SET `npcflag`=NULL,`unit_flags`=NULL,`unit_flags2`=NULL,`unit_flags3`=NULL,`curHealthPct`=NULL WHERE `guid` BETWEEN 47600000 AND 47600069;

-- from Karrz 2026_11_20_81_world_forever_wowhead_quest_item_drops.sql
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,216956,2.77,1,1,0,1,1,'Wowhead WoW Forever 23/829 est' FROM `creature_template_difficulty` d WHERE d.`Entry`=4668 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=216956);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,216956,1.39,1,1,0,1,1,'Wowhead WoW Forever 2/363 est' FROM `creature_template_difficulty` d WHERE d.`Entry`=4705 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=216956);

-- from Karrz 2026_11_20_82_world_forever_eg_live_quests_4.sql
DELETE FROM `quest_template` WHERE `ID`=79939;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (79939,2,-141,0,79940,4,1.0,0,1.0,0,215441,0,0,0,0,6130900294268439629,'The Broken Hammer','Recover clues about the recent battle at Mannoroc Coven, and return the Broken Warhammer to Katherine the Pure in Stormwind.','<An ornate broken warhammer lies surrounded by dead Burning Blade Cultists and Scarlet Crusade warriors. A fight clearly happened here, and fairly recently. You also recognize this as the weapon of a paladin of the Order of the Silver Hand. 

While you''ve seen many hammers like this one, the quality and worksmanship of this weapon is fairly unique. You should search the area for clues, and return to Katherine with the broken hammer.>','','',70938);
DELETE FROM `quest_objectives` WHERE `QuestID`=79939;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (446831,79939,1,0,1,215441,1,0,1,NULL,70938),
(447347,79939,1,1,2,216956,1,0,1,'Mannoroc Coven Clues',70938),
(446830,79939,3,2,0,5492,1,0,1,'Return to Katherine the Pure',70938);
DELETE FROM `quest_template_addon` WHERE `ID`=79939;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (79939,0,2,0);
DELETE FROM `quest_classic_money` WHERE `ID`=79939;
DELETE FROM `quest_classic_level` WHERE `ID`=79939;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (79939,40,35,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=79939;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (79939,2,40);
DELETE FROM `creature_queststarter` WHERE `quest`=79939;
DELETE FROM `gameobject_queststarter` WHERE `quest`=79939;
DELETE FROM `creature_questender` WHERE `quest`=79939;
DELETE FROM `gameobject_questender` WHERE `quest`=79939;
INSERT IGNORE INTO `gameobject_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (423703,79939,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (5492,79939,0);

-- from Karrz 2026_11_20_83_world_forever_wowhead_quest_objects.sql
DELETE FROM `gameobject_template` WHERE `entry` IN (423569,461639) AND `VerifiedBuild`=-1;
DELETE FROM `gameobject_loot_template` WHERE `Entry` IN (423569,461639) AND `Comment`='Wowhead WoW Forever';
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 423569,323,'Dropped Pouch',1,423569,79242,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 461639,1107,'Orthas''s Hammer',1,461639,84318,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(423569,0,212347,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(461639,0,227686,100.0,1,1,0,1,1,'Wowhead WoW Forever');
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47500100,423569,0,0,0,'0',0,0,0,-1,-1839.72,-4229.07,2.135,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500101,423569,0,0,0,'0',0,0,0,-1,-1822.92,-4232.67,2.135,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500102,423569,0,0,0,'0',0,0,0,-1,-1846.92,-4243.47,2.136,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500103,423569,0,0,0,'0',0,0,0,-1,-1849.32,-4243.47,2.136,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500105,461639,0,0,0,'0',0,0,0,-1,1708.12,-4893.26,89.658,0,0,0,0,1,120,255,1,'',NULL,-1);

-- from Karrz 2026_11_20_85_world_forever_wowhead_spawns_and_quests.sql
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600070,221471,0,0,0,'0',0,0,0,-1,0,0,-10638.30,-392.50,103.21,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221471) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221471 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600073,228619,0,0,0,'0',0,0,0,-1,0,0,2441.60,-2574.20,156.34,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=228619) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=228619 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600074,218160,0,0,0,'0',0,0,0,-1,0,0,-8565.70,878.50,106.52,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=218160) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=218160 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600078,221171,0,0,0,'0',0,0,0,-1,0,0,-11019.90,-662.50,34.22,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221171) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221171 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600079,221176,0,0,0,'0',0,0,0,-1,0,0,-11001.90,-387.10,40.99,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221176) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221176 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600082,221367,1,0,0,'0',0,0,0,-1,0,0,-3144.50,2162.80,32.23,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221367) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221367 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600083,221369,1,0,0,'0',0,0,0,-1,0,0,-3024.00,2260.20,45.34,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221369) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221369 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600085,221479,0,0,0,'0',0,0,0,-1,0,0,583.80,-3939.70,113.49,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221479) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221479 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600086,221933,0,0,0,'0',0,0,0,-1,0,0,106.40,-4124.30,172.25,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221933) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221933 AND `guid` NOT BETWEEN 47600070 AND 47600199);
DELETE FROM `quest_template` WHERE `ID`=81730;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81730,2,10,1,0,5,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission I: Defeat Worgen','Defeat 10 Nightmare Runners and 10 Nightmare Weavers in the Duskwood Nightmare Incursion in the Rotting Orchard and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion in the Rotting Orchard. Defeat worgen there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81730;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448713,81730,0,0,0,221171,10,0,1,NULL,70959),
(448714,81730,0,1,5,221172,10,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81730;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81730,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81730;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81730,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81730;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81730,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81730;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81730,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81730;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81730;
DELETE FROM `creature_questender` WHERE `quest`=81730;
DELETE FROM `gameobject_questender` WHERE `quest`=81730;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81730,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81730,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81731;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81731,2,10,1,0,5,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission II: Defeat Ogres','Defeat 3 Deranged Ogres and 3 Demented Fire Weavers in the Duskwood Nightmare Incursion at the Vul''gol Ogre Mound and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Vul''gol Ogre Mound. Defeat ogres there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81731;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448715,81731,0,0,1,221174,3,0,1,NULL,70959),
(448716,81731,0,1,2,221175,3,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81731;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81731,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81731;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81731,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81731;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81731,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81731;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81731,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81731;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81731;
DELETE FROM `creature_questender` WHERE `quest`=81731;
DELETE FROM `gameobject_questender` WHERE `quest`=81731;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81731,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81731,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81732;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81732,2,10,1,0,5,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission III: Defeat Dragonkin','Defeat 3 Wyrmkin Terrorwalkers and 10 Nightterror Whelps in the Duskwood Nightmare Incursion at the Yorgen Farmstead and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Yorgen Farmstead. Defeat dragonkin there and return to me.','','',70938);
DELETE FROM `quest_objectives` WHERE `QuestID`=81732;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448717,81732,0,0,0,221200,3,0,1,NULL,70938),
(448718,81732,0,1,3,221176,10,0,1,NULL,70938);
DELETE FROM `quest_template_addon` WHERE `ID`=81732;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81732,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81732;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81732,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81732;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81732,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81732;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81732,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81732;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81732;
DELETE FROM `creature_questender` WHERE `quest`=81732;
DELETE FROM `gameobject_questender` WHERE `quest`=81732;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81732,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81732,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81745;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81745,2,10,1,0,4,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission XVI: Rescue Kroll Mountainshade','Rescue Kroll Mountainshade from the Duskwood Nightmare Incursion in the guest house at the Rotting Orchard and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Rotting Orchard. Find the sleeping Druid of the Claw Kroll Mountainshade there and escort him to safety. Then return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81745;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448737,81745,0,0,0,221210,1,0,1,'Rescue Kroll Mountainshade',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81745;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81745,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81745;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81745,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81745;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81745,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81745;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81745,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81745;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81745;
DELETE FROM `creature_questender` WHERE `quest`=81745;
DELETE FROM `gameobject_questender` WHERE `quest`=81745;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81745,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81745,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81746;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81746,2,10,1,0,4,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission XVII: Rescue Alara Grovemender','Rescue Alara Grovemender in the Duskwood Nightmare Incursion in the stable at the Yorgen Farmstead and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Yorgen Darmstead. Find the sleeping Druid of the Claw Alara Grovemender there and escort her to safety. Then return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81746;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448738,81746,0,0,1,221215,1,0,1,'Rescue Alara Grovemender',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81746;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81746,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81746;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81746,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81746;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81746,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81746;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81746,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81746;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81746;
DELETE FROM `creature_questender` WHERE `quest`=81746;
DELETE FROM `gameobject_questender` WHERE `quest`=81746;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81746,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81746,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81747;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81747,2,10,1,0,4,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission XVIII: Rescue Elenora Marshwalker','Rescue Elenora Marshwalker in the Duskwood Nightmare Incursion in the ruins of a farmhouse near the Vul''gol Ogre Mound and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Vul''gol Ogre Mound. Find the sleeping Druid of the Claw Elenora Marshwalker there and escort her to safety. Then return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81747;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448739,81747,0,0,0,221216,1,0,1,'Rescue Elenora Marshwalker',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81747;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81747,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81747;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81747,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81747;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81747,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81747;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81747,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81747;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81747;
DELETE FROM `creature_questender` WHERE `quest`=81747;
DELETE FROM `gameobject_questender` WHERE `quest`=81747;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81747,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81747,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81762;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81762,2,-141,0,81764,3,1.0,0,1.0,0,0,0,0,0,0,6130900294268439629,'Some Good News','Speak with Katherine the Pure at the Cathedral of Light in Stormwind.','Greetings, $n. I have good news. I''ve made contact with my friend, and I am leaving soon to meet with him. What''s more, another orb has surfaced in Kalimdor.  I cannot be in two places at once so if you are willing, I''d like for you to go in my stead to follow up on this new orb. Speak with Katherine for further instructions.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81762;
DELETE FROM `quest_template_addon` WHERE `ID`=81762;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81762,0,2,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81762;
DELETE FROM `quest_classic_level` WHERE `ID`=81762;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81762,50,45,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81762;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81762,2,50);
DELETE FROM `creature_queststarter` WHERE `quest`=81762;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81762;
DELETE FROM `creature_questender` WHERE `quest`=81762;
DELETE FROM `gameobject_questender` WHERE `quest`=81762;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (218160,81762,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (5492,81762,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (218160);
DELETE FROM `quest_template` WHERE `ID`=84318;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (84318,2,-141,0,84319,5,1.0,0,1.0,0,227687,0,0,0,0,18446744073709551615,'Oi!','Find Orthas'' missing hammer in Corrin''s Crossing.','Oi! $c! Yes, ye! Ye did me a solid by smashing up that depressin'' mess of a meatsuit I''ve been riding in all these years, but I dinnae feel much of a pull to move on. I''m expectin'' it''s because I got some "Unfinished Business" to get up to ''afore I can be on me way. Well dull-wit, ye just been conscripted to help!

I need ye to fetch me hammer. Should be somewhere in Corrin''s Crossing and it''ll be hard to miss. 

Oi, take this too. It''s me favorite gold tooth. Give it a rub when you''ve found me weapon.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=84318;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (452327,84318,1,0,0,227686,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=84318;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (84318,0,2,0);
DELETE FROM `quest_classic_money` WHERE `ID`=84318;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (84318,15750,0);
DELETE FROM `quest_classic_level` WHERE `ID`=84318;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (84318,57,54,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=84318;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (84318,2,57);
DELETE FROM `creature_queststarter` WHERE `quest`=84318;
DELETE FROM `gameobject_queststarter` WHERE `quest`=84318;
DELETE FROM `creature_questender` WHERE `quest`=84318;
DELETE FROM `gameobject_questender` WHERE `quest`=84318;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (228619,84318,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (228619,84318,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (228619);
DELETE FROM `quest_template` WHERE `ID`=98462;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (98462,2,618,0,0,0,1.0,0,1.0,0,0,0,0,0,0,18446744073709551615,281234,1,'Shroud of the Winter Wilds','Bring $1oa Chillwind Chimaera Fur and $2oa Winterspring Owl Feathers to Evie Whirlbrew.','Back for more, eh? You know the drill! Bring me some Chillwind Chimaera Fur and Winterspring Owl Feathers, and I''ll use the ingredients to mix up a shrouding potion that''ll help to conceal you from the eyes of the creatures living around here.','','',70938);
DELETE FROM `quest_objectives` WHERE `QuestID`=98462;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (477799,98462,1,0,0,281241,5,0,1,NULL,70938),
(477800,98462,1,1,1,281242,5,0,1,NULL,70938);
DELETE FROM `quest_template_addon` WHERE `ID`=98462;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (98462,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=98462;
DELETE FROM `quest_classic_level` WHERE `ID`=98462;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (98462,60,55,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=98462;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (98462,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=98462;
DELETE FROM `gameobject_queststarter` WHERE `quest`=98462;
DELETE FROM `creature_questender` WHERE `quest`=98462;
DELETE FROM `gameobject_questender` WHERE `quest`=98462;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (11188,98462,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (11188,98462,0);

-- from Karrz 2026_11_21_10_world_forever_wowhead_spawns_dev_heights_3.sql
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600420,215643,0,0,0,'0',0,0,0,-1,0,0,-14452.90,497.90,26.28,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=215643) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=215643 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600421,221575,1,0,0,'0',0,0,0,-1,0,0,-3622.20,-4460.90,13.62,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221575) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221575 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600422,221985,1,0,0,'0',0,0,0,-1,0,0,-5564.20,1467.30,21.19,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221985) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221985 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600423,221333,0,0,0,'0',0,0,0,-1,0,0,322.00,-3739.70,138.87,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600424,221333,0,0,0,'0',0,0,0,-1,0,0,378.50,-3747.40,153.55,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600425,221333,0,0,0,'0',0,0,0,-1,0,0,358.00,-3747.40,150.12,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600426,221333,0,0,0,'0',0,0,0,-1,0,0,347.70,-3747.40,147.34,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600427,221333,0,0,0,'0',0,0,0,-1,0,0,383.60,-3755.10,162.77,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600428,221333,0,0,0,'0',0,0,0,-1,0,0,352.80,-3755.10,152.59,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600429,221333,0,0,0,'0',0,0,0,-1,0,0,347.70,-3755.10,150.14,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600430,221333,0,0,0,'0',0,0,0,-1,0,0,322.00,-3755.10,142.63,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221333) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221333 AND `guid` NOT BETWEEN 47600420 AND 47600439);

-- from Karrz 2026_11_21_11_world_forever_eg_live_quests_8.sql
DELETE FROM `quest_template` WHERE `ID`=79235;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (79235,2,405,0,0,3,1.0,0,1.0,0,0,33554432,0,0,0,18446744073709551615,'On the Lam','Find one of the Desolace marauders.','I''ve found a couple of scenes like you describe, $n. Always camps of humans and dwarves. Rumor among the caravans is a group of Horde marauders did it. Seems likely given the victims, and how brutal the attacks were.

Apparently the bandits fled Desolace once an Alliance marshal got hot on their trail.

If you''re looking to track one of ''em down, I''d check Booty Bay. Ports always have shady characters coming and going. You might catch one trying to get a boat to somewhere.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=79235;
DELETE FROM `quest_template_addon` WHERE `ID`=79235;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (79235,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=79235;
DELETE FROM `quest_classic_level` WHERE `ID`=79235;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (79235,40,30,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=79235;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (79235,2,40);
DELETE FROM `creature_queststarter` WHERE `quest`=79235;
DELETE FROM `gameobject_queststarter` WHERE `quest`=79235;
DELETE FROM `creature_questender` WHERE `quest`=79235;
DELETE FROM `gameobject_questender` WHERE `quest`=79235;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (11438,79235,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (215643,79235,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (215643);
DELETE FROM `quest_template` WHERE `ID`=79236;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (79236,2,405,0,0,3,1.0,0,1.0,0,0,33554432,0,0,0,18446744073709551615,'Cherry for Your Thoughts?','Bring a Cherry Grog to Tokal, in Booty Bay, to hear the rest of her story.','You with the marshal? No, you don''t look like it.

The rumors you''ve heard are only half true. Yes, we were pillaging human and dwarven camps, but we weren''t doing it for the Horde. We were privately employed.

I''ll tell you the whole story if you buy me some grog.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=79236;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (445860,79236,1,0,0,4600,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=79236;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (79236,0,0,79235);
DELETE FROM `quest_classic_money` WHERE `ID`=79236;
DELETE FROM `quest_classic_level` WHERE `ID`=79236;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (79236,40,30,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=79236;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (79236,2,40);
DELETE FROM `creature_queststarter` WHERE `quest`=79236;
DELETE FROM `gameobject_queststarter` WHERE `quest`=79236;
DELETE FROM `creature_questender` WHERE `quest`=79236;
DELETE FROM `gameobject_questender` WHERE `quest`=79236;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (215643,79236,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (215643,79236,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (215643);
DELETE FROM `quest_template` WHERE `ID`=81764;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81764,2,-141,0,81765,5,1.0,0,1.0,444651,0,8,0,0,0,6130900294268439629,'The Mysterious Merchant','Travel to Theramore and find the mysterious merchant.','Well met again, $n. Shaw and his spies have provided us with information on a mysterious merchant who just arrived in Kalimdor and is looking to offload a collection of dangerous artifacts. We''ve come to believe that he has an Echoing Orb in his collection. He is staying at the Theramore Inn in Dustwallow Marsh. Travel quickly, retrieve the orb, and speak to no one of this. We are sending you in alone to avoid drawing the attention of our enemies. 

Be safe, and go with the light.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81764;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448779,81764,3,0,0,221575,1,0,1,'Travel to Theramore and find the mysterious merchant.',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81764;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81764,0,2,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81764;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81764,8225,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81764;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81764,50,45,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81764;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81764,2,50);
DELETE FROM `creature_queststarter` WHERE `quest`=81764;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81764;
DELETE FROM `creature_questender` WHERE `quest`=81764;
DELETE FROM `gameobject_questender` WHERE `quest`=81764;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (5492,81764,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221575,81764,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221575);
DELETE FROM `quest_template` WHERE `ID`=81924;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81924,2,-263,0,0,6,1.0,0,1.0,0,0,35651584,0,0,0,18446744073709551615,219326,1,'Wisdom of the Guardians','Prove yourself to the guardian spirits of Feralas, Azshara, and the Hinterlands, then return to Tyrisius in Feralas.','Whatever Kaldorei knowledge you seek will not be found among these ruins, $c. Not anymore.

However, while the physical lies in ruin, the spiritual remains.

Seek the guardian spirits of Azshara, the Hinterlands, and Feralas. You will know them by their shrines. Prove yourself to them, and heed their words. Their wisdom will be passed on to you, so that it will not be lost to time as so much was here.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81924;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (449002,81924,0,0,0,221935,1,0,1,'Guardian of Feralas',70959),
(449003,81924,0,1,1,221933,1,0,1,'Guardian of the Hinterlands',70959),
(449004,81924,0,2,2,221928,1,0,1,'Guardian of Azshara',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81924;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81924,0,1024,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81924;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81924,14500,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81924;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81924,50,40,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81924;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81924,2,50);
DELETE FROM `creature_queststarter` WHERE `quest`=81924;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81924;
DELETE FROM `creature_questender` WHERE `quest`=81924;
DELETE FROM `gameobject_questender` WHERE `quest`=81924;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221985,81924,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221985,81924,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221985);
UPDATE `creature_template` SET `faction`=12 WHERE `entry`=221575;
UPDATE `creature_template` SET `faction`=35 WHERE `entry` IN (221985,215643);
UPDATE `creature_template` SET `npcflag`=`npcflag`|1 WHERE `entry`=221575;

-- from Karrz 2026_11_21_12_world_forever_eg_live_quests_9.sql
DELETE FROM `quest_template` WHERE `ID`=81786;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81786,2,47,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Hinterlands Mission I: Defeat Moonkin','Defeat 20 Fallen Moonkin in the Hinterlands Nightmare Incursion at Skulk Rock and return to Field Captain Korlian.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Seradane, and journey to the Nightmare Incursion at Skulk Rock. Defeat moonkin there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81786;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448821,81786,0,0,1,221330,20,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81786;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81786,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81786;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81786,39300,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81786;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81786,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81786;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81786,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81786;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81786;
DELETE FROM `creature_questender` WHERE `quest`=81786;
DELETE FROM `gameobject_questender` WHERE `quest`=81786;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81786,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81786,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
DELETE FROM `quest_template` WHERE `ID`=81787;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81787,2,47,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Hinterlands Mission II: Defeat Giant Turtles','Defeat 20 Dreamwater Visejaw in the Hinterlands Nightmare Incursion at Shaol''watha and return to Field Captain Korlian.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Seradane, and journey to the Nightmare Incursion at Shaol''watha. Defeat giant turtles there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81787;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448822,81787,0,0,0,221328,20,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81787;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81787,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81787;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81787,39300,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81787;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81787,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81787;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81787,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81787;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81787;
DELETE FROM `creature_questender` WHERE `quest`=81787;
DELETE FROM `gameobject_questender` WHERE `quest`=81787;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81787,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81787,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
DELETE FROM `quest_template` WHERE `ID`=81788;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81788,2,47,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Hinterlands Mission III: Defeat Dragonkin','Defeat 10 Wrath Whelps and 3 Wyrmkin Starhunters in the Hinterlands Nightmare Incursion at Agol''watha and return to Field Captain Korlian.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Seradane, and journey to the Nightmare Incursion at Agol''watha. Defeat dragonkin there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81788;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448823,81788,0,0,1,221326,10,0,1,NULL,70959),
(448824,81788,0,1,2,221325,3,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81788;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81788,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81788;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81788,39300,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81788;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81788,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81788;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81788,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81788;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81788;
DELETE FROM `creature_questender` WHERE `quest`=81788;
DELETE FROM `gameobject_questender` WHERE `quest`=81788;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81788,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81788,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
DELETE FROM `quest_template` WHERE `ID`=81838;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81838,2,47,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Hinterlands Mission XIV: Defeat Doomkin','Defeat the Doomkin in the Hinterlands Nightmare Incursion on the deep ledge inside Skulk Rock and return to Field Captain Korlian.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Seradane, and journey to the Nightmare Incursion at Skulk Rock. Defeat the giant moonkin known as the Doomkin there and return to me.','','',70888);
DELETE FROM `quest_objectives` WHERE `QuestID`=81838;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448878,81838,0,0,0,221333,1,0,1,NULL,70888);
DELETE FROM `quest_template_addon` WHERE `ID`=81838;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81838,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81838;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81838,1900,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81838;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81838,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81838;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81838,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81838;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81838;
DELETE FROM `creature_questender` WHERE `quest`=81838;
DELETE FROM `gameobject_questender` WHERE `quest`=81838;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81838,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81838,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);

-- from Karrz 2026_11_21_13_world_forever_eg_live_quests_10.sql
DELETE FROM `quest_template` WHERE `ID`=95820;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (95820,2,1637,0,95821,1,1.0,0,1.0,0,0,36700160,0,0,0,18446744073709551615,'Karolek','Meet Karolek at the Kodohide Leatherworkers shop in Orgrimmar.','We have done well to create great relationships with the merchants and craftspeople of Orgrimmar. Among these excellent relationships is an orc named Karolek, a leatherworker who ensures a steady supply of hides and other useful equipment to us.

He also happens to be great at making signs!

If you''d like to get your sign made fast, I would recommend him over anyone else. Let him know I sent you.','','',70245);
DELETE FROM `quest_objectives` WHERE `QuestID`=95820;
DELETE FROM `quest_template_addon` WHERE `ID`=95820;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (95820,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=95820;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (95820,900,0);
DELETE FROM `quest_classic_level` WHERE `ID`=95820;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (95820,60,1,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=95820;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (95820,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=95820;
DELETE FROM `gameobject_queststarter` WHERE `quest`=95820;
DELETE FROM `creature_questender` WHERE `quest`=95820;
DELETE FROM `gameobject_questender` WHERE `quest`=95820;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (256388,95820,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (3365,95820,0);
DELETE FROM `quest_template` WHERE `ID`=97183;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (97183,2,-141,0,97184,6,1.0,0,1.0,0,18792,0,0,0,0,18446744073709551615,68,6,0,'Blessed Arcanite Barding','Return with the Blessed Arcanite Barding to Danitha Morr at Bandarion Keep in Tirisfal Glades.','As the barding rests on the back of the Ancient Equine Spirit, it glows white hot. The air is thick with power for a brief moment, and then the barding disappears from the back of the horse and is now secure in your backpack.

Even through the leather of your satchel, you feel the heat still coming off of the saddle. It would seem that your offering of vengeance has been accepted, and the barding has been blessed. It''s time to return to Danitha Morr at Bandarion Keep.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=97183;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (475319,97183,1,0,0,18792,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=97183;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (97183,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=97183;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (97183,24900,0);
DELETE FROM `quest_classic_level` WHERE `ID`=97183;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (97183,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=97183;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (97183,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=97183;
DELETE FROM `gameobject_queststarter` WHERE `quest`=97183;
DELETE FROM `creature_questender` WHERE `quest`=97183;
DELETE FROM `gameobject_questender` WHERE `quest`=97183;
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (246378,97183,0);
DELETE FROM `quest_template` WHERE `ID`=97184;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (97184,2,-141,0,97185,3,1.0,0,1.0,0,0,0,0,0,0,12261800583900083122,68,3,0,'The Divination Scryer','Bring an Azerothian Diamond and a Pristine Black Diamond to Danitha Morr at Bandarion Keep in Tirisfal Glades.','We now must assemble a Divination Scryer that will be vital for your final trial. The exorcism censer you used in Terrordale is the catalyst for it, and I should be able to fashion a suitable housing for the scrying device.

The last components needed, though, are two diamonds--one white, one black. This represents the duality of our nature as paladins of The Forsaken. These two will be the beacon by which the scryer will pierce the veil between the living and the dead.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=97184;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (475322,97184,1,0,0,12800,1,0,1,NULL,70959),
(475323,97184,1,1,1,18335,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=97184;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (97184,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=97184;
DELETE FROM `quest_classic_level` WHERE `ID`=97184;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (97184,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=97184;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (97184,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=97184;
DELETE FROM `gameobject_queststarter` WHERE `quest`=97184;
DELETE FROM `creature_questender` WHERE `quest`=97184;
DELETE FROM `gameobject_questender` WHERE `quest`=97184;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (246378,97184,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (246378,97184,0);
DELETE FROM `quest_template` WHERE `ID`=97186;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (97186,2,-141,0,0,1,1.0,0,1.0,0,0,256,0,0,0,18446744073709551615,18775,1,'Manna-Enriched Horse Feed','Retrieve 20 Enriched Manna Biscuits for Nathanos Blightcaller in Eastern Plaguelands. The Argent Dawn is known as the sole purveyor of the biscuits. You''ll also need to provide Blightcaller with 50 gold for his time.','So you need feed to give to the incorporeal spirit of a horse? Interesting.

Yes, I suppose I can help you with what you need. I have spent a considerable amount of time rearing beasts that are... let''s say--no longer entirely of this world, and I know a thing or two about how to sustain them.

I simply need some of the spiritually-enriched biscuits that the Argent Dawn sells... and a small offering of gold. For my time, of course.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=97186;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (475328,97186,1,0,0,13724,20,0,1,NULL,70959),
(475329,97186,8,1,1,0,500000,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=97186;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (97186,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=97186;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (97186,-500000,0);
DELETE FROM `quest_classic_level` WHERE `ID`=97186;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (97186,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=97186;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (97186,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=97186;
DELETE FROM `gameobject_queststarter` WHERE `quest`=97186;
DELETE FROM `creature_questender` WHERE `quest`=97186;
DELETE FROM `gameobject_questender` WHERE `quest`=97186;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (11878,97186,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (11878,97186,0);
DELETE FROM `quest_template` WHERE `ID`=97412;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (97412,2,1637,81,8930,7,2.0,0,1.0,0,0,8,0,0,0,12261800583900083122,227343,1,227344,1,227345,1,'Just Compensation','Bring a Lightforge Belt and a set of Lightforge Gauntlets to Mokvar in Orgrimmar.','You''ve proven to be a very reliable individual, $n.  As much as I trust that you''ll help me through this predicament, it would be wise of me to reward you according to your performance.

For now I will exchange your belt and gloves. If we both see this through I shall make the rest of the pieces available to you.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=97412;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (475885,97412,1,0,2,16723,1,0,1,NULL,70959),
(475886,97412,1,1,3,16724,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=97412;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (97412,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=97412;
DELETE FROM `quest_classic_level` WHERE `ID`=97412;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (97412,60,58,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=97412;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (97412,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=97412;
DELETE FROM `gameobject_queststarter` WHERE `quest`=97412;
DELETE FROM `creature_questender` WHERE `quest`=97412;
DELETE FROM `gameobject_questender` WHERE `quest`=97412;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (230317,97412,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (230317,97412,0);
DELETE FROM `quest_template` WHERE `ID`=99210;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (99210,2,1,0,0,3,1.0,0,1.0,0,0,1048576,0,0,0,4,18785,1,18786,1,18787,1,47,2,0,'An Epic Ride','Inspect the armored riding rams to choose your epic mount.','Ah, hail $n! My, you''ve certainly grown since the last time you were at my humble stable, eh?

It would seem you have the experience ta be ridin'' our fiercest and fastest rams now! Ah, I''m proud of ye.

So, you have an important choice to make. You and yer ram will traverse the world together so choose wisely! Not to worry, whatever choice you make will be the right one.

Go see the armored rams and return to me when you''ve made yer choice.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=99210;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (479625,99210,3,0,0,276737,1,0,1,'Swift Gray Ram',70959),
(479626,99210,3,1,1,276779,1,0,1,'Swift Brown Ram',70959),
(479627,99210,3,2,2,276783,1,0,1,'Swift White Ram',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=99210;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (99210,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=99210;
DELETE FROM `quest_classic_level` WHERE `ID`=99210;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (99210,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=99210;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (99210,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=99210;
DELETE FROM `gameobject_queststarter` WHERE `quest`=99210;
DELETE FROM `creature_questender` WHERE `quest`=99210;
DELETE FROM `gameobject_questender` WHERE `quest`=99210;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (1261,99210,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (1261,99210,0);
DELETE FROM `quest_template` WHERE `ID`=99211;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (99211,2,85,0,0,0,1.0,0,1.0,0,0,1048576,0,0,0,16,274799,1,13334,1,18791,1,68,2,0,'An Epic Ride','Inspect the armored undead riding warhorses to choose your epic mount.','Greetings, $n. I didn''t expect to see you back to my humble stables again so soon.

You certainly have had quite a journey. I think I can guess what has brought you here today.

You now have enough power, experience and skill to ride our deftest and most fearsome warhorses. These armored fiends will bear you through any trial, even past the gates of death itself. 

Go examine the armored undead warhorses and return to me when you have made your choice.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=99211;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (479628,99211,3,0,1,276793,1,0,1,'Ochre Skeletal Warhorse',70959),
(479629,99211,3,1,2,276797,1,0,1,'Purple Skeletal Warhorse',70959),
(479630,99211,3,2,3,276796,1,0,1,'Green Skeletal Warhorse',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=99211;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (99211,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=99211;
DELETE FROM `quest_classic_level` WHERE `ID`=99211;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (99211,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=99211;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (99211,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=99211;
DELETE FROM `gameobject_queststarter` WHERE `quest`=99211;
DELETE FROM `creature_questender` WHERE `quest`=99211;
DELETE FROM `gameobject_questender` WHERE `quest`=99211;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (4731,99211,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (4731,99211,0);
DELETE FROM `quest_template` WHERE `ID`=99214;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (99214,2,1657,0,0,3,1.0,0,1.0,0,0,1048576,0,0,0,8,18902,1,18767,1,18766,1,69,2,0,'An Epic Ride','Inspect the armored riding sabers to choose your epic mount.','Greetings, friend! I am pleased to see you again. Today you have enough experience and aptitude to bond with our fastest and fiercest sabers.

These sabers are, of course, extremely intelligent and fiercely loyal to their bonded rider. You won''t find a more noble and steadfast companion.

As such, you have an important choice to make. You and your saber will traverse the world together, so choose wisely!

Go, examine the armored sabers and return to me when you have made your choice.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=99214;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (479641,99214,3,0,4,276730,1,0,1,'Swift Stormsaber',70959),
(479642,99214,3,1,5,276731,1,0,1,'Swift Mistsaber',70959),
(479643,99214,3,2,6,276732,1,0,1,'Swift Frostsaber',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=99214;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (99214,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=99214;
DELETE FROM `quest_classic_level` WHERE `ID`=99214;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (99214,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=99214;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (99214,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=99214;
DELETE FROM `gameobject_queststarter` WHERE `quest`=99214;
DELETE FROM `creature_questender` WHERE `quest`=99214;
DELETE FROM `gameobject_questender` WHERE `quest`=99214;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (4730,99214,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (4730,99214,0);
DELETE FROM `quest_template` WHERE `ID`=99215;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (99215,2,1637,0,0,0,1.0,0,1.0,0,0,1048576,0,0,0,2,18797,1,18796,1,18798,1,76,2,0,'An Epic Ride','Inspect the armored riding wolves to choose your epic mount.','Lok-tar, $n. It is good to see you again. 
 
As you know, there is no stronger bond than that of an orc and their wolf, and now you have enough experience to handle and ride our fiercest and fastest wolves. 
 
Many of these fine wolves remember you from the last time you were here and have grown since you first met. They are stronger, faster and braver than before, much like yourself. 

Go and find which armored wolf speaks to you. Return to me when you have your answer.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=99215;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (479644,99215,3,0,1,276833,1,0,1,'Swift Brown Wolf',70959),
(479645,99215,3,1,2,276805,1,0,1,'Swift Gray Wolf',70959),
(479646,99215,3,2,3,276832,1,0,1,'Swift Timber Wolf',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=99215;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (99215,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=99215;
DELETE FROM `quest_classic_level` WHERE `ID`=99215;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (99215,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=99215;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (99215,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=99215;
DELETE FROM `gameobject_queststarter` WHERE `quest`=99215;
DELETE FROM `creature_questender` WHERE `quest`=99215;
DELETE FROM `gameobject_questender` WHERE `quest`=99215;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (3362,99215,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (3362,99215,0);
DELETE FROM `quest_template` WHERE `ID`=99217;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (99217,2,215,0,0,0,1.0,0,1.0,0,0,1048576,0,0,0,32,18795,1,18794,1,18793,1,81,2,0,'An Epic Ride','Inspect the armored riding kodos to choose your epic mount.','Ah, I''ve been expecting you $n. It would seem the winds have brought you to me once again, so you may ride our fastest and strongest kodos.

Today, I am proud to present to you your next kodo. Much like yourself, each has grown stronger and faster since you last met.

You and your kodo will travel the world together just like before, so find which one speaks to you.

Go examine the armored kodos and return to me when you have made your choice.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=99217;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (479650,99217,3,0,0,276877,1,0,1,'Great Gray Kodo',70959),
(479651,99217,3,1,1,276876,1,0,1,'Great Brown Kodo',70959),
(479652,99217,3,2,2,276879,1,0,1,'Great White Kodo',70959);
DELETE FROM `quest_template_addon` WHERE `ID`=99217;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (99217,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=99217;
DELETE FROM `quest_classic_level` WHERE `ID`=99217;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (99217,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=99217;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (99217,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=99217;
DELETE FROM `gameobject_queststarter` WHERE `quest`=99217;
DELETE FROM `creature_questender` WHERE `quest`=99217;
DELETE FROM `gameobject_questender` WHERE `quest`=99217;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (3685,99217,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (3685,99217,0);
DELETE FROM `quest_template` WHERE `ID`=99234;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (99234,2,3217,41,0,1,1.0,0,1.0,0,277558,0,1,0,0,18446744073709551615,'Brawl at the Maul','Speak with Griniblix the Spectator above the Maul in Dire Maul.','There must be more to the Maul than this!

Perhaps the loud Spectator who oversees the event at Dire Maul will know!','','',70938);
DELETE FROM `quest_objectives` WHERE `QuestID`=99234;
DELETE FROM `quest_template_addon` WHERE `ID`=99234;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (99234,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=99234;
DELETE FROM `quest_classic_level` WHERE `ID`=99234;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (99234,60,55,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=99234;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (99234,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=99234;
DELETE FROM `gameobject_queststarter` WHERE `quest`=99234;
DELETE FROM `creature_questender` WHERE `quest`=99234;
DELETE FROM `gameobject_questender` WHERE `quest`=99234;
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (14395,99234,0);

-- from Karrz 2026_11_21_14_world_forever_wowhead_feralas_missions.sql
DELETE FROM `creature_template` WHERE `entry`=221480;
DELETE FROM `creature_template_difficulty` WHERE `DifficultyID`=0 AND `Entry`=221480;
DELETE FROM `creature_template_model` WHERE `CreatureID`=221480;
DELETE FROM `creature_classic_level` WHERE `entry`=221480;
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(221480,0,0,'Field Captain Arunnel',NULL,NULL,NULL,NULL,0,0,35,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(221480,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(221480,0,1707,1.0,1.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(221480,50,50);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47600441,221480,1,0,0,'0',0,0,0,-1,0,0,-2940.53,2079.35,30.262,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1);
DELETE FROM `quest_template` WHERE `ID`=81855;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81855,2,357,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Feralas Mission I: Defeat Children of Cenarius','Defeat 10 Lost Daughters and 10 Vengeful Sons in the Feralas Nightmare Incursion at the Twin Colossals and return to Field Captain Arunnel.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Dream Bough, and journey to the Nightmare Incursion at the Twin Colossals. Defeat maddened sons and daughters of Cenarius there and return to me.','','',70888);
DELETE FROM `quest_objectives` WHERE `QuestID`=81855;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448899,81855,0,0,0,221375,10,0,1,NULL,70888),
(448900,81855,0,1,2,221377,10,0,1,NULL,70888);
DELETE FROM `quest_template_addon` WHERE `ID`=81855;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81855,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81855;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81855,39300,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81855;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81855,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81855;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81855,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81855;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81855;
DELETE FROM `creature_questender` WHERE `quest`=81855;
DELETE FROM `gameobject_questender` WHERE `quest`=81855;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81855,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81855,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);
DELETE FROM `quest_template` WHERE `ID`=81856;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81856,2,357,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Feralas Mission II: Defeat Harpies','Defeat 10 Dreamspring Roguefeathers and 10 Dreamspring Stormcallers in the Feralas Nightmare Incursion at the Ruins of Ravenwind and return to Field Captain Arunnel.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Dream Bough, and journey to the Nightmare Incursion at the Ruins of Ravenwind. Defeat harpies there and return to me.','','',70888);
DELETE FROM `quest_objectives` WHERE `QuestID`=81856;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448901,81856,0,0,1,221370,10,0,1,NULL,70888),
(448902,81856,0,1,3,221371,10,0,1,NULL,70888);
DELETE FROM `quest_template_addon` WHERE `ID`=81856;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81856,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81856;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81856,39300,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81856;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81856,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81856;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81856,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81856;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81856;
DELETE FROM `creature_questender` WHERE `quest`=81856;
DELETE FROM `gameobject_questender` WHERE `quest`=81856;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81856,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81856,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);
DELETE FROM `quest_template` WHERE `ID`=81857;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81857,2,357,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Feralas Mission III: Defeat Dragonkin','Defeat 10 Frenzied Whelps and 3 Wyrmkin Berserkers in the Feralas Nightmare Incursion at Oneiros and return to Field Captain Arunnel.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Dream Bough, and journey to the Nightmare Incursion at Oneiros. Defeat dragonkin there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81857;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448903,81857,0,0,0,221369,10,0,1,NULL,70959),
(448904,81857,0,1,2,221367,3,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81857;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81857,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81857;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81857,39300,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81857;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81857,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81857;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81857,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81857;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81857;
DELETE FROM `creature_questender` WHERE `quest`=81857;
DELETE FROM `gameobject_questender` WHERE `quest`=81857;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81857,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81857,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);

-- from Karrz 2026_11_21_22_world_forever_wowhead_incursion_bosses.sql
DELETE FROM `creature_template` WHERE `entry` IN (221204,221206,221207,221331,221334,221391,221393);
DELETE FROM `creature_template_difficulty` WHERE `DifficultyID`=0 AND `Entry` IN (221204,221206,221207,221331,221334,221391,221393);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (221204,221206,221207,221331,221334,221391,221393);
DELETE FROM `creature_classic_level` WHERE `entry` IN (221204,221206,221207,221331,221334,221391,221393);
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(221204,0,0,'Ylanthrius',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221206,0,0,'Vvarc'' Zul',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221207,0,0,'Amokarok',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221331,0,0,'Florius',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221334,0,0,'Ghamoo-Raja',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221391,0,0,'Slirena',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221393,0,0,'Tyrannikus',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(221204,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221206,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221207,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221331,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221334,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221391,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221393,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(221204,0,2717,1.0,1.0,-1),
(221206,0,14423,1.0,1.0,-1),
(221207,0,11181,1.0,1.0,-1),
(221331,0,2717,1.0,1.0,-1),
(221334,0,119778,1.0,1.0,-1),
(221391,0,10871,1.0,1.0,-1),
(221393,0,2717,1.0,1.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(221204,28,28),
(221206,28,28),
(221207,28,28),
(221331,53,53),
(221334,53,53),
(221391,53,53),
(221393,53,53);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47600450,221204,0,0,0,'0',0,0,0,-1,0,0,-10944.30,-360.10,39.76,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600451,221204,0,0,0,'0',0,0,0,-1,0,0,-10998.30,-360.10,42.66,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600452,221204,0,0,0,'0',0,0,0,-1,0,0,-11077.50,-360.10,43.33,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600453,221206,0,0,0,'0',0,0,0,-1,0,0,-11199.90,-165.60,90.66,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600454,221206,0,0,0,'0',0,0,0,-1,0,0,-11217.90,-165.60,96.89,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600455,221206,0,0,0,'0',0,0,0,-1,0,0,-11232.30,-176.40,91.49,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600456,221207,0,0,0,'0',0,0,0,-1,0,0,-11066.70,-932.50,63.71,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600457,221207,0,0,0,'0',0,0,0,-1,0,0,-11070.30,-937.90,63.55,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600458,221207,0,0,0,'0',0,0,0,-1,0,0,-11091.90,-948.70,65.35,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600468,221331,0,0,0,'0',0,0,0,-1,0,0,476.00,-3324.30,121.05,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600469,221331,0,0,0,'0',0,0,0,-1,0,0,455.50,-3339.70,119.88,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600470,221331,0,0,0,'0',0,0,0,-1,0,0,445.20,-3347.40,119.17,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600471,221334,0,0,0,'0',0,0,0,-1,0,0,799.50,-4001.20,95.38,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600472,221334,0,0,0,'0',0,0,0,-1,0,0,758.40,-4008.90,92.92,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600473,221334,0,0,0,'0',0,0,0,-1,0,0,763.50,-4016.60,93.42,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600474,221391,1,0,0,'0',0,0,0,-1,0,0,-2968.30,2774.90,52.12,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600475,221391,1,0,0,'0',0,0,0,-1,0,0,-3042.50,2747.10,58.34,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600476,221391,1,0,0,'0',0,0,0,-1,0,0,-2986.90,2733.20,51.00,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600479,221393,1,0,0,'0',0,0,0,-1,0,0,-3033.20,1801.10,12.80,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1);
DELETE FROM `quest_template` WHERE `ID`=81742;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81742,2,10,1,0,5,2.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,7,0,'Duskwood Mission XIII: Defeat Ylanthrius','Defeat Ylanthrius in the Duskwood Nightmare Incursion at the Yorgen Farmstead field and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Yorgen Farmstead. Defeat the dragon Ylanthrius there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81742;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448730,81742,0,0,1,221204,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81742;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81742,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81742;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81742,3400,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81742;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81742,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81742;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81742,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81742;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81742;
DELETE FROM `creature_questender` WHERE `quest`=81742;
DELETE FROM `gameobject_questender` WHERE `quest`=81742;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81742,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81742,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81743;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81743,2,10,1,0,5,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission XIV: Defeat Vvarc''zul','Defeat Vvarc''zul in the Duskwood Nightmare Incursion deep in the Vul''gol Ogre Mound and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Vul''gol Ogre Mound. Defeat the ogre warlord Vvarc''zul there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81743;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448731,81743,0,0,0,221206,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81743;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81743,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81743;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81743,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81743;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81743,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81743;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81743,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81743;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81743;
DELETE FROM `creature_questender` WHERE `quest`=81743;
DELETE FROM `gameobject_questender` WHERE `quest`=81743;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81743,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81743,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81744;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81744,2,10,1,0,5,1.0,0,1.0,0,0,4352,0,0,0,18446744073709551615,2641,4,0,'Duskwood Mission XV: Defeat Amokarok','Defeat Amokarok in the Duskwood Nightmare Incursion at a campsite near the barn in the Rotting Orchard and return to Field Captain Palandar.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in the Twilight Grove, and journey to the Nightmare Incursion at the Rotting Orchard. Defeat the worgen leader Amokarok there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81744;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448736,81744,0,0,1,221207,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81744;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81744,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81744;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81744,1700,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81744;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81744,27,23,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81744;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81744,2,27);
DELETE FROM `creature_queststarter` WHERE `quest`=81744;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81744;
DELETE FROM `creature_questender` WHERE `quest`=81744;
DELETE FROM `gameobject_questender` WHERE `quest`=81744;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81744,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221471,81744,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
DELETE FROM `quest_template` WHERE `ID`=81837;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81837,2,47,1,0,5,2.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,7,0,'Hinterlands Mission XIII: Defeat Florius','Defeat Florius in the Hinterlands Nightmare Incursion at the main courtyard in Agol''watha and return to Field Captain Korlian.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Seradane, and journey to the Nightmare Incursion in Agol''watha. Defeat the dragon Florius there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81837;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448877,81837,0,0,1,221331,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81837;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81837,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81837;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81837,3800,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81837;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81837,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81837;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81837,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81837;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81837;
DELETE FROM `creature_questender` WHERE `quest`=81837;
DELETE FROM `gameobject_questender` WHERE `quest`=81837;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81837,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81837,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
DELETE FROM `quest_template` WHERE `ID`=81839;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81839,2,47,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Hinterlands Mission XV: Defeat Ghamoo-Raja','Defeat Ghamoo-Raja in the Hinterlands Nightmare Incursion in the courtyard at Shaol''watha and return to Field Captain Korlian.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Seradane, and journey to the Nightmare Incursion at Shaol''watha. Defeat the turtle "king" known as Ghamoo-Raja there and return to me.','','',70888);
DELETE FROM `quest_objectives` WHERE `QuestID`=81839;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448882,81839,0,0,1,221334,1,0,1,NULL,70888);
DELETE FROM `quest_template_addon` WHERE `ID`=81839;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81839,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81839;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81839,1900,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81839;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81839,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81839;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81839,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81839;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81839;
DELETE FROM `creature_questender` WHERE `quest`=81839;
DELETE FROM `gameobject_questender` WHERE `quest`=81839;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81839,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221479,81839,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
DELETE FROM `quest_template` WHERE `ID`=81868;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81868,2,357,1,0,5,2.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,7,0,'Feralas Mission XIII: Defeat Tyrannikus','Defeat Tyrannikus in the Feralas Nightmare Incursion at the ruined temple in Oneiros and return to Field Captain Arunnel.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Dream Bough, and journey to the Nightmare Incursion in Oneiros. Defeat the dragon Tyrannikus there and return to me.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=81868;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448927,81868,0,0,0,221393,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=81868;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81868,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81868;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81868,3800,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81868;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81868,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81868;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81868,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81868;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81868;
DELETE FROM `creature_questender` WHERE `quest`=81868;
DELETE FROM `gameobject_questender` WHERE `quest`=81868;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81868,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81868,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);
DELETE FROM `quest_template` WHERE `ID`=81871;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (81871,2,357,1,0,5,1.0,0,1.0,446536,0,4352,0,0,0,18446744073709551615,219927,1,2641,6,0,'Feralas Mission XV: Defeat Slirena','Defeat Slirena in the Feralas Nightmare Incursion near the ziggurat in the Ruins of Ravenwind and return to Field Captain Arunnel.','While these demons distract us here, the Emerald Dream is being corrupted into nightmare. Quick, travel through the Emerald Dream Portal in Dream Bough, and journey to the Nightmare Incursion at the Ruins of Ravenwind. Defeat the harpy "queen" Slirena there and return to me.','','',70888);
DELETE FROM `quest_objectives` WHERE `QuestID`=81871;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (448931,81871,0,0,0,221391,1,0,1,NULL,70888);
DELETE FROM `quest_template_addon` WHERE `ID`=81871;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (81871,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=81871;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (81871,1900,0);
DELETE FROM `quest_classic_level` WHERE `ID`=81871;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (81871,52,47,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=81871;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (81871,2,52);
DELETE FROM `creature_queststarter` WHERE `quest`=81871;
DELETE FROM `gameobject_queststarter` WHERE `quest`=81871;
DELETE FROM `creature_questender` WHERE `quest`=81871;
DELETE FROM `gameobject_questender` WHERE `quest`=81871;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81871,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (221480,81871,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);

-- from Karrz 2026_11_21_23_world_forever_wowhead_quest_objects_2.sql
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`size`,`VerifiedBuild`)
SELECT 409311,2,5812,'Spear of Mannoroth',1,-1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=409311);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`)
SELECT s.g,409311,s.m,0,0,'0',0,0,0,-1,s.x,s.y,s.z,0,0,0,0,1,120,255,1,'',NULL,-1 FROM (SELECT 47501100 AS g,1 AS m,1709.40 AS x,-3455.40 AS y,144.30 AS z UNION ALL SELECT 47501101 AS g,1 AS m,1713.20 AS x,-3461.20 AS y,144.10 AS z) s
 WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id`=409311 AND `guid` NOT BETWEEN 47501100 AND 47501199);
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`size`,`VerifiedBuild`)
SELECT 456682,2,94376,'Half-Buried Mech',1,-1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=456682);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`)
SELECT s.g,456682,s.m,0,0,'0',0,0,0,-1,s.x,s.y,s.z,0,0,0,0,1,120,255,1,'',NULL,-1 FROM (SELECT 47501104 AS g,1 AS m,-10083.60 AS x,-4303.70 AS y,0.48 AS z UNION ALL SELECT 47501105 AS g,1 AS m,-10079.00 AS x,-4310.60 AS y,0.48 AS z) s
 WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id`=456682 AND `guid` NOT BETWEEN 47501100 AND 47501199);
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`size`,`VerifiedBuild`)
SELECT 456685,2,3078,'Access Hatch',1,-1 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=456685);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`)
SELECT s.g,456685,s.m,0,0,'0',0,0,0,-1,s.x,s.y,s.z,0,0,0,0,1,120,255,1,'',NULL,-1 FROM (SELECT 47501106 AS g,1 AS m,-10083.60 AS x,-4303.70 AS y,0.48 AS z UNION ALL SELECT 47501107 AS g,1 AS m,-10079.00 AS x,-4310.60 AS y,0.48 AS z) s
 WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id`=456685 AND `guid` NOT BETWEEN 47501100 AND 47501199);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`)
SELECT s.g,642517,s.m,0,0,'0',0,0,0,-1,s.x,s.y,s.z,0,0,0,0,1,30,255,1,'',NULL,-1 FROM (SELECT 47501128 AS g,0 AS m,-9166.50 AS x,-4879.30 AS y,84.65 AS z) s
 WHERE NOT EXISTS (SELECT 1 FROM `gameobject` WHERE `id`=642517 AND `guid` NOT BETWEEN 47501100 AND 47501199);

-- from Karrz 2026_11_21_24_world_forever_eg_live_quests_11.sql
DELETE FROM `quest_template` WHERE `ID`=78092;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (78092,2,-141,0,78093,6,1.0,0,1.0,423561,209748,33554432,0,0,0,6130900294268439629,'It Must Be Destroyed','Gather 12 Motes of Mannoroth from demons in Ashenvale. Bring them along with the Orb of Althalaxx to the Spear of Mannoroth at Demon Fall Canyon.','The tendrils of sentience reaching out from this orb are too much for even an experienced warlock like myself to withstand for long. I am reluctant to admit this, $n, but the orb must be destroyed.

The orb is nearly impervious, but it may be vulnerable to the weapon of a powerful demon lord. I have heard that such a blade is present in Ashenvale--at the site where the pit lord Mannoroth was destroyed.

Gather motes of the fallen demon''s essence there, then shatter the orb upon the blade.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=78092;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (443906,78092,1,0,0,209779,12,0,1,NULL,70959),
(443907,78092,1,1,1,209748,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=78092;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (78092,0,2,78091);
DELETE FROM `quest_classic_money` WHERE `ID`=78092;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (78092,5500,0);
DELETE FROM `quest_classic_level` WHERE `ID`=78092;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (78092,30,22,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=78092;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (78092,2,30);
DELETE FROM `creature_queststarter` WHERE `quest`=78092;
DELETE FROM `gameobject_queststarter` WHERE `quest`=78092;
DELETE FROM `creature_questender` WHERE `quest`=78092;
DELETE FROM `gameobject_questender` WHERE `quest`=78092;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (5495,78092,0);
INSERT IGNORE INTO `gameobject_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (409311,78092,0);
DELETE FROM `quest_template` WHERE `ID`=79242;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (79242,2,405,0,0,6,1.0,0,1.0,0,0,33554432,0,0,0,18446744073709551615,277208,1,277223,1,277235,1,'No Honor Among Thieves','Find Illari Duskfeather on the coast of Arathi Highlands, and get access to her cache of stolen loot.','As I was saying...

Our boss wasn''t with the Horde. She was a night elf named Illari Duskfeather. She gave us intel on the camps, and even let us keep most of the loot. She only kept a few of the rarer finds.

Once the marshal was on our tail, though, she left us for dead. I don''t know her motives, but I think we were set up as patsies.

I''m not the vengeful type, but I won''t stop someone else from hunting her down. If you''re looking for her, she once mentioned a hideout on the coast of Arathi.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=79242;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (445980,79242,3,0,1,215655,1,0,1,'Found Illari Duskfeather',70959),
(445876,79242,1,1,0,212347,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=79242;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (79242,0,0,79236);
DELETE FROM `quest_classic_money` WHERE `ID`=79242;
INSERT IGNORE INTO `quest_classic_money` (`ID`,`RewardMoney`,`RewardMoneyMaxLevel`) VALUES (79242,10000,0);
DELETE FROM `quest_classic_level` WHERE `ID`=79242;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (79242,40,30,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=79242;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (79242,2,40);
DELETE FROM `creature_queststarter` WHERE `quest`=79242;
DELETE FROM `gameobject_queststarter` WHERE `quest`=79242;
DELETE FROM `creature_questender` WHERE `quest`=79242;
DELETE FROM `gameobject_questender` WHERE `quest`=79242;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (215643,79242,0);
INSERT IGNORE INTO `gameobject_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (418855,79242,0);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (215643);
DELETE FROM `quest_template` WHERE `ID`=84135;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (84135,2,987,0,0,2,1.0,0,1.0,0,0,35652096,0,0,0,18446744073709551615,'Beach Bot','Use a rock or something to dislodge parts of the mech.','Lying on the shore, half-lost in the afternoon spray, is a strange metal contraption. It looks like some kind of mech, but you have never seen anything like it before. You notice a label on its side that reads "Property of D.E.L.T.A.: Deepsea Exploration and Liquefaction Technologies Alliance". You also spot a small compartment that you might be able to open.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=84135;
DELETE FROM `quest_template_addon` WHERE `ID`=84135;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (84135,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=84135;
DELETE FROM `quest_classic_level` WHERE `ID`=84135;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (84135,60,55,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=84135;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (84135,2,60);
DELETE FROM `creature_queststarter` WHERE `quest`=84135;
DELETE FROM `gameobject_queststarter` WHERE `quest`=84135;
DELETE FROM `creature_questender` WHERE `quest`=84135;
DELETE FROM `gameobject_questender` WHERE `quest`=84135;
INSERT IGNORE INTO `gameobject_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (456682,84135,0);
INSERT IGNORE INTO `gameobject_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (456685,84135,0);
DELETE FROM `quest_template` WHERE `ID`=95615;
INSERT IGNORE INTO `quest_template` (`ID`,`QuestType`,`QuestSortID`,`QuestInfoID`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardSpell`,`StartItem`,`Flags`,`FlagsEx`,`FlagsEx2`,`TimeAllowed`,`AllowableRaces`,`RewardItem1`,`RewardAmount1`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`QuestCompletionLog`,`VerifiedBuild`) VALUES (95615,2,16591,0,0,4,1.0,0,1.0,0,269997,36700160,0,0,0,6130900294268439629,274918,1,274915,1,274916,1,2826,3,0,'In Memoriam','Place $1oa Memorial Candles on graves in the chapel graveyard for Sister Rowland at Farholde Keep.','If you don''t mind, I''d like you to do the honor of lighting these memorial candles. Go to the cemetery just outside and place a fresh candle wherever you see one that''s gone out.

Such a task is a far cry from the excitement of your other adventures, I''m sure. Think of this as an opportunity for service and reflection--a quiet moment to acknowledge those who left this world before us, so that we might carry on and make it a better place.','','',70959);
DELETE FROM `quest_objectives` WHERE `QuestID`=95615;
INSERT IGNORE INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`Flags`,`Visible`,`Description`,`VerifiedBuild`) VALUES (471055,95615,2,0,1,642517,3,0,1,'Candles replaced',70959),
(472117,95615,1,1,0,269997,1,0,1,NULL,70959);
DELETE FROM `quest_template_addon` WHERE `ID`=95615;
INSERT IGNORE INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`PrevQuestID`) VALUES (95615,0,0,0);
DELETE FROM `quest_classic_money` WHERE `ID`=95615;
DELETE FROM `quest_classic_level` WHERE `ID`=95615;
INSERT IGNORE INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (95615,38,36,0);
DELETE FROM `quest_template_classic_level` WHERE `ID`=95615;
INSERT IGNORE INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (95615,2,38);
DELETE FROM `creature_queststarter` WHERE `quest`=95615;
DELETE FROM `gameobject_queststarter` WHERE `quest`=95615;
DELETE FROM `creature_questender` WHERE `quest`=95615;
DELETE FROM `gameobject_questender` WHERE `quest`=95615;
INSERT IGNORE INTO `creature_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES (262031,95615,0);
INSERT IGNORE INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES (262031,95615,0);

-- from Karrz 2026_11_21_68_world_forever_riverglades_spawns_on_the_ground.sql
UPDATE `gameobject` SET `position_z` = 81.25 WHERE `guid` = 47501128 AND `id` = 642517;

-- Zan Shivsproket ends Best Laid Plans and starts One Last Drop, but was a vendor only.
UPDATE `creature_template` SET `npcflag` = `npcflag` | 2 WHERE `entry` = 6777;

-- Mason Connery (Alcaz Prison, quest 96335) in his ball and chain beyond the dragon (Karrz 2026_11_14_41).
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(48120078,264770,2994,0,0,'1,201',0,0,0,-1,0,0,-8890,2990,6.2,4.712,7200,0,0,100,0,NULL,NULL,NULL,NULL,'',NULL,0);

-- Model sizes for the new NPCs' displays, which have no creature_model_info row (without one the spawn is dropped at load).
-- No sniff has them: Karrz's sizes (2026_11_21_78, 2026_11_20_86), a human-sized 0.306 / 1.5 where he had none (119778). ESTIMATED.
INSERT IGNORE INTO `creature_model_info` (`DisplayID`, `BoundingRadius`, `CombatReach`, `DisplayID_Other_Gender`, `VerifiedBuild`) VALUES
(116412, 0.306, 1.5, 0, 0),  -- Tokal 215643
(118567, 0.306, 1.5, 0, 0),  -- Demented Fire Weaver 221175
(118584, 0.5, 2.0, 0, 0),    -- Wyrmkin Terrorwalker 221200, Starhunter 221325 (dragonkin)
(118604, 0.75, 2.25, 0, 0),  -- Doomkin 221333 (owlbeast)
(118686, 0.306, 1.5, 0, 0),  -- Elrick 221575
(118930, 0.306, 1.5, 0, 0),  -- Tyrisius 221985
(119778, 0.306, 1.5, 0, 0),  -- 221334
(121693, 0.306, 1.5, 0, 0),  -- Orthas 228619
(144257, 0.306, 1.5, 0, 0);  -- Mason Connery 264770

-- Everlake: An Epic Ride (99214 Night Elf, 99217 Tauren) asks the player to talk to the three mounts on show, but the sabers
-- and kodos had no gossip flag (the rams, wolves and skeletal horses of the other races' versions have it), so they could not
-- be spoken to and the objectives never completed. Karrz's data leaves them as they are.
UPDATE `creature_template` SET `npcflag` = `npcflag` | 1 WHERE `entry` IN (276730, 276731, 276732, 276876, 276877, 276879);
