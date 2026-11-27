-- Merchant's Favor prices of the trade company recipe vendors at the Crossroads. 2026_10_10_03 added server-only estimates
-- (VerifiedBuild 0, no hotfix_data) because client 70338 had no rows for these ItemExtendedCost IDs. The client has them now
-- (checked: all 22 IDs are in ItemExtendedCost.db2), so the vendor window showed the client price while the server charged the
-- estimate, e.g. Pawani's Pattern: Wisdom's Leather Gloves (11865): shown 30 Favor, charged 90. Removing the estimates makes the
-- server use the client rows. Karrz1/TrinityCore issue #350. Safe to run again.
DELETE FROM `item_extended_cost` WHERE `VerifiedBuild` = 0 AND `ID` IN (11840,11845,11848,11849,11850,11851,11852,11855,11856,11857,
  11858,11859,11860,11861,11864,11865,11866,11867,11869,11870,11871,11872);
