-- Level rewards inspired by AzerothCore's mod-congrats-on-level (AGPL-3.0).
-- Import into the world database before enabling Congrats.Enable.
-- Add one or more rows per level from 1 to 60. Money is in gold; spell,
-- itemId1 and itemId2 are IDs (0 disables each reward). learn=0 casts the
-- spell, learn=1 teaches it. race and class are numeric IDs; 0 matches all.
-- All matching rows are awarded, including both general and race/class rows.
-- Race IDs are not restricted to the original module's playable races.
-- For example: goblin=9, worgen=22, pandaren=24/25/26, dracthyr=52/70,
-- earthen=84/85, haranir=86/91 and skyborne=95/96. See RaceMask.h for all IDs.
-- Verify item and spell IDs against this core before adding rewards.
-- Items that cannot be stored are not mailed; the player must contact a GM.
-- Existing rewards are never deleted or replaced by this import.
CREATE TABLE IF NOT EXISTS `mod_congrats_on_level_items` (
    `level` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `money` INT UNSIGNED NOT NULL DEFAULT 0,
    `spell` INT UNSIGNED NOT NULL DEFAULT 0,
    `learn` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `itemId1` INT UNSIGNED NOT NULL DEFAULT 0,
    `itemId2` INT UNSIGNED NOT NULL DEFAULT 0,
    `race` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    `class` TINYINT UNSIGNED NOT NULL DEFAULT 0,
    KEY `idx_level` (`level`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Example: 1 gold for every race and class at level 10.
-- INSERT INTO `mod_congrats_on_level_items`
-- (`level`, `money`, `spell`, `learn`, `itemId1`, `itemId2`, `race`, `class`)
-- VALUES (10, 1, 0, 0, 0, 0, 0, 0);
