-- WoW Forever: Blizzard's hotfixes of 24 November 2026 (build 1.60.1.71091, which carries the same game data as 71037).
-- Records from the Everlake tracker (its checkout of step 71091+1, made from the live hotfix records it stores), Blizzard's
-- values unchanged. That day's hotfixes touch 7 items; the realm already holds 5 of them exactly (Frigid Ring 18679,
-- Hardened Stone Band 18674, Linken's Sword of Mastery 11902, Tempestria's Frozen Necklace 18678, and Gustberry Juice 252027's
-- new price 125 from 2026_11_24_50). This file brings the other two:
--   Totem of the Maelstrom 272432: renamed from Totem of the Storm.
--   Spirit of Aquementas 11904: DmgVariance 0 (the realm had 0.2).
-- Layouts: ItemSparse of 71091 has the layout of the server's 70959 file (the tracker's checkout writes only such tables).
-- hotfix_data ids 2117000-2117001. Safe to run again.

DELETE FROM `item_sparse` WHERE `ID` IN (11904,272432);
INSERT INTO `item_sparse` (`ID`,`Description`,`Display3`,`Display2`,`Display1`,`Display`,`ExpansionID`,`DmgVariance`,`LimitCategory`,`DurationInInventory`,`QualityModifier`,`BagFamily`,`StartQuestID`,`LanguageID`,`ItemRange`,`StatPercentageOfSocket1`,`StatPercentageOfSocket2`,`StatPercentageOfSocket3`,`StatPercentageOfSocket4`,`StatPercentageOfSocket5`,`StatPercentageOfSocket6`,`StatPercentageOfSocket7`,`StatPercentageOfSocket8`,`StatPercentageOfSocket9`,`StatPercentageOfSocket10`,`StatPercentEditor1`,`StatPercentEditor2`,`StatPercentEditor3`,`StatPercentEditor4`,`StatPercentEditor5`,`StatPercentEditor6`,`StatPercentEditor7`,`StatPercentEditor8`,`StatPercentEditor9`,`StatPercentEditor10`,`StatModifierBonusStat1`,`StatModifierBonusStat2`,`StatModifierBonusStat3`,`StatModifierBonusStat4`,`StatModifierBonusStat5`,`StatModifierBonusStat6`,`StatModifierBonusStat7`,`StatModifierBonusStat8`,`StatModifierBonusStat9`,`StatModifierBonusStat10`,`Stackable`,`MaxCount`,`MinReputation`,`RequiredAbility`,`AllowableRace1`,`AllowableRace2`,`SellPrice`,`BuyPrice`,`VendorStackCount`,`PriceVariance`,`PriceRandomValue`,`Flags1`,`Flags2`,`Flags3`,`Flags4`,`Flags5`,`FactionRelated`,`ModifiedCraftingReagentItemID`,`ContentTuningID`,`PlayerLevelToItemLevelCurveID`,`ItemLevelOffsetCurveID`,`ItemLevelOffsetItemLevel`,`ItemSquishEraID`,`ItemNameDescriptionID`,`RequiredTransmogHoliday`,`RequiredHoliday`,`GemProperties`,`SocketMatchEnchantmentId`,`TotemCategoryID`,`InstanceBound`,`ZoneBound1`,`ZoneBound2`,`ItemSet`,`LockID`,`PageID`,`ItemDelay`,`MinFactionID`,`RequiredSkillRank`,`RequiredSkill`,`ItemLevel`,`AllowableClass`,`ArtifactID`,`SpellWeight`,`SpellWeightCategory`,`SocketType1`,`SocketType2`,`SocketType3`,`SheatheType`,`Material`,`PageMaterialID`,`Bonding`,`DamageDamageType`,`ContainerSlots`,`RequiredPVPMedal`,`RequiredPVPRank`,`RequiredLevel`,`InventoryType`,`OverallQualityID`,`AmmunitionType`,`VerifiedBuild`) VALUES
(11904,'','','','','Spirit of Aquementas',0,0.0,0,0,0.0,0,0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,11666,0,0,0,0,0,0,0,0,0,45,-1,-1,-1,-1,-1,-1,-1,-1,-1,1,0,0,0,-1,-1,13815,55260,1,1.0,1.0,0,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,56,-1,0,0,0,0,0,0,3,3,0,1,0,0,0,0,0,23,3,0,71091),
(272432,'','','','','Totem of the Maelstrom',0,0.0,0,0,0.0,0,0,0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0.0,0,0,0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1,0,0,0,-1,-1,13067,65339,1,1.0,1.0170999765396118,4096,24576,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,65,32767,0,0,0,0,0,0,0,2,0,1,0,0,0,0,60,28,3,0,71091);

DELETE FROM `hotfix_data` WHERE `Id` BETWEEN 2117000 AND 2117001;
INSERT INTO `hotfix_data` (`Id`,`UniqueId`,`TableHash`,`RecordId`,`Status`,`VerifiedBuild`) VALUES
(2117000,1397837000,2442913102,11904,1,71091),
(2117001,1397837001,2442913102,272432,1,71091);
