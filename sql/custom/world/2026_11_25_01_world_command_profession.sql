-- .profession help (cs_misc.cpp). Safe to run again.
DELETE FROM `command` WHERE `name` IN ('profession', 'profession show', 'profession hide');
INSERT INTO `command` (`name`, `help`) VALUES
('profession', 'Syntax: .profession\r\n\r\nList your primary professions. The game window shows only 2 of them; the rest are hidden but keep their skill and recipes.'),
('profession show', 'Syntax: .profession show $name\r\n\r\nShow this profession in the Professions tab and give it a window, in place of one of the 2 shown now (the one you picked longer ago). The start of a name is enough, like .profession show tail.'),
('profession hide', 'Syntax: .profession hide $name\r\n\r\nHide this profession: it keeps its skill and recipes, and its slot is left free, so a trainer can teach you a new profession into it. It comes back by itself at your next login if the slot is still free.');
