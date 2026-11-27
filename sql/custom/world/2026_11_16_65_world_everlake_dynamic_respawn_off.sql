-- Everlake: our own dynamic respawn groups are off; Karrz 0.1.37's are used instead.
-- Everlake's image put quest targets in spawn group 2 and herb/ore nodes in spawn group 4 (Everlake repo,
-- sql/everlake/2026_11_09_00 .. 2026_11_14_00). Karrz 0.1.37 turns Respawn.DynamicMode on by default and puts the
-- normal outdoor combat creatures of maps 0, 1 and 2991 in SIN's groups 901035/901036 (2026_11_16_66/_67), but those
-- files skip any spawn that is already in a group. This file runs just before them (the updater sorts by file name)
-- and takes every spawn out of groups 2 and 4, so SIN's groups can take the quest creatures.
-- Result: herb and ore nodes and quest objects keep their normal timers; open-world combat creatures, quest targets
-- included, follow Respawn.DynamicMode. The group templates 2 and 4 stay (system groups of the world data).
-- Safe to run again.

DELETE FROM `spawn_group` WHERE `groupId` IN (2, 4);
