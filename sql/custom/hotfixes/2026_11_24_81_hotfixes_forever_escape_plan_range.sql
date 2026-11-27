-- WoW Forever: Escape Plan (287026, gun) shot from melee range (forever-bugs #539). Our row is a live record of build 70862
-- (2026_11_09_41) and has ItemRange 0, as live had before Blizzard's hotfix of 2026-11-17 ("Escape Plan now has correct range
-- and damage values"). Live sends no newer record for it in the public hotfix file, so ItemRange takes the value every gun in
-- the client's 70959 ItemSparse has (100 for all 81 guns with a row there), which is also what live's own fix gave the two wands from the same
-- report (ItemRange 100, push 70888). Damage: the server already uses Forever's 54-102 (classic_item_damage, world
-- 2026_11_21_88), so the item row's damage fields are left as they are.
-- New hotfix_data row (id 2116990) so clients holding the 70862 record take the new one. Safe to run again.
UPDATE `item_sparse` SET `ItemRange` = 100 WHERE `ID` = 287026;
DELETE FROM `hotfix_data` WHERE `Id` = 2116990 OR (`TableHash` = 2442913102 AND `RecordId` = 287026);
INSERT INTO `hotfix_data` (`Id`,`UniqueId`,`TableHash`,`RecordId`,`Status`,`VerifiedBuild`) VALUES
(2116990,1397836990,2442913102,287026,1,70959);
