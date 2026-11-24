-- WoW Forever: a trainee Riding Turtle without an Apprentice Riding requirement.
-- Item 9902000 teaches mount spell 1399990. Client mount type 283 deliberately
-- has no Riding requirement, while the mount spell grants exactly 20% speed.
-- The turtle model uses Riding Turtle 17266's client-supported display 17158.
-- Display 12655 is missing from the current 1.60 client data. Safe to run again.

DELETE FROM `spell_name` WHERE `ID` IN (1399990,1399991);
INSERT INTO `spell_name` (`ID`,`Name`,`VerifiedBuild`) VALUES
(1399990,'Trainee Turtle Mount',70959);

DELETE FROM `spell_name_locale` WHERE `ID` = 1399990 AND `locale` = 'zhCN';
INSERT INTO `spell_name_locale` (`ID`,`locale`,`Name_lang`,`VerifiedBuild`) VALUES
(1399990,'zhCN','新手乌龟坐骑',70959);

DELETE FROM `spell_misc` WHERE `ID` IN (1399990,1399991);
INSERT INTO `spell_misc` (`ID`,`Attributes1`,`Attributes2`,`Attributes3`,`Attributes4`,`Attributes5`,`Attributes6`,`Attributes7`,`Attributes8`,`Attributes9`,`Attributes10`,`Attributes11`,`Attributes12`,`Attributes13`,`Attributes14`,`Attributes15`,`Attributes16`,`Attributes17`,`DifficultyID`,`CastingTimeIndex`,`DurationIndex`,`PvPDurationIndex`,`RangeIndex`,`SchoolMask`,`Speed`,`LaunchDelay`,`MinDuration`,`SpellIconFileDataID`,`ActiveIconFileDataID`,`ContentTuningID`,`ShowFutureSpellPlayerConditionID`,`SpellVisualScript`,`ActiveSpellVisualScript`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,269582608,0,0,0,0,0,0,0,4096,0,0,0,0,0,0,8192,0,0,14,21,0,1,1,0,0,0,132199,136116,0,0,0,0,1399990,70959);

DELETE FROM `spell_effect` WHERE `ID` IN (1399990,1399991);
INSERT INTO `spell_effect` (`ID`,`EffectAura`,`DifficultyID`,`EffectIndex`,`Effect`,`EffectAmplitude`,`EffectAttributes`,`EffectAuraPeriod`,`EffectBonusCoefficient`,`EffectChainAmplitude`,`EffectChainTargets`,`EffectItemType`,`EffectMechanic`,`EffectPointsPerResource`,`EffectPosFacing`,`EffectRealPointsPerLevel`,`EffectTriggerSpell`,`BonusCoefficientFromAP`,`PvpMultiplier`,`Coefficient`,`Variance`,`ResourceCoefficient`,`GroupSizeBasePointsCoefficient`,`EffectBasePoints`,`ScalingClass`,`TargetNodeGraph`,`EffectMiscValue1`,`EffectMiscValue2`,`EffectRadiusIndex1`,`EffectRadiusIndex2`,`EffectSpellClassMask1`,`EffectSpellClassMask2`,`EffectSpellClassMask3`,`EffectSpellClassMask4`,`ImplicitTarget1`,`ImplicitTarget2`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,78,0,0,6,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,0,0,0,17266,0,0,0,0,0,0,0,1,0,1399990,70959),
(1399991,32,0,1,6,0,0,0,1,1,0,0,0,0,0,0,0,0,1,0,0,0,1,20,0,0,0,0,0,0,0,0,0,0,1,0,1399990,70959);

DELETE FROM `spell_aura_options` WHERE `ID` = 1399990;
INSERT INTO `spell_aura_options` (`ID`,`DifficultyID`,`CumulativeAura`,`ProcCategoryRecovery`,`ProcChance`,`ProcCharges`,`SpellProcsPerMinuteID`,`ProcTypeMask1`,`ProcTypeMask2`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,0,0,0,101,0,0,0,0,1399990,70959);

DELETE FROM `spell_categories` WHERE `ID` = 1399990;
INSERT INTO `spell_categories` (`ID`,`DifficultyID`,`Category`,`DefenseType`,`DiminishType`,`DispelType`,`Mechanic`,`PreventionType`,`StartRecoveryCategory`,`ChargeCategory`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,0,0,0,0,0,21,0,0,0,1399990,70959);

DELETE FROM `spell_interrupts` WHERE `ID` IN (1399990,1399991);
INSERT INTO `spell_interrupts` (`ID`,`DifficultyID`,`InterruptFlags`,`AuraInterruptFlags1`,`AuraInterruptFlags2`,`ChannelInterruptFlags1`,`ChannelInterruptFlags2`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,0,31,128,0,0,0,1399990,70959);

DELETE FROM `spell_levels` WHERE `ID` = 1399990;
INSERT INTO `spell_levels` (`ID`,`DifficultyID`,`MaxLevel`,`MaxPassiveAuraLevel`,`BaseLevel`,`SpellLevel`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,0,0,0,0,1,1399990,70959);

DELETE FROM `spell_x_spell_visual` WHERE `ID` = 1399990;
INSERT INTO `spell_x_spell_visual` (`ID`,`DifficultyID`,`SpellVisualID`,`Probability`,`Flags`,`Priority`,`SpellIconFileID`,`ActiveIconFileID`,`ViewerUnitConditionID`,`ViewerPlayerConditionID`,`CasterUnitConditionID`,`CasterPlayerConditionID`,`SpellID`,`VerifiedBuild`) VALUES
(1399990,0,5160,1,0,1,0,0,0,0,0,0,1399990,70959);

DELETE FROM `hotfix_blob` WHERE `TableHash` = 3776013982 AND `RecordId` = 1399990 AND `locale` IN ('enUS','zhCN');
INSERT INTO `hotfix_blob` (`TableHash`,`RecordId`,`locale`,`Blob`,`VerifiedBuild`) VALUES
(3776013982,1399990,'enUS',CONCAT('',CHAR(0),'Summons and dismisses a trainee riding turtle. Increases ground speed by 20%.',CHAR(0),'Increases ground speed by 20%.',CHAR(0)),70959),
(3776013982,1399990,'zhCN',CONCAT('',CHAR(0),'召唤或解散一只新手骑乘乌龟。地面移动速度提高20%。',CHAR(0),'地面移动速度提高20%。',CHAR(0)),70959);

DELETE FROM `mount` WHERE `ID` = 3920;
INSERT INTO `mount` (`Name`,`SourceText`,`Description`,`ID`,`MountTypeID`,`Flags`,`SourceTypeEnum`,`SourceSpellID`,`PlayerConditionID`,`MountFlyRideHeight`,`UiModelSceneID`,`MountSpecialRiderAnimKitID`,`MountSpecialSpellVisualKitID`,`VerifiedBuild`) VALUES
('Trainee Riding Turtle','','A patient turtle for novice riders.',3920,283,2112,8,1399990,0,0,4,0,0,70959);

DELETE FROM `mount_locale` WHERE `ID` = 3920 AND `locale` = 'zhCN';
INSERT INTO `mount_locale` (`ID`,`locale`,`Name_lang`,`SourceText_lang`,`Description_lang`,`VerifiedBuild`) VALUES
(3920,'zhCN','新手骑乘乌龟','','适合新手骑乘的耐心乌龟。',70959);

DELETE FROM `mount_x_display` WHERE `ID` = 9920;
INSERT INTO `mount_x_display` (`ID`,`CreatureDisplayInfoID`,`PlayerConditionID`,`Unknown1100`,`MountID`,`VerifiedBuild`) VALUES
(9920,17158,0,0,3920,70959);

DELETE FROM `mount_capability` WHERE `ID` = 9900;
DELETE FROM `mount_type_x_capability` WHERE `ID` = 9900;

DELETE FROM `item` WHERE `ID` = 9902000;
INSERT INTO `item` (`ID`,`ClassID`,`SubclassID`,`Material`,`InventoryType`,`SheatheType`,`ItemPetFoodID`,`SoundOverrideSubclassID`,`IconFileDataID`,`ItemGroupSoundsID`,`ContentTuningID`,`ModifiedCraftingReagentItemID`,`Unknown1200`,`CraftingQualityID`,`ItemSquishEraID`,`RecraftReagentCountPercentage`,`OrderSource`,`VerifiedBuild`) VALUES
(9902000,15,0,0,0,0,0,-1,132199,16,0,0,0,0,0,0,0,70959);

DELETE FROM `item_sparse` WHERE `ID` = 9902000;
INSERT INTO `item_sparse` (`ID`,`Description`,`Display3`,`Display2`,`Display1`,`Display`,`ExpansionID`,`DmgVariance`,`LimitCategory`,`DurationInInventory`,`QualityModifier`,`BagFamily`,`StartQuestID`,`LanguageID`,`ItemRange`,`StatPercentageOfSocket1`,`StatPercentageOfSocket2`,`StatPercentageOfSocket3`,`StatPercentageOfSocket4`,`StatPercentageOfSocket5`,`StatPercentageOfSocket6`,`StatPercentageOfSocket7`,`StatPercentageOfSocket8`,`StatPercentageOfSocket9`,`StatPercentageOfSocket10`,`StatPercentEditor1`,`StatPercentEditor2`,`StatPercentEditor3`,`StatPercentEditor4`,`StatPercentEditor5`,`StatPercentEditor6`,`StatPercentEditor7`,`StatPercentEditor8`,`StatPercentEditor9`,`StatPercentEditor10`,`StatModifierBonusStat1`,`StatModifierBonusStat2`,`StatModifierBonusStat3`,`StatModifierBonusStat4`,`StatModifierBonusStat5`,`StatModifierBonusStat6`,`StatModifierBonusStat7`,`StatModifierBonusStat8`,`StatModifierBonusStat9`,`StatModifierBonusStat10`,`Stackable`,`MaxCount`,`MinReputation`,`RequiredAbility`,`AllowableRace1`,`AllowableRace2`,`SellPrice`,`BuyPrice`,`VendorStackCount`,`PriceVariance`,`PriceRandomValue`,`Flags1`,`Flags2`,`Flags3`,`Flags4`,`Flags5`,`FactionRelated`,`ModifiedCraftingReagentItemID`,`ContentTuningID`,`PlayerLevelToItemLevelCurveID`,`ItemLevelOffsetCurveID`,`ItemLevelOffsetItemLevel`,`ItemSquishEraID`,`ItemNameDescriptionID`,`RequiredTransmogHoliday`,`RequiredHoliday`,`GemProperties`,`SocketMatchEnchantmentId`,`TotemCategoryID`,`InstanceBound`,`ZoneBound1`,`ZoneBound2`,`ItemSet`,`LockID`,`PageID`,`ItemDelay`,`MinFactionID`,`RequiredSkillRank`,`RequiredSkill`,`ItemLevel`,`AllowableClass`,`ArtifactID`,`SpellWeight`,`SpellWeightCategory`,`SocketType1`,`SocketType2`,`SocketType3`,`SheatheType`,`Material`,`PageMaterialID`,`Bonding`,`DamageDamageType`,`ContainerSlots`,`RequiredPVPMedal`,`RequiredPVPRank`,`RequiredLevel`,`InventoryType`,`OverallQualityID`,`VerifiedBuild`) VALUES
(9902000,'Teaches you how to summon a trainee riding turtle.','','','','Trainee Riding Turtle',0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,1,1,0,0,-1,-1,0,0,1,1,1,64,24580,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,1,70959);

DELETE FROM `item_sparse_locale` WHERE `ID` = 9902000 AND `locale` = 'zhCN';
INSERT INTO `item_sparse_locale` (`ID`,`locale`,`Description_lang`,`Display3_lang`,`Display2_lang`,`Display1_lang`,`Display_lang`,`VerifiedBuild`) VALUES
(9902000,'zhCN','教你学会召唤一只新手骑乘乌龟。','','','','新手骑乘乌龟',70959);

DELETE FROM `item_search_name` WHERE `ID` = 9902000;
INSERT INTO `item_search_name` (`ID`,`Display`,`OverallQualityID`,`ExpansionID`,`MinFactionID`,`MinReputation`,`AllowableClass`,`RequiredLevel`,`RequiredSkill`,`RequiredSkillRank`,`RequiredAbility`,`ItemLevel`,`Flags1`,`Flags2`,`Flags3`,`Flags4`,`Flags5`,`AllowableRace1`,`AllowableRace2`,`VerifiedBuild`) VALUES
(9902000,'Trainee Riding Turtle',1,0,0,0,-1,0,0,0,0,1,0,0,0,0,0,-1,-1,70959);

DELETE FROM `item_effect` WHERE `ID` IN (9902000,9902001);
INSERT INTO `item_effect` (`ID`,`LegacySlotIndex`,`TriggerType`,`Charges`,`CoolDownMSec`,`CategoryCoolDownMSec`,`SpellCategoryID`,`SpellID`,`ChrSpecializationID`,`PlayerConditionID`,`VerifiedBuild`) VALUES
(9902000,0,0,-1,0,3000,330,55884,0,0,70959),
(9902001,1,6,0,-1,-1,0,1399990,0,0,70959);

DELETE FROM `item_x_item_effect` WHERE `ID` IN (9902000,9902001);
INSERT INTO `item_x_item_effect` (`ID`,`ItemEffectID`,`ItemID`,`VerifiedBuild`) VALUES
(9902000,9902000,9902000,70959),
(9902001,9902001,9902000,70959);

DELETE FROM `hotfix_data` WHERE `Id` BETWEEN 26150000 AND 26150013
  OR `Id` BETWEEN 26150100 AND 26150118
  OR `Id` BETWEEN 26150200 AND 26150223
  OR `Id` BETWEEN 26150300 AND 26150406;
INSERT INTO `hotfix_data` (`Id`,`UniqueId`,`TableHash`,`RecordId`,`Status`,`VerifiedBuild`) VALUES
(26150200,1400020200,1187407512,1399990,1,70959),
(26150202,1400020202,3322146344,1399990,1,70959),
(26150204,1400020204,4030871717,1399990,1,70959),
(26150205,1400020205,4030871717,1399991,1,70959),
(26150206,1400020206,4096770149,1399990,1,70959),
(26150207,1400020207,3689412649,1399990,1,70959),
(26150208,1400020208,1720692227,1399990,1,70959),
(26150210,1400020210,501138918,1399990,1,70959),
(26150211,1400020211,666345498,1399990,1,70959),
(26150212,1400020212,3776013982,1399990,1,70959),
(26150213,1400020213,2524150337,3920,1,70959),
(26150217,1400020217,1344507586,9902000,1,70959),
(26150218,1400020218,2442913102,9902000,1,70959),
(26150219,1400020219,3465080266,9902000,1,70959),
(26150220,1400020220,1073915313,9902000,1,70959),
(26150221,1400020221,1073915313,9902001,1,70959),
(26150222,1400020222,13330255,9902000,1,70959),
(26150223,1400020223,13330255,9902001,1,70959),
(26150300,1400020300,2030087241,9920,1,70959),
(26150400,1400020400,2524150337,3920,1,70959),
(26150401,1400020401,4030871717,1399991,1,70959),
(26150402,1400020402,1187407512,1399991,3,70959),
(26150403,1400020403,3322146344,1399991,3,70959),
(26150404,1400020404,1720692227,1399991,3,70959),
(26150405,1400020405,4134404214,9900,3,70959),
(26150406,1400020406,685366953,9900,3,70959);
