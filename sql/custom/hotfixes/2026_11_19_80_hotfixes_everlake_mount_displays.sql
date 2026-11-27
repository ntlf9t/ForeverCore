-- Mount rows 3901-3916 (2026_11_06_70) reach the client as hotfixes but had no MountXDisplay, so the Mount Journal shows no
-- model and the world model falls back to the creature of the MOUNTED aura. That fallback is wrong for Riding Gryphon (3915,
-- spell 3363): it shows the Chromatic Drake (aura creature 15135). Each mount gets its own MountXDisplay with the display the
-- server already uses, and the gryphon gets gryphon display 6852. Values from Karrz1/TrinityCore issue #353 (tested in game there);
-- every display id is in the client's CreatureDisplayInfo. IDs 9902-9917: the client's MountXDisplay ends at 3828, and 9900/9901
-- are ours already. Safe to run again.
DELETE FROM `mount_x_display` WHERE `ID` BETWEEN 9902 AND 9917;
INSERT INTO `mount_x_display` (`ID`,`CreatureDisplayInfoID`,`PlayerConditionID`,`Unknown1100`,`MountID`,`VerifiedBuild`) VALUES
(9902,2408,0,0,3901,70959), -- Palomino Stallion
(9903,2787,0,0,3902,70959), -- Blue Ram
(9904,9991,0,0,3903,70959), -- Panther
(9905,4805,0,0,3904,70959), -- Leopard
(9906,6447,0,0,3905,70959), -- Spotted Panther
(9907,6468,0,0,3906,70959), -- Obsidian Raptor
(9908,4805,0,0,3907,70959), -- Primal Leopard
(9909,6442,0,0,3908,70959), -- Tawny Sabercat
(9910,9714,0,0,3909,70959), -- Golden Sabercat
(9911,10662,0,0,3910,70959), -- Purple Mechanostrider
(9912,10664,0,0,3911,70959), -- Red & Blue Mechanostrider
(9913,9475,0,0,3912,70959), -- Fluorescent Green Mechanostrider
(9914,14329,0,0,3913,70959), -- Swift Dawnsaber
(9915,15293,0,0,3914,70959), -- Chromatic Mount
(9916,6852,0,0,3915,70959), -- Riding Gryphon
(9917,10718,0,0,3916,70959); -- Skeletal Steed

DELETE FROM `hotfix_data` WHERE `Id` BETWEEN 984600 AND 984615 OR (`TableHash` = 2030087241 AND `RecordId` BETWEEN 9902 AND 9917);
INSERT INTO `hotfix_data` (`Id`,`UniqueId`,`TableHash`,`RecordId`,`Status`,`VerifiedBuild`) VALUES
(984600,1281446000,2030087241,9902,1,70959),
(984601,1281446001,2030087241,9903,1,70959),
(984602,1281446002,2030087241,9904,1,70959),
(984603,1281446003,2030087241,9905,1,70959),
(984604,1281446004,2030087241,9906,1,70959),
(984605,1281446005,2030087241,9907,1,70959),
(984606,1281446006,2030087241,9908,1,70959),
(984607,1281446007,2030087241,9909,1,70959),
(984608,1281446008,2030087241,9910,1,70959),
(984609,1281446009,2030087241,9911,1,70959),
(984610,1281446010,2030087241,9912,1,70959),
(984611,1281446011,2030087241,9913,1,70959),
(984612,1281446012,2030087241,9914,1,70959),
(984613,1281446013,2030087241,9915,1,70959),
(984614,1281446014,2030087241,9916,1,70959),
(984615,1281446015,2030087241,9917,1,70959);
