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
