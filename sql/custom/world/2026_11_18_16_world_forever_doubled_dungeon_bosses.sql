-- Dungeon bosses that could stand twice. Found by replaying the world (TDB forever-2026-10-14, every sql/custom/world
-- file and world-data's files in name order) and listing encounter bosses, boss_ scripts and rares with more than one
-- live spawn per instance map that no single pool limits to one.
--
-- Witherfang 250483 (Ruins of Lordaeron, first boss): the sniff spawn 21300000 walks a patrol (path 213000000) and
-- 2026_10_27_70_world_azeroth_npcs_spawns_paths.sql added 43000408, the same boss seen mid-patrol (1688.9, 54.9 is on
-- that path, 56 yd from the sniff spawn, so the import's 5 yd check and 2026_11_07_95's 20 yd check both missed it).
-- Both spawned; only the first kill gave loot, since that kill finishes the encounter (3353). The import's copy goes.
--
-- Deathsworn Captain 3872 (Shadowfang Keep): two pools on one spot each roll Captain or Tormented Officer 3873, so about
-- 15% of runs had two Captains. Pool 1601 (TrinityCore's: Captain 30%, Officer 70%) stays; the VMaNGOS inline pool
-- 1018183 and its two spawns go.
--
-- Safe to run twice.
DELETE FROM `creature_addon` WHERE `guid` IN (43000408, 20018183, 25072732);
DELETE FROM `creature` WHERE `guid` = 43000408 AND `id` = 250483 AND `map` = 2999;
DELETE FROM `creature` WHERE `guid` = 20018183 AND `id` = 3872 AND `map` = 33;
DELETE FROM `creature` WHERE `guid` = 25072732 AND `id` = 3873 AND `map` = 33;
DELETE FROM `pool_members` WHERE `type` = 0 AND `spawnId` IN (20018183, 25072732) AND `poolSpawnId` = 1018183;
DELETE FROM `pool_template` WHERE `entry` = 1018183;
