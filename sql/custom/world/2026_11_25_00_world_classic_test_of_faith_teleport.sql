-- Quest 1149 (Test of Faith): Dorn Plainstalker casts 6716 on accept, which roots the player and triggers 6714 after 3 s.
-- 6714 teleports to TARGET_DEST_DB but had no spell_target_position row, so the player stayed next to Dorn.
-- Destination: the planks overlooking Thousand Needles, facing area trigger 246 (-4932.5, -1596.0, 84.8, radius 20) below.
DELETE FROM `spell_target_position` WHERE `ID` = 6714 AND `EffectIndex` = 0;
INSERT INTO `spell_target_position` (`ID`, `EffectIndex`, `OrderIndex`, `MapID`, `PositionX`, `PositionY`, `PositionZ`, `Orientation`, `VerifiedBuild`) VALUES
(6714, 0, 0, 1, -4884.49, -1596.2, 101.2, 3.17, 0);
