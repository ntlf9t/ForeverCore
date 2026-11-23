-- .reload gameobject_template help (cs_reload.cpp). Safe to run again.
DELETE FROM `command` WHERE `name` = 'reload gameobject_template';
INSERT INTO `command` (`name`, `help`) VALUES
('reload gameobject_template', 'Syntax: .reload gameobject_template #entry\r\n\r\nReload the specified gameobject template entry from the database.');
