-- .profession hide now lasts across logins (character_skills.professionSlot -2). Safe to run again.
DELETE FROM `command` WHERE `name` = 'profession hide';
INSERT INTO `command` (`name`, `help`) VALUES
('profession hide', 'Syntax: .profession hide $name\r\n\r\nHide this profession: it keeps its skill and recipes, and its slot is left free, so a trainer can teach you a new profession into it. It stays hidden, across logins too, until you .profession show it.');
