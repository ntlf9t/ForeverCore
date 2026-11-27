-- Hunter pets: three tame rows corrected from in-game tames (community pet addons, the tamed pet's spellbook right after Tame Beast).
-- Speed comes from the Faster Attack passive in that spellbook, not from a swing timer. classic_pet_tame_spell is read once
-- (Pet::GetTameSpells), so the rows take effect after a worldserver restart; pets already tamed resync their speed passive on load
-- (Pet::SyncTameAttackSpeed), learned abilities stay. Safe to run again.

-- Vulgara the Insatiable (254589, Zephras Isle): two players' tames came with Faster Attack II (1.6 sec), not Faster Attack III
-- (1.5 sec, from Wowhead in 2026_11_15_00). Bite stays.
DELETE FROM `classic_pet_tame_spell` WHERE `CreatureEntry` = 254589 AND `SpellId` IN (1263099, 1263100, 1263102, 1263104, 1263107, 1263109, 1263110, 1263111, 1263113, 1263114);
INSERT INTO `classic_pet_tame_spell` (`CreatureEntry`, `SpellId`) VALUES
(254589, 1263100); -- Faster Attack II

-- Giggler (14228, Desolace): a level 34 tame had Faster Attack III (1.5 sec) beside its Bite 5 and Tendon Rip 2 (rows already in
-- 2026_11_13_97). It had no speed row, so it swung at 2.0 sec.
DELETE FROM `classic_pet_tame_spell` WHERE `CreatureEntry` = 14228 AND `SpellId` IN (1263099, 1263100, 1263102, 1263104, 1263107, 1263109, 1263110, 1263111, 1263113, 1263114);
INSERT INTO `classic_pet_tame_spell` (`CreatureEntry`, `SpellId`) VALUES
(14228, 1263102); -- Faster Attack III

-- Daggerfang (270693, Loch Modan crocolisk, in our creature data): a level 15 tame had Bite 2 and Dismember 1 in its spellbook, and
-- no speed passive (2.0 sec). It had no row, so it came with nothing.
DELETE FROM `classic_pet_tame_spell` WHERE `CreatureEntry` = 270693 AND `SpellId` IN (17255, 1264758);
INSERT INTO `classic_pet_tame_spell` (`CreatureEntry`, `SpellId`) VALUES
(270693, 17255),   -- Bite 2
(270693, 1264758); -- Dismember 1
