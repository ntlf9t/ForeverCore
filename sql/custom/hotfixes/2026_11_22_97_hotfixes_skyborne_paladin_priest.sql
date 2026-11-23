-- Allow both Skyborne races to select Paladin and Priest in the character creator.
-- TableHash 812099832 is CharBaseInfo.db2; record IDs are private to this custom range.
DELETE FROM `char_base_info` WHERE `ID` BETWEEN 9910000 AND 9910003;
INSERT INTO `char_base_info`
    (`ID`, `RaceID`, `ClassID`, `OtherFactionRaceID`, `VerifiedBuild`)
VALUES
(9910000, 95, 2, 96, 70959),
(9910001, 95, 5, 96, 70959),
(9910002, 96, 2, 95, 70959),
(9910003, 96, 5, 95, 70959);

DELETE FROM `hotfix_data` WHERE `Id` BETWEEN 26140000 AND 26140003;
INSERT INTO `hotfix_data`
    (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`)
VALUES
(26140000, 1400000000, 812099832, 9910000, 1, 70959),
(26140001, 1400000001, 812099832, 9910001, 1, 70959),
(26140002, 1400000002, 812099832, 9910002, 1, 70959),
(26140003, 1400000003, 812099832, 9910003, 1, 70959);
