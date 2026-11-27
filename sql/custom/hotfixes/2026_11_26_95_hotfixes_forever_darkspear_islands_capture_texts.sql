-- Server-only fallback announcements for the Darkspear Islands capture points.
-- Leave any existing text untouched. A later official hotfix must separately
-- remove its matching fallback, because build 0 takes precedence over official rows.
DROP TEMPORARY TABLE IF EXISTS `_forever_darkspear_capture_texts`;
CREATE TEMPORARY TABLE `_forever_darkspear_capture_texts` (
    `ID` int unsigned NOT NULL PRIMARY KEY,
    `Text` text NOT NULL
);
INSERT INTO `_forever_darkspear_capture_texts` (`ID`, `Text`) VALUES
(310228, '$n has assaulted the Camp!'),
(310229, 'The Horde has taken the Camp!'),
(310230, '$n has defended the Camp!'),
(310231, 'The Alliance has taken the Camp!'),
(310232, '$n has defended the Camp!'),
(310233, '$n has assaulted the Camp!'),
(310234, 'The Horde has taken the Ruins!'),
(310235, 'The Alliance has taken the Ruins!'),
(310236, '$n has defended the Ruins!'),
(310238, '$n has defended the Ruins!'),
(310239, '$n has assaulted the Ruins!'),
(310240, '$n has assaulted the Ruins!'),
(310241, '$n has defended Shipwreck Cove!'),
(310242, '$n has defended Shipwreck Cove!'),
(310243, '$n has assaulted Shipwreck Cove!'),
(310244, '$n has assaulted Shipwreck Cove!'),
(310245, 'The Horde has taken Shipwreck Cove!'),
(310246, 'The Alliance has taken Shipwreck Cove!'),
(310247, 'The Horde has taken the Abandoned Tower!'),
(310248, 'The Alliance has taken the Abandoned Tower!'),
(310249, '$n has defended the Abandoned Tower!'),
(310250, '$n has defended the Abandoned Tower!'),
(310251, '$n has assaulted the Abandoned Tower!'),
(310252, '$n has assaulted the Abandoned Tower!');

DROP TEMPORARY TABLE IF EXISTS `_forever_darkspear_existing_texts`;
CREATE TEMPORARY TABLE `_forever_darkspear_existing_texts` (`ID` int unsigned NOT NULL PRIMARY KEY);
INSERT INTO `_forever_darkspear_existing_texts` (`ID`)
SELECT DISTINCT b.`ID`
FROM `broadcast_text` b
JOIN `_forever_darkspear_capture_texts` t ON t.`ID` = b.`ID`;

INSERT INTO `broadcast_text` (`Text`, `Text1`, `ID`, `LanguageID`, `ConditionID`, `EmotesID`, `Flags`,
    `ChatBubbleDurationMs`, `VoiceOverPriorityID`, `SoundKitID1`, `SoundKitID2`, `EmoteID1`, `EmoteID2`,
    `EmoteID3`, `EmoteDelay1`, `EmoteDelay2`, `EmoteDelay3`, `VerifiedBuild`)
SELECT t.`Text`, '', t.`ID`, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
FROM `_forever_darkspear_capture_texts` t
LEFT JOIN `_forever_darkspear_existing_texts` b ON b.`ID` = t.`ID`
WHERE b.`ID` IS NULL;

DROP TEMPORARY TABLE `_forever_darkspear_existing_texts`;
DROP TEMPORARY TABLE `_forever_darkspear_capture_texts`;
