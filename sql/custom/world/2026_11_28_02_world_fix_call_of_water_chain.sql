-- Call of Water 94494 ends at Norric Lochthane, who gives the next Forever quest 94495.
UPDATE `quest_template`
SET `RewardNextQuest` = 94495
WHERE `ID` = 94494
  AND `RewardNextQuest` <> 94495;

INSERT INTO `quest_template_addon` (`ID`,`PrevQuestID`)
VALUES (94495,94494)
ON DUPLICATE KEY UPDATE `PrevQuestID` = 94494;
