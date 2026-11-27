-- WoW Forever: Krol'dok Stronghold's last placeholders (8110001 Krol'dok Peon) on live entries. Live has no Krol'dok Peon.
-- What it has that no spawn of the dungeon stands for yet: five creatures added with it (client 70862), killed on live
-- with no recorded spot (EG Link's combat logs, eg-link-output-wowf 1bf749ba, builds 70938-70959: an instance), that
-- drop the dungeon's own items (Krol'dok Warplate Gauntlets 287012, Shadow-Seer Orb 287016 ... 287007-287016, which only
-- the stronghold's creatures drop, per Wowhead's and Icy Veins' Forever data):
--   257900 Redridge Prisoner (34 deaths), 258038 Shadowhide Bully (29), 262067 Twilight Peon (21), 262065 Riding Wolf (16),
--   258040 Shadowhide Curseweaver (11).
-- The placeholder's 22 spots are the dungeon's last unclaimed ones. They are shared by live deaths as 2026_11_21_82 did
-- for the Twilight Cultists: 7 Prisoners, 6 Bullies, 4 Peons, 3 Riding Wolves, 2 Curseweavers, each spot along the way
-- from the cave taking the kind furthest behind its share, so packs mix (INFERRED). Templates from EG Link's creature
-- records (rank, class, type, models, health multiplier, CreatureDifficultyID, type flags; levels from its combat logs),
-- faction 16, speeds and gold as the placeholder (INFERRED); the spells EG Link saw cast, timers INFERRED. The four
-- Twilight Peon displays get creature_model_info as in _82 (the realm's commonest size on the same client model).
-- The placeholder's template goes once nothing spawns it. Safe to run again.

-- model sizes (INFERRED, only where none exists)
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (143055,0.236,1.5,0,0);   -- client model 7200
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (143056,0.236,1.5,0,0);   -- client model 7200
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (143057,0.372,1.5,0,0);   -- client model 6838
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (143058,0.372,1.5,0,0);   -- client model 6838

-- the live templates
DELETE FROM `creature_template` WHERE `entry` IN (257900,258038,262067,262065,258040);
INSERT INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(257900,0,0,'Redridge Prisoner',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(258038,0,0,'Shadowhide Bully',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(262067,0,0,'Twilight Peon',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(262065,0,0,'Riding Wolf',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,1,0,1,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(258040,0,0,'Shadowhide Curseweaver',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0);
DELETE FROM `creature_template_difficulty` WHERE `Entry` IN (257900,258038,262067,262065,258040);
INSERT INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(257900,0,0,0,0,0,1.0,1.0,1.0,1.0,340991,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(258038,0,0,0,0,0,3.0,1.0,1.0,1.0,341132,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(262067,0,0,0,0,0,1.0,1.0,1.0,1.0,345337,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(262065,0,0,0,0,0,3.0,1.0,1.0,1.0,345335,1,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(258040,0,0,0,0,0,3.0,3.0,1.0,1.0,341134,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (257900,258038,262067,262065,258040);
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(257900,0,487,1.0,1.0,0),
(258038,0,1887,1.0,1.0,0),
(262067,0,143055,1.0,1.0,0),
(262067,1,143056,1.0,1.0,0),
(262067,2,143057,1.0,1.0,0),
(262067,3,143058,1.0,1.0,0),
(262065,0,2327,0.8,1.0,0),
(262065,1,247,0.8,1.0,0),
(262065,2,207,0.8,1.0,0),
(262065,3,2320,0.8,1.0,0),
(258040,0,1888,1.0,1.0,0);
DELETE FROM `creature_classic_level` WHERE `entry` IN (257900,258038,262067,262065,258040);
INSERT INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(257900,38,39),
(258038,40,41),
(262067,38,39),
(262065,41,42),
(258040,40,41);

-- abilities: the spells EG Link saw them cast on live (timers INFERRED)
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (257900,258038,262067,262065,258040);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(258038,0,0,0,'',0,0,100,0,4000,7000,12000,16000,0,'',11,11428,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Shadowhide Bully - Knockdown on victim (live spell, INFERRED timer)'),
(258040,0,0,0,'',0,0,100,0,0,1000,3500,5000,0,'',11,9613,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Shadowhide Curseweaver - Shadow Bolt on victim (live spell, INFERRED timer)'),
(258040,0,1,0,'',0,0,100,0,3000,6000,20000,25000,0,'',11,13338,0,0,0,0,0,0,'',6,0,0,0,0,'',0,0,0,0,'Shadowhide Curseweaver - Curse of Tongues on a random player (live spell, INFERRED timer)'),
(262065,0,0,0,'',0,0,100,0,2000,4000,10000,14000,0,'',11,13445,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Riding Wolf - Rend on victim (live spell, INFERRED timer)');

-- the 22 spots (guids and spots kept)
UPDATE `creature` SET `id` = 257900, `modelid` = 0 WHERE `id` = 8110001 AND `guid` IN (48110011,48110023,48110031,48110040,48110074,48110054,48110062);   -- Redridge Prisoner x7
UPDATE `creature` SET `id` = 258038, `modelid` = 0 WHERE `id` = 8110001 AND `guid` IN (48110010,48110026,48110041,48110045,48110071,48110063);   -- Shadowhide Bully x6
UPDATE `creature` SET `id` = 262067, `modelid` = 0 WHERE `id` = 8110001 AND `guid` IN (48110016,48110030,48110046,48110056);   -- Twilight Peon x4
UPDATE `creature` SET `id` = 262065, `modelid` = 0 WHERE `id` = 8110001 AND `guid` IN (48110015,48110038,48110057);   -- Riding Wolf x3
UPDATE `creature` SET `id` = 258040, `modelid` = 0 WHERE `id` = 8110001 AND `guid` IN (48110025,48110073);   -- Shadowhide Curseweaver x2

-- the placeholder, once nothing spawns it
DELETE FROM `smart_scripts` WHERE `entryorguid` = 8110001 AND `source_type` = 0 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110001);
DELETE FROM `creature_classic_level` WHERE `entry` = 8110001 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110001);
DELETE FROM `creature_template_model` WHERE `CreatureID` = 8110001 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110001);
DELETE FROM `creature_template_difficulty` WHERE `Entry` = 8110001 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110001);
DELETE FROM `creature_template` WHERE `entry` = 8110001 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110001);
