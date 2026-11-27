-- WoW Forever client 1.60.1.71091 (Battle.net update of 24 November 2026). Its game data is 71037's (the Everlake tracker's
-- timeline: "same game data as 1.60.1.71037"), so the server's extracted data stays as it is.
-- This row lets bnetserver and worldserver accept that client; a realm takes it as its own build or through
-- Realm.AlsoAcceptBuilds. Its message numbers are handled per connection: 71091 clients get the 70790 numbering
-- (Classic.Build70790.FirstBuild = 70790 covers every later build) until a 71091 change is known.
-- No auth key is known for 71091: keep Network.SkipBuildAuthKeyCheck = 1 in worldserver.conf.
-- bnetserver and worldserver read build_info only at startup: restart both once after this update. Safe to run again.
DELETE FROM `build_info` WHERE `build`=71091;
INSERT INTO `build_info` (`build`,`majorVersion`,`minorVersion`,`bugfixVersion`,`hotfixVersion`) VALUES
(71091,1,60,1,NULL);
