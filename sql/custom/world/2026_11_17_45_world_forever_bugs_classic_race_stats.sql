-- Racial base stat offsets back to the Classic values (forever-bugs #414, fixed on live 21 Oct: they were the modern ones). The start
-- sniff 2026_10_06_00 was taken on the beta before that fix and replaced the vanilla rows of 2026_10_01_06 with the modern offsets
-- (no race Spirit, Tauren +2 Strength, Night Elf +2 Agility). These are the vanilla rows again (VMaNGOS player_levelstats split into
-- race offsets and class stats): a level-1 warrior's Spirit is 20 + the race's, so Human 21, Orc 23, Undead 25 as in Classic.
-- The issue's table measures from Human, whose own Spirit is +1, and has Gnome Intellect +3 where Classic has 24 (+4).
-- Skyborne (95, 96) keep the sniffed values: their post-fix live values are not known. Safe to run again.
DELETE FROM `player_racestats` WHERE `race` IN (1,2,3,4,5,6,7,8);
INSERT INTO `player_racestats` (`race`,`str`,`agi`,`sta`,`inte`,`spi`) VALUES
(1,0,0,0,0,1),
(2,3,-3,2,-3,3),
(3,2,-4,3,-1,-1),
(4,-3,5,-1,0,0),
(5,-1,-2,1,-2,5),
(6,5,-5,2,-5,2),
(7,-5,3,-1,4,0),
(8,1,2,1,-4,1);
