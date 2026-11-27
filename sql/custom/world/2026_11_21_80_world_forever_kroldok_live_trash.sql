-- WoW Forever: Krol'dok Stronghold's trash on its live entries. 2026_11_11_33_world_forever_kroldok_stronghold.sql made
-- the dungeon playable with PLACEHOLDER trash (8110000-8110005) and asked for the live entries once a cache showed
-- them. EG Link's players' caches now hold them (EG Link, Efficient Games, CC BY 4.0, eg-link-output-wowf 1bf749ba,
-- builds 70938-70959: creature records = name, rank, class, type, models, health multiplier, CreatureDifficultyID,
-- type flags; combat logs = levels and the spells each one cast). The same kind, standing where the placeholder stood:
--   8110000 Krol'dok Brute (26 spawns)     -> 258687 Krol'dok Brute
--   8110004 Krol'dok Centurion (4 spawns)  -> 257885 Krol'dok Centurion (Mugg also summons them: the script uses 257885)
--   8110002 Krol'dok Shaman (2 spawns)     -> 257888 Krol'dok Shaman (Toof's guards)
--   8110005 Krol'dok War Wolf (2 spawns)   -> 259283 Snarlfang and 259285 Terrorhowl, War Handler Ashka's wolves
-- The spawns keep their guids and spots (INFERRED, as before); the placeholders' templates go once nothing uses them.
-- Abilities: the spells EG Link saw each of them cast on live, timers INFERRED as the placeholders' were.
-- Faction 16, speeds, attack times and gold as the placeholders (INFERRED). Not done here, no live match yet:
-- 8110001 Krol'dok Peon and 8110003 Twilight Cultist stay (live has Twilight Grunts, Warlocks, Outriders and
-- Lieutenants and Shadowhide gnolls in this dungeon, with no recorded spots to tell which stands where).
-- Safe to run again.

-- the live templates (EG Link creature records; level range from its combat logs)
DELETE FROM `creature_template` WHERE `entry` IN (258687,257885,257888,259283,259285);
INSERT INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(258687,0,0,'Krol''dok Brute',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(257885,0,0,'Krol''dok Centurion',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(257888,0,0,'Krol''dok Shaman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(259283,0,0,'Snarlfang',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0),
(259285,0,0,'Terrorhowl',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0);
DELETE FROM `creature_template_difficulty` WHERE `Entry` IN (258687,257885,257888,259283,259285);
INSERT INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(258687,0,0,0,0,0,3.5,1.0,1.0,1.0,341796,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(257885,0,0,0,0,0,4.0,1.0,1.0,1.0,340976,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(257888,0,0,0,0,0,3.5,1.0,1.0,1.0,340979,0,0,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(259283,0,0,0,0,0,3.0,1.0,1.0,1.0,342463,0,128,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0),
(259285,0,0,0,0,0,3.0,1.0,1.0,1.0,342465,0,128,0,0,0,0,200,550,0,0,0,0,0,0,0,0,0);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (258687,257885,257888,259283,259285);
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(258687,0,1045,1.5,1.0,0),
(257885,0,11571,1.2,1.0,0),
(257888,0,326,1.5,1.0,0),
(259283,0,11413,1.1,1.0,0),
(259285,0,11414,1.1,1.0,0);
DELETE FROM `creature_classic_level` WHERE `entry` IN (258687,257885,257888,259283,259285);
INSERT INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(258687,40,41),
(257885,42,42),
(257888,40,41),
(259283,43,43),
(259285,43,43);

-- abilities: the spells EG Link saw them cast on live (timers INFERRED)
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (258687,257885,257888,259283,259285);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(258687,0,0,0,'',0,0,100,0,3000,6000,6000,9000,0,'',11,12057,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Krol''dok Brute - Strike on victim (live spell, INFERRED timer)'),
(258687,0,1,0,'',0,0,100,0,5000,8000,8000,12000,0,'',11,15663,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Krol''dok Brute - Cleave on victim (live spell, INFERRED timer)'),
(257885,0,0,0,'',0,0,100,0,4000,7000,9000,12000,0,'',11,16856,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Krol''dok Centurion - Mortal Strike on victim (live spell, INFERRED timer)'),
(257885,0,1,0,'',0,0,100,0,6000,9000,12000,16000,0,'',11,15548,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Krol''dok Centurion - Thunderclap around itself (live spell, INFERRED timer)'),
(257885,0,2,0,'',0,0,100,0,2000,4000,25000,30000,0,'',11,16244,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Krol''dok Centurion - Demoralizing Shout around itself (live spell, INFERRED timer)'),
(257888,0,0,0,'',4,0,100,0,0,0,0,0,0,'',11,12550,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Krol''dok Shaman - Lightning Shield on itself on aggro (live spell)'),
(257888,0,1,0,'',0,0,100,0,1000,2000,4000,6000,0,'',11,12167,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Krol''dok Shaman - Lightning Bolt on victim (live spell, INFERRED timer)'),
(257888,0,2,0,'',0,0,100,0,8000,12000,30000,40000,0,'',11,6742,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Krol''dok Shaman - Bloodlust on itself (live spell, INFERRED timer)'),
(259283,0,0,0,'',0,0,100,0,2000,4000,10000,14000,0,'',11,13445,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Snarlfang - Rend on victim (live spell, INFERRED timer)'),
(259285,0,0,0,'',0,0,100,0,6000,9000,20000,25000,0,'',11,1282071,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Terrorhowl - Frightening Howl around itself (live spell, INFERRED timer)');

-- the spawns move to the live entries (guids and spots kept)
UPDATE `creature` SET `id` = 258687, `modelid` = 0 WHERE `id` = 8110000 AND `guid` BETWEEN 48110000 AND 48110199;   -- Krol'dok Brute
UPDATE `creature` SET `id` = 257885, `modelid` = 0 WHERE `id` = 8110004 AND `guid` BETWEEN 48110000 AND 48110199;   -- Krol'dok Centurion
UPDATE `creature` SET `id` = 257888, `modelid` = 0 WHERE `id` = 8110002 AND `guid` BETWEEN 48110000 AND 48110199;   -- Krol'dok Shaman
UPDATE `creature` SET `id` = 259283, `modelid` = 0 WHERE `id` = 8110005 AND `guid` IN (48110006);   -- Snarlfang
UPDATE `creature` SET `id` = 259285, `modelid` = 0 WHERE `id` = 8110005 AND `guid` IN (48110007);   -- Terrorhowl

-- the placeholders nothing uses any more
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` IN (8110000,8110002,8110004,8110005) AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = `entryorguid`);
DELETE FROM `creature_classic_level` WHERE `entry` IN (8110000,8110002,8110004,8110005) AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = `entry`);
DELETE FROM `creature_template_model` WHERE `CreatureID` IN (8110000,8110002,8110004,8110005) AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = `CreatureID`);
DELETE FROM `creature_template_difficulty` WHERE `Entry` IN (8110000,8110002,8110004,8110005) AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = `Entry`);
DELETE FROM `creature_template` WHERE `entry` IN (8110000,8110002,8110004,8110005) AND NOT EXISTS (SELECT 1 FROM `creature` c WHERE c.`id` = `entry`);
