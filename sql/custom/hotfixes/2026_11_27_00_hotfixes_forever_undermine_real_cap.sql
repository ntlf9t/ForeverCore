-- The Tarnished Undermine Real (CurrencyTypes 3469) holds up to 250, as its item's tooltip (226404, unique 250) and live WoW
-- Forever say (forg.gg's Undermine Real guide: "the in-game tooltip says 250"; 165 was a beta value). The client's
-- CurrencyTypes.db2 still has MaxQty 165, so the core capped every gain there. This sends the record with MaxQty 250 to the
-- server (the hotfix store overrides the DB2 row) and to clients (hotfix_data id 2117470, CurrencyTypes table hash
-- 793851790). Every other field is the client's row. Safe to run again.
DELETE FROM `currency_types` WHERE `ID` = 3469;
INSERT INTO `currency_types` (`ID`, `Name`, `Description`, `CategoryID`, `InventoryIconFileID`, `SpellWeight`, `SpellCategory`, `MaxQty`,
  `MaxEarnablePerWeek`, `Quality`, `FactionID`, `ItemGroupSoundsID`, `XpQuestDifficulty`, `AwardConditionID`, `MaxQtyWorldStateID`,
  `RechargingAmountPerCycle`, `RechargingCycleDurationMS`, `AccountTransferPercentage`, `MaxQtyCurveID`, `OrderIndex`,
  `RecraftReagentCountPercentage`, `OrderSource`, `MCRCurrencyID`, `Flags1`, `Flags2`, `VerifiedBuild`) VALUES
(3469, 'Tarnished Undermine Real', 'This currency is slowly being phased out of circulation, but it still enjoys a very favorable exchange rate at goblin towns throughout the Eastern Kingdoms and Kalimdor.',
  22, 133799, 0, 0, 250, 0, 2, 0, 24, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 33562624, 4, 71139);
DELETE FROM `hotfix_data` WHERE `Id` = 2117470 OR (`TableHash` = 793851790 AND `RecordId` = 3469);
INSERT INTO `hotfix_data` (`Id`, `UniqueId`, `TableHash`, `RecordId`, `Status`, `VerifiedBuild`) VALUES
(2117470, 1397837470, 793851790, 3469, 1, 71139);
