-- WoW Forever: the two Skyborne races carry their own stat offsets, read from level 1 naked character sheets on 6 November 2026, after
-- the 21 October racial stat fix (wowsims/forever, MIT, docs/evidence EV-0093). The start sniff 2026_10_06_00 gave both the shared beta
-- delta -1/+1/-1/+1/0, and 2026_11_17_45 left them as sniffed because their post-fix values were not known. Same baseline as the other
-- races' rows (Orc +3 Spirit, Troll +1, Undead +5 in both). Safe to run again.
DELETE FROM `player_racestats` WHERE `race` IN (95, 96);
INSERT INTO `player_racestats` (`race`, `str`, `agi`, `sta`, `inte`, `spi`) VALUES
(95, -3, 4, -1, 4, -3),   -- High Order Skyborne (Alliance)
(96, -4, 3, 0, -1, 3);    -- Windshaper Skyborne (Horde)
