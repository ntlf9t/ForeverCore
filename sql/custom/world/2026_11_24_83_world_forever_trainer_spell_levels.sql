-- WoW Forever trainer levels from the client's SpellLevels (1.60.1.70959).
--   Hunter list 20 (every hunter trainer): nine spells at ReqLevel 0, so a level 1 hunter could buy them, in a replayed copy of
--   our world on 2026-11-23 (the trainer sniff file 2026_10_01_04 had 0 for them before its rerun). The current file has the
--   levels; these UPDATEs set them again in case a database still holds the old rows. Live's trainers (EG Link, below) agree.
--   Mage list 156: Polymorph (Pig) 28272 at level 25, the client says 60.
-- Not changed: the spells live players have that nothing here teaches (Teleport: Moonglade, Gift of the Wild 1-2, Prayer of
-- Fortitude 1-2, Shank 1, rogue Poised, Seal of Righteousness 21084): no live trainer lists any of them in EG Link's trainer
-- data (builds 70790-71037), while the same trainers list the neighbouring ranks (Mark of the Wild and Power Word: Fortitude to
-- 60, druid Poised), so live teaches them some other way. Teleport: Moonglade comes from the Moonglade quest here
-- (2026_11_14_00).
-- Data from Efficient Games (https://efficient.games), licensed under CC BY 4.0
-- (https://creativecommons.org/licenses/by/4.0/). Source: github.com/JIVESCORP/eg-link-output-wowf 423d6c9, trainers.json of
-- builds 1.60.1.70790-71037. Changed: only read to check which trainers teach these spells. Safe to run again.
UPDATE `trainer_spell` SET `ReqLevel` = 4  WHERE `TrainerId` = 20 AND `SpellId` IN (1978, 13163);   -- Serpent Sting 1, Aspect of the Monkey
UPDATE `trainer_spell` SET `ReqLevel` = 6  WHERE `TrainerId` = 20 AND `SpellId` IN (1130, 3044);    -- Hunter's Mark 1, Arcane Shot 1
UPDATE `trainer_spell` SET `ReqLevel` = 8  WHERE `TrainerId` = 20 AND `SpellId` IN (5116, 14260);   -- Concussive Shot, Raptor Strike 2
UPDATE `trainer_spell` SET `ReqLevel` = 10 WHERE `TrainerId` = 20 AND `SpellId` IN (13165, 13549, 19883); -- Aspect of the Hawk 1, Serpent Sting 2, Track Humanoids
UPDATE `trainer_spell` SET `ReqLevel` = 60 WHERE `TrainerId` = 156 AND `SpellId` = 28272;            -- Polymorph (Pig)
