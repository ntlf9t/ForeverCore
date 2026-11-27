-- WoW Forever: blue (rare) weapons and armour of item level 5-20 could not be disenchanted (player report: "blues don't disenchant").
-- The client's ItemDisenchantLoot.db2 gives rare items of item level 5-15 and 16-20 their own ids, new in Forever:
--   335 armour 5-15, 336 armour 16-20, 337 weapons 16-20, 338 weapons 5-15.
-- The Forever TDB (2026-10-14) has no disenchant_loot_template rows for them, so the cast went through (SkillRequired 0)
-- and the loot window came up empty. 90 rare items fall in that band (Blackened Defias Leggings, Cavedweller Bracers,
-- Robe of Evocation, Magefist Gloves ...).
-- Loot: Small Glimmering Shard (10978), 100%, 1, the same as the next band up (ids 9/10, rare item level 21-25) and
-- as Classic gave for low rare items. INFERRED from those rows: no source lists Forever's rows for 335-338.
DELETE FROM `disenchant_loot_template` WHERE `Entry` IN (335,336,337,338);
INSERT INTO `disenchant_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(335,0,10978,100,0,1,1,1,1,'Rare armour, item level 5-15 - Small Glimmering Shard'),
(336,0,10978,100,0,1,1,1,1,'Rare armour, item level 16-20 - Small Glimmering Shard'),
(337,0,10978,100,0,1,1,1,1,'Rare weapon, item level 16-20 - Small Glimmering Shard'),
(338,0,10978,100,0,1,1,1,1,'Rare weapon, item level 5-15 - Small Glimmering Shard');
