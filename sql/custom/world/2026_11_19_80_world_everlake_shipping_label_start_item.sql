-- Shipping Label 98247 / 98248 (turn in at Marcy Baker 256390 / Dokimi 256386): started from the label item, which is also the
-- quest's only objective. With StartItem 0 the core destroys the item that started a quest (Player::AddQuestAndCheckCompletion)
-- unless it is the quest's source item or a unique objective, so the label could be gone the moment the quest is taken and the
-- quest could never be finished. The label becomes the source item, which the core keeps. Same trap as the Craftsman's Writs
-- (Karrz1/TrinityCore issue #354). Safe to run again.
UPDATE `quest_template` SET `StartItem` = 280179 WHERE `ID` = 98247 AND `StartItem` = 0;
UPDATE `quest_template` SET `StartItem` = 280180 WHERE `ID` = 98248 AND `StartItem` = 0;
