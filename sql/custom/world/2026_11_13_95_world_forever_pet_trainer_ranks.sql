-- Hunter pets (audit 11-13): the pet trainers imported from the vanilla data (trainer 1000000 + creature entry: Nalesette Wildbringer,
-- Peria Lamenur, Karrina Mekenda, Keldas, Claude Erksine, Harruk, Grokor, Zudd, Reban Freerunner, Bolyun, Caelyb, Hesuwa Thunderhorn,
-- Xao'tsu, Silvaria, Belia Thundergranite, and Isaac Chan who shares Peria's list) sell the same 45 ranks at the same prices as the
-- official pet trainer list (trainer 273, Quel'dora Quickgale and Alanndarian Nightsong, sniff build 70124), but without its rank
-- chain: no rank needed the one below it (ReqAbility1 0), and the first ranks of Great Stamina and Natural Armor asked for level 10
-- where the official list asks for none. Each rank now takes ReqAbility1 and ReqLevel from trainer 273. Prices were already equal.
-- Only pet trainers (trainer.Type 3) and only spells that trainer 273 also sells are touched.
-- Safe to run again.
UPDATE `trainer_spell` b
  JOIN `trainer` t ON t.`Id` = b.`TrainerId` AND t.`Type` = 3
  JOIN `trainer_spell` a ON a.`TrainerId` = 273 AND a.`SpellId` = b.`SpellId`
   SET b.`ReqAbility1` = a.`ReqAbility1`, b.`ReqLevel` = a.`ReqLevel`
 WHERE b.`TrainerId` BETWEEN 1000000 AND 1999999;
