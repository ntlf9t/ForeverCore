-- Town heralds for Rend Blackhand's head, the way live WoW Forever has had them since 2026-11-12. Blizzard's quest designer
-- (@QuestTheLine, quoted by Warcraft Tavern 2026-11-12): the Heralds of Thrall now buff people "in not just the Crossroads but the
-- Razor Hill guard tower as well", and new Stormwind Criers do the same for the Alliance in Goldshire, Lakeshire and Sentinel Hill.
-- Places: where players saw them on live (Icy Veins addon sightings of npc 10719 and 269863, the busiest point per town, turned
-- into world coordinates with the client's UiMapAssignment); heights from spawns standing there. Safe to run again.

-- Herald of Thrall (10719): Thrall's turn-in script (actionlist 950000229, quest 4974) already summons one at the Crossroads for
-- 30 sec, but its spawn script was lost in the VMaNGOS conversion, so it stood there silent. VMaNGOS generic_scripts 10719
-- (migration 20230616201152): unattackable, says 6013 at 3 sec and 6015 at 13 sec, casts Warchief's Blessing at 15 sec. Texts as
-- AzerothCore has them for the same broadcast ids.
UPDATE `creature_template` SET `unit_flags` = `unit_flags` | 0x300, `AIName` = 'SmartAI' WHERE `entry` = 10719;

DELETE FROM `creature_text` WHERE `CreatureID` = 10719 AND `GroupID` IN (0, 1);
INSERT INTO `creature_text` (`CreatureID`, `GroupID`, `ID`, `Text`, `Type`, `Language`, `Probability`, `Emote`, `Duration`, `Sound`, `BroadcastTextId`, `TextRange`, `comment`) VALUES
(10719, 0, 0, 'Honor your heroes! On this day, they have dealt a great blow against one of our most hated enemies! The false Warchief, Rend Blackhand, has fallen!', 14, 0, 100, 22, 0, 0, 6013, 0, 'Herald of Thrall - Rend turn-in'),
(10719, 1, 0, 'Be bathed in the power of the Warchief! Drink in his might! Battle for the glory of the Horde!', 14, 0, 100, 22, 0, 0, 6015, 0, 'Herald of Thrall - Rend turn-in');

DELETE FROM `smart_scripts` WHERE (`entryorguid` = 10719 AND `source_type` = 0) OR (`entryorguid` = 1071900 AND `source_type` = 9);
-- Thrall (4949): a second herald on top of the Razor Hill guard tower (live: Durotar 49.8 40.3), alongside the Crossroads one
DELETE FROM `smart_scripts` WHERE `entryorguid` = 4949 AND `source_type` = 0 AND `id` = 7;
-- Stormwind Crier (269863): summoned by Major Mattingly when End of the Dark Horde 97883 is turned in; casts Might of Stormwind
DELETE FROM `smart_scripts` WHERE (`entryorguid` = 269863 AND `source_type` = 0) OR (`entryorguid` = 26986300 AND `source_type` = 9);
DELETE FROM `smart_scripts` WHERE `entryorguid` = 14394 AND `source_type` = 0 AND `id` IN (3, 4, 5);

INSERT INTO `smart_scripts` (`entryorguid`, `source_type`, `id`, `link`, `Difficulties`, `event_type`, `event_phase_mask`, `event_chance`, `event_flags`, `event_param1`, `event_param2`, `event_param3`, `event_param4`, `event_param5`, `event_param_string`, `action_type`, `action_param1`, `action_param2`, `action_param3`, `action_param4`, `action_param5`, `action_param6`, `action_param7`, `action_param_string`, `target_type`, `target_param1`, `target_param2`, `target_param3`, `target_param4`, `target_param_string`, `target_x`, `target_y`, `target_z`, `target_o`, `comment`) VALUES
(10719, 0, 0, 0, '', 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 80, 1071900, 2, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Herald of Thrall - On just summoned - Run Rend turn-in script'),
(1071900, 9, 0, 0, '', 0, 0, 100, 0, 3000, 3000, 0, 0, 0, '', 1, 0, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Herald of Thrall - Say line 0'),
(1071900, 9, 1, 0, '', 0, 0, 100, 0, 10000, 10000, 0, 0, 0, '', 1, 1, 0, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Herald of Thrall - Say line 1'),
(1071900, 9, 2, 0, '', 0, 0, 100, 0, 2000, 2000, 0, 0, 0, '', 11, 16609, 2, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Herald of Thrall - Cast Warchief''s Blessing'),
(4949, 0, 7, 0, '', 20, 0, 100, 0, 4974, 0, 0, 0, 0, '', 12, 10719, 3, 30000, 0, 0, 0, 0, '', 8, 0, 0, 0, 0, '', 386.7, -4596.2, 76.17, 1.6, 'Thrall - On quest 4974 rewarded - Summon Herald of Thrall on the Razor Hill tower'),
(269863, 0, 0, 0, '', 54, 0, 100, 0, 0, 0, 0, 0, 0, '', 80, 26986300, 2, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Stormwind Crier - On just summoned - Run Rend turn-in script'),
(26986300, 9, 0, 0, '', 0, 0, 100, 0, 5000, 5000, 0, 0, 0, '', 11, 460939, 2, 0, 0, 0, 0, 0, '', 1, 0, 0, 0, 0, '', 0, 0, 0, 0, 'Stormwind Crier - Cast Might of Stormwind'),
(14394, 0, 3, 0, '', 20, 0, 100, 0, 97883, 0, 0, 0, 0, '', 12, 269863, 3, 30000, 0, 0, 0, 0, '', 8, 0, 0, 0, 0, '', -9451.9, 60.3, 57.0, 0, 'Major Mattingly - On quest 97883 rewarded - Summon Stormwind Crier in Goldshire'),
(14394, 0, 4, 0, '', 20, 0, 100, 0, 97883, 0, 0, 0, 0, '', 12, 269863, 3, 30000, 0, 0, 0, 0, '', 8, 0, 0, 0, 0, '', -9275.5, -2251.5, 63.6, 0, 'Major Mattingly - On quest 97883 rewarded - Summon Stormwind Crier in Lakeshire'),
(14394, 0, 5, 0, '', 20, 0, 100, 0, 97883, 0, 0, 0, 0, '', 12, 269863, 3, 30000, 0, 0, 0, 0, '', 8, 0, 0, 0, 0, '', -10631.3, 1039.5, 34.3, 0, 'Major Mattingly - On quest 97883 rewarded - Summon Stormwind Crier in Sentinel Hill');

-- Stormwind Crier (269863) is a Forever creature the world has no template for. Icy Veins npc 269863: display 2688, level 50,
-- humanoid, warrior class, health x1.25. The rest is copied from the Town Crier (468), a Stormwind crier of the same kind. No
-- source has a line for it, so it does not speak; live's criers ride in from the road, ours appear where they stop.
INSERT INTO `creature_template` (`entry`, `KillCredit1`, `KillCredit2`, `name`, `femaleName`, `subname`, `TitleAlt`, `IconName`, `RequiredExpansion`, `VignetteID`, `faction`, `npcflag`, `speed_walk`, `speed_run`, `scale`, `Classification`, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `family`, `trainer_class`, `type`, `VehicleId`, `AIName`, `MovementType`, `ExperienceModifier`, `RacialLeader`, `movementId`, `WidgetSetID`, `WidgetSetUnitConditionID`, `RegenHealth`, `CreatureImmunitiesId`, `flags_extra`, `ScriptName`, `StringId`, `VerifiedBuild`)
SELECT 269863, 0, 0, 'Stormwind Crier', `femaleName`, NULL, NULL, NULL, `RequiredExpansion`, 0, `faction`, 0, `speed_walk`, `speed_run`, `scale`, 0, `dmgschool`, `BaseAttackTime`, `RangeAttackTime`, `BaseVariance`, `RangeVariance`, 1, `unit_flags` | 0x300, `unit_flags2`, `unit_flags3`, 0, 0, 7, 0, 'SmartAI', 0, `ExperienceModifier`, 0, 0, 0, 0, `RegenHealth`, 0, `flags_extra`, '', NULL, 70532
FROM `creature_template` WHERE `entry` = 468 AND NOT EXISTS (SELECT 1 FROM `creature_template` WHERE `entry` = 269863);

INSERT INTO `creature_template_model` (`CreatureID`, `Idx`, `CreatureDisplayID`, `DisplayScale`, `Probability`, `VerifiedBuild`)
SELECT 269863, 0, 2688, 1, 1, 70532 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `creature_template_model` WHERE `CreatureID` = 269863);

INSERT INTO `creature_template_difficulty` (`Entry`, `DifficultyID`, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, `HealthModifier`, `ManaModifier`, `ArmorModifier`, `DamageModifier`, `CreatureDifficultyID`, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, `LootID`, `PickPocketLootID`, `SkinLootID`, `GoldMin`, `GoldMax`, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, `VerifiedBuild`)
SELECT 269863, 0, `LevelScalingDeltaMin`, `LevelScalingDeltaMax`, `ContentTuningID`, `HealthScalingExpansion`, 1.25, `ManaModifier`, `ArmorModifier`, `DamageModifier`, 0, `TypeFlags`, `TypeFlags2`, `TypeFlags3`, 0, 0, 0, 0, 0, `StaticFlags1`, `StaticFlags2`, `StaticFlags3`, `StaticFlags4`, `StaticFlags5`, `StaticFlags6`, `StaticFlags7`, `StaticFlags8`, 70532
FROM `creature_template_difficulty` WHERE `Entry` = 468 AND `DifficultyID` = 0 AND NOT EXISTS (SELECT 1 FROM `creature_template_difficulty` WHERE `Entry` = 269863);

INSERT INTO `creature_classic_level` (`entry`, `level_min`, `level_max`)
SELECT 269863, 50, 50 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `creature_classic_level` WHERE `entry` = 269863);

-- vanilla stat formulas, as the Herald of Thrall has (2026_10_11_11); health x1.25 from Icy Veins
INSERT INTO `creature_classic_stats` (`entry`, `health_multiplier`, `mana_multiplier`, `armor_multiplier`, `damage_multiplier`, `damage_variance`)
SELECT 269863, 1.25, 1, 1, 1, 0.14 FROM DUAL WHERE NOT EXISTS (SELECT 1 FROM `creature_classic_stats` WHERE `entry` = 269863);
