-- Teach Holy Light (635) through the custom Tauren and Skyborne Paladin trainer list.
DELETE FROM `trainer_spell` WHERE `TrainerId` = 28 AND `SpellId` = 635;
INSERT INTO `trainer_spell`
    (`TrainerId`, `SpellId`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`,
     `ReqAbility1`, `ReqAbility2`, `ReqAbility3`, `ReqLevel`)
VALUES
(28, 635, 10, 0, 0, 0, 0, 0, 1);
