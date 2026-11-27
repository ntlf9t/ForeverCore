-- WoW Forever class spells newer than the trainer sniff (build 70124, 2026_10_01_04_world_forever_sniff_npc.sql), so no trainer taught them:
--   hunter Lacerate 24118, 24119, 24120, 1299332 (Survival, 4 ranks, levels 30/40/50/60);
--   paladin Voice of Truth 1310897 (Holy, level 20).
-- Ranks and levels: Wowhead's Forever spellbook changes (hunter/lacerate, paladin/voice-of-truth) and the client's SpellLevels (71037).
-- Live prices are not recorded: each cost is what the same trainer charges for its other spells of that level. Trainer 20 (hunter) and
-- 29 (paladin) are the only trainers of those classes that creatures use (creature_trainer). Safe to run again.
DELETE FROM `trainer_spell` WHERE (`TrainerId` = 20 AND `SpellId` IN (24118, 24119, 24120, 1299332)) OR (`TrainerId` = 29 AND `SpellId` = 1310897);
INSERT INTO `trainer_spell` (`TrainerId`, `SpellId`, `MoneyCost`, `ReqSkillLine`, `ReqSkillRank`, `ReqAbility1`, `ReqAbility2`, `ReqAbility3`, `ReqLevel`, `VerifiedBuild`) VALUES
(20, 24118, 7600, 0, 0, 0, 0, 0, 30, 0),
(20, 24119, 16000, 0, 0, 24118, 0, 0, 40, 0),
(20, 24120, 30000, 0, 0, 24119, 0, 0, 50, 0),
(20, 1299332, 42000, 0, 0, 24120, 0, 0, 60, 0),
(29, 1310897, 4000, 0, 0, 0, 0, 0, 20, 0);
