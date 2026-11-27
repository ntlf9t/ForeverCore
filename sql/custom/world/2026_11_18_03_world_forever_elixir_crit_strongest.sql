-- WoW Forever: elixirs stack their stats across groups, but only the strongest elixir crit applies (wowsims/forever, MIT, docs/rulings
-- R-0025, sim/common/shared/consumable_stats.go; evidence pending). The Forever crit elixirs: Elixir of the Mongoose 17538, the Owl
-- 1250940, Sages 1250941, the Whale 1250981, the Grizzly 1250986 (each +2% crit beside a stat) and Endless Opportunity 1327753 (+4%).
-- Group 1400910 with stack rule 3 (exclusive same effect): their crit (aura 290, SPELL_AURA_MOD_CRIT_PCT) counts once, the highest;
-- SpellMgr::LoadSpellGroupStackRules pins the group to that aura so their stats keep stacking. Safe to run again.
DELETE FROM `spell_group` WHERE `id` = 1400910;
INSERT INTO `spell_group` (`id`,`spell_id`) VALUES
(1400910,17538),(1400910,1250940),(1400910,1250941),(1400910,1250981),(1400910,1250986),(1400910,1327753);
DELETE FROM `spell_group_stack_rules` WHERE `group_id` = 1400910;
INSERT INTO `spell_group_stack_rules` (`group_id`,`stack_rule`) VALUES (1400910,3);
