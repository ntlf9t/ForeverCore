-- WoW Forever, build 70755: "Mage: Frost Blast: This spell has been removed." Mage trainers still taught Frost Blast 1326053-1326055
-- (2026_10_26_40_world_classic_trainer_untaught_ranks.sql and the restored trainer lists). Safe to run again.
DELETE FROM `trainer_spell` WHERE `SpellId` IN (1326053, 1326054, 1326055);
