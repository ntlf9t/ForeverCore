-- Allow Tauren (race 6) to select Paladin in the character creator.
-- TableHash 812099832 is CharBaseInfo.db2.
DELETE FROM `char_base_info` WHERE `ID` = 9910004;
INSERT INTO `char_base_info`
    (`ID`, `RaceID`, `ClassID`, `OtherFactionRaceID`, `VerifiedBuild`)
VALUES
(9910004, 6, 2, 0, 70959);

DELETE FROM `hotfix_data` WHERE `Id` = 26140004;
INSERT INTO `hotfix_data`
    (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`)
VALUES
(26140004, 1400000004, 812099832, 9910004, 1, 70959);

-- Include Tauren and both Skyborne races in the Human Paladin new-character loadout.
-- The loadout contains starting items 45, 43, 44, 6948, 2361, 159 and 2070.
DELETE FROM `character_loadout` WHERE `ID` = 1558 AND `VerifiedBuild` = 70959;
INSERT INTO `character_loadout`
    (`ID`, `ChrClassID`, `Purpose`, `ItemContext`, `Field_1_60_1_69876_003`,
     `RaceMask1`, `RaceMask2`, `VerifiedBuild`)
VALUES
(1558, 2, 9, 75, 0, 33, 3, 70959);

DELETE FROM `hotfix_data` WHERE `Id` = 26140005;
INSERT INTO `hotfix_data`
    (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`)
VALUES
(26140005, 1400000005, 3758770171, 1558, 1, 70959);
