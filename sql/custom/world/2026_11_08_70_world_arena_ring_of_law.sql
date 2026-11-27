-- Arenas 2v2 / 3v3 in the Ring of Law (map 3200, an arena copy of Blackrock Depths; hotfixes 2026_11_08_70).
-- Team 1 starts in the south tunnel, where the Ring of Law fighters come out, behind gate 161525; team 2 in the east tunnel,
-- where the Ring of Law boss comes out, behind gate 161522 (script arena_ring_of_law opens both at the start). Spots are the
-- Blackrock Depths script's own spawn points for those fighters (classic_blackrock_depths.cpp), facing the ring centre
-- (596.3, -188.7). The gates hold the teams in during preparation, so StartMaxDist is only a safety net: 30 yards.
SET @RING_A_X := 608.960, @RING_A_Y := -235.322, @RING_A_Z := -53.907, @RING_A_O := 1.857;
SET @RING_H_X := 644.300, @RING_H_Y := -175.989, @RING_H_Z := -53.739, @RING_H_O := 3.418;

DELETE FROM `world_safe_locs` WHERE `ID` IN (1104112,1104113);
INSERT INTO `world_safe_locs` (`ID`,`MapID`,`LocX`,`LocY`,`LocZ`,`Facing`,`Comment`) VALUES
(1104112,3200,@RING_A_X,@RING_A_Y,@RING_A_Z,@RING_A_O,'Ring of Law arena - team 1 start (south tunnel)'),
(1104113,3200,@RING_H_X,@RING_H_Y,@RING_H_Z,@RING_H_O,'Ring of Law arena - team 2 start (east tunnel)');

DELETE FROM `battleground_template` WHERE `ID` IN (6,1169);
INSERT INTO `battleground_template` (`ID`,`AllianceStartLoc`,`HordeStartLoc`,`StartMaxDist`,`Weight`,`ScriptName`,`Comment`) VALUES
(6,1104112,1104113,0,1,'','All Arenas'),
(1169,1104112,1104113,30,1,'','Mak''gora Arena (Ring of Law)');
