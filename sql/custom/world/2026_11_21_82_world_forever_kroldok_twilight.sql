-- WoW Forever: Krol'dok Stronghold's Twilight Cultist placeholders (8110003) on the live Twilight kinds. EG Link's caches
-- (EG Link, Efficient Games, CC BY 4.0, eg-link-output-wowf 1bf749ba, builds 70938-70959) hold four Twilight kinds in
-- this dungeon and no spot for any of them: 258042 Twilight Grunt, 258100 Twilight Warlock, 258102 Twilight Outrider,
-- 258104 Twilight Lieutenant. The placeholders' 17 spots are shared out by how often players killed each kind on live
-- (EG Link's combat logs: 144, 24, 36 and 41 of 245 deaths): 10 Grunts, 2 Warlocks, 2 Outriders, 3 Lieutenants. Along
-- the way from the cave the seven that are not Grunts stand at every second or third spot, so packs mix (INFERRED).
-- Templates as 2026_11_21_80 (EG Link creature records; levels from its combat logs; faction, speeds and gold as the
-- placeholder). Abilities: the spells EG Link saw each cast on live, timers INFERRED. Loot: the quest items 267091 and
-- 267234 at Wowhead's Forever rates (the ForeverTracker's cache of its item pages), quest-only.
-- Model sizes: 7 of the 8 displays had no creature_model_info (the core loads no creature without it): the realm's
-- commonest size of displays on the same client model (CreatureDisplayInfo.ModelID, wago.tools 1.60.1.71037) and scale
-- 1.0, INFERRED, only where none exists. The placeholder's template goes once nothing spawns it. Safe to run again.

-- model sizes (INFERRED)
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (139811,0.372,1.5,0,0);   -- client model 6838: 485 of 553 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (139813,0.236,1.5,0,0);   -- client model 7200: 213 of 253 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (139817,0.372,1.5,0,0);   -- client model 6838: 485 of 553 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (139818,0.236,1.5,0,0);   -- client model 7200: 213 of 253 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (139999,0.372,1.5,0,0);   -- client model 6838: 485 of 553 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (140001,0.236,1.5,0,0);   -- client model 7200: 213 of 253 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (143142,0.372,1.5,0,0);   -- client model 6838: 485 of 553 realm displays
INSERT IGNORE INTO `creature_model_info` (`DisplayID`,`BoundingRadius`,`CombatReach`,`DisplayID_Other_Gender`,`VerifiedBuild`) VALUES (143143,0.236,1.5,0,0);   -- client model 7200: 213 of 253 realm displays

-- the live templates
DELETE FROM `creature_template` WHERE `entry` IN (258042,258100,258102,258104);
INSERT INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(258042,0,0,'Twilight Grunt',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(258100,0,0,'Twilight Warlock',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(258102,0,0,'Twilight Outrider',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(258104,0,0,'Twilight Lieutenant',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0);
DELETE FROM `creature_template_difficulty` WHERE `Entry` IN (258042,258100,258102,258104);
INSERT INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(258042,0,0,0,0,0,3.0,1.0,1.0,1.0,341136,0,0,0,258042,0,0,200,550,0,0,0,0,0,0,0,0,0),
(258100,0,0,0,0,0,3.0,1.0,1.0,1.0,341194,0,0,0,258100,0,0,200,550,0,0,0,0,0,0,0,0,0),
(258102,0,0,0,0,0,3.0,1.0,1.0,1.0,341196,2048,0,0,258102,0,0,200,550,0,0,0,0,0,0,0,0,0),
(258104,0,0,0,0,0,3.25,1.0,1.0,1.0,341198,0,0,0,258104,0,0,200,550,0,0,0,0,0,0,0,0,0);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (258042,258100,258102,258104);
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(258042,0,140001,1.0,1.0,0),
(258042,1,139999,1.0,1.0,0),
(258100,0,139817,1.0,1.0,0),
(258100,1,139818,1.0,1.0,0),
(258102,0,139813,1.0,1.0,0),
(258102,1,139811,1.0,1.0,0),
(258104,0,143142,1.0,1.0,0),
(258104,1,143143,1.0,1.0,0);
DELETE FROM `creature_classic_level` WHERE `entry` IN (258042,258100,258102,258104);
INSERT INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(258042,40,41),
(258100,41,42),
(258102,41,42),
(258104,41,42);

-- quest items at Wowhead's Forever rates
DELETE FROM `creature_loot_template` WHERE `Entry` IN (258042,258100,258102,258104);
INSERT INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(258042,0,267091,17.8,1,1,0,1,1,'Twilight Grunt: quest item (Wowhead Forever rate)'),
(258042,0,267234,13.16,1,1,0,1,1,'Twilight Grunt: quest item (Wowhead Forever rate)'),
(258100,0,267091,7.71,1,1,0,1,1,'Twilight Warlock: quest item (Wowhead Forever rate)'),
(258100,0,267234,7.14,1,1,0,1,1,'Twilight Warlock: quest item (Wowhead Forever rate)'),
(258102,0,267091,16.67,1,1,0,1,1,'Twilight Outrider: quest item (Wowhead Forever rate)'),
(258102,0,267234,10.82,1,1,0,1,1,'Twilight Outrider: quest item (Wowhead Forever rate)'),
(258104,0,267091,16.88,1,1,0,1,1,'Twilight Lieutenant: quest item (Wowhead Forever rate)'),
(258104,0,267234,12.31,1,1,0,1,1,'Twilight Lieutenant: quest item (Wowhead Forever rate)');

-- abilities: the spells EG Link saw them cast on live (timers INFERRED)
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (258042,258100,258102,258104);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(258042,0,0,0,'',0,0,100,0,2000,5000,6000,10000,0,'',11,15572,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Grunt - Sunder Armor on victim (live spell, INFERRED timer)'),
(258042,0,1,0,'',0,0,100,0,8000,12000,20000,25000,0,'',11,1307067,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Twilight Grunt - Bladestorm around itself (live spell, INFERRED timer)'),
(258100,0,0,0,'',0,0,100,0,0,1000,3000,4000,0,'',11,20787,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Warlock - Immolate on victim (live spell, INFERRED timer)'),
(258100,0,1,0,'',0,0,100,0,6000,9000,15000,20000,0,'',11,20754,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Warlock - Rain of Fire at victim (live spell, INFERRED timer)'),
(258102,0,0,0,'',9,0,100,0,5,30,2000,3000,0,'',11,6660,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Outrider - Shoot victim at range (live spell, INFERRED timer)'),
(258102,0,1,0,'',0,0,100,0,4000,7000,12000,16000,0,'',11,14443,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Outrider - Multi-Shot at victim (live spell, INFERRED timer)'),
(258102,0,2,0,'',0,0,100,0,6000,10000,15000,20000,0,'',11,14030,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Outrider - Hooked Net on victim (live spell, INFERRED timer)'),
(258104,0,0,0,'',4,0,100,0,0,0,0,0,0,'',11,9128,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Twilight Lieutenant - Battle Shout on aggro (live spell)'),
(258104,0,1,0,'',0,0,100,0,5000,8000,12000,16000,0,'',11,6713,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Twilight Lieutenant - Disarm victim (live spell, INFERRED timer)'),
(258104,0,2,0,'',2,0,100,0,0,30,30000,30000,0,'',11,1277424,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Twilight Lieutenant - Shield Wall below 30% health (live spell, INFERRED timer)');

-- the 17 spawns (guids and spots kept)
UPDATE `creature` SET `id` = 258042, `modelid` = 0 WHERE `id` = 8110003 AND `guid` IN (48110014,48110021,48110029,48110036,48110034,48110078,48110052,48110051,48110068,48110061);   -- Twilight Grunt x10
UPDATE `creature` SET `id` = 258100, `modelid` = 0 WHERE `id` = 8110003 AND `guid` IN (48110035,48110069);   -- Twilight Warlock x2
UPDATE `creature` SET `id` = 258102, `modelid` = 0 WHERE `id` = 8110003 AND `guid` IN (48110020,48110049);   -- Twilight Outrider x2
UPDATE `creature` SET `id` = 258104, `modelid` = 0 WHERE `id` = 8110003 AND `guid` IN (48110019,48110044,48110066);   -- Twilight Lieutenant x3

-- the placeholder, once nothing spawns it
DELETE FROM `smart_scripts` WHERE `entryorguid` = 8110003 AND `source_type` = 0 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110003);
DELETE FROM `creature_classic_level` WHERE `entry` = 8110003 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110003);
DELETE FROM `creature_template_model` WHERE `CreatureID` = 8110003 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110003);
DELETE FROM `creature_template_difficulty` WHERE `Entry` = 8110003 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110003);
DELETE FROM `creature_template` WHERE `entry` = 8110003 AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = 8110003);
