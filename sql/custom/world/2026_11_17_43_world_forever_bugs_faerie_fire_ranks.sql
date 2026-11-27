-- Faerie Fire ranks (770, 778, 9749, 9907): one druid could put two ranks on a target (rank 2, then rank 1 after the form cooldown),
-- which stacked and needed two dispels (forever-bugs #308, fixed on live: "not supposed to stack under any condition"). The ranks are
-- not chained in the client data and the server's same-caster rank rule only covers buffs. A spell group with stack rule 4 (only the
-- highest effect counts) makes a weaker rank fail with "A more powerful spell is already active" and a stronger one replace it, whoever
-- cast it (vanilla had one Faerie Fire on a target). Group 1400910, after the camp buff groups 1400900-1400906. Safe to run again.
DELETE FROM `spell_group` WHERE `id` = 1400910;
INSERT INTO `spell_group` (`id`,`spell_id`) VALUES
(1400910,770),
(1400910,778),
(1400910,9749),
(1400910,9907);

DELETE FROM `spell_group_stack_rules` WHERE `group_id` = 1400910;
INSERT INTO `spell_group_stack_rules` (`group_id`,`stack_rule`) VALUES
(1400910,4);
