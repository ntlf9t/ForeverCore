-- Karrz data, batch 1b (karrz-v0.1.34): fix-up after 2026_11_08_96_world_forever_riverglades_quests.
-- Song of the Strider (95984, Riverglades) follows A Feast for Buzzards (95983) in that file, but 95983 is one of the quests the
-- file leaves out (its NPC 263316 has no template and no known spot), so with the link in place 95984 is never offered. Clear the
-- link until 95983 comes in; whoever adds 95983 sets it back. Safe to run again.
UPDATE `quest_template_addon` SET `PrevQuestID`=0 WHERE `ID`=95984 AND `PrevQuestID`=95983;
