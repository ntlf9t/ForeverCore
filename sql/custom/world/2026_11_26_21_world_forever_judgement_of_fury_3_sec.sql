-- WoW Forever build 1.60.1.70755 (notes "About this build", 4 November 2026): "Paladin: Judgement of Fury's duration reduced to 3 seconds
-- (Was 4 seconds)." The taunt 9970901 (2026_11_19_65) goes from DurationIndex 35 (4 sec) to 27 (3 sec); classic_spell_pal_judgement_of_fury
-- casts it with a 3 sec duration as well. Safe to run again.
UPDATE `serverside_spell` SET `DurationIndex` = 27 WHERE `Id` = 9970901 AND `DurationIndex` = 35;
