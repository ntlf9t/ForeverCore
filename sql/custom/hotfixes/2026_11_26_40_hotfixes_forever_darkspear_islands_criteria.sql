-- WoW Forever: Darkspear Islands "Conquering the Isles" (98918) / "Conquering the Island" (98919) need criteria trees
-- 233756 / 233754 ("Win Darkspear Islands while controlling at least three bases"), which are not in the client data we
-- have (encrypted section) nor in the hotfixes. Server only rows (no hotfix_data, the client is not sent them): each tree
-- is one criterion of type 73 (PlayerTriggerGameEvent) on the server game event 299701, which battleground_darkspear_islands
-- gives to the winners when their team holds 3 or more bases at the end. Safe to run again.

DELETE FROM `criteria` WHERE `ID` IN (233754, 233756) AND `VerifiedBuild` = 0;
INSERT INTO `criteria` (`ID`, `Type`, `Asset`, `ModifierTreeId`, `StartEvent`, `StartAsset`, `StartTimer`, `FailEvent`, `FailAsset`, `Flags`, `EligibilityWorldStateID`, `EligibilityWorldStateValue`, `VerifiedBuild`) VALUES
(233754, 73, 299701, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0),
(233756, 73, 299701, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0);

DELETE FROM `criteria_tree` WHERE `ID` IN (233754, 233756) AND `VerifiedBuild` = 0;
INSERT INTO `criteria_tree` (`ID`, `Description`, `Parent`, `Amount`, `Operator`, `CriteriaID`, `OrderIndex`, `Flags`, `VerifiedBuild`) VALUES
(233754, 'Win Darkspear Islands while controlling at least three bases', 0, 1, 0, 233754, 0, 0, 0),
(233756, 'Win Darkspear Islands while controlling at least three bases', 0, 1, 0, 233756, 0, 0, 0);
