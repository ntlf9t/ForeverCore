-- Classic 1.60 (WoW Forever): the Forsaken paladin's epic mount chain (Danitha Morr, Bandarion Keep) could not be finished.
-- The 70959 sniff has the chain's quests up to The Divination Scryer (97184) but not An Offering of Vengeance (97182) or the
-- last quest, Justice and Retribution (97185), which teaches Summon Forsaken Charger (1296534); and the sniffed tail had no
-- class, no order and no giver for Blessed Arcanite Barding (97183).
-- Built from Wowhead Forever and Efficient Games (https://efficient.games, CC BY 4.0): titles, texts, givers, objectives,
-- provided items, Undercity +200 and the reward spell; XP, money and every other field as the Alliance quests they mirror,
-- Ancient Equine Spirit (7643) and Judgment and Redemption (7647), whose rewards match (9,900 / 19,900 XP at 60, 1g 48s 50c /
-- 2g 98s 50c). 97185 teaches the mount through 1296537 (Learn Spell 1296534), as 7647 does through 23215.
-- INFERRED: the objective ids (live ids unknown; numbered like 7643's and 7647's), PrevQuestIDs and the class (the chain is the
-- paladin's, Wowhead and EG say Paladin), and no reward or progress text for 97182 and 97185 (none known).
-- Death Knight Darkreaver (14516) dropped Charger's Lost Soul for 4% of kills (276784, a Wowhead rate over all kills) or 15%
-- (18749, Alliance, VMaNGOS): a quest item for the one paladin who summoned him now always drops for whoever has the quest.
-- Safe to run again.
DELETE FROM `quest_template` WHERE `ID` IN (97182, 97185);
INSERT INTO `quest_template` (`ID`,`QuestType`,`QuestPackageID`,`ContentTuningID`,`QuestSortID`,`QuestInfoID`,`SuggestedGroupNum`,`RewardNextQuest`,`RewardXPDifficulty`,`RewardXPMultiplier`,`RewardMoneyDifficulty`,`RewardMoneyMultiplier`,`RewardBonusMoney`,`RewardDisplaySpell1`,`RewardDisplaySpell2`,`RewardDisplaySpell3`,`RewardSpell`,`RewardHonor`,`RewardKillHonor`,`StartItem`,`RewardArtifactXPDifficulty`,`RewardArtifactXPMultiplier`,`RewardArtifactCategoryID`,`Flags`,`FlagsEx`,`FlagsEx2`,`FlagsEx3`,`RewardItem1`,`RewardAmount1`,`RewardItem2`,`RewardAmount2`,`RewardItem3`,`RewardAmount3`,`RewardItem4`,`RewardAmount4`,`ItemDrop1`,`ItemDropQuantity1`,`ItemDrop2`,`ItemDropQuantity2`,`ItemDrop3`,`ItemDropQuantity3`,`ItemDrop4`,`ItemDropQuantity4`,`RewardChoiceItemID1`,`RewardChoiceItemQuantity1`,`RewardChoiceItemDisplayID1`,`RewardChoiceItemID2`,`RewardChoiceItemQuantity2`,`RewardChoiceItemDisplayID2`,`RewardChoiceItemID3`,`RewardChoiceItemQuantity3`,`RewardChoiceItemDisplayID3`,`RewardChoiceItemID4`,`RewardChoiceItemQuantity4`,`RewardChoiceItemDisplayID4`,`RewardChoiceItemID5`,`RewardChoiceItemQuantity5`,`RewardChoiceItemDisplayID5`,`RewardChoiceItemID6`,`RewardChoiceItemQuantity6`,`RewardChoiceItemDisplayID6`,`POIContinent`,`POIx`,`POIy`,`POIPriority`,`RewardTitle`,`RewardArenaPoints`,`RewardSkillLineID`,`RewardNumSkillUps`,`PortraitGiver`,`PortraitGiverMount`,`PortraitGiverModelSceneID`,`PortraitTurnIn`,`RewardFactionID1`,`RewardFactionValue1`,`RewardFactionOverride1`,`RewardFactionCapIn1`,`RewardFactionID2`,`RewardFactionValue2`,`RewardFactionOverride2`,`RewardFactionCapIn2`,`RewardFactionID3`,`RewardFactionValue3`,`RewardFactionOverride3`,`RewardFactionCapIn3`,`RewardFactionID4`,`RewardFactionValue4`,`RewardFactionOverride4`,`RewardFactionCapIn4`,`RewardFactionID5`,`RewardFactionValue5`,`RewardFactionOverride5`,`RewardFactionCapIn5`,`RewardFactionFlags`,`RewardCurrencyID1`,`RewardCurrencyQty1`,`RewardCurrencyID2`,`RewardCurrencyQty2`,`RewardCurrencyID3`,`RewardCurrencyQty3`,`RewardCurrencyID4`,`RewardCurrencyQty4`,`AcceptedSoundKitID`,`CompleteSoundKitID`,`AreaGroupID`,`TimeAllowed`,`AllowableRaces`,`Expansion`,`ManagedWorldStateID`,`QuestSessionBonus`,`LogTitle`,`LogDescription`,`QuestDescription`,`AreaDescription`,`PortraitGiverText`,`PortraitGiverName`,`PortraitTurnInText`,`PortraitTurnInName`,`QuestCompletionLog`,`ResetByScheduler`,`VerifiedBuild`,`RewardFavor`) VALUES
(97182,2,0,0,-141,81,0,97183,4,2,0,1,60,0,0,0,0,0,0,18753,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,7,0,0,0,7,0,0,0,7,0,0,0,7,0,0,0,7,0,0,0,0,0,0,0,0,0,890,878,0,0,12261800583900083122,0,0,0,'An Offering of Vengeance','Acquire special horse feed used for feeding a spirit horse. Nathanos Blightcaller in Eastern Plaguelands may be able to provide such a feed.$B$BTravel to the Dire Maul in Feralas and slay Tendris Warpwood. Doing so will free the Ancient Equine Spirit. Feed it the special horse feed to soothe it.$B$BLastly, give it the Arcanite Barding and hope that it is willing to provide the needed blessing.','A paladin charger''s barding requires the blessing of a powerful equine spirit. In the ruins of Dire Maul the corrupted treant known as Tendris Warpwood has such a spirit imprisoned. Seek retribution on behalf of this spirit, and free it from its bondage. With luck, it may be willing to provide its blessing.$B$BTo help ensure success, I''d also advise you to bring a special type of spiritually-attuned feed. Travel to Eastern Plaguelands and speak with the ranger known as Nathanos Blightcaller about this.','',NULL,NULL,NULL,NULL,'',0,0,0),
(97185,2,0,0,-141,81,0,0,7,2,0,1,274350,0,0,0,1296537,0,0,276785,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,276784,1,18746,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,68,0,20000,7,0,0,0,7,0,0,0,7,0,0,0,7,0,0,0,7,0,0,0,0,0,0,0,0,0,890,878,0,0,12261800583900083122,0,0,0,'Justice and Retribution','Use the Divination Scryer in the heart of the Great Ossuary''s basement in the Scholomance.  Doing so will bring forth the spirits you must judge. Defeating these spirits will summon forth Death Knight Darkreaver.  Defeat him and reclaim the lost soul of the fallen charger.$B$BGive the Spirit of Retribution and the Blessed Enchanted Barding to Darkreaver''s Fallen Charger.','In this satchel you will find the items you will need for your trial. Use the divination scryer in the heart of the Great Ossuary''s basement to bring forth accursed spirits to face justice. The power of your judgements will be extremely valuable in this battle, so use them wisely.$B$BOnce you have dispersed these spirits, Darkreaver will appear. Defeat him and claim the lost soul of the charger. Show it the path of justice and retribution that you walk and with luck, it will take its place at your side.','',NULL,NULL,NULL,NULL,'',0,0,0);

DELETE FROM `quest_objectives` WHERE `QuestID` IN (97182, 97185);
INSERT INTO `quest_objectives` (`ID`,`QuestID`,`Type`,`Order`,`StorageIndex`,`ObjectID`,`Amount`,`ConditionalAmount`,`Flags`,`Flags2`,`ProgressBarWeight`,`ParentObjectiveID`,`Visible`,`Description`,`VerifiedBuild`) VALUES
(90971824,97182,1,4,4,18753,1,0,0,0,0,0,1,'',0),
(90971825,97182,1,5,5,18775,1,0,0,0,0,0,1,'',0),
(90971854,97185,1,4,4,276783,1,0,0,0,0,0,1,'',0),
(90971855,97185,1,5,5,18792,1,0,0,0,0,0,1,'',0);

DELETE FROM `quest_classic_level` WHERE `ID` IN (97182, 97185);
INSERT INTO `quest_classic_level` (`ID`,`QuestLevel`,`MinLevel`,`MaxLevel`) VALUES (97182,60,60,0),(97185,60,60,0);
DELETE FROM `quest_template_classic_level` WHERE `ID` IN (97182, 97185);
INSERT INTO `quest_template_classic_level` (`ID`,`LevelType`,`QuestLevel`) VALUES (97182,2,60),(97185,2,60);

-- The chain in order, paladins only: Ott's Finest Work (97180, brings the barding to Danitha) -> 97182 -> 97183 -> 97184 -> 97185;
-- the horse feed (97186) while 97182 is in the log, as 7645 is for 7643.
DELETE FROM `quest_template_addon` WHERE `ID` IN (97182, 97183, 97184, 97185, 97186);
INSERT INTO `quest_template_addon` (`ID`,`MaxLevel`,`AllowableClasses`,`SourceSpellID`,`PrevQuestID`,`NextQuestID`,`ExclusiveGroup`,`BreadcrumbForQuestId`,`RewardMailTemplateID`,`RewardMailDelay`,`RequiredSkillID`,`RequiredSkillPoints`,`RequiredMinRepFaction`,`RequiredMaxRepFaction`,`RequiredMinRepValue`,`RequiredMaxRepValue`,`ProvidedItemCount`,`SpecialFlags`,`ScriptName`) VALUES
(97182,0,2,0,97180,97183,0,0,0,0,0,0,0,0,0,0,1,0,''),
(97183,0,2,0,97182,97184,0,0,0,0,0,0,0,0,0,0,1,0,''),
(97184,0,2,0,97183,97185,0,0,0,0,0,0,0,0,0,0,0,0,''),
(97185,0,2,0,97184,0,0,0,0,0,0,0,0,0,0,0,1,0,''),
(97186,0,2,0,-97182,0,0,0,0,0,0,0,0,0,0,0,0,0,'');

-- Givers: Danitha Morr (246378) gives 97182 and 97185; the Ancient Equine Spirit (14566) takes 97182 and gives 97183, as it
-- does 7643 / 7644; Darkreaver's Fallen Charger (14568) takes 97185, as it does 7647.
DELETE FROM `creature_queststarter` WHERE `quest` IN (97182, 97183, 97185);
INSERT INTO `creature_queststarter` (`id`,`quest`) VALUES (246378,97182),(14566,97183),(246378,97185);
DELETE FROM `creature_questender` WHERE `quest` IN (97182, 97185);
INSERT INTO `creature_questender` (`id`,`quest`) VALUES (14566,97182),(14568,97185);

-- Danitha's words when 97183 is handed in (Wowhead Forever's progress and completion text).
DELETE FROM `quest_request_items` WHERE `ID` = 97183;
INSERT INTO `quest_request_items` (`ID`,`EmoteOnComplete`,`EmoteOnIncomplete`,`EmoteOnCompleteDelay`,`EmoteOnIncompleteDelay`,`CompletionText`,`VerifiedBuild`) VALUES
(97183,0,0,0,0,'I confess, I am somewhat surprised to see you back here with the blessed barding. The equine spirits that have patronized living paladins for years generally abhor the $R. Were it not for the circumstances in which you met the beast, it certainly would have rejected you entirely. Luckily for us, vengeance and retribution are also virtues which these spirits well understand.$B$BThe fact that Blightcaller was so helpful is... well, it is surprising. We take the wins as we get them around here though.',0);
DELETE FROM `quest_offer_reward` WHERE `ID` = 97183;
INSERT INTO `quest_offer_reward` (`ID`,`Emote1`,`Emote2`,`Emote3`,`Emote4`,`EmoteDelay1`,`EmoteDelay2`,`EmoteDelay3`,`EmoteDelay4`,`RewardText`,`VerifiedBuild`) VALUES
(97183,0,0,0,0,0,0,0,0,'I''m proud of you, $N. With every step you take, you push our fledgling order further forward into a strong future.$B$BFor your final challenge, you will be using this barding to harness your charger. Before that, however, you will have a final struggle to overcome.$B$BThere is also one last item that needs to be made before we begin this, $N. Compared to what you have already accomplished, this last part should be easy...',0);

-- Charger's Lost Soul: always, for whoever has 7647 (18749) or 97185 (276784).
DELETE FROM `creature_loot_template` WHERE `Entry` = 14516 AND `ItemType` = 0 AND `Item` IN (18749, 276784);
INSERT INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(14516,0,18749,100,1,1,0,1,1,'Charger''s Lost Soul (Judgment and Redemption 7647)'),
(14516,0,276784,100,1,1,0,1,1,'Charger''s Lost Soul (Justice and Retribution 97185)');
