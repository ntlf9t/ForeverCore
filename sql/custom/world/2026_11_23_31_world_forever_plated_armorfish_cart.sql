-- Classic 1.60 (WoW Forever): Recipe: Plated Armorfish (286153) could not be had. Live players take it from a supply cart at
-- Ariden's Camp in Deadwind Pass (Wowhead Forever: object 694054 "Recipe: Raw Plated Armorfish", 52.4 34.3; soulbound). The
-- object came in with the 70888 live data (2026_11_13_88) but was never spawned, and its personal loot (chest data30, 144443)
-- was empty.
-- INFERRED: the spot, from Wowhead's map point (Deadwind Pass map -833.3/-3333.3, -9866.7/-11533.3), three yards from the
-- camp's campfire (30013989) and at its height; orientation and the 5 minute respawn are guesses. Safe to run again.
DELETE FROM `gameobject` WHERE `guid` = 69405400;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(69405400, 694054, 0, 0, 0, '0', 0, 0, 0, -1, -10438.3, -2143.3, 90.8, 0, 0, 0, 0, 1, 300, 255, 1, '', NULL, 0);

DELETE FROM `gameobject_loot_template` WHERE `Entry` = 144443 AND `ItemType` = 0 AND `Item` = 286153;
INSERT INTO `gameobject_loot_template` (`Entry`, `ItemType`, `Item`, `Chance`, `QuestRequired`, `LootMode`, `GroupId`, `MinCount`, `MaxCount`, `Comment`) VALUES
(144443, 0, 286153, 100, 0, 1, 0, 1, 1, 'Recipe: Plated Armorfish');
