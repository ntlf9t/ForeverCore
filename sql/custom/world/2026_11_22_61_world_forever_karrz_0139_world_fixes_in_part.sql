-- Karrz 0.1.39 fixes taken in part: the rest of each file is already on Everlake, or Everlake does it its own way.
-- Each section names the Karrz file it comes from (Karrz1/ForeverCore, sql/custom/world). Safe to run again.

-- 2026_11_19_46 (Ruins of Lordaeron, Viktor the Vile): only his creature type. Everlake already runs the Warm Kindling event
-- with its own script (spawn 21300410), so Karrz's event is not taken. EG Link has him as undead (type 6).
UPDATE `creature_template` SET `type` = 6 WHERE `entry` = 256035;

-- 2026_11_19_65 (City of Dalaran): Shrewd Negotiations 97287 is turned in to the Image of Archmage Modera only, as on live
-- (EG Link). The Arcane Mote drops and the Grimy Key objective are Everlake's already.
DELETE FROM `creature_questender` WHERE `quest` = 97287;
INSERT INTO `creature_questender` (`id`,`quest`,`VerifiedBuild`) VALUES
(269127,97287,0);

-- 2026_11_19_86 (map markers): Morbent Fel 55 and Fire Hardened Mail 1701 had only their turn-in marker. Death to the Dragonmaw
-- 98291 keeps Everlake's markers.
DELETE FROM `quest_poi` WHERE `QuestID` IN (55,1701);
INSERT INTO `quest_poi` (`QuestID`,`BlobIndex`,`Idx1`,`ObjectiveIndex`,`QuestObjectiveID`,`QuestObjectID`,`MapID`,`UiMapID`,`Priority`,`Flags`,`WorldEffectID`,`PlayerConditionID`,`NavigationPlayerConditionID`,`SpawnTrackingID`,`AlwaysAllowMergingBlobs`,`VerifiedBuild`) VALUES
(55,0,0,-1,0,0,0,1431,0,1,0,0,0,0,0,0),
(55,0,1,0,90000550,1200,0,1431,0,0,0,0,0,0,0,0),
(1701,0,0,-1,0,0,0,1453,0,1,0,0,0,0,0,0),
(1701,0,1,4,90017014,6838,0,1437,0,0,0,0,0,0,0,0),
(1701,0,2,5,90017015,6839,1,1442,0,0,0,0,0,0,0,0),
(1701,1,3,5,90017015,6839,1,1442,0,0,0,0,0,0,0,0),
(1701,2,4,5,90017015,6839,1,1442,0,0,0,0,0,0,0,0),
(1701,0,5,6,90017016,6840,1,1442,0,0,0,0,0,0,0,0);
DELETE FROM `quest_poi_points` WHERE `QuestID` IN (55,1701);
INSERT INTO `quest_poi_points` (`QuestID`,`Idx1`,`Idx2`,`X`,`Y`,`Z`,`VerifiedBuild`) VALUES
(55,0,0,-10320,623,27,0),
(55,0,1,-10323,630,27,0),
(55,0,2,-10330,633,27,0),
(55,0,3,-10337,630,27,0),
(55,0,4,-10340,623,27,0),
(55,0,5,-10337,616,27,0),
(55,0,6,-10330,613,27,0),
(55,0,7,-10323,616,27,0),
(55,1,0,-10343,377,65,0),
(55,1,1,-10336,359,65,0),
(55,1,2,-10318,352,65,0),
(55,1,3,-10300,359,65,0),
(55,1,4,-10293,377,65,0),
(55,1,5,-10300,395,65,0),
(55,1,6,-10318,402,65,0),
(55,1,7,-10336,395,65,0),
(1701,0,0,-8417,600,95,0),
(1701,0,1,-8420,607,95,0),
(1701,0,2,-8427,610,95,0),
(1701,0,3,-8434,607,95,0),
(1701,0,4,-8437,600,95,0),
(1701,0,5,-8434,593,95,0),
(1701,0,6,-8427,590,95,0),
(1701,0,7,-8420,593,95,0),
(1701,1,0,-4036,-2711,32,0),
(1701,1,1,-4032,-2722,32,0),
(1701,1,2,-3993,-2771,32,0),
(1701,1,3,-3982,-2775,32,0),
(1701,1,4,-3949,-2773,32,0),
(1701,1,5,-3879,-2761,32,0),
(1701,1,6,-3848,-2749,32,0),
(1701,1,7,-3837,-2745,32,0),
(1701,1,8,-3817,-2724,32,0),
(1701,1,9,-3813,-2713,32,0),
(1701,1,10,-3754,-2459,32,0),
(1701,1,11,-3766,-2329,32,0),
(1701,1,12,-3770,-2300,32,0),
(1701,1,13,-3774,-2289,32,0),
(1701,1,14,-3785,-2285,32,0),
(1701,1,15,-3836,-2264,32,0),
(1701,1,16,-3847,-2268,32,0),
(1701,1,17,-3918,-2309,32,0),
(1701,1,18,-3922,-2320,32,0),
(1701,2,0,759,1831,-10,0),
(1701,2,1,766,1813,-10,0),
(1701,2,2,784,1806,-10,0),
(1701,2,3,802,1813,-10,0),
(1701,2,4,809,1831,-10,0),
(1701,2,5,802,1849,-10,0),
(1701,2,6,784,1856,-10,0),
(1701,2,7,766,1849,-10,0),
(1701,3,0,759,1474,-20,0),
(1701,3,1,766,1456,-20,0),
(1701,3,2,784,1449,-20,0),
(1701,3,3,802,1456,-20,0),
(1701,3,4,809,1474,-20,0),
(1701,3,5,802,1492,-20,0),
(1701,3,6,784,1499,-20,0),
(1701,3,7,766,1492,-20,0),
(1701,4,0,535,1642,-10,0),
(1701,4,1,539,1631,-10,0),
(1701,4,2,597,1541,-10,0),
(1701,4,3,608,1537,-10,0),
(1701,4,4,619,1541,-10,0),
(1701,4,5,623,1552,-10,0),
(1701,4,6,567,1710,-10,0),
(1701,4,7,563,1721,-10,0),
(1701,4,8,552,1725,-10,0),
(1701,4,9,541,1721,-10,0),
(1701,4,10,537,1710,-10,0),
(1701,5,0,461,1603,5,0),
(1701,5,1,468,1585,5,0),
(1701,5,2,486,1578,5,0),
(1701,5,3,504,1585,5,0),
(1701,5,4,511,1603,5,0),
(1701,5,5,504,1621,5,0),
(1701,5,6,486,1628,5,0),
(1701,5,7,468,1621,5,0);

-- 2026_11_19_87 (Wetlands): the Khaz Modan Iron and timber spots of Spoils of War 98197, Sylessa Duskwhisper on her floor, and the
-- map areas of Spoils of War and Forced Disarmament 98293. The Dragonmaw armaments and their loot are Everlake's already
-- (Everlake world data spawns them), so Karrz's armament spawns are left out.
UPDATE `gameobject` SET `position_z` = CASE `guid` WHEN 67077400 THEN -12.788 WHEN 67077401 THEN -12.254 WHEN 67077402 THEN -12.421 END WHERE `guid` IN (67077400,67077401,67077402) AND `id` = 670774;
DELETE FROM `gameobject` WHERE `guid` BETWEEN 67077117 AND 67077199 OR `guid` BETWEEN 67077314 AND 67077399 OR `guid` BETWEEN 67077403 AND 67077499;
INSERT INTO `gameobject` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnDifficulties`, `phaseUseFlags`, `PhaseId`, `PhaseGroup`, `terrainSwapMap`, `position_x`, `position_y`, `position_z`, `orientation`, `rotation0`, `rotation1`, `rotation2`, `rotation3`, `spawntimesecs`, `animprogress`, `state`, `ScriptName`, `StringId`, `VerifiedBuild`) VALUES
(67077117, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3677.6, -555.0, -15.997, 5.148, 0, 0, 0.537604, -0.843198, 300, 255, 1, '', NULL, 0),
(67077118, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3537.1, -583.9, -17.392, 1.333, 0, 0, 0.618239, 0.78599, 300, 255, 1, '', NULL, 0),
(67077119, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3854.0, -641.8, -12.693, 3.2, 0, 0, 0.999574, -0.0292, 300, 255, 1, '', NULL, 0),
(67077120, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3542.6, -724.6, -12.199, 1.855, 0, 0, 0.800123, 0.599836, 300, 255, 1, '', NULL, 0),
(67077121, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3556.4, -836.2, -13.258, 2.633, 0, 0, 0.967841, 0.251564, 300, 255, 1, '', NULL, 0),
(67077122, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3589.4, -947.9, -13.355, 1.291, 0, 0, 0.601598, 0.798799, 300, 255, 1, '', NULL, 0),
(67077123, 670771, 0, 0, 0, '0', 0, 0, 0, -1, -3821.0, -964.4, -17.194, 3.653, 0, 0, 0.967486, -0.252926, 300, 255, 1, '', NULL, 0),
(67077314, 670773, 0, 0, 0, '0', 0, 0, 0, -1, -3481.9, -674.9, -21.64, 5.859, 0, 0, 0.210506, -0.977593, 300, 255, 1, '', NULL, 0),
(67077315, 670773, 0, 0, 0, '0', 0, 0, 0, -1, -3487.5, -674.9, -21.948, 3.23, 0, 0, 0.999023, -0.044189, 300, 255, 1, '', NULL, 0),
(67077316, 670773, 0, 0, 0, '0', 0, 0, 0, -1, -3614.2, -898.2, -12.139, 2.966, 0, 0, 0.996148, 0.087684, 300, 255, 1, '', NULL, 0),
(67077403, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3703.8, -501.2, -15.633, 1.995, 0, 0, 0.840118, 0.542404, 300, 255, 1, '', NULL, 0),
(67077404, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3856.8, -517.8, -18.142, 4.394, 0, 0, 0.810258, -0.586073, 300, 255, 1, '', NULL, 0),
(67077405, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3764.5, -532.3, -20.039, 1.98, 0, 0, 0.836026, 0.54869, 300, 255, 1, '', NULL, 0),
(67077406, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3592.2, -596.4, -15.918, 1.653, 0, 0, 0.735565, 0.677454, 300, 255, 1, '', NULL, 0),
(67077407, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3597.7, -596.4, -16.352, 3.671, 0, 0, 0.96517, -0.261623, 300, 255, 1, '', NULL, 0),
(67077408, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3696.9, -600.5, -11.923, 1.886, 0, 0, 0.809324, 0.587363, 300, 255, 1, '', NULL, 0),
(67077409, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3743.8, -637.7, -12.412, 0.949, 0, 0, 0.456894, 0.889521, 300, 255, 1, '', NULL, 0),
(67077410, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3454.4, -650.1, -22.902, 3.182, 0, 0, 0.999796, -0.020202, 300, 255, 1, '', NULL, 0),
(67077411, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3459.9, -650.1, -23.138, 5.2, 0, 0, 0.515501, -0.856889, 300, 255, 1, '', NULL, 0),
(67077412, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3570.1, -670.8, -12.583, 1.121, 0, 0, 0.53161, 0.846989, 300, 255, 1, '', NULL, 0),
(67077413, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3564.6, -674.9, -12.811, 1.703, 0, 0, 0.75227, 0.658855, 300, 255, 1, '', NULL, 0),
(67077414, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3917.4, -716.3, -15.171, 4.54, 0, 0, 0.765355, -0.643608, 300, 255, 1, '', NULL, 0),
(67077415, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3925.7, -720.4, -15.717, 4.702, 0, 0, 0.71077, -0.703424, 300, 255, 1, '', NULL, 0),
(67077416, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3437.8, -774.2, -9.946, 0.326, 0, 0, 0.162279, 0.986745, 300, 255, 1, '', NULL, 0),
(67077417, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3435.1, -782.4, -9.415, 5.335, 0, 0, 0.456531, -0.889707, 300, 255, 1, '', NULL, 0),
(67077418, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3553.6, -799.0, -12.997, 2.501, 0, 0, 0.949142, 0.314848, 300, 255, 1, '', NULL, 0),
(67077419, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3600.5, -968.5, -16.457, 5.315, 0, 0, 0.465405, -0.885098, 300, 255, 1, '', NULL, 0),
(67077420, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3691.4, -1001.6, -15.859, 5.356, 0, 0, 0.447164, -0.894452, 300, 255, 1, '', NULL, 0),
(67077421, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3818.2, -1018.2, -32.054, 0.084, 0, 0, 0.041988, 0.999118, 300, 255, 1, '', NULL, 0),
(67077422, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3812.7, -1022.3, -31.978, 0.666, 0, 0, 0.32688, 0.945066, 300, 255, 1, '', NULL, 0),
(67077423, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3597.7, -1047.1, -16.581, 0.616, 0, 0, 0.303153, 0.952942, 300, 255, 1, '', NULL, 0),
(67077424, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3592.2, -1051.2, -16.589, 1.198, 0, 0, 0.563817, 0.8259, 300, 255, 1, '', NULL, 0),
(67077425, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3641.8, -1055.4, -32.052, 2.665, 0, 0, 0.971742, 0.236047, 300, 255, 1, '', NULL, 0),
(67077426, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3650.1, -1059.5, -32.052, 2.827, 0, 0, 0.987654, 0.156648, 300, 255, 1, '', NULL, 0),
(67077427, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3716.2, -1096.7, -45.128, 1.852, 0, 0, 0.799222, 0.601036, 300, 255, 1, '', NULL, 0),
(67077428, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3754.8, -1111.2, -32.028, 4.742, 0, 0, 0.696561, -0.717498, 300, 255, 1, '', NULL, 0),
(67077429, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3760.3, -1111.2, -32.165, 0.477, 0, 0, 0.236245, 0.971693, 300, 255, 1, '', NULL, 0),
(67077430, 670774, 0, 0, 0, '0', 0, 0, 0, -1, -3749.3, -1179.4, -32.049, 2.758, 0, 0, 0.981663, 0.190623, 300, 255, 1, '', NULL, 0);
UPDATE `creature` SET `position_z` = 16.226 WHERE `guid` = 27084400 AND `id` = 270844;
DELETE FROM `quest_poi` WHERE `QuestID` IN (98197,98293);
INSERT INTO `quest_poi` (`QuestID`,`BlobIndex`,`Idx1`,`ObjectiveIndex`,`QuestObjectiveID`,`QuestObjectID`,`MapID`,`UiMapID`,`Priority`,`Flags`,`WorldEffectID`,`PlayerConditionID`,`NavigationPlayerConditionID`,`SpawnTrackingID`,`AlwaysAllowMergingBlobs`,`VerifiedBuild`) VALUES
(98197,0,0,-1,0,0,0,1437,0,1,0,0,0,0,0,0),
(98197,0,1,0,9400394,279821,0,1437,0,0,0,0,0,0,0,0),
(98197,0,2,1,9400395,279822,0,1437,0,0,0,0,0,0,0,0),
(98197,1,3,1,9400395,279822,0,1437,0,0,0,0,0,0,0,0),
(98197,2,4,1,9400395,279822,0,1437,0,0,0,0,0,0,0,0),
(98293,0,0,-1,0,0,0,1437,0,1,0,0,0,0,0,0),
(98293,0,1,0,477300,280369,0,1437,0,0,0,0,0,0,0,0);
DELETE FROM `quest_poi_points` WHERE `QuestID` IN (98197,98293);
INSERT INTO `quest_poi_points` (`QuestID`,`Idx1`,`Idx2`,`X`,`Y`,`Z`,`VerifiedBuild`) VALUES
(98197,0,0,-3706,-807,10,0),
(98197,0,1,-3709,-800,10,0),
(98197,0,2,-3716,-797,10,0),
(98197,0,3,-3723,-800,10,0),
(98197,0,4,-3726,-807,10,0),
(98197,0,5,-3723,-814,10,0),
(98197,0,6,-3716,-817,10,0),
(98197,0,7,-3709,-814,10,0),
(98197,1,0,-4023,-592,-17,0),
(98197,1,1,-4021,-600,-17,0),
(98197,1,2,-4016,-611,-17,0),
(98197,1,3,-3947,-777,-17,0),
(98197,1,4,-3832,-975,-17,0),
(98197,1,5,-3757,-1095,-17,0),
(98197,1,6,-3747,-1099,-17,0),
(98197,1,7,-3634,-1099,-17,0),
(98197,1,8,-3623,-1095,-17,0),
(98197,1,9,-3460,-781,-17,0),
(98197,1,10,-3456,-770,-17,0),
(98197,1,11,-3464,-667,-17,0),
(98197,1,12,-3469,-656,-17,0),
(98197,1,13,-3526,-573,-17,0),
(98197,1,14,-3537,-569,-17,0),
(98197,1,15,-3669,-540,-17,0),
(98197,1,16,-3893,-515,-17,0),
(98197,1,17,-3903,-520,-17,0),
(98197,1,18,-4019,-582,-17,0),
(98197,2,0,-3833,-1018,-23,0),
(98197,2,1,-3829,-1029,-23,0),
(98197,2,2,-3760,-1190,-23,0),
(98197,2,3,-3749,-1194,-23,0),
(98197,2,4,-3739,-1190,-23,0),
(98197,2,5,-3582,-1062,-23,0),
(98197,2,6,-3424,-793,-23,0),
(98197,2,7,-3420,-782,-23,0),
(98197,2,8,-3423,-774,-23,0),
(98197,2,9,-3427,-764,-23,0),
(98197,2,10,-3438,-759,-23,0),
(98197,2,11,-3554,-784,-23,0),
(98197,2,12,-3564,-788,-23,0),
(98197,2,13,-3829,-1008,-23,0),
(98197,3,0,-3941,-720,-15,0),
(98197,3,1,-3936,-731,-15,0),
(98197,3,2,-3926,-735,-15,0),
(98197,3,3,-3915,-731,-15,0),
(98197,3,4,-3907,-727,-15,0),
(98197,3,5,-3868,-702,-15,0),
(98197,3,6,-3864,-691,-15,0),
(98197,3,7,-3868,-681,-15,0),
(98197,3,8,-3879,-676,-15,0),
(98197,3,9,-3889,-681,-15,0),
(98197,3,10,-3936,-710,-15,0),
(98197,4,0,-3872,-518,-17,0),
(98197,4,1,-3867,-528,-17,0),
(98197,4,2,-3754,-648,-17,0),
(98197,4,3,-3744,-653,-17,0),
(98197,4,4,-3565,-690,-17,0),
(98197,4,5,-3454,-665,-17,0),
(98197,4,6,-3444,-661,-17,0),
(98197,4,7,-3439,-650,-17,0),
(98197,4,8,-3444,-639,-17,0),
(98197,4,9,-3693,-491,-17,0),
(98197,4,10,-3704,-486,-17,0),
(98197,4,11,-3857,-503,-17,0),
(98197,4,12,-3867,-507,-17,0),
(98293,0,0,-3722,-797,27,0),
(98293,0,1,-3725,-790,27,0),
(98293,0,2,-3732,-787,27,0),
(98293,0,3,-3740,-790,27,0),
(98293,0,4,-3742,-797,27,0),
(98293,0,5,-3740,-804,27,0),
(98293,0,6,-3732,-807,27,0),
(98293,0,7,-3725,-804,27,0),
(98293,1,0,-3508,-3330,23,0),
(98293,1,1,-3483,-3499,23,0),
(98293,1,2,-3479,-3510,23,0),
(98293,1,3,-3448,-3556,23,0),
(98293,1,4,-3438,-3560,23,0),
(98293,1,5,-3427,-3556,23,0),
(98293,1,6,-3402,-3539,23,0),
(98293,1,7,-3398,-3528,23,0),
(98293,1,8,-3343,-2958,23,0),
(98293,1,9,-3368,-2842,23,0),
(98293,1,10,-3372,-2831,23,0),
(98293,1,11,-3383,-2827,23,0),
(98293,1,12,-3386,-2827,23,0),
(98293,1,13,-3396,-2831,23,0),
(98293,1,14,-3400,-2842,23,0),
(98293,1,15,-3489,-3218,23,0);

-- 2026_11_20_61, part 2 (Eagle's Fist 79975 / This Must Be The Place 79976): the Messenger Bag and the satchel on the floor.
-- Part 1 (Brewer's Trade 98071) is Everlake's already, with its own Homebrew Hops spawns.
UPDATE `gameobject` SET `position_z`=90.41 WHERE `guid`=40691800 AND `id`=406918;
UPDATE `gameobject` SET `position_z`=90.38 WHERE `guid`=42400600 AND `id`=424006;

-- 2026_11_21_67 (Wetlands, Nightveiled Rotheap 270589): one up at a time. Everlake has 31 of Karrz's 57 spawns left, so the pool
-- is built from the spawns that exist.
DELETE FROM `pool_members` WHERE `type` = 0 AND `spawnId` BETWEEN 27058900 AND 27058956;
DELETE FROM `pool_template` WHERE `entry` = 2705890;
INSERT INTO `pool_template` (`entry`,`max_limit`,`description`) VALUES (2705890,1,'Wetlands - Nightveiled Rotheap, one at a time');
INSERT INTO `pool_members` (`type`,`spawnId`,`poolSpawnId`,`chance`,`description`)
SELECT 0,`guid`,2705890,0,'Nightveiled Rotheap' FROM `creature` WHERE `id` = 270589 AND `guid` BETWEEN 27058900 AND 27058956;

-- 2026_11_21_81 (Thousand Needles, Heed My Call 79366): the Ravaging Tempest 216474, its Eye of the Tempest drop, and the waves the
-- Cleansing Ritual (spell 1282953) starts (event 102554). Everlake already has the three quests, but nothing dropped the eye.
-- The wave elementals and Ailgrha Splittusk come from 2026_11_22_60. INFERRED by Karrz: wave order, 45 s spacing, spots.
DELETE FROM `creature_template` WHERE `entry`=216474;
DELETE FROM `creature_template_model` WHERE `CreatureID`=216474;
DELETE FROM `creature_template_difficulty` WHERE `Entry`=216474;
DELETE FROM `creature_classic_level` WHERE `entry`=216474;
INSERT INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 216474,0,0,'Ravaging Tempest',`femaleName`,NULL,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,0,`speed_walk`,`speed_run`,`scale`,1,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,8,`unit_flags`,`unit_flags2`,`unit_flags3`,0,`trainer_class`,4,`VehicleId`,'',`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,'',`StringId`,70959 FROM `creature_template` WHERE `entry`=278382;
INSERT INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES (216474,0,5561,2.0,1.0,70959);
INSERT INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) SELECT 216474,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,2.0,`ManaModifier`,`ArmorModifier`,`DamageModifier`,265961,134217728,67108864,`TypeFlags3`,216474,0,0,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,70959 FROM `creature_template_difficulty` WHERE `Entry`=278382 AND `DifficultyID`=0;
INSERT INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES (216474,40,40);
DELETE FROM `creature_loot_template` WHERE `Entry`=216474;
INSERT INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(216474,0,212792,100,1,1,0,1,1,'Eye of the Tempest (Heed My Call 79366)');
DELETE FROM `event_scripts` WHERE `id`=102554;
INSERT INTO `event_scripts` (`id`,`delay`,`command`,`datalong`,`datalong2`,`dataint`,`x`,`y`,`z`,`o`,`Comment`) VALUES
(102554,0,10,278383,60000,0,-5113.6,-2048.1,-42.57,3.1,'Heed My Call: wave 1 Ravaging Quake Elemental'),
(102554,0,10,278383,60000,0,-5125.3,-2052.5,-46.77,0.4,'Heed My Call: wave 1 Ravaging Quake Elemental'),
(102554,45,10,278382,60000,0,-5110.7,-2056.9,-43.09,2.4,'Heed My Call: wave 2 Ravaging Storm Elemental'),
(102554,45,10,278382,60000,0,-5128.3,-2043.7,-48.86,5.6,'Heed My Call: wave 2 Ravaging Storm Elemental'),
(102554,90,10,278388,60000,0,-5110.7,-2043.7,-42.31,3.9,'Heed My Call: wave 3 Ravaging Drought Elemental'),
(102554,90,10,278388,60000,0,-5128.3,-2052.5,-47.08,0.8,'Heed My Call: wave 3 Ravaging Drought Elemental'),
(102554,135,10,278384,60000,0,-5104.8,-2048.1,-43.53,3.1,'Heed My Call: wave 4 Ravaging Flood Elemental'),
(102554,135,10,278384,60000,0,-5125.3,-2043.7,-46.17,5.6,'Heed My Call: wave 4 Ravaging Flood Elemental'),
(102554,180,10,216463,300000,0,-5128.3,-2048.1,-48.35,0.0,'Heed My Call: final wave Ailgrha Splittusk (elite)'),
(102554,180,10,216474,300000,0,-5113.6,-2048.1,-42.57,3.1,'Heed My Call: final wave Ravaging Tempest (elite, drops the Eye of the Tempest)');
