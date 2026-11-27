-- Everlake: take the 100 Gold, Level 60 and Max Alchemy products out of the in-game Store.
-- Professions held only Max Alchemy, so its group goes too (the Store sends every group, even an empty one).
DELETE FROM `shop_product_action` WHERE `ProductID` IN (2,14,20);
DELETE FROM `shop_product` WHERE `ID` IN (2,14,20);
DELETE FROM `shop_group` WHERE `ID` = 3;
