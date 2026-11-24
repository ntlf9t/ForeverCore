-- Allow Tauren and both Skyborne races to learn Holy Light (635).
-- Expands the existing Human/Dwarf SkillLineAbility record 6501 to the
-- race mask bits for Tauren (RaceMask1 bit 32) and Skyborne (RaceMask2 bits 1/2).
DELETE FROM `skill_line_ability` WHERE `ID` = 6501 AND `VerifiedBuild` = 70959;
INSERT INTO `skill_line_ability`
    (`AbilityVerb`, `AbilityAllVerb`, `ID`, `SkillLine`, `Spell`, `MinSkillLineRank`,
     `ClassMask`, `SupercedesSpell`, `AcquireMethod`, `TrivialSkillLineRankHigh`,
     `TrivialSkillLineRankLow`, `Flags`, `NumSkillUps`, `UniqueBit`,
     `TradeSkillCategoryID`, `SkillupSkillLineID`, `Field_5_5_4_67090_0141`,
     `Field_5_5_4_67090_0142`, `RaceMask1`, `RaceMask2`, `VerifiedBuild`)
VALUES
('', '', 6501, 594, 635, 1, 2, 0, 2, 0, 0, 0, 1, 0, 0, 0, 0, 0, 37, 3, 70959);

DELETE FROM `hotfix_data` WHERE `Id` = 26140150;
INSERT INTO `hotfix_data`
    (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`)
VALUES
(26140150, 1400000150, 4282664694, 6501, 1, 70959);
