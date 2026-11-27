-- Hunter pets (audit 11-13), follow-up to 2026_11_12_70: pet families and the tameable flag that Wowhead's WoW Forever database
-- shows for spawned beasts where ours differs. Source: the NPC page ("Tameable (<family>)" in Quick Facts) and the pet family in
-- the spell pages' "Taught by" tab, wowhead.com/forever, read 2026-11-13. The live player caches of 2026_11_11_70 and
-- 2026_11_12_70 do not list these beasts. CreatureTemplate::IsTameable needs a beast, a pet family, TypeFlags bit 1 and, unless the
-- hunter can tame exotic pets (never on 1.60), no bit 0x10000. Bit 0x08000000 is the Beast Lore bit of 2026_11_12_08. Safe to run
-- again.

-- 1. Zephras Isle owls: live family 26 (Bird of Prey), ours 11 (Raptor), so a tamed one learned raptor abilities. A pet tamed
--    before this keeps the raptor ranks it was taught.
UPDATE `creature_template` SET `family` = 26 WHERE `entry` IN (253282, 253283); -- Shriekling Fledgling, Shriekling Matriarch

-- 2. Tameable on live, ours had no pet family and no tameable bit.
UPDATE `creature_template` SET `family` = 3 WHERE `entry` = 266851;           -- Ukorsbane (Durotar, spider)
UPDATE `creature_template` SET `family` = 11 WHERE `entry` = 268530;          -- Bloodtalon Matriarch (raptor)
UPDATE `creature_template` SET `family` = 1 WHERE `entry` = 268831;           -- Plains Prowler (wolf)
UPDATE `creature_template` SET `family` = 26 WHERE `entry` IN (270196, 270298); -- Jai'vhanel, Child of Jai'vhanel (bird of prey)
UPDATE `creature_template_difficulty` SET `TypeFlags` = `TypeFlags` | 0x08000001
 WHERE `DifficultyID` = 0 AND `Entry` IN (266851, 268530, 268831, 270196, 270298);

-- 3. Silithid Swarmer (3252): tameable on live (Scorpid); ours carried the retail exotic bit 0x10000, so no 1.60 hunter could tame it.
UPDATE `creature_template_difficulty` SET `TypeFlags` = `TypeFlags` & ~0x10000 WHERE `DifficultyID` = 0 AND `Entry` = 3252;

-- 4. Not tameable on live, and their retail families (35 Serpent, 53 Beetle) do not exist in the 1.60 client, so a tamed one
--    would be a pet of a family the client cannot show. The tameable bit comes from the retail data. The core checks IsTameable
--    when it loads or unstables a pet, so a hunter who already tamed one could no longer call it: check character_pet
--    (CreatureId 3680 or 10177) before deploying.
UPDATE `creature_template_difficulty` SET `TypeFlags` = `TypeFlags` & ~1 WHERE `DifficultyID` = 0 AND `Entry` IN (3680, 10177); -- Serpentbloom Snake, Spire Scarab
