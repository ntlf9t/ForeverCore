-- Classic Scourge invasion camps use one fixed model per creature. These retail
-- model rows had a zero probability and were therefore discarded at load time.
UPDATE `creature_template_model`
SET `Probability` = 100
WHERE `CreatureID` IN (16141, 16298, 16299, 16380)
  AND `Idx` = 0
  AND `Probability` = 0;
