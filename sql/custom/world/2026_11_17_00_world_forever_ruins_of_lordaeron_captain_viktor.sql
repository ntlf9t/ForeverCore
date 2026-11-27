-- WoW Forever: Ruins of Lordaeron (map 2999), the two encounters the 2026-10-11 sniff never saw: the rare Lordaeron Captain
-- (encounter 3408) and Viktor the Vile (encounter 3411). Their boss ids are in classic_instance_ruins_of_lordaeron.cpp.
-- What is real data and what is a guess:
--  * real (Wowhead Forever, npc 255699, 106 kills): the Captain's name, Rare Elite class, Undead type, display 139050, abilities
--    (Cleave 5532, Battle Stance 7165, Hamstring 9080, Apparition 1266050), every drop and its count, money (1s 98c).
--  * real (client 70790): Apparition is a dummy aura; faction template 3594 is the client's only one on the Scourge faction (20)
--    that is friendly to the Alliance and to monsters and hostile to the Horde, which is what players report (Wowhead comments,
--    Warcraft Tavern: hostile to Horde, Alliance can't attack him, he walks past the dungeon's undead).
--  * real (the 2026-10-11 sniff): the Captain's walk is the Skeletal Soldier patrol 213001070 on the western side; the fireplace is
--    the sniffed Warm Kindling 616225 (spawn 21300410) in the burned house; the wave spawn spots are sniffed creature spots there.
--  * from the guides (Warcraft Tavern, Icy Veins): the Captain is a rare with a small chance to be up, on the western side; using
--    the fireplace starts five waves of undead, then Viktor the Vile comes out (he uses Witherfang's poison 3358, already scripted).
--  * INFERRED (our guesses, every row says so): the Captain's spawn chance (20%), level 20, health x5, money range, ability timers;
--    which undead come in each wave, the 50 s between waves, Viktor 20 s after the last wave, Viktor coming out at the fireplace.
-- Replace them with sniff data when someone records a run. Spawn guid 21300900, path 213009000, pool 21300900. Safe to run again.

-- Lordaeron Captain: template (Wowhead; level, health and money INFERRED)
DELETE FROM `creature_template` WHERE `entry` = 255699;
INSERT INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(255699,0,0,'Lordaeron Captain',NULL,NULL,NULL,NULL,0,0,3594,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'SmartAI',0,1.0,0,0,0,0,1,0,0,'',NULL,0);
DELETE FROM `creature_template_difficulty` WHERE `Entry` = 255699;
INSERT INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(255699,0,0,0,0,0,5.0,1.0,1.0,1.0,0,0,0,0,255699,0,0,150,250,0,0,0,0,0,0,0,0,0);
DELETE FROM `creature_template_model` WHERE `CreatureID` = 255699;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(255699,0,139050,1.0,1.0,0);
DELETE FROM `creature_classic_level` WHERE `entry` = 255699;
INSERT INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(255699,20,20); -- INFERRED: the dungeon's other bosses are 17-20
DELETE FROM `creature_template_addon` WHERE `entry` = 255699;
INSERT INTO `creature_template_addon` (`entry`,`auras`) VALUES
(255699,'1266050'); -- Apparition

-- Lordaeron Captain: loot (Wowhead: chance = drops / 106 kills; the two blues are one group, one of them per kill)
DELETE FROM `creature_loot_template` WHERE `Entry` = 255699;
INSERT INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255699,0,6641,47.17,0,1,1,1,1,'wowhead: 50 of 106 kills - Haunting Blade'),
(255699,0,6642,47.17,0,1,1,1,1,'wowhead: 50 of 106 kills - Phantom Armor'),
(255699,0,2592,5.66,0,1,0,1,1,'wowhead: 6 of 106 kills - Wool Cloth'),
(255699,0,1766,1.887,0,1,0,1,1,'wowhead: 2 of 106 kills - Canvas Cloak'),
(255699,0,2589,1.887,0,1,0,1,1,'wowhead: 2 of 106 kills - Linen Cloth'),
(255699,0,929,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Healing Potion'),
(255699,0,1206,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Moss Agate'),
(255699,0,1742,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Laced Mail Gloves'),
(255699,0,1788,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Patched Leather Boots'),
(255699,0,2988,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Inscribed Leather Gloves'),
(255699,0,3196,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Edged Bastard Sword'),
(255699,0,4297,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Pattern: Barbaric Gloves'),
(255699,0,4345,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Pattern: Red Woolen Boots'),
(255699,0,6553,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Bard''s Trousers'),
(255699,0,6564,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Shimmering Cloak'),
(255699,0,6570,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Shimmering Sash'),
(255699,0,9779,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Bandit Cloak'),
(255699,0,9788,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Raider''s Belt'),
(255699,0,251340,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Plans: Veteran''s Chain Shirt'),
(255699,0,251344,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Plans: Crusader''s Chain Shirt'),
(255699,0,252776,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Pattern: Wisdom''s Leather Armor'),
(255699,0,253904,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Pattern: Filigreed Silky Gown'),
(255699,0,253908,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Pattern: Filigreed Shadow Gown'),
(255699,0,253910,0.943,0,1,0,1,1,'wowhead: 1 of 106 kills - Pattern: Filigreed Pearly Gown');

-- Lordaeron Captain: abilities (Wowhead list; timers INFERRED)
DELETE FROM `smart_scripts` WHERE `entryorguid` = 255699 AND `source_type` = 0;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(255699,0,0,0,'',4,0,100,0,0,0,0,0,0,'',11,7165,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Lordaeron Captain - On Aggro - Cast 7165 (Battle Stance) on Self'),
(255699,0,1,0,'',0,0,100,0,4000,7000,8000,12000,0,'',11,5532,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Lordaeron Captain - In Combat - Cast 5532 (Cleave) on Victim (INFERRED timer)'),
(255699,0,2,0,'',0,0,100,0,6000,10000,12000,18000,0,'',11,9080,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'Lordaeron Captain - In Combat - Cast 9080 (Hamstring) on Victim (INFERRED timer)');

-- Lordaeron Captain: a rare, so one spawn in a pool that is up 20% of the time (INFERRED chance), walking the sniffed western
-- patrol of Skeletal Soldier 21300107 (path 213001070), copied to its own path
DELETE FROM `pool_members` WHERE `type` = 0 AND `spawnId` = 21300900;
DELETE FROM `pool_template` WHERE `entry` = 21300900;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES
(21300900,1,'Ruins of Lordaeron - Lordaeron Captain (rare, 20% INFERRED)');
DELETE FROM `creature` WHERE `guid` = 21300900;
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`modelid`,`equipment_id`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`VerifiedBuild`) VALUES
(21300900,255699,2999,0,0,'1',0,0,0,-1,1708.78,415.264,61.6564,3.29,0,0,86400,0,0,100,2,NULL,NULL,NULL,NULL,'',0);
INSERT INTO `pool_members` (`type`,`spawnId`,`poolSpawnId`,`chance`,`description`) VALUES
(0,21300900,21300900,20,'Lordaeron Captain (INFERRED chance)');
DELETE FROM `creature_addon` WHERE `guid` = 21300900;
INSERT INTO `creature_addon` (`guid`,`PathId`) VALUES
(21300900,213009000);
DELETE FROM `waypoint_path` WHERE `PathId` = 213009000;
INSERT INTO `waypoint_path` (`PathId`,`MoveType`,`Flags`,`Velocity`,`Comment`) VALUES
(213009000,0,0,NULL,'Lordaeron Captain - western patrol (sniffed path 213001070 of Skeletal Soldier 21300107)');
DELETE FROM `waypoint_path_node` WHERE `PathId` = 213009000;
INSERT INTO `waypoint_path_node` (`PathId`,`NodeId`,`PositionX`,`PositionY`,`PositionZ`,`Orientation`,`Delay`) VALUES
(213009000,0,1708.78,415.264,61.6564,NULL,0),
(213009000,1,1691.53,412.753,62.0055,NULL,0),
(213009000,2,1678.43,419.064,61.6564,NULL,0),
(213009000,3,1665.38,413.931,61.6564,NULL,0),
(213009000,4,1655.74,411.259,61.6564,NULL,0),
(213009000,5,1639.41,406.887,61.6564,NULL,0),
(213009000,6,1635.04,412.076,61.6564,NULL,0),
(213009000,7,1641.44,424.373,61.5898,NULL,0),
(213009000,8,1657.03,423.88,61.5898,NULL,0),
(213009000,9,1671.49,421.917,61.6495,NULL,0),
(213009000,10,1683.01,430.34,61.5898,NULL,0),
(213009000,11,1707.63,428.286,61.5898,NULL,0),
(213009000,12,1721.51,423.264,61.6564,NULL,0);

-- Viktor the Vile: no standing spawn. The one from 2026_11_05_99 (AnoCore) stands inside the copied Undercity at z -84.8, below
-- the dungeon. He comes out of the fireplace after the waves instead.
DELETE FROM `creature` WHERE `map` = 2999 AND `id` = 256035;
-- his boss state comes from the instance script's encounter tracker (boss 5); rows 90/91 set it by hand and never sent FAIL
DELETE FROM `smart_scripts` WHERE `entryorguid` = 256035 AND `source_type` = 0 AND `id` IN (50,90,91);
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(256035,0,50,0,'',38,0,100,0,2,1,0,0,0,'',38,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Viktor the Vile - On Data Set 2 1 (out of the fireplace) - Engage the instance');

-- the fireplace: one use per instance starts five waves, 50 s apart (INFERRED), then Viktor comes out of the fireplace
UPDATE `gameobject_template` SET `AIName` = 'SmartGameObjectAI' WHERE `entry` = 616225;
DELETE FROM `smart_scripts` WHERE `entryorguid` = -21300410 AND `source_type` = 1;
DELETE FROM `smart_scripts` WHERE `entryorguid` = 25603500 AND `source_type` = 9;
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`) VALUES
(-21300410,1,0,0,'',64,0,100,1,0,0,0,0,0,'',80,25603500,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'Warm Kindling (fireplace) - On Use - Start the waves (once per instance)'),
(25603500,9,0,0,'',0,0,100,0,0,0,0,0,0,'',12,250618,4,120000,1,0,0,0,'',8,0,0,0,0,'',1510.94,403.524,61.5898,4.073,'Warm Kindling - Wave 1 - Summon Skeleton (INFERRED)'),
(25603500,9,1,0,'',0,0,100,0,0,0,0,0,0,'',12,250618,4,120000,2,0,0,0,'',8,0,0,0,0,'',1467.52,384.403,61.7516,0.007,'Warm Kindling - Wave 1 - Summon Skeleton (INFERRED)'),
(25603500,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,250618,4,120000,3,0,0,0,'',8,0,0,0,0,'',1501.48,354.325,61.6731,1.721,'Warm Kindling - Wave 1 - Summon Skeleton (INFERRED)'),
(25603500,9,3,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 1 - Skeleton engages (Set Data 2 1)'),
(25603500,9,4,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,2,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 1 - Skeleton engages (Set Data 2 1)'),
(25603500,9,5,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,3,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 1 - Skeleton engages (Set Data 2 1)'),
(25603500,9,6,0,'',0,0,100,0,50000,50000,0,0,0,'',12,250627,4,120000,1,0,0,0,'',8,0,0,0,0,'',1515.42,399.112,61.5898,3.805,'Warm Kindling - Wave 2 after 50 s - Summon Ghoul (INFERRED)'),
(25603500,9,7,0,'',0,0,100,0,0,0,0,0,0,'',12,250627,4,120000,2,0,0,0,'',8,0,0,0,0,'',1465.81,385.822,61.5898,6.245,'Warm Kindling - Wave 2 after 50 s - Summon Ghoul (INFERRED)'),
(25603500,9,8,0,'',0,0,100,0,0,0,0,0,0,'',12,250627,4,120000,3,0,0,0,'',8,0,0,0,0,'',1505.89,349.029,61.7186,1.818,'Warm Kindling - Wave 2 after 50 s - Summon Ghoul (INFERRED)'),
(25603500,9,9,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 2 - Ghoul engages (Set Data 2 1)'),
(25603500,9,10,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,2,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 2 - Ghoul engages (Set Data 2 1)'),
(25603500,9,11,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,3,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 2 - Ghoul engages (Set Data 2 1)'),
(25603500,9,12,0,'',0,0,100,0,50000,50000,0,0,0,'',12,250626,4,120000,1,0,0,0,'',8,0,0,0,0,'',1510.94,403.524,61.5898,4.073,'Warm Kindling - Wave 3 after 50 s - Summon Skeletal Soldier (INFERRED)'),
(25603500,9,13,0,'',0,0,100,0,0,0,0,0,0,'',12,250626,4,120000,2,0,0,0,'',8,0,0,0,0,'',1467.52,384.403,61.7516,0.007,'Warm Kindling - Wave 3 after 50 s - Summon Skeletal Soldier (INFERRED)'),
(25603500,9,14,0,'',0,0,100,0,0,0,0,0,0,'',12,250624,4,120000,3,0,0,0,'',8,0,0,0,0,'',1501.48,354.325,61.6731,1.721,'Warm Kindling - Wave 3 after 50 s - Summon Skeletal Mage (INFERRED)'),
(25603500,9,15,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 3 - Skeletal Soldier engages (Set Data 2 1)'),
(25603500,9,16,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,2,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 3 - Skeletal Soldier engages (Set Data 2 1)'),
(25603500,9,17,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,3,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 3 - Skeletal Mage engages (Set Data 2 1)'),
(25603500,9,18,0,'',0,0,100,0,50000,50000,0,0,0,'',12,250630,4,120000,1,0,0,0,'',8,0,0,0,0,'',1515.42,399.112,61.5898,3.805,'Warm Kindling - Wave 4 after 50 s - Summon Plague Ghoul (INFERRED)'),
(25603500,9,19,0,'',0,0,100,0,0,0,0,0,0,'',12,250627,4,120000,2,0,0,0,'',8,0,0,0,0,'',1465.81,385.822,61.5898,6.245,'Warm Kindling - Wave 4 after 50 s - Summon Ghoul (INFERRED)'),
(25603500,9,20,0,'',0,0,100,0,0,0,0,0,0,'',12,250630,4,120000,3,0,0,0,'',8,0,0,0,0,'',1505.89,349.029,61.7186,1.818,'Warm Kindling - Wave 4 after 50 s - Summon Plague Ghoul (INFERRED)'),
(25603500,9,21,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 4 - Plague Ghoul engages (Set Data 2 1)'),
(25603500,9,22,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,2,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 4 - Ghoul engages (Set Data 2 1)'),
(25603500,9,23,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,3,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 4 - Plague Ghoul engages (Set Data 2 1)'),
(25603500,9,24,0,'',0,0,100,0,50000,50000,0,0,0,'',12,250626,4,120000,1,0,0,0,'',8,0,0,0,0,'',1510.94,403.524,61.5898,4.073,'Warm Kindling - Wave 5 after 50 s - Summon Skeletal Soldier (INFERRED)'),
(25603500,9,25,0,'',0,0,100,0,0,0,0,0,0,'',12,250624,4,120000,2,0,0,0,'',8,0,0,0,0,'',1467.52,384.403,61.7516,0.007,'Warm Kindling - Wave 5 after 50 s - Summon Skeletal Mage (INFERRED)'),
(25603500,9,26,0,'',0,0,100,0,0,0,0,0,0,'',12,250630,4,120000,3,0,0,0,'',8,0,0,0,0,'',1501.48,354.325,61.6731,1.721,'Warm Kindling - Wave 5 after 50 s - Summon Plague Ghoul (INFERRED)'),
(25603500,9,27,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 5 - Skeletal Soldier engages (Set Data 2 1)'),
(25603500,9,28,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,2,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 5 - Skeletal Mage engages (Set Data 2 1)'),
(25603500,9,29,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,3,0,0,0,'',0,0,0,0,'Warm Kindling - Wave 5 - Plague Ghoul engages (Set Data 2 1)'),
(25603500,9,30,0,'',0,0,100,0,20000,20000,0,0,0,'',12,256035,6,300000,1,0,0,0,'',8,0,0,0,0,'',1496.89,384.622,62.4043,6.204,'Warm Kindling - 20 s after wave 5 - Viktor the Vile comes out of the fireplace (INFERRED timing)'),
(25603500,9,31,0,'',0,0,100,0,0,0,0,0,0,'',45,2,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'Warm Kindling - Viktor the Vile engages (Set Data 2 1)');
