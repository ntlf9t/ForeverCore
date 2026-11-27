-- WoW Forever item fixes from Blizzard's notes (the tracker's timeline) on item records our hotfix files already hold:
-- * Squall-breaker's Potion (212982), note of 70959 (2026-11-19): "Squall-breaker's Potion can now be deleted." Our row (70840 push,
--   2026_11_07_40) still has Flags1 65568 = 0x20 ITEM_FLAG_NO_USER_DESTROY; clear that bit.
-- * Formula: Enchant Boots - Speed (289560), note of 70938 (2026-11-16): "Formula: Enchant Boots - Speed from reputation is now
--   bind-on-pickup, as intended." Our row (70790 push, 2026_11_06_40) has Bonding 0; the tracker's live record after 70959 has
--   Bonding 1 (bind on pickup), its only change.
-- * Sparklance Wand (280031), note of 70888 (2026-11-10): "Sparklance Wand now does Arcane damage (was Nature damage)." Our row
--   (70862, 2026_11_09_41) has DamageDamageType 3 (Nature); Arcane is 6.
-- New hotfix_data rows (ids 2117460-2117462) so clients holding the older records take the new ones. Safe to run again.
UPDATE `item_sparse` SET `Flags1` = `Flags1` & ~0x20 WHERE `ID` = 212982;
UPDATE `item_sparse` SET `Bonding` = 1 WHERE `ID` = 289560;
UPDATE `item_sparse` SET `DamageDamageType` = 6 WHERE `ID` = 280031;
DELETE FROM `hotfix_data` WHERE `Id` IN (2117460,2117461,2117462)
    OR (`TableHash` = 2442913102 AND `RecordId` IN (212982,289560,280031));
INSERT INTO `hotfix_data` (`Id`,`UniqueId`,`TableHash`,`RecordId`,`Status`,`VerifiedBuild`) VALUES
(2117460,1397837460,2442913102,212982,1,71139),
(2117461,1397837461,2442913102,289560,1,71139),
(2117462,1397837462,2442913102,280031,1,71139);
