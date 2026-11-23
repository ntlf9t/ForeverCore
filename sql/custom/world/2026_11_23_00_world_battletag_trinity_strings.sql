-- Localized messages for the player-facing .battletag command.
DELETE FROM `trinity_string` WHERE `entry` IN (1223, 1224, 1225, 1226, 1227, 1228, 1229);
INSERT INTO `trinity_string` (`entry`, `content_default`, `content_loc4`) VALUES
(1223, 'You have no BattleTag yet. Pick one with .battletag <name>; a number is added, like Name#1234.', '你还没有战网昵称。请使用 .battletag <name> 设置；系统会自动添加数字后缀，例如 Name#1234。'),
(1224, 'Your BattleTag is %s. Change it with .battletag <name>.', '你的战网昵称是 %s。可使用 .battletag <name> 更改。'),
(1225, 'Your BattleTag is now %s.', '你的战网昵称现已更改为 %s。'),
(1226, 'This account has no Battle.net account, so it cannot have a BattleTag.', '此账号没有关联战网账号，因此无法设置战网昵称。'),
(1227, 'A BattleTag name is 2-12 letters and digits (A-Z, 0-9), starting with a letter.', '战网昵称须为 2-12 个字母或数字（A-Z、0-9），并以字母开头。'),
(1228, 'That name has no free numbers left, pick another one.', '该名称的数字后缀已全部占用，请换一个名称。'),
(1229, 'You have no BattleTag yet, so Battle.net friends cannot whisper you. Pick one with .battletag <name>.', '你还没有战网昵称，因此战网好友无法向你发送密语。请使用 .battletag <name> 设置一个。');
