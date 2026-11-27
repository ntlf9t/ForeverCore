-- Name reservation by full name (Classic 1.60 name + surname): "Ora Swiftwind" belongs to one Battle.net account on every
-- realm, and another account may still be "Ora Brightleaf". Follows 2026_11_07_09_auth_name_reservation.sql.
--
-- Until now there was one row per name, holding the surname its character last had. That row becomes the reservation of
-- that full name, so existing reservations carry over unchanged. Surnames compare without regard to case
-- (utf8mb4_unicode_ci), like characters.surname. Safe to run again: every step checks whether it is done.

-- 1. name_reservation_character gets the surname of the full name each character uses
SET @sql := IF((SELECT COUNT(*) FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'name_reservation_character' AND COLUMN_NAME = 'surname') = 0,
    'ALTER TABLE `name_reservation_character` ADD COLUMN `surname` varchar(48) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT '''' AFTER `name`',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 2. while name_reservation still has one row per name (its primary key is the name alone), copy each row's surname to
--    the characters using that name; after step 3 a name can have several rows and this join would be ambiguous
SET @nameOnlyKey := (SELECT COUNT(*) FROM information_schema.KEY_COLUMN_USAGE WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'name_reservation' AND CONSTRAINT_NAME = 'PRIMARY') = 1;
SET @sql := IF(@nameOnlyKey,
    'UPDATE `name_reservation_character` c JOIN `name_reservation` r ON r.`name` = c.`name` SET c.`surname` = r.`surname`',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 3. the reservation is for the full name
SET @sql := IF(@nameOnlyKey,
    'ALTER TABLE `name_reservation` DROP PRIMARY KEY, ADD PRIMARY KEY (`name`, `surname`)',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

-- 4. characters are looked up by the full name they use
SET @sql := IF((SELECT COUNT(*) FROM information_schema.STATISTICS WHERE TABLE_SCHEMA = DATABASE() AND TABLE_NAME = 'name_reservation_character' AND INDEX_NAME = 'idx_name' AND COLUMN_NAME = 'surname') = 0,
    'ALTER TABLE `name_reservation_character` DROP INDEX `idx_name`, ADD INDEX `idx_name` (`name`, `surname`)',
    'DO 0');
PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;
