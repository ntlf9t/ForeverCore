-- WoW Forever riding prices: Apprentice Riding (33388, level 40) costs 100g and Journeyman Riding (33391, level 60) 1,000g at
-- Friendly (method.gg, games.gg; trainers 195 and 1259 already sell Journeyman at 1,000g in our build 70124 sniff). The racial
-- riding trainers had 90g / 900g, which is the price live shows at Honored. The 10% Honored discount comes from
-- Player::GetReputationPriceDiscount, so the stored price is the Friendly one (as in 2026_11_11_13 trainer prices).
UPDATE `trainer_spell` SET `MoneyCost` = 1000000 WHERE `SpellId` = 33388 AND `MoneyCost` = 900000;
UPDATE `trainer_spell` SET `MoneyCost` = 10000000 WHERE `SpellId` = 33391 AND `MoneyCost` = 9000000;
