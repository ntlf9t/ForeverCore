-- WoW Forever client 1.60.1.71139 (Battle.net update of 25 November 2026). The Everlake tracker's timeline shows its files
-- change two item records over 71091 (Blinding Powder 5530 and Encrypted Twilight Text 20404 binding), and the next day's
-- hotfixes set both again; 2026_11_26_00 carries where they ended, so the server's extracted data stays as it is.
-- This row lets bnetserver and worldserver accept that client; a realm takes it as its own build or through
-- Realm.AlsoAcceptBuilds. Its message numbers are handled per connection: 71139 clients get the 70790 numbering
-- (Classic.Build70790.FirstBuild = 70790 covers every later build) until a 71139 change is known.
-- No auth key is known for 71139: keep Network.SkipBuildAuthKeyCheck = 1 in worldserver.conf.
-- bnetserver and worldserver read build_info only at startup: restart both once after this update. Safe to run again.
DELETE FROM `build_info` WHERE `build`=71139;
INSERT INTO `build_info` (`build`,`majorVersion`,`minorVersion`,`bugfixVersion`,`hotfixVersion`) VALUES
(71139,1,60,1,NULL);
