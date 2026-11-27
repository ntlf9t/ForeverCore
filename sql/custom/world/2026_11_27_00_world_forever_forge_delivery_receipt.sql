-- Forge Delivery Receipt (1269600), cast by the Forged Delivery Receipt (262902, 15 Merchant's Favor): "Slap a forged delivery
-- receipt onto an empty Waylaid Crate, allowing you to return it to the Azeroth Commerce Authority for +50 reputation."
-- classic_spell_item_forge_delivery_receipt turns the labeled Waylaid Crate it is cast on into a Notarized Shipping Container (262917),
-- which the quest Crate Return (93862, world data) takes for the +50 reputation.
-- Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` = 1269600 AND `ScriptName` = 'classic_spell_item_forge_delivery_receipt';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES (1269600, 'classic_spell_item_forge_delivery_receipt');
