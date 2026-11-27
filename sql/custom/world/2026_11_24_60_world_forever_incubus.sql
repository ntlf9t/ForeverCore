-- WoW Forever Incubus: Summon Incubus 713 summons 185317 (client DB2 SpellEffect), the male Sayaad (family 302, Sayaad skill line 205).
-- Our world data only knew the Succubus 1863, so the Incubus had no pet_levelstats (Pet::InitStatsForLevel fell back to the
-- ExpectedStat creature health and base mana), no Lash of Pain and none of the Succubus's multipliers. The core now treats 185317 as
-- the Sayaad wherever 1863 is special-cased (TemporarySummon.h PET_INCUBUS, WarlockPetForever.h swing, StatSystem.cpp health per
-- Stamina and attack power, spell_pet.cpp).
-- Copied from the Succubus as it stands in the world database when this runs (the copy follows later changes to 1863 if re-run):
--  * pet_levelstats: every level of 1863 (health, mana, armor, stats). The health is then set to the Nov 10 values by
--    2026_11_24_61_world_forever_demon_base_health_1110.sql.
--  * creature_template_spell: Lash of Pain 7814 as its first spell (2026_10_11_27_world_classic_demon_spells.sql gives it to 1863 only).
--  * creature_template_difficulty (difficulty 0): health, mana, armor and damage modifiers (1863's come from
--    2026_10_05_14_world_classic_creature_multipliers.sql: damage 0.9, health 0.7, armor 0).
-- Already the same and left alone: unit_class 2 (sniff row and 2026_10_12_01), creature_template_addon aura 18729, the family (302 for the
-- Incubus, 17 for the Succubus) and the Incubus's own display 105317 from the Forever sniff. creature_classic_stats / creature_classic_level
-- (1863 has rows) are not copied: a player's pet never reads them (Pet.cpp, StatSystem.cpp, TemporarySummon.cpp check !IsPet() or a
-- creature summoner), and 2026_10_11_11 clears and refills that table whenever it runs.
-- Safe to run again.
DELETE FROM `pet_levelstats` WHERE `creature_entry` = 185317;
INSERT INTO `pet_levelstats` (`creature_entry`,`level`,`hp`,`mana`,`armor`,`str`,`agi`,`sta`,`inte`,`spi`)
SELECT 185317, `level`, `hp`, `mana`, `armor`, `str`, `agi`, `sta`, `inte`, `spi` FROM `pet_levelstats` WHERE `creature_entry` = 1863;

DELETE FROM `creature_template_spell` WHERE `CreatureID` = 185317;
INSERT INTO `creature_template_spell` (`CreatureID`,`Index`,`Spell`,`VerifiedBuild`) VALUES
(185317,0,7814,0);

UPDATE `creature_template_difficulty` i JOIN `creature_template_difficulty` s ON s.`Entry` = 1863 AND s.`DifficultyID` = 0
SET i.`HealthModifier` = s.`HealthModifier`, i.`ManaModifier` = s.`ManaModifier`, i.`ArmorModifier` = s.`ArmorModifier`, i.`DamageModifier` = s.`DamageModifier`
WHERE i.`Entry` = 185317 AND i.`DifficultyID` = 0;
