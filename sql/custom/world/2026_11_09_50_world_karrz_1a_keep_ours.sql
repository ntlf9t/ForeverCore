-- Karrz data batch 1a, our fix-up: keeps what our world already does right (runs after every Karrz file of the batch by name order).
-- Some Karrz files (mainly 2026_11_05_99_world_forever_restore_forever_quest_data, a row diff between two of Karrz's
-- worlds) delete SmartAI rows that our world still uses, for NPCs and objects whose replacement scripts exist only in
-- Karrz's core (Alterac Valley commanders, High Priest Thekal, the Zul'Gurub zealots, General Rajaxx and others).
-- Until those scripts are ported (Karrz scripts batch, with the held boss-script SQL), keep what we had: every owner
-- that this batch left with no smart_scripts rows at all gets its rows back exactly as before the batch.
-- Checked on a scratch copy of the live world (TDB 2026-10-14 + everlake + world-data 24a3b39). Safe to run again.

DELETE FROM `smart_scripts` WHERE (`entryorguid`,`source_type`) IN ((-30234837,1),(-30048616,1),(-30046076,1),(-30045315,1),(-30044811,1),(-30044809,1),(-30044766,1),(-30043203,1),(-30043196,1),(-30043188,1),(-30043187,1),(-30043184,1),(-30043177,1),(-30040694,1),(-30035848,1),(-30035798,1),(-30032443,1),(-30026197,1),(-30026192,1),(-30016598,1),(-30015730,1),(-30015722,1),(-30015398,1),(-30015351,1),(-30015216,1),(-30011894,1),(-30011881,1),(413,3),(643,0),(1428,3),(1449,3),(2624,0),(2937,0),(3718,3),(4622,3),(4845,3),(4884,3),(4977,0),(4978,0),(5402,0),(5525,5),(5618,3),(5619,3),(5620,3),(5621,3),(5622,3),(5623,3),(6206,3),(6729,0),(7286,0),(7429,5),(8438,0),(8443,0),(8578,0),(8581,0),(8608,3),(9596,0),(10264,0),(10268,0),(10339,0),(10340,0),(10541,0),(10584,0),(10742,0),(10813,0),(10882,0),(11347,0),(11348,0),(12143,0),(12416,0),(12420,0),(12422,0),(13148,0),(13179,0),(13180,0),(13181,0),(13236,0),(13284,0),(13437,0),(13438,0),(13439,0),(13442,0),(13443,0),(13577,0),(14302,0),(14509,0),(14566,0),(14605,0),(14668,0),(14693,0),(15041,0),(15082,0),(15083,0),(15085,0),(15163,0),(15341,0),(15554,0),(15622,0),(15934,0),(16124,0),(16125,0),(16126,0),(16127,0),(16148,0),(16149,0),(16150,0),(16286,0),(16290,0),(16363,0),(16387,0),(16981,0),(16982,0),(252477,0),(940000000,9),(940000001,9),(940000002,9),(940000003,9),(940000004,9),(940000005,9),(940000006,9),(940000007,9),(940000008,9),(940000009,9),(940000010,9),(940100000,9),(940100001,9),(940100002,9),(940100003,9),(940100004,9),(940100005,9),(940200000,9),(940200001,9),(950001272,9),(950001273,9),(950001274,9),(950001275,9),(950001296,9),(950001297,9),(950001298,9));
INSERT INTO `smart_scripts` VALUES (-30234837,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000009,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 234837: Blackwing Lair lever -> Chromaggus portcullis (no script)');
INSERT INTO `smart_scripts` VALUES (-30048616,1,0,0,'',70,0,100,0,2,0,0,0,0,'',12,2168,1,300000,0,4,0,0,'',8,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 48616: Blackwood Nut Stores (Darkshore): Blackwood Warrior');
INSERT INTO `smart_scripts` VALUES (-30046076,1,0,0,'',70,0,100,0,2,0,0,0,0,'',45,1,1,0,0,0,0,0,'',10,20092997,8023,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 46076: Sharpbeak cage');
INSERT INTO `smart_scripts` VALUES (-30045315,1,0,0,'',70,0,100,0,2,0,0,0,0,'',70,180,0,0,0,0,0,0,'',14,30099885,176088,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 45315: Command Tent (Western Plaguelands, quest Scarlet Diversions): Scarlet Crusade Forward Camp spell focus');
INSERT INTO `smart_scripts` VALUES (-30044811,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000008,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44811: Scarlet Monastery Armory door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (-30044809,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000007,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44809: Scarlet Monastery Cathedral door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (-30044766,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000010,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44766: Mausoleum Trigger - Ulag the Cleaver');
INSERT INTO `smart_scripts` VALUES (-30043203,1,0,0,'',38,0,100,0,1,1,0,0,0,'',80,940100001,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5619: shadow portal room gate');
INSERT INTO `smart_scripts` VALUES (-30043203,1,1,0,'',82,0,100,0,11598,0,0,0,0,'',63,1,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5619: shadow portal room gate - guardian died');
INSERT INTO `smart_scripts` VALUES (-30043203,1,2,0,'',77,0,100,0,1,3,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5619: shadow portal room gate - all guardians dead, open');
INSERT INTO `smart_scripts` VALUES (-30043196,1,0,0,'',38,0,100,0,1,1,0,0,0,'',80,940100000,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5618: shadow portal room gate');
INSERT INTO `smart_scripts` VALUES (-30043196,1,1,0,'',82,0,100,0,11598,0,0,0,0,'',63,1,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5618: shadow portal room gate - guardian died');
INSERT INTO `smart_scripts` VALUES (-30043196,1,2,0,'',77,0,100,0,1,4,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5618: shadow portal room gate - all guardians dead, open');
INSERT INTO `smart_scripts` VALUES (-30043188,1,0,0,'',38,0,100,0,1,1,0,0,0,'',80,940100004,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5622: shadow portal room gate');
INSERT INTO `smart_scripts` VALUES (-30043188,1,1,0,'',82,0,100,0,11598,0,0,0,0,'',63,1,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5622: shadow portal room gate - guardian died');
INSERT INTO `smart_scripts` VALUES (-30043188,1,2,0,'',77,0,100,0,1,3,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5622: shadow portal room gate - all guardians dead, open');
INSERT INTO `smart_scripts` VALUES (-30043187,1,0,0,'',38,0,100,0,1,1,0,0,0,'',80,940100005,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5623: shadow portal room gate');
INSERT INTO `smart_scripts` VALUES (-30043187,1,1,0,'',82,0,100,0,11598,0,0,0,0,'',63,1,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5623: shadow portal room gate - guardian died');
INSERT INTO `smart_scripts` VALUES (-30043187,1,2,0,'',77,0,100,0,1,3,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5623: shadow portal room gate - all guardians dead, open');
INSERT INTO `smart_scripts` VALUES (-30043184,1,0,0,'',38,0,100,0,1,1,0,0,0,'',80,940100002,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5620: shadow portal room gate');
INSERT INTO `smart_scripts` VALUES (-30043184,1,1,0,'',82,0,100,0,11598,0,0,0,0,'',63,1,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5620: shadow portal room gate - guardian died');
INSERT INTO `smart_scripts` VALUES (-30043184,1,2,0,'',77,0,100,0,1,3,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5620: shadow portal room gate - all guardians dead, open');
INSERT INTO `smart_scripts` VALUES (-30043177,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000006,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 43177: Scholomance torch -> old treasure vault door (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (-30040694,1,0,0,'',70,0,100,0,2,0,0,0,0,'',12,7091,1,120000,0,4,0,0,'',8,0,0,0,0,'',24.745,413.288,-44.823,3,'VMaNGOS gameobject_scripts 40694: Shadowforge Cache (Uldaman): Shadowforge Ambushers (pre-1.12 ones skipped)');
INSERT INTO `smart_scripts` VALUES (-30040694,1,1,0,'',70,0,100,0,2,0,0,0,0,'',12,7091,1,120000,0,4,0,0,'',8,0,0,0,0,'',22.386,410.042,-44.606,2.3,'VMaNGOS gameobject_scripts 40694: Shadowforge Cache (Uldaman): Shadowforge Ambushers (pre-1.12 ones skipped)');
INSERT INTO `smart_scripts` VALUES (-30035848,1,0,1,'',70,0,100,0,2,0,0,0,0,'',12,11142,1,900000,0,0,0,0,'',8,0,0,0,0,'',3644.62,-3168.25,128.52,5.93,'VMaNGOS gameobject_scripts 35848: Undead Postmen');
INSERT INTO `smart_scripts` VALUES (-30035848,1,1,2,'',61,0,100,0,0,0,0,0,0,'',12,11142,1,900000,0,0,0,0,'',8,0,0,0,0,'',3656.82,-3160.63,129.03,4.84,'VMaNGOS gameobject_scripts 35848: Undead Postmen');
INSERT INTO `smart_scripts` VALUES (-30035848,1,2,0,'',61,0,100,0,0,0,0,0,0,'',12,11142,1,900000,0,0,0,0,'',8,0,0,0,0,'',3664.55,-3176.47,126.42,2.2,'VMaNGOS gameobject_scripts 35848: Undead Postmen');
INSERT INTO `smart_scripts` VALUES (-30035798,1,0,0,'',38,0,100,0,1,1,0,0,0,'',80,940100003,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5621: shadow portal room gate');
INSERT INTO `smart_scripts` VALUES (-30035798,1,1,0,'',82,0,100,0,11598,0,0,0,0,'',63,1,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5621: shadow portal room gate - guardian died');
INSERT INTO `smart_scripts` VALUES (-30035798,1,2,0,'',77,0,100,0,1,3,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5621: shadow portal room gate - all guardians dead, open');
INSERT INTO `smart_scripts` VALUES (-30032443,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000005,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 32443: Shadowfang Keep courtyard door lever (no script)');
INSERT INTO `smart_scripts` VALUES (-30026197,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000004,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 26197: Deadmines Mast Room door lever (TC row: wrong door entry)');
INSERT INTO `smart_scripts` VALUES (-30026192,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000003,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 26192: Deadmines Foundry door lever (TC row: wrong door entry)');
INSERT INTO `smart_scripts` VALUES (-30016598,1,0,0,'',70,0,100,0,2,0,0,0,0,'',70,62,0,0,0,0,0,0,'',14,30030237,2870,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 16598: Stone of Outer Binding (Arathi): aura column');
INSERT INTO `smart_scripts` VALUES (-30015730,1,0,0,'',70,0,100,0,2,0,0,0,0,'',12,3285,2,180000,0,0,0,0,'',8,0,0,0,0,'',843.523,-2669.85,91.6668,4.3958,'VMaNGOS gameobject_scripts 15730: Regulator Valve (Barrens): Venture Co. ambush');
INSERT INTO `smart_scripts` VALUES (-30015722,1,0,0,'',70,0,100,0,2,0,0,0,0,'',12,3284,2,180000,0,0,0,0,'',8,0,0,0,0,'',826.776,-2674.53,91.6667,5.5347,'VMaNGOS gameobject_scripts 15722: Main Control Valve (Barrens): Venture Co. ambush');
INSERT INTO `smart_scripts` VALUES (-30015722,1,1,0,'',70,0,100,0,2,0,0,0,0,'',12,3285,2,180000,0,0,0,0,'',8,0,0,0,0,'',824.479,-2678.73,91.6667,6.0491,'VMaNGOS gameobject_scripts 15722: Main Control Valve (Barrens): Venture Co. ambush');
INSERT INTO `smart_scripts` VALUES (-30015398,1,0,0,'',70,0,100,0,2,0,0,0,0,'',70,62,0,0,0,0,0,0,'',14,30030238,2870,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15398: Stone of West Binding (Arathi): aura column');
INSERT INTO `smart_scripts` VALUES (-30015351,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000002,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15351: Blackrock Depths Shadowforge Lock -> giant doors (TC rows: retail guids)');
INSERT INTO `smart_scripts` VALUES (-30015216,1,0,0,'',70,0,100,0,2,0,0,0,0,'',70,62,0,0,0,0,0,0,'',14,30030236,2870,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15216: Stone of East Binding (Arathi): aura column');
INSERT INTO `smart_scripts` VALUES (-30011894,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000001,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 11894: Scarlet Monastery secret door torch (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (-30011881,1,0,0,'',70,0,100,0,2,0,0,0,0,'',80,940000000,2,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 11881: Scarlet Monastery Chapel door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (413,3,0,1,'',87,0,100,0,0,0,0,0,0,'',12,2570,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1777.91,-1501.28,65.0042,4.66,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,1,2,'',61,0,100,0,0,0,0,0,0,'',12,2569,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1729.03,-1574.77,53.9953,3.5954,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,10,0,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1748.81,-1555.65,58.5205,4.3808,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,2,3,'',61,0,100,0,0,0,0,0,0,'',12,2569,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1742.55,-1594.43,52.7884,1.9722,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,3,4,'',61,0,100,0,0,0,0,0,0,'',12,2569,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1764.01,-1591,53.1026,1.309,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,4,5,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1776.35,-1523.46,65.0042,1.5708,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,5,6,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1782.63,-1508.94,99.3345,3.0892,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,6,7,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1777.76,-1516.91,99.3345,4.2935,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,7,8,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1770.32,-1510.47,90.5951,0.8901,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,8,9,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1772.38,-1522.57,75.3211,2.1293,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (413,3,9,10,'',61,0,100,0,0,0,0,0,0,'',12,2794,1,300000,0,0,0,0,'',8,0,0,0,0,'',-1758.89,-1555.83,58.6428,5.1138,'VMaNGOS event 413 Runed Pedestal - summon guardians');
INSERT INTO `smart_scripts` VALUES (643,0,0,0,'',0,0,100,0,7000,17000,15000,20000,0,'',11,6713,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 6430');
INSERT INTO `smart_scripts` VALUES (1428,3,0,1,'',87,0,100,0,0,0,0,0,0,'',50,92252,120,1,0,0,0,0,'',8,0,0,0,0,'',-768.659,-3721.86,42.3966,4.5553,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,1,2,'',61,0,100,0,0,0,0,0,0,'',5,2,0,0,0,0,0,0,'',11,6253,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,10,11,'',61,0,100,0,0,0,0,0,0,'',86,8675,2,11,6254,30,0,0,'',11,6254,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,11,12,'',61,0,100,0,0,0,0,0,0,'',86,8675,2,11,6253,30,0,0,'',11,6253,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,12,0,'',61,0,100,0,0,0,0,0,0,'',50,92388,106,1,0,0,0,0,'',8,0,0,0,0,'',-768.692,-3721.9,42.3976,2.6878,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,2,3,'',61,0,100,0,0,0,0,0,0,'',5,2,0,0,0,0,0,0,'',11,6254,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,3,4,'',61,0,100,0,0,0,0,0,0,'',5,2,0,0,0,0,0,0,'',11,6252,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,4,5,'',61,0,100,0,0,0,0,0,0,'',5,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,5,6,'',61,0,100,0,0,0,0,0,0,'',1,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,6,7,'',61,0,100,0,0,0,0,0,0,'',83,2,0,0,0,0,0,0,'',11,6252,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,7,8,'',61,0,100,0,0,0,0,0,0,'',83,2,0,0,0,0,0,0,'',11,6254,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,8,9,'',61,0,100,0,0,0,0,0,0,'',69,0,0,0,0,0,0,0,'',8,0,0,0,0,'',-763.195,-3720.34,42.2333,3.1549,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1428,3,9,10,'',61,0,100,0,0,0,0,0,0,'',86,8675,2,11,6252,30,0,0,'',11,6252,30,0,0,'',0,0,0,0,'VMaNGOS event 1428 The Binding - ritual visuals (no delays)');
INSERT INTO `smart_scripts` VALUES (1449,3,0,1,'',87,0,100,0,0,0,0,0,0,'',5,34,0,0,0,0,0,0,'',11,6253,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (1449,3,1,2,'',61,0,100,0,0,0,0,0,0,'',5,34,0,0,0,0,0,0,'',11,6254,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (1449,3,2,3,'',61,0,100,0,0,0,0,0,0,'',5,34,0,0,0,0,0,0,'',11,6252,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (1449,3,3,4,'',61,0,100,0,0,0,0,0,0,'',82,2,0,0,0,0,0,0,'',11,6254,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (1449,3,4,5,'',61,0,100,0,0,0,0,0,0,'',82,2,0,0,0,0,0,0,'',11,6252,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (1449,3,5,6,'',61,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,0,'',20,92252,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (1449,3,6,0,'',61,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,0,'',20,92388,30,0,0,'',0,0,0,0,'VMaNGOS event 1449 The Binding - ritual end');
INSERT INTO `smart_scripts` VALUES (2624,0,0,0,'',25,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI: start in phase 0 (TC phase 1)');
INSERT INTO `smart_scripts` VALUES (2624,0,1,2,'',2,0,100,1,10,90,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 262401');
INSERT INTO `smart_scripts` VALUES (2624,0,2,3,'',61,0,100,0,0,0,0,0,0,'',11,5402,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 262401');
INSERT INTO `smart_scripts` VALUES (2624,0,3,0,'',61,0,100,0,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 262401');
INSERT INTO `smart_scripts` VALUES (2624,0,4,0,'',0,4094,100,1,1000,1000,0,0,0,'',11,5404,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 262402');
INSERT INTO `smart_scripts` VALUES (2624,0,5,0,'',0,0,100,0,6000,12000,7000,15000,0,'',11,5403,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 26240');
INSERT INTO `smart_scripts` VALUES (2937,0,0,0,'',2,0,100,1,0,15,0,0,0,'',25,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 293701');
INSERT INTO `smart_scripts` VALUES (3718,3,0,0,'',87,0,100,0,0,0,0,0,0,'',41,0,180,0,0,0,0,0,'',14,30017428,164729,0,0,'',0,0,0,0,'VMaNGOS event 3718 - despawn Miblon\'s Door');
INSERT INTO `smart_scripts` VALUES (4622,3,0,1,'',87,0,100,0,0,0,0,0,0,'',12,10340,1,70000,1,0,0,0,'',8,0,0,0,0,'',168.818,-420.429,110.556,6.2134,'VMaNGOS event 4622 - Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (4622,3,1,0,'',61,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',12,1,0,0,0,'',0,0,0,0,'VMaNGOS event 4622 - Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (4622,3,2,3,'',87,0,100,0,0,0,0,0,0,'',12,10340,1,70000,2,0,0,0,'',8,0,0,0,0,'',182.742,-413.81,110.556,4.623,'VMaNGOS event 4622 - Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (4622,3,3,0,'',61,0,100,0,0,0,0,0,0,'',45,1,2,0,0,0,0,0,'',12,2,0,0,0,'',0,0,0,0,'VMaNGOS event 4622 - Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (4845,3,0,0,'',87,0,100,0,0,0,0,0,0,'',50,175584,0,0,0,0,0,0,'',8,0,0,0,0,'',-14.3415,-395.729,48.5381,2.8623,'VMaNGOS event 4845 - summon Challenge to Urok');
INSERT INTO `smart_scripts` VALUES (4884,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',19,9816,100,0,0,'',0,0,0,0,'VMaNGOS event 4884 Emberseer Start - wake Pyroguard Emberseer');
INSERT INTO `smart_scripts` VALUES (4977,0,0,0,'',2,0,100,1,0,15,0,0,0,'',25,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 497701');
INSERT INTO `smart_scripts` VALUES (4978,0,0,0,'',0,0,100,0,2000,4000,5000,8000,0,'',11,8398,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 49780');
INSERT INTO `smart_scripts` VALUES (4978,0,1,0,'',0,0,100,0,9000,12000,12000,16000,0,'',11,865,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 49780');
INSERT INTO `smart_scripts` VALUES (5402,0,0,0,'',63,0,100,1,0,0,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 540201');
INSERT INTO `smart_scripts` VALUES (5402,0,1,0,'',9,0,100,0,0,5,7000,11000,0,'',11,15496,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 540202');
INSERT INTO `smart_scripts` VALUES (5402,0,2,0,'',0,0,100,0,1000,5000,12000,18000,0,'',11,9128,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 54020');
INSERT INTO `smart_scripts` VALUES (5525,5,0,0,'',50,0,100,0,0,0,0,0,0,'',70,7200,0,0,0,0,0,0,'',14,30396410,179501,0,0,'',0,0,0,0,'VMaNGOS event 8450: Knot Thimblejack Cache on Free Knot!');
INSERT INTO `smart_scripts` VALUES (5618,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',14,30043196,177376,0,0,'',0,0,0,0,'VMaNGOS event 5618 Shadow Portal - start room gate event');
INSERT INTO `smart_scripts` VALUES (5619,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',14,30043203,177377,0,0,'',0,0,0,0,'VMaNGOS event 5619 Shadow Portal - start room gate event');
INSERT INTO `smart_scripts` VALUES (5620,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',14,30043184,177375,0,0,'',0,0,0,0,'VMaNGOS event 5620 Shadow Portal - start room gate event');
INSERT INTO `smart_scripts` VALUES (5621,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',14,30035798,177371,0,0,'',0,0,0,0,'VMaNGOS event 5621 Shadow Portal - start room gate event');
INSERT INTO `smart_scripts` VALUES (5622,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',14,30043188,177373,0,0,'',0,0,0,0,'VMaNGOS event 5622 Shadow Portal - start room gate event');
INSERT INTO `smart_scripts` VALUES (5623,3,0,0,'',87,0,100,0,0,0,0,0,0,'',45,1,1,0,0,0,0,0,'',14,30043187,177372,0,0,'',0,0,0,0,'VMaNGOS event 5623 Shadow Portal - start room gate event');
INSERT INTO `smart_scripts` VALUES (6206,3,0,1,'',87,0,100,0,0,0,0,0,0,'',5,4,0,0,0,0,0,0,'',10,20042333,11799,0,0,'',0,0,0,0,'VMaNGOS event 6206 Use Bauble - Tajarri');
INSERT INTO `smart_scripts` VALUES (6206,3,1,0,'',61,0,100,0,0,0,0,0,0,'',1,0,0,0,0,0,0,0,'',10,20042333,11799,0,0,'',0,0,0,0,'VMaNGOS event 6206 Use Bauble - Tajarri');
INSERT INTO `smart_scripts` VALUES (6729,0,0,0,'',1,0,100,1,1000,1000,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 672901');
INSERT INTO `smart_scripts` VALUES (7286,0,0,0,'',25,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI: start in phase 0 (TC phase 1)');
INSERT INTO `smart_scripts` VALUES (7286,0,1,0,'',63,4093,100,1,0,0,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 728601');
INSERT INTO `smart_scripts` VALUES (7286,0,2,3,'',1,4093,100,1,0,0,0,0,0,'',38,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 728602');
INSERT INTO `smart_scripts` VALUES (7286,0,3,0,'',61,0,100,0,0,0,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 728602');
INSERT INTO `smart_scripts` VALUES (7286,0,4,5,'',4,4093,100,1,0,0,0,0,0,'',38,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 728603');
INSERT INTO `smart_scripts` VALUES (7286,0,5,0,'',61,0,100,0,0,0,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 728603');
INSERT INTO `smart_scripts` VALUES (7429,5,0,0,'',50,0,100,0,0,0,0,0,0,'',70,7200,0,0,0,0,0,0,'',14,30396410,179501,0,0,'',0,0,0,0,'VMaNGOS event 8450: Knot Thimblejack Cache on Free Knot!');
INSERT INTO `smart_scripts` VALUES (8438,0,0,0,'',0,0,100,0,0,4000,0,4000,0,'',11,11671,32,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 84380');
INSERT INTO `smart_scripts` VALUES (8438,0,1,0,'',0,0,100,0,0,3000,2000,2000,0,'',11,12471,64,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 84380');
INSERT INTO `smart_scripts` VALUES (8443,0,0,0,'',0,0,100,0,9000,18000,9000,18000,0,'',11,6607,32,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 84430');
INSERT INTO `smart_scripts` VALUES (8443,0,1,0,'',0,0,100,0,9000,10000,9000,10000,0,'',11,12888,32,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 84430');
INSERT INTO `smart_scripts` VALUES (8578,0,0,0,'',9,0,100,0,0,8,13000,16000,0,'',11,11831,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 857801');
INSERT INTO `smart_scripts` VALUES (8578,0,1,0,'',4,0,100,1,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 857802');
INSERT INTO `smart_scripts` VALUES (8578,0,2,0,'',0,0,100,0,0,0,2000,2000,0,'',11,20823,64,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 85780');
INSERT INTO `smart_scripts` VALUES (8581,0,0,0,'',4,0,60,1,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 858101');
INSERT INTO `smart_scripts` VALUES (8581,0,1,0,'',9,0,100,0,0,5,8000,13000,0,'',11,12170,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 858102');
INSERT INTO `smart_scripts` VALUES (8581,0,2,0,'',2,0,60,1,0,20,0,0,0,'',1,1,0,1,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 858104');
INSERT INTO `smart_scripts` VALUES (8581,0,3,0,'',0,0,100,0,7000,12000,11000,14000,0,'',11,12169,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 85810');
INSERT INTO `smart_scripts` VALUES (8608,3,0,0,'',87,0,100,0,0,0,0,0,0,'',1,0,0,0,0,0,0,0,'',10,20092849,5635,0,0,'',0,0,0,0,'VMaNGOS event 8608 - Falstad Wildhammer yell');
INSERT INTO `smart_scripts` VALUES (9596,0,0,0,'',0,0,100,0,0,0,7000,11000,0,'',11,13737,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 95960');
INSERT INTO `smart_scripts` VALUES (10264,0,0,0,'',63,0,100,1,0,0,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1026402');
INSERT INTO `smart_scripts` VALUES (10264,0,1,0,'',0,0,100,0,5000,9000,16000,21000,0,'',11,16727,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 102640');
INSERT INTO `smart_scripts` VALUES (10268,0,0,0,'',2,0,100,0,0,20,30000,30000,0,'',11,8269,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1026801');
INSERT INTO `smart_scripts` VALUES (10268,0,1,0,'',0,0,100,0,7000,15000,7000,15000,0,'',11,16495,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 102680');
INSERT INTO `smart_scripts` VALUES (10268,0,2,0,'',0,0,100,0,15000,20000,10000,20000,0,'',11,16128,32,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 102680');
INSERT INTO `smart_scripts` VALUES (10339,0,0,0,'',2,0,100,1,1,50,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033901');
INSERT INTO `smart_scripts` VALUES (10339,0,1,2,'',2,0,100,1,0,20,0,0,0,'',28,16167,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033902');
INSERT INTO `smart_scripts` VALUES (10339,0,10,0,'',0,0,100,0,4000,4000,10000,10000,0,'',11,16390,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 103390');
INSERT INTO `smart_scripts` VALUES (10339,0,11,0,'',0,0,100,0,23000,23000,23000,23000,0,'',11,10101,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 103390');
INSERT INTO `smart_scripts` VALUES (10339,0,2,3,'',61,0,100,0,0,0,0,0,0,'',42,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033902');
INSERT INTO `smart_scripts` VALUES (10339,0,3,0,'',61,0,100,0,0,0,0,0,0,'',11,16328,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033902');
INSERT INTO `smart_scripts` VALUES (10339,0,4,5,'',63,0,100,1,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033903');
INSERT INTO `smart_scripts` VALUES (10339,0,5,0,'',61,0,100,0,0,0,0,0,0,'',11,16167,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033903');
INSERT INTO `smart_scripts` VALUES (10339,0,6,7,'',17,0,100,1,10429,0,0,0,0,'',11,13360,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033904');
INSERT INTO `smart_scripts` VALUES (10339,0,7,0,'',61,0,100,0,0,0,0,0,0,'',1,1,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1033904');
INSERT INTO `smart_scripts` VALUES (10339,0,8,0,'',0,0,100,0,8000,8000,7000,7000,0,'',11,16359,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 103390');
INSERT INTO `smart_scripts` VALUES (10339,0,9,0,'',0,0,100,0,11000,11000,16000,16000,0,'',11,16350,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 103390');
INSERT INTO `smart_scripts` VALUES (10340,0,100,0,'',38,0,100,0,1,1,0,0,0,'',80,940200000,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623: Vaelastrasz joins the Gyth fight');
INSERT INTO `smart_scripts` VALUES (10340,0,101,0,'',38,0,100,0,1,2,0,0,0,'',80,940200001,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4624: Vaelastrasz heals and leaves');
INSERT INTO `smart_scripts` VALUES (10541,0,0,1,'',8,0,100,0,16378,0,10000,10000,0,'',1,0,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1054101');
INSERT INTO `smart_scripts` VALUES (10541,0,1,2,'',61,0,100,0,0,0,0,0,0,'',1,1,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1054101');
INSERT INTO `smart_scripts` VALUES (10541,0,2,3,'',61,0,100,0,0,0,0,0,0,'',1,2,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1054101');
INSERT INTO `smart_scripts` VALUES (10541,0,3,4,'',61,0,100,0,0,0,0,0,0,'',1,3,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1054101');
INSERT INTO `smart_scripts` VALUES (10541,0,4,0,'',61,0,100,0,0,0,0,0,0,'',1,4,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1054101');
INSERT INTO `smart_scripts` VALUES (10584,0,0,0,'',9,0,100,0,0,5,5000,9000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1058401');
INSERT INTO `smart_scripts` VALUES (10584,0,1,0,'',0,0,100,0,9000,14000,17000,21000,0,'',11,16509,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 105840');
INSERT INTO `smart_scripts` VALUES (10584,0,2,0,'',0,0,100,0,10000,20000,21000,28000,0,'',11,16508,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 105840');
INSERT INTO `smart_scripts` VALUES (10742,0,0,0,'',74,0,100,0,0,20,9000,14000,0,'',11,16637,0,0,0,0,0,0,'',9,0,0,30,0,'',0,0,0,0,'VMaNGOS spell list 107420');
INSERT INTO `smart_scripts` VALUES (10813,0,0,0,'',0,0,100,0,31000,47000,10000,19000,0,'',11,12098,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 108130');
INSERT INTO `smart_scripts` VALUES (10813,0,1,0,'',0,0,100,0,49000,61000,28000,28000,0,'',11,13704,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 108130');
INSERT INTO `smart_scripts` VALUES (10813,0,2,0,'',0,0,100,0,31000,32000,6000,26000,0,'',11,17287,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 108130');
INSERT INTO `smart_scripts` VALUES (10813,0,3,0,'',0,0,100,0,28000,39000,7000,22000,0,'',11,17399,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 108130');
INSERT INTO `smart_scripts` VALUES (10813,0,4,0,'',0,0,100,0,38000,57000,27000,28000,0,'',11,17405,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 108130');
INSERT INTO `smart_scripts` VALUES (10882,0,0,0,'',63,0,100,0,0,0,0,0,0,'',11,10389,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1088201');
INSERT INTO `smart_scripts` VALUES (11347,0,0,0,'',25,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI: start in phase 0 (TC phase 1)');
INSERT INTO `smart_scripts` VALUES (11347,0,1,0,'',1,0,100,0,3000,20000,3000,20000,0,'',10,5,6,273,274,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134701');
INSERT INTO `smart_scripts` VALUES (11347,0,10,0,'',61,0,100,0,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134706');
INSERT INTO `smart_scripts` VALUES (11347,0,11,0,'',0,0,100,0,18000,22000,28000,42000,0,'',11,6713,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113470');
INSERT INTO `smart_scripts` VALUES (11347,0,12,0,'',0,0,100,0,15000,25000,15000,25000,0,'',11,17201,0,0,0,0,0,0,'',26,30,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113470');
INSERT INTO `smart_scripts` VALUES (11347,0,13,0,'',0,0,100,0,25000,35000,25000,35000,0,'',11,20545,32,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113470');
INSERT INTO `smart_scripts` VALUES (11347,0,14,0,'',74,0,100,0,0,60,15000,20000,0,'',11,24208,0,0,0,0,0,0,'',9,0,0,30,0,'',0,0,0,0,'VMaNGOS spell list 113470');
INSERT INTO `smart_scripts` VALUES (11347,0,2,0,'',2,4089,100,0,0,1,2000,2000,0,'',80,950001272,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134702');
INSERT INTO `smart_scripts` VALUES (11347,0,3,4,'',0,4090,100,0,2000,2000,2000,2000,0,'',42,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134703');
INSERT INTO `smart_scripts` VALUES (11347,0,4,0,'',61,0,100,0,0,0,0,0,0,'',41,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134703');
INSERT INTO `smart_scripts` VALUES (11347,0,5,6,'',0,4089,100,0,10000,10000,10000,10000,0,'',34,8,4,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134704');
INSERT INTO `smart_scripts` VALUES (11347,0,6,0,'',61,0,100,0,0,0,0,0,0,'',80,950001273,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134704');
INSERT INTO `smart_scripts` VALUES (11347,0,7,8,'',7,0,100,1,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134705');
INSERT INTO `smart_scripts` VALUES (11347,0,8,0,'',61,0,100,0,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134705');
INSERT INTO `smart_scripts` VALUES (11347,0,9,10,'',63,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134706');
INSERT INTO `smart_scripts` VALUES (11348,0,0,0,'',25,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI: start in phase 0 (TC phase 1)');
INSERT INTO `smart_scripts` VALUES (11348,0,1,0,'',1,0,100,0,3000,20000,3000,20000,0,'',10,1,20,273,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134801');
INSERT INTO `smart_scripts` VALUES (11348,0,10,0,'',61,0,100,0,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134806');
INSERT INTO `smart_scripts` VALUES (11348,0,11,0,'',0,0,100,0,12000,24000,20000,40000,0,'',11,12540,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113480');
INSERT INTO `smart_scripts` VALUES (11348,0,12,0,'',0,0,100,0,20000,40000,20000,30000,0,'',11,18765,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113480');
INSERT INTO `smart_scripts` VALUES (11348,0,13,0,'',0,0,100,0,4000,10000,4000,16000,0,'',11,15581,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113480');
INSERT INTO `smart_scripts` VALUES (11348,0,14,0,'',13,0,100,0,6000,12000,0,0,0,'',11,15614,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113480');
INSERT INTO `smart_scripts` VALUES (11348,0,15,0,'',0,0,100,0,20000,35000,35000,45000,0,'',11,21060,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 113480');
INSERT INTO `smart_scripts` VALUES (11348,0,2,0,'',2,4089,100,0,0,1,2000,2000,0,'',80,950001274,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134802');
INSERT INTO `smart_scripts` VALUES (11348,0,3,4,'',0,4090,100,0,2000,2000,2000,2000,0,'',42,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134803');
INSERT INTO `smart_scripts` VALUES (11348,0,4,0,'',61,0,100,0,0,0,0,0,0,'',41,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134803');
INSERT INTO `smart_scripts` VALUES (11348,0,5,6,'',0,4089,100,0,10000,10000,10000,10000,0,'',34,8,4,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134804');
INSERT INTO `smart_scripts` VALUES (11348,0,6,0,'',61,0,100,0,0,0,0,0,0,'',80,950001275,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134804');
INSERT INTO `smart_scripts` VALUES (11348,0,7,8,'',7,0,100,1,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134805');
INSERT INTO `smart_scripts` VALUES (11348,0,8,0,'',61,0,100,0,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134805');
INSERT INTO `smart_scripts` VALUES (11348,0,9,10,'',63,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1134806');
INSERT INTO `smart_scripts` VALUES (12143,0,0,0,'',9,0,100,0,15,100,5000,5000,0,'',11,21727,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1214301');
INSERT INTO `smart_scripts` VALUES (12416,0,0,0,'',21,0,100,1,0,0,0,0,0,'',41,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1241604');
INSERT INTO `smart_scripts` VALUES (12416,0,1,0,'',0,0,100,0,7000,10000,7000,10000,0,'',11,15754,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 124160');
INSERT INTO `smart_scripts` VALUES (12416,0,2,0,'',0,0,100,0,3000,6000,4000,6000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 124160');
INSERT INTO `smart_scripts` VALUES (12416,0,3,0,'',0,0,100,0,5000,8000,5000,8000,0,'',11,23967,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 124160');
INSERT INTO `smart_scripts` VALUES (12420,0,0,0,'',9,0,100,0,0,100,3000,6000,0,'',11,22271,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1242001');
INSERT INTO `smart_scripts` VALUES (12420,0,1,0,'',9,0,100,0,11,40,3000,4500,0,'',11,17290,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1242002');
INSERT INTO `smart_scripts` VALUES (12420,0,2,0,'',21,0,100,1,0,0,0,0,0,'',41,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1242003');
INSERT INTO `smart_scripts` VALUES (12422,0,0,0,'',21,0,100,1,0,0,0,0,0,'',41,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1242204');
INSERT INTO `smart_scripts` VALUES (12422,0,1,0,'',0,0,100,0,7000,10000,7000,10000,0,'',11,15663,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 124220');
INSERT INTO `smart_scripts` VALUES (12422,0,2,0,'',0,0,100,0,3000,6000,4000,6000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 124220');
INSERT INTO `smart_scripts` VALUES (12422,0,3,0,'',0,0,100,0,5000,8000,5000,8000,0,'',11,23967,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 124220');
INSERT INTO `smart_scripts` VALUES (13148,0,0,1,'',63,0,100,1,0,0,0,0,0,'',11,21155,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1314801');
INSERT INTO `smart_scripts` VALUES (13148,0,1,0,'',61,0,100,0,0,0,0,0,0,'',41,1000,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1314801');
INSERT INTO `smart_scripts` VALUES (13179,0,0,0,'',0,0,100,0,4000,9000,10000,17000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 131790');
INSERT INTO `smart_scripts` VALUES (13179,0,1,0,'',0,0,100,0,1000,10000,6000,15000,0,'',11,15572,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 131790');
INSERT INTO `smart_scripts` VALUES (13180,0,0,0,'',0,0,100,0,4000,9000,10000,17000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 131800');
INSERT INTO `smart_scripts` VALUES (13180,0,1,0,'',0,0,100,0,1000,10000,6000,15000,0,'',11,15572,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 131800');
INSERT INTO `smart_scripts` VALUES (13181,0,0,0,'',0,0,100,0,4000,9000,10000,17000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 131810');
INSERT INTO `smart_scripts` VALUES (13181,0,1,0,'',0,0,100,0,1000,10000,6000,15000,0,'',11,15572,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 131810');
INSERT INTO `smart_scripts` VALUES (13236,0,0,0,'',25,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI: start in phase 0 (TC phase 1)');
INSERT INTO `smart_scripts` VALUES (13236,0,1,0,'',1,0,100,1,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323601');
INSERT INTO `smart_scripts` VALUES (13236,0,10,0,'',3,4084,100,0,30,100,100,100,0,'',23,0,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323608');
INSERT INTO `smart_scripts` VALUES (13236,0,11,0,'',0,0,100,0,9000,13000,11000,15000,0,'',11,16006,1,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323609');
INSERT INTO `smart_scripts` VALUES (13236,0,12,0,'',0,0,100,0,7000,8000,14000,17000,0,'',11,15616,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323610');
INSERT INTO `smart_scripts` VALUES (13236,0,13,0,'',2,0,100,0,0,50,48000,60000,0,'',11,15786,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323611');
INSERT INTO `smart_scripts` VALUES (13236,0,14,0,'',2,0,100,0,0,30,15000,22000,0,'',11,15982,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323612');
INSERT INTO `smart_scripts` VALUES (13236,0,15,0,'',7,0,100,1,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323613');
INSERT INTO `smart_scripts` VALUES (13236,0,2,3,'',4,0,100,1,0,0,0,0,0,'',11,15234,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323602');
INSERT INTO `smart_scripts` VALUES (13236,0,3,0,'',61,0,100,0,0,0,0,0,0,'',23,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323602');
INSERT INTO `smart_scripts` VALUES (13236,0,4,0,'',9,4082,100,0,0,40,3400,4800,0,'',11,15234,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323603');
INSERT INTO `smart_scripts` VALUES (13236,0,5,6,'',3,4082,100,1,0,15,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323604');
INSERT INTO `smart_scripts` VALUES (13236,0,6,0,'',61,0,100,0,0,0,0,0,0,'',23,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323604');
INSERT INTO `smart_scripts` VALUES (13236,0,7,0,'',9,4082,100,1,35,80,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323605');
INSERT INTO `smart_scripts` VALUES (13236,0,8,0,'',9,4082,100,1,5,15,0,0,0,'',21,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323606');
INSERT INTO `smart_scripts` VALUES (13236,0,9,0,'',9,4082,100,1,0,5,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1323607');
INSERT INTO `smart_scripts` VALUES (13284,0,0,0,'',1,0,100,0,1000,1000,600000,600000,0,'',11,12550,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1328401');
INSERT INTO `smart_scripts` VALUES (13284,0,1,0,'',0,0,100,0,1000,3000,5000,7000,0,'',11,21401,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1328402');
INSERT INTO `smart_scripts` VALUES (13284,0,2,0,'',2,0,100,0,0,50,15000,22000,0,'',11,12492,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1328403');
INSERT INTO `smart_scripts` VALUES (13437,0,0,0,'',1,0,100,1,1000,1000,0,0,0,'',11,16380,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1343701');
INSERT INTO `smart_scripts` VALUES (13437,0,1,0,'',4,0,100,1,0,0,0,0,0,'',28,16380,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1343702');
INSERT INTO `smart_scripts` VALUES (13437,0,2,0,'',0,0,100,0,4000,6000,7000,9000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134370');
INSERT INTO `smart_scripts` VALUES (13437,0,3,0,'',0,0,100,0,9000,13000,18000,34000,0,'',11,16509,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134370');
INSERT INTO `smart_scripts` VALUES (13438,0,0,0,'',0,0,100,0,4000,6000,7000,9000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134380');
INSERT INTO `smart_scripts` VALUES (13438,0,1,0,'',0,0,100,0,9000,13000,18000,34000,0,'',11,16509,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134380');
INSERT INTO `smart_scripts` VALUES (13439,0,0,0,'',0,0,100,0,4000,6000,7000,9000,0,'',11,15580,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134390');
INSERT INTO `smart_scripts` VALUES (13439,0,1,0,'',0,0,100,0,9000,13000,18000,34000,0,'',11,16509,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134390');
INSERT INTO `smart_scripts` VALUES (13442,0,0,0,'',2,0,100,0,0,50,12000,15000,0,'',11,15981,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1344203');
INSERT INTO `smart_scripts` VALUES (13442,0,1,0,'',0,0,100,0,2000,5000,5000,8000,0,'',11,22206,32,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134420');
INSERT INTO `smart_scripts` VALUES (13442,0,2,0,'',0,0,100,0,7000,9000,10000,13000,0,'',11,22127,1,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134420');
INSERT INTO `smart_scripts` VALUES (13443,0,0,0,'',1,0,100,0,1000,1000,600000,600000,0,'',11,22128,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1344301');
INSERT INTO `smart_scripts` VALUES (13443,0,1,0,'',0,0,100,0,5000,8000,13000,17000,0,'',11,21668,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134430');
INSERT INTO `smart_scripts` VALUES (13443,0,2,0,'',0,0,100,0,7000,9000,10000,13000,0,'',11,22127,1,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 134430');
INSERT INTO `smart_scripts` VALUES (13577,0,0,0,'',0,0,100,0,5000,8000,9000,13000,0,'',11,16856,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 135770');
INSERT INTO `smart_scripts` VALUES (13577,0,1,0,'',0,0,100,0,4000,7000,7000,9000,0,'',11,15663,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 135770');
INSERT INTO `smart_scripts` VALUES (14302,0,0,1,'',6,0,100,1,0,0,0,0,0,'',11,23363,3,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1430202');
INSERT INTO `smart_scripts` VALUES (14302,0,1,0,'',61,0,100,0,0,0,0,0,0,'',41,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1430202');
INSERT INTO `smart_scripts` VALUES (14302,0,2,0,'',0,0,100,0,10000,10000,4000,6000,0,'',11,22560,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 143020');
INSERT INTO `smart_scripts` VALUES (14509,0,0,0,'',25,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI: start in phase 0 (TC phase 1)');
INSERT INTO `smart_scripts` VALUES (14509,0,1,0,'',1,0,100,0,3000,20000,3000,20000,0,'',10,1,23,25,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450901');
INSERT INTO `smart_scripts` VALUES (14509,0,10,11,'',7,0,100,1,0,0,0,0,0,'',34,6,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450907');
INSERT INTO `smart_scripts` VALUES (14509,0,11,12,'',61,0,100,0,0,0,0,0,0,'',34,7,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450907');
INSERT INTO `smart_scripts` VALUES (14509,0,12,13,'',61,0,100,0,0,0,0,0,0,'',34,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450907');
INSERT INTO `smart_scripts` VALUES (14509,0,13,14,'',61,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450907');
INSERT INTO `smart_scripts` VALUES (14509,0,14,0,'',61,0,100,0,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450907');
INSERT INTO `smart_scripts` VALUES (14509,0,15,16,'',6,0,100,1,0,0,0,0,0,'',34,6,3,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450908');
INSERT INTO `smart_scripts` VALUES (14509,0,16,17,'',61,0,100,0,0,0,0,0,0,'',34,7,3,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450908');
INSERT INTO `smart_scripts` VALUES (14509,0,17,18,'',61,0,100,0,0,0,0,0,0,'',34,8,3,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450908');
INSERT INTO `smart_scripts` VALUES (14509,0,18,0,'',61,0,100,0,0,0,0,0,0,'',1,4,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450908');
INSERT INTO `smart_scripts` VALUES (14509,0,19,0,'',13,0,100,0,6000,24000,0,0,0,'',11,22666,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 145090');
INSERT INTO `smart_scripts` VALUES (14509,0,2,0,'',2,4089,100,0,0,1,2000,2000,0,'',80,950001296,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450902');
INSERT INTO `smart_scripts` VALUES (14509,0,20,0,'',0,0,100,0,12000,24000,12000,24000,0,'',11,22859,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 145090');
INSERT INTO `smart_scripts` VALUES (14509,0,21,0,'',16,0,100,0,24185,30,20000,40000,0,'',11,24185,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 145090');
INSERT INTO `smart_scripts` VALUES (14509,0,3,4,'',0,4090,100,0,2000,2000,2000,2000,0,'',22,3,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450903');
INSERT INTO `smart_scripts` VALUES (14509,0,4,0,'',61,0,100,0,0,0,0,0,0,'',80,950001297,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450903');
INSERT INTO `smart_scripts` VALUES (14509,0,5,6,'',0,4089,100,0,10000,10000,10000,10000,0,'',34,8,4,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450904');
INSERT INTO `smart_scripts` VALUES (14509,0,6,0,'',61,0,100,0,0,0,0,0,0,'',80,950001298,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450904');
INSERT INTO `smart_scripts` VALUES (14509,0,7,8,'',2,4092,100,1,1,20,0,0,0,'',11,8269,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450905');
INSERT INTO `smart_scripts` VALUES (14509,0,8,0,'',61,0,100,0,0,0,0,0,0,'',1,3,0,1,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450905');
INSERT INTO `smart_scripts` VALUES (14509,0,9,0,'',4,0,100,1,0,0,0,0,0,'',34,6,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1450906');
INSERT INTO `smart_scripts` VALUES (14566,0,0,0,'',63,0,100,1,0,0,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1456601');
INSERT INTO `smart_scripts` VALUES (14605,0,0,0,'',9,0,100,0,0,5,5000,8000,0,'',11,8355,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1460502');
INSERT INTO `smart_scripts` VALUES (14605,0,1,0,'',7,0,100,1,0,0,0,0,0,'',41,10000,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1460503');
INSERT INTO `smart_scripts` VALUES (14668,0,0,0,'',0,0,100,0,3000,3000,3000,3000,0,'',11,20153,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 146680');
INSERT INTO `smart_scripts` VALUES (14668,0,1,0,'',0,0,100,0,2000,5000,10000,12000,0,'',11,22703,1,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 146680');
INSERT INTO `smart_scripts` VALUES (14693,0,0,0,'',9,0,100,0,0,5,3000,10000,0,'',11,22643,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 146930');
INSERT INTO `smart_scripts` VALUES (14693,0,1,0,'',0,0,100,0,0,5000,14000,40000,0,'',11,17165,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 146930');
INSERT INTO `smart_scripts` VALUES (14693,0,2,0,'',0,0,100,0,0,5000,12000,20000,0,'',11,15531,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 146930');
INSERT INTO `smart_scripts` VALUES (14693,0,3,0,'',0,0,100,0,0,5000,17000,30000,0,'',11,28873,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 146930');
INSERT INTO `smart_scripts` VALUES (15041,0,0,0,'',0,0,100,1,4000,12000,0,0,0,'',11,19448,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1504101');
INSERT INTO `smart_scripts` VALUES (15041,0,1,0,'',23,0,100,1,24086,10,0,0,0,'',11,24088,34,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1504102');
INSERT INTO `smart_scripts` VALUES (15041,0,2,0,'',23,0,100,0,24087,0,20000,20000,0,'',11,24087,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1504103');
INSERT INTO `smart_scripts` VALUES (15082,0,0,0,'',63,0,100,0,0,0,0,0,0,'',11,24240,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508201');
INSERT INTO `smart_scripts` VALUES (15082,0,1,2,'',0,0,100,0,24000,28000,24000,28000,0,'',11,24646,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508202');
INSERT INTO `smart_scripts` VALUES (15082,0,2,3,'',61,0,100,0,0,0,0,0,0,'',11,24647,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508202');
INSERT INTO `smart_scripts` VALUES (15082,0,3,0,'',61,0,100,0,0,0,0,0,0,'',14,0,100,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508202');
INSERT INTO `smart_scripts` VALUES (15082,0,4,0,'',0,0,100,0,18000,20000,18000,20000,0,'',11,6524,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150820');
INSERT INTO `smart_scripts` VALUES (15082,0,5,0,'',0,0,100,0,10000,15000,10000,15000,0,'',11,24648,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150820');
INSERT INTO `smart_scripts` VALUES (15083,0,0,0,'',63,0,100,0,0,0,0,0,0,'',11,24240,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508301');
INSERT INTO `smart_scripts` VALUES (15083,0,1,2,'',0,0,100,0,20000,25000,20000,25000,0,'',11,24728,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508303');
INSERT INTO `smart_scripts` VALUES (15083,0,2,3,'',61,0,100,0,0,0,0,0,0,'',11,24681,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508303');
INSERT INTO `smart_scripts` VALUES (15083,0,3,0,'',61,0,100,0,0,0,0,0,0,'',11,24729,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508303');
INSERT INTO `smart_scripts` VALUES (15083,0,4,0,'',0,0,100,0,20000,26000,20000,26000,0,'',11,24684,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150830');
INSERT INTO `smart_scripts` VALUES (15083,0,5,0,'',0,0,100,0,12000,15000,17000,33000,0,'',11,24664,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150830');
INSERT INTO `smart_scripts` VALUES (15083,0,6,0,'',0,0,100,0,9000,15000,9000,15000,0,'',11,24685,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150830');
INSERT INTO `smart_scripts` VALUES (15085,0,0,0,'',63,0,100,0,0,0,0,0,0,'',11,24240,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1508501');
INSERT INTO `smart_scripts` VALUES (15085,0,1,0,'',0,0,100,0,15000,19000,15000,19000,0,'',11,24680,0,0,0,0,0,0,'',6,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150850');
INSERT INTO `smart_scripts` VALUES (15085,0,2,0,'',0,0,100,0,7000,11000,7000,11000,0,'',11,24682,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150850');
INSERT INTO `smart_scripts` VALUES (15085,0,3,0,'',0,0,100,0,12000,15000,12000,15000,0,'',11,24683,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 150850');
INSERT INTO `smart_scripts` VALUES (15163,0,0,0,'',63,0,33,1,0,0,0,0,0,'',3,0,14255,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1516301');
INSERT INTO `smart_scripts` VALUES (15163,0,1,0,'',63,0,33,1,0,0,0,0,0,'',3,0,11636,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1516302');
INSERT INTO `smart_scripts` VALUES (15163,0,2,0,'',63,0,33,1,0,0,0,0,0,'',3,0,10433,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1516303');
INSERT INTO `smart_scripts` VALUES (15163,0,3,0,'',63,0,33,1,0,0,0,0,0,'',3,0,5305,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1516304');
INSERT INTO `smart_scripts` VALUES (15163,0,4,5,'',4,0,100,1,0,0,0,0,0,'',14,0,100,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1516305');
INSERT INTO `smart_scripts` VALUES (15163,0,5,0,'',61,0,100,0,0,0,0,0,0,'',38,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1516305');
INSERT INTO `smart_scripts` VALUES (15341,0,0,1,'',4,0,100,1,0,0,0,0,0,'',34,2,1,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534101');
INSERT INTO `smart_scripts` VALUES (15341,0,1,0,'',61,0,100,0,0,0,0,0,0,'',38,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534101');
INSERT INTO `smart_scripts` VALUES (15341,0,10,0,'',63,0,100,0,0,0,0,0,0,'',2,310,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534106');
INSERT INTO `smart_scripts` VALUES (15341,0,11,0,'',7,0,100,1,0,0,0,0,0,'',1,4,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534107');
INSERT INTO `smart_scripts` VALUES (15341,0,12,0,'',9,0,100,0,0,5,22000,25000,0,'',11,25599,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 153410');
INSERT INTO `smart_scripts` VALUES (15341,0,13,0,'',0,0,100,0,5000,5000,15000,25000,0,'',11,6713,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 153410');
INSERT INTO `smart_scripts` VALUES (15341,0,2,3,'',6,0,100,1,0,0,0,0,0,'',34,2,3,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534102');
INSERT INTO `smart_scripts` VALUES (15341,0,3,0,'',61,0,100,0,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534102');
INSERT INTO `smart_scripts` VALUES (15341,0,4,5,'',2,0,100,1,1,30,0,0,0,'',11,8269,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534103');
INSERT INTO `smart_scripts` VALUES (15341,0,5,0,'',61,0,100,0,0,0,0,0,0,'',1,1,0,1,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534103');
INSERT INTO `smart_scripts` VALUES (15341,0,6,0,'',5,0,100,0,30000,30000,0,0,0,'',1,2,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534104');
INSERT INTO `smart_scripts` VALUES (15341,0,7,8,'',63,0,100,0,0,0,0,0,0,'',1,3,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534105');
INSERT INTO `smart_scripts` VALUES (15341,0,8,9,'',61,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534105');
INSERT INTO `smart_scripts` VALUES (15341,0,9,0,'',61,0,100,0,0,0,0,0,0,'',42,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1534105');
INSERT INTO `smart_scripts` VALUES (15554,0,0,0,'',63,0,100,0,0,0,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1555401');
INSERT INTO `smart_scripts` VALUES (15622,0,0,0,'',0,0,100,0,0,0,0,0,0,'',11,22913,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 156220');
INSERT INTO `smart_scripts` VALUES (15934,0,0,0,'',0,0,100,0,4000,4000,4000,6000,0,'',11,24150,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 159340');
INSERT INTO `smart_scripts` VALUES (16124,0,0,0,'',0,0,100,0,0,0,15000,15000,0,'',11,30285,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161240');
INSERT INTO `smart_scripts` VALUES (16124,0,1,0,'',0,0,100,0,5000,6000,8000,10000,0,'',11,11428,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161240');
INSERT INTO `smart_scripts` VALUES (16125,0,0,1,'',0,0,100,0,5000,8000,12000,15000,0,'',11,27577,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1612501');
INSERT INTO `smart_scripts` VALUES (16125,0,1,0,'',61,0,100,0,0,0,0,0,0,'',14,0,100,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1612501');
INSERT INTO `smart_scripts` VALUES (16125,0,2,0,'',0,0,100,0,1000,2000,10000,15000,0,'',11,27825,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161250');
INSERT INTO `smart_scripts` VALUES (16126,0,0,0,'',0,0,100,0,1000,2000,5000,6000,0,'',11,27831,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161260');
INSERT INTO `smart_scripts` VALUES (16127,0,0,0,'',0,0,100,0,1000,1000,3000,4000,0,'',11,27989,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161270');
INSERT INTO `smart_scripts` VALUES (16127,0,1,0,'',0,0,100,0,3000,3000,10000,11000,0,'',11,27990,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161270');
INSERT INTO `smart_scripts` VALUES (16148,0,0,0,'',0,0,100,0,1000,3000,5000,6000,0,'',11,27991,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161480');
INSERT INTO `smart_scripts` VALUES (16148,0,1,0,'',0,0,100,0,5000,10000,10000,12000,0,'',11,27992,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161480');
INSERT INTO `smart_scripts` VALUES (16148,0,2,0,'',0,0,100,0,10000,20000,15000,20000,0,'',11,28333,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161480');
INSERT INTO `smart_scripts` VALUES (16149,0,0,0,'',0,0,100,0,2000,5000,30000,30000,0,'',11,27993,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161490');
INSERT INTO `smart_scripts` VALUES (16150,0,0,0,'',16,0,100,0,27995,30,5000,10000,0,'',11,27995,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1615002');
INSERT INTO `smart_scripts` VALUES (16150,0,1,0,'',63,0,100,1,0,0,0,0,0,'',11,27987,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1615003');
INSERT INTO `smart_scripts` VALUES (16150,0,2,0,'',0,0,100,0,3000,5000,10000,12000,0,'',11,27994,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 161500');
INSERT INTO `smart_scripts` VALUES (16286,0,0,0,'',6,0,100,1,0,0,0,0,0,'',11,29232,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1628601');
INSERT INTO `smart_scripts` VALUES (16290,0,0,0,'',0,0,100,0,0,3000,0,3000,0,'',11,25680,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 162900');
INSERT INTO `smart_scripts` VALUES (16363,0,0,1,'',63,0,100,0,0,0,0,0,0,'',20,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1636301');
INSERT INTO `smart_scripts` VALUES (16363,0,1,0,'',61,0,100,0,0,0,0,0,0,'',21,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1636301');
INSERT INTO `smart_scripts` VALUES (16363,0,2,3,'',7,0,100,1,0,0,0,0,0,'',20,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1636302');
INSERT INTO `smart_scripts` VALUES (16363,0,3,0,'',61,0,100,0,0,0,0,0,0,'',21,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1636302');
INSERT INTO `smart_scripts` VALUES (16363,0,4,0,'',0,0,100,1,0,0,0,0,0,'',11,28158,32,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1636303');
INSERT INTO `smart_scripts` VALUES (16363,0,5,0,'',1,0,100,1,0,0,0,0,0,'',11,28158,32,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS EventAI 1636304');
INSERT INTO `smart_scripts` VALUES (16387,0,0,0,'',0,0,100,0,1000,1000,13000,18000,0,'',11,19729,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 163870');
INSERT INTO `smart_scripts` VALUES (16387,0,1,0,'',0,0,100,0,15000,15000,15000,25000,0,'',11,28352,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 163870');
INSERT INTO `smart_scripts` VALUES (16981,0,0,0,'',0,0,100,0,3000,3000,8000,10000,0,'',11,15453,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 169810');
INSERT INTO `smart_scripts` VALUES (16982,0,0,0,'',0,0,100,0,1000,4000,6000,7000,0,'',11,17547,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'VMaNGOS spell list 169820');
INSERT INTO `smart_scripts` VALUES (252477,0,0,0,'',1,0,100,0,1000,3000,900,1500,0,'',11,1288546,0,0,0,0,0,0,NULL,1,0,0,0,0,NULL,0,0,0,0,'Peacekeeper Elite - Out of Combat - Cast \'1288546\' on Self');
INSERT INTO `smart_scripts` VALUES (940000000,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30011875,104591,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 11881: Scarlet Monastery Chapel door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000001,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30011876,97700,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 11894: Scarlet Monastery secret door torch (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000002,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30015640,161462,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15351: Blackrock Depths Shadowforge Lock -> giant doors (TC rows: retail guids)');
INSERT INTO `smart_scripts` VALUES (940000002,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30015639,161461,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15351: Blackrock Depths Shadowforge Lock -> giant doors (TC rows: retail guids)');
INSERT INTO `smart_scripts` VALUES (940000002,9,2,0,'',0,0,100,0,20000,20000,0,0,0,'',147,10,0,0,0,0,0,0,'',14,30015576,157923,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15351: Blackrock Depths Shadowforge Lock -> giant doors (TC rows: retail guids)');
INSERT INTO `smart_scripts` VALUES (940000002,9,3,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30015352,161516,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 15351: Blackrock Depths Shadowforge Lock -> giant doors (TC rows: retail guids)');
INSERT INTO `smart_scripts` VALUES (940000003,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30026182,16399,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 26192: Deadmines Foundry door lever (TC row: wrong door entry)');
INSERT INTO `smart_scripts` VALUES (940000004,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30026185,16400,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 26197: Deadmines Mast Room door lever (TC row: wrong door entry)');
INSERT INTO `smart_scripts` VALUES (940000005,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30020835,18895,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 32443: Shadowfang Keep courtyard door lever (no script)');
INSERT INTO `smart_scripts` VALUES (940000006,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30043178,175610,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 43177: Scholomance torch -> old treasure vault door (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000007,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30015012,101850,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44809: Scarlet Monastery Cathedral door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000007,9,1,0,'',0,0,100,0,15000,15000,0,0,0,'',147,10,0,0,0,0,0,0,'',14,30015012,101850,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44809: Scarlet Monastery Cathedral door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000008,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30015013,101851,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44811: Scarlet Monastery Armory door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000008,9,1,0,'',0,0,100,0,15000,15000,0,0,0,'',147,10,0,0,0,0,0,0,'',14,30015013,101851,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44811: Scarlet Monastery Armory door lever (TC row: retail guid)');
INSERT INTO `smart_scripts` VALUES (940000009,9,0,0,'',0,0,100,0,0,0,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30234830,179116,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 234837: Blackwing Lair lever -> Chromaggus portcullis (no script)');
INSERT INTO `smart_scripts` VALUES (940000010,9,0,0,'',0,0,100,0,6000,6000,0,0,0,'',50,105168,7,1,0,0,0,0,'',8,0,0,0,0,'',2375.96,360.053,38.2241,2.3911,'VMaNGOS gameobject_scripts 44766: Mausoleum Trigger - Ulag the Cleaver');
INSERT INTO `smart_scripts` VALUES (940000010,9,1,0,'',0,0,100,0,0,0,0,0,0,'',50,103813,7,1,0,0,0,0,'',8,0,0,0,0,'',2387.86,339.52,37.4054,2.2166,'VMaNGOS gameobject_scripts 44766: Mausoleum Trigger - Ulag the Cleaver');
INSERT INTO `smart_scripts` VALUES (940000010,9,2,0,'',0,0,100,0,11000,11000,0,0,0,'',147,8,0,0,0,0,0,0,'',14,30044816,176594,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44766: Mausoleum Trigger - Ulag the Cleaver');
INSERT INTO `smart_scripts` VALUES (940000010,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,6390,1,120000,0,0,0,0,'',8,0,0,0,0,'',2384.65,343.654,38.1009,2.226,'VMaNGOS gameobject_scripts 44766: Mausoleum Trigger - Ulag the Cleaver');
INSERT INTO `smart_scripts` VALUES (940000010,9,4,0,'',0,0,100,0,15000,15000,0,0,0,'',147,10,0,0,0,0,0,0,'',14,30044816,176594,0,0,'',0,0,0,0,'VMaNGOS gameobject_scripts 44766: Mausoleum Trigger - Ulag the Cleaver');
INSERT INTO `smart_scripts` VALUES (940100000,9,0,0,'',0,0,100,0,0,0,0,0,0,'',63,1,0,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100000,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,10,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100000,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',256.289,0.652,84.924,4.765,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100000,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',241.345,4.231,84.924,5.062,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100000,9,4,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',249.715,-5.978,85.106,3.177,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100000,9,5,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',230.05,-9.946,85.317,5.847,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100000,9,6,0,'',0,0,100,0,300000,300000,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5618: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100001,9,0,0,'',0,0,100,0,0,0,0,0,0,'',63,1,0,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5619: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100001,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,10,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5619: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100001,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',180.707,-75.818,84.925,1.396,'VMaNGOS event 5619: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100001,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',185.689,-64.627,84.925,5.55,'VMaNGOS event 5619: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100001,9,4,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',175.7,-55.238,85.229,4.772,'VMaNGOS event 5619: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100001,9,5,0,'',0,0,100,0,300000,300000,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5619: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100002,9,0,0,'',0,0,100,0,0,0,0,0,0,'',63,1,0,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5620: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100002,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,10,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5620: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100002,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',123.306,3.933,85.312,6.056,'VMaNGOS event 5620: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100002,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',110.892,-6.463,85.312,0.436,'VMaNGOS event 5620: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100002,9,4,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',102.454,4.374,85.312,2.182,'VMaNGOS event 5620: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100002,9,5,0,'',0,0,100,0,300000,300000,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5620: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100003,9,0,0,'',0,0,100,0,0,0,0,0,0,'',63,1,0,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5621: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100003,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,10,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5621: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100003,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',239.556,-4.945,72.674,1.4525,'VMaNGOS event 5621: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100003,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',226.854,0.262,72.673,3.161,'VMaNGOS event 5621: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100003,9,4,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',248.115,2.809,72.669,4.668,'VMaNGOS event 5621: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100003,9,5,0,'',0,0,100,0,300000,300000,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5621: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100004,9,0,0,'',0,0,100,0,0,0,0,0,0,'',63,1,0,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5622: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100004,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,10,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5622: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100004,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',185.616,-42.912,75.4812,4.4506,'VMaNGOS event 5622: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100004,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',177.746,-42.7475,75.4812,4.8869,'VMaNGOS event 5622: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100004,9,4,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',181.825,-42.5812,75.4812,4.66,'VMaNGOS event 5622: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100004,9,5,0,'',0,0,100,0,300000,300000,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5622: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100005,9,0,0,'',0,0,100,0,0,0,0,0,0,'',63,1,0,1,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5623: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100005,9,1,0,'',0,0,100,0,0,0,0,0,0,'',147,10,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5623: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100005,9,2,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',128.806,-7.874,75.482,5.62,'VMaNGOS event 5623: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100005,9,3,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',130.415,-1.113,75.482,2.688,'VMaNGOS event 5623: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100005,9,4,0,'',0,0,100,0,0,0,0,0,0,'',12,11598,1,300000,0,0,0,0,'',8,0,0,0,0,'',124.162,5.816,75.482,5.061,'VMaNGOS event 5623: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940100005,9,5,0,'',0,0,100,0,300000,300000,0,0,0,'',147,8,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS event 5623: shadow portal room');
INSERT INTO `smart_scripts` VALUES (940200000,9,0,0,'',0,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,1,0,'',0,0,100,0,1000,1000,0,0,0,'',1,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,2,0,'',0,0,100,0,2000,2000,0,0,0,'',145,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,3,0,'',0,0,100,0,3000,3000,0,0,0,'',1,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,4,0,'',0,0,100,0,2000,2000,0,0,0,'',8,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,5,0,'',0,0,100,0,0,0,0,0,0,'',49,0,0,0,0,0,0,0,'',19,10339,100,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,6,0,'',0,0,100,0,0,0,0,0,0,'',1,16,0,0,0,0,0,0,'',19,10162,100,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,7,0,'',0,0,100,0,6000,6000,0,0,0,'',1,17,0,0,0,0,0,0,'',19,10162,100,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,8,0,'',0,0,100,0,4000,4000,0,0,0,'',1,18,0,0,0,0,0,0,'',19,10162,100,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200000,9,9,0,'',0,0,100,0,6000,6000,0,0,0,'',86,16404,2,19,10162,100,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4623 Call of Vaelastrasz (combat)');
INSERT INTO `smart_scripts` VALUES (940200001,9,0,0,'',0,0,100,0,0,0,0,0,0,'',8,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4624 Call of Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (940200001,9,1,0,'',0,0,100,0,0,0,0,0,0,'',1,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4624 Call of Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (940200001,9,2,0,'',0,0,100,0,3000,3000,0,0,0,'',11,16319,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4624 Call of Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (940200001,9,3,0,'',0,0,100,0,3000,3000,0,0,0,'',11,16354,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4624 Call of Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (940200001,9,4,0,'',0,0,100,0,2000,2000,0,0,0,'',41,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic 4624 Call of Vaelastrasz (no Gyth)');
INSERT INTO `smart_scripts` VALUES (950001272,9,0,0,'',0,0,100,0,0,0,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,1,0,'',0,0,100,0,0,0,0,0,0,'',20,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,2,0,'',0,0,100,0,0,0,0,0,0,'',21,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,3,0,'',0,0,100,0,0,0,0,0,0,'',28,0,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,4,0,'',0,0,100,0,0,0,0,0,0,'',11,19951,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,5,0,'',0,0,100,0,0,0,0,0,0,'',90,7,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,6,0,'',0,0,100,0,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001272,9,7,0,'',0,0,100,0,0,0,0,0,0,'',34,7,4,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001273,9,0,0,'',0,0,100,0,2000,2000,0,0,0,'',11,23329,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,1,0,'',0,0,100,0,0,0,0,0,0,'',11,24171,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,2,0,'',0,0,100,0,0,0,0,0,0,'',90,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,3,0,'',0,0,100,0,0,0,0,0,0,'',28,19951,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,4,0,'',0,0,100,0,0,0,0,0,0,'',20,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,5,0,'',0,0,100,0,0,0,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,6,0,'',0,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001273,9,7,0,'',0,0,100,0,0,0,0,0,0,'',1,1,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001274,9,0,0,'',0,0,100,0,0,0,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,1,0,'',0,0,100,0,0,0,0,0,0,'',20,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,2,0,'',0,0,100,0,0,0,0,0,0,'',21,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,3,0,'',0,0,100,0,0,0,0,0,0,'',28,0,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,4,0,'',0,0,100,0,0,0,0,0,0,'',11,19951,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,5,0,'',0,0,100,0,0,0,0,0,0,'',90,7,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,6,0,'',0,0,100,0,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001274,9,7,0,'',0,0,100,0,0,0,0,0,0,'',34,7,4,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001275,9,0,0,'',0,0,100,0,2000,2000,0,0,0,'',11,23329,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,1,0,'',0,0,100,0,0,0,0,0,0,'',11,24171,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,2,0,'',0,0,100,0,0,0,0,0,0,'',90,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,3,0,'',0,0,100,0,0,0,0,0,0,'',28,19951,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,4,0,'',0,0,100,0,0,0,0,0,0,'',20,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,5,0,'',0,0,100,0,0,0,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,6,0,'',0,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001275,9,7,0,'',0,0,100,0,0,0,0,0,0,'',1,1,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001296,9,0,0,'',0,0,100,0,0,0,0,0,0,'',22,2,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,1,0,'',0,0,100,0,0,0,0,0,0,'',20,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,2,0,'',0,0,100,0,0,0,0,0,0,'',21,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,3,0,'',0,0,100,0,0,0,0,0,0,'',28,0,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,4,0,'',0,0,100,0,0,0,0,0,0,'',11,19951,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,5,0,'',0,0,100,0,0,0,0,0,0,'',90,7,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,6,0,'',0,0,100,0,0,0,0,0,0,'',1,0,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001296,9,7,0,'',0,0,100,0,0,0,0,0,0,'',34,7,4,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14508');
INSERT INTO `smart_scripts` VALUES (950001297,9,0,0,'',0,0,100,0,0,0,0,0,0,'',90,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,1,0,'',0,0,100,0,0,0,0,0,0,'',11,24171,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,2,0,'',0,0,100,0,2000,2000,0,0,0,'',5,53,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,3,0,'',0,0,100,0,0,0,0,0,0,'',1,1,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,4,0,'',0,0,100,0,2000,2000,0,0,0,'',11,24169,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,5,0,'',0,0,100,0,0,0,0,0,0,'',28,19951,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,6,0,'',0,0,100,0,0,0,0,0,0,'',20,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,7,0,'',0,0,100,0,0,0,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001297,9,8,0,'',0,0,100,0,1000,1000,0,0,0,'',42,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 1450903');
INSERT INTO `smart_scripts` VALUES (950001298,9,0,0,'',0,0,100,0,2000,2000,0,0,0,'',11,23329,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,1,0,'',0,0,100,0,0,0,0,0,0,'',11,24171,2,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,2,0,'',0,0,100,0,0,0,0,0,0,'',90,0,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,3,0,'',0,0,100,0,0,0,0,0,0,'',28,19951,0,0,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,4,0,'',0,0,100,0,0,0,0,0,0,'',20,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,5,0,'',0,0,100,0,0,0,0,0,0,'',21,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,6,0,'',0,0,100,0,0,0,0,0,0,'',22,1,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
INSERT INTO `smart_scripts` VALUES (950001298,9,7,0,'',0,0,100,0,0,0,0,0,0,'',1,2,0,1,0,0,0,0,'',7,0,0,0,0,'',0,0,0,0,'VMaNGOS generic_scripts 14509');
-- General Rajaxx and the Val'anaar Peacekeeper Elite run on the rows above again.
UPDATE `creature_template` SET `AIName`='SmartAI' WHERE `entry` IN (15341,252477) AND `AIName`='' AND `ScriptName`='';

-- Two of our fixes are newer than Karrz files in this batch that touch the same rows; the batch runs after them on an
-- existing world, so they are applied again here (both are plain deletes / delete-then-insert, safe to run again).
-- 2026_11_08_01_world_dead_quest_loot: Karrz's VMaNGOS loot rebuild (2026_10_24_10) and quest-data restore (2026_11_05_99)
-- write back quest-only loot rows that no quest can unlock (entries 205, 2374, 4021 and others).

DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 774 AND `QuestRequired` = 1; -- Малахит, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 6170 AND `ItemType` = 0 AND `Item` = 895 AND `QuestRequired` = 1; -- Череп воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 205 AND `ItemType` = 0 AND `Item` = 895 AND `QuestRequired` = 1; -- Череп воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 920 AND `ItemType` = 0 AND `Item` = 895 AND `QuestRequired` = 1; -- Череп воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 205 AND `ItemType` = 0 AND `Item` = 896 AND `QuestRequired` = 1; -- Клык воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 206 AND `ItemType` = 0 AND `Item` = 896 AND `QuestRequired` = 1; -- Клык воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6170 AND `ItemType` = 0 AND `Item` = 896 AND `QuestRequired` = 1; -- Клык воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 533 AND `ItemType` = 0 AND `Item` = 896 AND `QuestRequired` = 1; -- Клык воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 898 AND `ItemType` = 0 AND `Item` = 896 AND `QuestRequired` = 1; -- Клык воргена, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 920 AND `ItemType` = 0 AND `Item` = 896 AND `QuestRequired` = 1; -- Клык воргена, no quest in 1.12
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 2216 AND `ItemType` = 0 AND `Item` = 1527 AND `QuestRequired` = 1; -- Испорченный клок сена, no quest in 1.12
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 1697 AND `ItemType` = 0 AND `Item` = 1923 AND `QuestRequired` = 1; -- Сумка посланника, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 11561 AND `ItemType` = 0 AND `Item` = 2477 AND `QuestRequired` = 1; -- Череп опустошителя, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 1754 AND `ItemType` = 0 AND `Item` = 3516 AND `QuestRequired` = 1; -- Голова Лесковара, no quest in 1.12
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 1711 AND `ItemType` = 0 AND `Item` = 3744 AND `QuestRequired` = 1; -- Подвеска Кровавого камня, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 3818 AND `QuestRequired` = 1; -- Бледнолист, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 3871 AND `QuestRequired` = 1; -- Чертеж: золотые чешуйчатые наплечники, plain
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 2008 AND `ItemType` = 0 AND `Item` = 3929 AND `QuestRequired` = 1; -- Добыча Моури, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 3696 AND `ItemType` = 0 AND `Item` = 5389 AND `QuestRequired` = 1; -- Оскверненный тотем фурболгов, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 10642 AND `ItemType` = 0 AND `Item` = 5448 AND `QuestRequired` = 1; -- Треснувший браслет элементаля, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 3891 AND `ItemType` = 0 AND `Item` = 5505 AND `QuestRequired` = 1; -- Записи Терониса, start item
DELETE FROM `creature_loot_template` WHERE `Entry` = 4021 AND `ItemType` = 0 AND `Item` = 5681 AND `QuestRequired` = 1; -- Едкая слизь, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 6390 AND `QuestRequired` = 1; -- Выкройка: стильная синяя рубашка, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2375 AND `ItemType` = 0 AND `Item` = 6391 AND `QuestRequired` = 1; -- Выкройка: стильная зеленая рубашка, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2377 AND `ItemType` = 0 AND `Item` = 6579 AND `QuestRequired` = 1; -- Наплеч поборника, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 6238 AND `ItemType` = 0 AND `Item` = 6927 AND `QuestRequired` = 1; -- Ухо Большого Билла, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4702 AND `ItemType` = 0 AND `Item` = 7271 AND `QuestRequired` = 1; -- Безупречный бивень, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4703 AND `ItemType` = 0 AND `Item` = 7271 AND `QuestRequired` = 1; -- Безупречный бивень, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4700 AND `ItemType` = 0 AND `Item` = 7271 AND `QuestRequired` = 1; -- Безупречный бивень, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 14406 AND `ItemType` = 0 AND `Item` = 7271 AND `QuestRequired` = 1; -- Безупречный бивень, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 11597 AND `ItemType` = 0 AND `Item` = 7271 AND `QuestRequired` = 1; -- Безупречный бивень, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4701 AND `ItemType` = 0 AND `Item` = 7271 AND `QuestRequired` = 1; -- Безупречный бивень, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6606 AND `ItemType` = 0 AND `Item` = 7333 AND `QuestRequired` = 1; -- Свисток инспектора, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2374 AND `ItemType` = 0 AND `Item` = 7364 AND `QuestRequired` = 1; -- Выкройка: тяжелые перчатки Земли, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2375 AND `ItemType` = 0 AND `Item` = 7364 AND `QuestRequired` = 1; -- Выкройка: тяжелые перчатки Земли, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 7364 AND `QuestRequired` = 1; -- Выкройка: тяжелые перчатки Земли, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2377 AND `ItemType` = 0 AND `Item` = 7364 AND `QuestRequired` = 1; -- Выкройка: тяжелые перчатки Земли, plain
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 4770 AND `ItemType` = 0 AND `Item` = 7389 AND `QuestRequired` = 1; -- Учетная книга Торговой Компании, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4861 AND `ItemType` = 0 AND `Item` = 7679 AND `QuestRequired` = 1; -- Клык крылана-охотника, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4862 AND `ItemType` = 0 AND `Item` = 7679 AND `QuestRequired` = 1; -- Клык крылана-охотника, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 4863 AND `ItemType` = 0 AND `Item` = 7680 AND `QuestRequired` = 1; -- Чешуя нефритового василиска, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 7909 AND `QuestRequired` = 1; -- Аквамарин, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2377 AND `ItemType` = 0 AND `Item` = 7909 AND `QuestRequired` = 1; -- Аквамарин, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 10316 AND `QuestRequired` = 1; -- Выкройка: многоцветный килт, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 8581 AND `ItemType` = 0 AND `Item` = 10664 AND `QuestRequired` = 1; -- Записка волхву Римтори, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 8608 AND `ItemType` = 0 AND `Item` = 10664 AND `QuestRequired` = 1; -- Записка волхву Римтори, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2375 AND `ItemType` = 0 AND `Item` = 11038 AND `QuestRequired` = 1; -- Формула чар для двуручного оружия: малый дух, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2376 AND `ItemType` = 0 AND `Item` = 11038 AND `QuestRequired` = 1; -- Формула чар для двуручного оружия: малый дух, plain
DELETE FROM `creature_loot_template` WHERE `Entry` = 2659 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2726 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6505 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6506 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6507 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6517 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6520 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6521 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6556 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 6557 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 9118 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 9163 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 9164 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 9167 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 10660 AND `ItemType` = 0 AND `Item` = 11108 AND `QuestRequired` = 1; -- Выцветшая фотография, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 9456 AND `ItemType` = 0 AND `Item` = 11222 AND `QuestRequired` = 1; -- Голова Кром'зара, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 2377 AND `ItemType` = 0 AND `Item` = 12261 AND `QuestRequired` = 1; -- Чертеж: пылающий золотой клинок, plain
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 14460 AND `ItemType` = 0 AND `Item` = 15586 AND `QuestRequired` = 1; -- Быстро растущий цветок, no quest in 1.12
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 15920 AND `ItemType` = 0 AND `Item` = 17822 AND `QuestRequired` = 1; -- Карты клана Северного Волка, no quest in 1.12
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 15921 AND `ItemType` = 0 AND `Item` = 17823 AND `QuestRequired` = 1; -- Грозовая Вершина: планы битвы, no quest in 1.12
DELETE FROM `gameobject_loot_template` WHERE `Entry` = 17299 AND `ItemType` = 0 AND `Item` = 19911 AND `QuestRequired` = 1; -- Сердце хлыстня, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 15043 AND `ItemType` = 0 AND `Item` = 19975 AND `QuestRequired` = 1; -- Зулианский грязнотинник, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 8957 AND `ItemType` = 0 AND `Item` = 20018 AND `QuestRequired` = 1; -- Шкура гризли злобных когтей, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 7857 AND `ItemType` = 0 AND `Item` = 20021 AND `QuestRequired` = 1; -- Золотая пиратская серьга, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 7855 AND `ItemType` = 0 AND `Item` = 20021 AND `QuestRequired` = 1; -- Золотая пиратская серьга, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 7896 AND `ItemType` = 0 AND `Item` = 20021 AND `QuestRequired` = 1; -- Золотая пиратская серьга, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 7856 AND `ItemType` = 0 AND `Item` = 20021 AND `QuestRequired` = 1; -- Золотая пиратская серьга, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 7858 AND `ItemType` = 0 AND `Item` = 20021 AND `QuestRequired` = 1; -- Золотая пиратская серьга, no quest in 1.12
DELETE FROM `creature_loot_template` WHERE `Entry` = 15685 AND `ItemType` = 0 AND `Item` = 20021 AND `QuestRequired` = 1; -- Золотая пиратская серьга, no quest in 1.12

-- 2026_10_26_06_world_classic_warlock_binding_demons_hostile: Karrz's 2026_10_24_30 fixes the same quests its own way;
-- ours is newer and adds the attack-the-summoner rows.
UPDATE `creature_template` SET `faction`=90 WHERE `entry` IN (5676,5677,6268);

DELETE FROM `smart_scripts` WHERE `source_type`=0 AND ((`entryorguid`=5676 AND `id`=4) OR (`entryorguid`=5677 AND `id`=2));
INSERT INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`action_type`,`target_type`,`comment`) VALUES
(5676,0,4,0,54,0,100,0,49,7,'Summoned Voidwalker - On Just Summoned - Start Attacking Summoner'),
(5677,0,2,0,54,0,100,0,49,7,'Summoned Succubus - On Just Summoned - Start Attacking Summoner');
