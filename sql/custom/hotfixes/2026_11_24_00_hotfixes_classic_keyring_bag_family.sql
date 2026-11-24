-- Classic 1.60: keys use the key bag family so the client and server allow them in keyrings.
-- The retail ItemSparse data no longer assigns this legacy family.
UPDATE `item_sparse` AS `s`
INNER JOIN `item` AS `i` ON `i`.`ID` = `s`.`ID`
SET `s`.`BagFamily` = `s`.`BagFamily` | 256
WHERE `i`.`ClassID` = 13;
