-- Allow Skyborne Paladins to learn One-Handed Swords and Two-Handed Swords
-- from their starter-area Paladin trainer.
DELETE FROM `trainer_spell` WHERE `TrainerId` = 28 AND `SpellId` IN (201, 202);
INSERT INTO `trainer_spell`
    (`TrainerId`, `SpellId`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`,
     `ReqAbility1`, `ReqAbility2`, `ReqAbility3`, `ReqLevel`)
VALUES
(28, 201, 100, 0, 0, 0, 0, 0, 1),
(28, 202, 100, 0, 0, 0, 0, 0, 1);
