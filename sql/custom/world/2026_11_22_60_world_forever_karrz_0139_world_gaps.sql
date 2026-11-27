-- WoW Forever world data from Karrz1/ForeverCore 0.1.39 (forever-bots b441bf74e0): only what the PTR world did not have on
-- 2026-11-22, taken row by row from Karrz's bulk files (EG Link live data, Wowhead WoW Forever pages, live captures). Rules:
--   quests: none left (all on the PTR or in 2026_11_22_50); creature and object templates: only entries the PTR lacks;
--   spawns: only for creatures / objects with no spawn at all; loot and vendor rows: only rows the PTR lacks; quest drops added
--   by Karrz only for items nothing on the PTR drops; guarded SmartAI rows (live dungeon abilities, added only when nothing of the
--   creature casts the spell) as he wrote them; his UPDATEs outside the quest tables (quest-giver flags, SmartAI flags, loot ids,
--   quest object links, limited vendor stock), all of them conditional or additive. Karrz's deletes of rows we already have,
--   and his rewrites of quests the PTR already has, are left out. Safe to run again.


-- from Karrz 2026_11_18_55_world_forever_live_sniffs_1116_1117.sql
INSERT IGNORE INTO `npc_vendor` (`entry`, `slot`, `item`, `maxcount`, `incrtime`, `ExtendedCost`, `type`, `BonusListIDs`, `PlayerConditionID`, `IgnoreFiltering`, `VerifiedBuild`) VALUES
(4963, 1, 2723, 0, 0, 0, 1, NULL, 0, 0, 70938),
(4963, 2, 2593, 0, 0, 0, 1, NULL, 0, 0, 70938),
(4963, 3, 2596, 0, 0, 0, 1, NULL, 0, 0, 70938),
(4963, 4, 2594, 0, 0, 0, 1, NULL, 0, 0, 70938),
(4963, 5, 2595, 0, 0, 0, 1, NULL, 0, 0, 70938);

-- from Karrz 2026_11_19_61_world_forever_live_vendor_gaps.sql
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(6807,100, 4603,5,7200,0,1,NULL,0,0,70959),
(6807,101, 6289,5,7200,0,1,NULL,0,0,70959),
(6807,102, 6303,5,7200,0,1,NULL,0,0,70959),
(6807,103, 6308,5,7200,0,1,NULL,0,0,70959),
(6807,104, 6362,5,7200,0,1,NULL,0,0,70959);

-- from Karrz 2026_11_19_85_world_forever_eg_live_dungeon_abilities.sql
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 3654,0,100,0,'',0,0,100,0,8000,12000,18000,25000,0,'',11,7967,32,0,0,0,0,0,'',6,0,0,0,0,'',0,0,0,0,'EG live: Mutanus the Devourer - Naralex''s Nightmare (7967), VMaNGOS spell list 36540' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 3654 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 7967);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 3654,0,101,0,'',0,0,100,0,10000,15000,12000,18000,0,'',11,7399,0,0,0,0,0,0,'',6,0,0,0,0,'',0,0,0,0,'EG live: Mutanus the Devourer - Terrify (7399), VMaNGOS spell list 36540' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 3654 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 7399);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 3654,0,102,0,'',0,0,100,0,8000,10000,10000,12000,0,'',11,8150,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Mutanus the Devourer - Thundercrack (8150), VMaNGOS spell list 36540' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 3654 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8150);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4278,0,100,0,'',0,0,100,0,6000,10000,15000,20000,0,'',11,5588,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Commander Springvale - Hammer of Justice (5588), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4278 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 5588);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 6243,0,100,0,'',0,0,100,0,5000,10000,15000,25000,0,'',11,6533,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Gelihast - Net (6533), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 6243 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 6533);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 12876,0,100,0,'',0,0,100,0,8000,12000,15000,20000,0,'',11,15531,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Baron Aquanis - Frost Nova (15531), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 12876 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 15531);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 8127,0,100,0,'',0,0,100,0,5000,10000,25000,30000,0,'',11,8376,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Antu''sul - Earthgrab Totem (8376), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 8127 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8376);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 3669,0,100,0,'',2,0,100,0,0,50,15000,20000,0,'',11,5188,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Lord Cobrahn - Healing Touch (5188), INFERRED: below 50% health' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 3669 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 5188);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4292,0,100,0,'',74,0,100,0,0,60,10000,15000,0,'',11,3472,0,0,0,0,0,0,'',9,0,0,40,0,'',0,0,0,0,'EG live: Scarlet Protector - Holy Light (3472), INFERRED: an ally in combat below 60% within 40 yd' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4292 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 3472);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4291,0,100,0,'',0,0,100,0,5000,10000,10000,15000,0,'',11,8131,0,0,0,0,0,0,'',5,30,0,1,0,'',0,0,0,0,'EG live: Scarlet Diviner - Mana Burn (8131), INFERRED: a random target with mana within 30 yd' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4291 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8131);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4809,0,100,0,'',74,0,100,0,0,60,10000,15000,0,'',11,2055,0,0,0,0,0,0,'',9,0,0,40,0,'',0,0,0,0,'EG live: Twilight Acolyte - Heal (2055), INFERRED: an ally in combat below 60% within 40 yd' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4809 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 2055);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4814,0,100,0,'',0,0,100,0,3000,6000,12000,16000,0,'',11,8056,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Twilight Elementalist - Frost Shock (8056), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4814 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8056);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4814,0,101,0,'',0,0,100,0,6000,9000,12000,16000,0,'',11,8052,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Twilight Elementalist - Flame Shock (8052), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4814 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8052);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4814,0,102,0,'',0,0,100,0,9000,12000,15000,20000,0,'',11,8046,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Twilight Elementalist - Earth Shock (8046), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4814 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8046);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4805,0,100,0,'',1,0,100,0,1000,1000,30000,30000,0,'',11,12544,32,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Blackfathom Sea Witch - Frost Armor (12544), INFERRED: out of combat, when the armor is gone' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4805 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 12544);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4818,0,100,0,'',4,0,100,1,0,0,0,0,0,'',11,7164,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Blindlight Murloc - Defensive Stance (7164), INFERRED: on aggro' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4818 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 7164);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 5048,0,100,0,'',0,0,100,0,2000,5000,10000,15000,0,'',11,744,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Deviate Adder - Poison (744), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 5048 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 744);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 6211,0,100,0,'',0,0,100,0,4000,8000,8000,12000,0,'',11,845,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Caverndeep Reaver - Cleave (845), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 6211 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 845);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 7351,0,100,0,'',0,0,100,0,5000,8000,7000,16000,0,'',11,745,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Tomb Reaver - Web (745), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 7351 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 745);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 11791,0,100,0,'',0,0,100,0,3000,6000,8000,12000,0,'',11,3391,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Putridus Trickster - Thrash (3391), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 11791 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 3391);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4535,0,100,0,'',4,0,100,1,0,0,0,0,0,'',11,6268,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Tamed Battleboar - Rushing Charge (6268), INFERRED: on aggro' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4535 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 6268);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 6047,0,100,0,'',0,0,100,0,4000,8000,12000,18000,0,'',11,865,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Aqua Guardian - Frost Nova (865), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 6047 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 865);

-- from Karrz 2026_11_19_92_world_forever_eg_live_dungeon_abilities_2.sql
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 643,0,100,0,'',0,0,100,0,7000,17000,15000,20000,0,'',11,6713,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Sneed - Disarm (6713), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 643 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 6713);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 1729,0,100,0,'',0,0,100,0,1000,1000,42000,63000,0,'',11,4979,32,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Defias Evoker - Quick Flame Ward (4979), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 1729 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 4979);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4418,0,100,0,'',0,0,100,0,1000,1000,40000,65000,0,'',11,4979,32,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Defias Wizard - Quick Flame Ward (4979), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4418 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 4979);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4978,0,100,0,'',0,0,100,0,2000,4000,5000,8000,0,'',11,8398,0,0,0,0,0,0,'',5,0,0,0,0,'',0,0,0,0,'EG live: Aku''mai Servant - Frostbolt Volley (8398), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4978 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 8398);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 4978,0,101,0,'',0,0,100,0,9000,12000,12000,16000,0,'',11,865,0,0,0,0,0,0,'',1,0,0,0,0,'',0,0,0,0,'EG live: Aku''mai Servant - Frost Nova (865), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 4978 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 865);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 13696,0,100,0,'',9,0,100,0,0,5,30000,45000,0,'',11,5413,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Noxxious Scion - within 5 yd - Noxious Catalyst (5413), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 13696 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 5413);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 13696,0,101,0,'',9,0,100,0,0,30,14000,21000,0,'',11,21068,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Noxxious Scion - within 30 yd - Corruption (21068), VMaNGOS timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 13696 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 21068);

-- from Karrz 2026_11_19_93_world_forever_eg_live_dalaran_trash.sql
INSERT IGNORE INTO `areatrigger_template` (`Id`, `IsCustom`, `Flags`, `ActionSetId`, `ActionSetFlags`, `VerifiedBuild`) VALUES
(43682, 1, 0, 0, 0, 0);
INSERT IGNORE INTO `areatrigger_template_actions` (`AreaTriggerId`, `IsCustom`, `ActionType`, `ActionParam`, `TargetType`) VALUES
(43682, 1, 0, 1303458, 1);
INSERT IGNORE INTO `areatrigger_create_properties` (`Id`, `IsCustom`, `AreaTriggerId`, `IsAreatriggerCustom`, `Flags`, `MoveCurveId`,
`ScaleCurveId`, `MorphCurveId`, `FacingCurveId`, `AnimId`, `AnimKitId`, `DecalPropertiesId`, `SpellForVisuals`, `PositionalSoundKitId`,
`TimeToTargetScale`, `Speed`, `SpeedIsTime`, `Shape`, `ShapeData0`, `ShapeData1`, `ShapeData2`, `ShapeData3`, `ShapeData4`,
`ShapeData5`, `ShapeData6`, `ShapeData7`, `Roll`, `Pitch`, `Yaw`, `TargetRoll`, `TargetPitch`, `TargetYaw`, `ScriptName`,
`VerifiedBuild`) VALUES
(43682, 0, 43682, 1, 0, 0, 0, 0, 0, -1, -1, 0, NULL, 0, 0, 0, 0, 0, 8, 8, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0);
INSERT IGNORE INTO `smart_scripts` (`entryorguid`,`source_type`,`id`,`link`,`Difficulties`,`event_type`,`event_phase_mask`,`event_chance`,`event_flags`,`event_param1`,`event_param2`,`event_param3`,`event_param4`,`event_param5`,`event_param_string`,`action_type`,`action_param1`,`action_param2`,`action_param3`,`action_param4`,`action_param5`,`action_param6`,`action_param7`,`action_param_string`,`target_type`,`target_param1`,`target_param2`,`target_param3`,`target_param4`,`target_param_string`,`target_x`,`target_y`,`target_z`,`target_o`,`comment`)
SELECT 255069,0,100,0,'',0,0,100,0,4000,8000,15000,20000,0,'',11,9080,0,0,0,0,0,0,'',2,0,0,0,0,'',0,0,0,0,'EG live: Fallen Warrior - Hamstring (9080), INFERRED timers' FROM DUAL
WHERE NOT EXISTS (SELECT 1 FROM `smart_scripts` s WHERE s.`entryorguid` = 255069 AND s.`source_type` = 0 AND s.`action_type` = 11 AND s.`action_param1` = 9080);

-- from Karrz 2026_11_20_70_world_forever_eg_live_npc_templates.sql
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(176546,0,0,'Call for Help Trigger',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(185331,0,0,'Avelina Lilly Projection',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(185332,0,0,'Isaac Pearson Projection',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(185403,0,0,'Cyriden Farseeker',NULL,'Archaeologist',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(185404,0,0,'Relathor Moonsong',NULL,'Archaeologist',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(203079,0,0,'Wandering Swordsman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(204070,0,0,'Soboz',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(205278,0,0,'Brother Romulus',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(205382,0,0,'Mokwa',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,2,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(208124,0,0,'Raluk',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,2,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(208812,0,0,'Jorul',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,4,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(208841,0,0,'Revered Champion',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(208842,0,0,'The Gardener',NULL,'Gardener',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,1703,0,0,1,0,0,'',NULL,-1),
(208843,0,0,'Abominable Snowman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(208844,0,0,'Scarlet Revenant',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(208845,0,0,'Par''kourc',NULL,'Blackrock Clan Outrunner',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(208846,0,0,'Sun Admirer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,6,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(208847,0,0,'The Snatcher',NULL,'Rascal',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(209742,0,0,'Desert Mirage',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(209928,0,0,'Mowgh',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,4,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(210107,0,0,'Kackle',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,6,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(211764,0,0,'Gefell',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(211765,0,0,'Gemela',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(211951,0,0,'Koartul',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,21,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(211967,0,0,'Leech Stalker Corpse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,3,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(214208,0,0,'N''ora Anyheart',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(216463,0,0,'Ailgrha Splittusk',NULL,'Mother of Storms',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(216670,0,0,'Caverndeep Looter',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(217588,0,0,'Arbor Tarantula',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(217589,0,0,'Hay Weevil',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(217590,0,0,'Flesh Picker',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(217683,0,0,'Altar of the Wind Spirit',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(217836,0,0,'Needletooth',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218089,0,0,'Scarlet Squire Corpse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218090,0,0,'Scarlet Crusader Corpse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218093,0,0,'Burning Blade Acolyte Corpse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218095,0,0,'Burning Blade Acolyte Corpse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218240,0,0,'Tower Defense Automaton',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(218273,0,0,'Wandering Swordsman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218434,0,0,'[DNT] Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218460,0,0,'[DNT] Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218461,0,0,'[DNT] Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(218462,0,0,'[DNT] Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(221656,0,0,'Stern-faced Bar Patron',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(222243,0,0,'Zopilote',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,7,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(222726,0,0,'Tyrant of the Hive',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(223212,0,0,'[DNT] Tanaris - Arena Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(224965,0,0,'Khonsu',NULL,'Night Traveler',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(227996,0,0,'Sebastian Jurgens',NULL,'Mad Doctor',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(228143,0,0,'[DNT] Challenge',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(228443,0,0,'[DNT] Challenge',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(228611,0,0,'Wandering Swordsman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(228673,0,0,'Wandering Swordsman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(228721,0,0,'Lieutenant Skarresh',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1704,0,0,1,0,0,'',NULL,-1),
(228728,0,0,'Flamebringer Kelris',NULL,'Twilight Lord',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(228814,0,0,'Arcterris',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1701,0,0,1,0,0,'',NULL,-1),
(228969,0,0,'Lord Gazzran',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1704,0,0,1,0,0,'',NULL,-1),
(228970,0,0,'Galenges',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1704,0,0,1,0,0,'',NULL,-1),
(229485,0,0,'Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1760,0,0,1,0,0,'',NULL,-1),
(231661,0,0,'Rahuz',NULL,'The Scorned Student',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(232215,0,0,'Rahuz',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(232216,0,0,'Rahuz',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(232556,0,0,'Drake',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(232557,0,0,'Drake',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(238374,0,0,'Dockhand',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1732,0,0,1,0,0,'',NULL,-1),
(238637,0,0,'Makeshift Trap',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,9,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(239942,0,0,'Lady Sesspira',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(240792,0,0,'Scarlet Smith',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(240797,0,0,'Scarlet Executioner',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(242577,0,0,'Devouring Hunger',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(242827,0,0,'Captain Bloodcoin',NULL,'Seafaring Auctioneer',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(243046,0,0,'Scarlet Captain',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(243509,0,0,'Noxious Slime',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(243893,0,0,'High General Abbendis',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(244188,0,0,'Scalebeard',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,21,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(244612,0,0,'Wandering Swordsman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(245332,0,0,'Par''kourc',NULL,'Blackrock Clan Outrunner',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(245423,0,0,'Rahuz',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(246991,0,0,'Magister Hawkhelm',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(249226,0,0,'Death Wailer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(249231,0,0,'Varkharn the Vigilant',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(249232,0,0,'Ganoloth the Tireless',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,3,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(249233,0,0,'Unyielding Eye',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,6,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(249238,0,0,'Legion Hulk',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,3,0,'',0,1.0,0,1741,0,0,1,0,0,'',NULL,-1),
(249399,0,0,'Brave Bentzel',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(249473,0,0,'Sarinnia Wormwing',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(249702,0,0,'Wilted Lashling',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,12,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(250352,0,0,'Old Thornpaw',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,1,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(250355,0,0,'Defias Vintner',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(250652,0,0,'Spiteful Phantom',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,6,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(251461,0,0,'Altairus',NULL,'Caller of the North Wind',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(251494,0,0,'Boulupulo',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(252535,0,0,'Zara',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(252703,0,0,'Shen''dralar Pylon',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(253275,0,0,'Outcast Necrokhan',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(253351,0,0,'[DNT] Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(253353,0,0,'[DNT] Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(253479,0,0,'Nyliaris',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(253529,0,0,'Bristleback Snortsnout',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,5,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(253533,0,0,'Frightened Bristleback Child',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(254490,0,0,'Desolace Bone Worm',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(254613,0,0,'Bristleback Looter',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(254614,0,0,'Outcast Centaur',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(254782,0,0,'Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(254797,0,0,'Lost One',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(255174,0,0,'Blind Screecher',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,24,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(255183,0,0,'Jezerelle the Swaying',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,3,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255272,0,0,'Tobin Wheeldon',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255273,0,0,'Jaston Valarias',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255277,0,0,'Spectral Citizen',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255701,0,0,'Maralus',NULL,'Trade Goods',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(255703,0,0,'Naria',NULL,'Food Vendor',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(255721,0,0,'Jarael',NULL,'Leatherworking',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(255724,0,0,'Melanori',NULL,'Tailoring',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(255831,0,0,'Mangled Corpse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255864,0,0,'Seer Onku',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255877,0,0,'Hunter Moore',NULL,'Fisherman',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(255892,0,0,'Bonegnaw',NULL,'Terror of the Hills',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(256346,0,0,'Animated Tome',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(256738,0,0,'Basket of Alchemy Goods',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(256739,0,0,'Crate of Blacksmithing Goods',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(256740,0,0,'Crate of Enchanting Supplies',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(256741,0,0,'Basket of Textile Supplies',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(256800,0,0,'Twilight Enforcer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(256830,0,0,'Bannerwing Survivor',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1714,0,0,1,0,0,'',NULL,-1),
(256881,0,0,'Overlord Kilgar',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(256904,0,0,'Farholde Scout',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(257056,0,0,'Buzzbeak',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,7,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(257450,0,0,'Rog''mar Scout',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(258491,0,0,'Kronk',NULL,'Pummelization Specialist',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(258553,0,0,'Peacebloom',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(258595,0,0,'Snufflesnout',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(258617,0,0,'Snort',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,5,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(258626,0,0,'Mog''thar',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(258652,0,0,'Twilight Thrall',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,3,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(258922,0,0,'Hungry Crocolisk',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,6,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(259056,0,0,'Komuk',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(259179,0,0,'Redridge Thug',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(259198,0,0,'Silverleaf',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(259209,0,0,'Copper Vein',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(259210,0,0,'Tin Vein',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(259211,0,0,'Iron Deposit',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(259224,0,0,'Rock Garden',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(259263,0,0,'Coyote Prowler',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,1,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(259363,0,0,'Sapling',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,11,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(260017,0,0,'Greenhouse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260020,0,0,'Greenhouse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260023,0,0,'Farholde Ambusher',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(260078,0,0,'Greenhouse',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260091,0,0,'Explosive Charge',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,11,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(260128,0,0,'Blindweed',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260225,0,0,'Bloodsnout',NULL,'Scoutmaster Vargas''s Companion',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,1,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(260300,0,0,'Campfire Marker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260354,0,0,'(DNT) Saltseer Cultist Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260425,0,0,'Venture Co. Mercenary',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(260429,0,0,'Venture Co. Agent',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(260466,0,0,'Grubbub',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260468,0,0,'"Pyromancer" Braxton',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260478,0,0,'(DNT) Saltseer Pyromancer Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260823,0,0,'Overseer Myoleth',NULL,'Cult of the Ashen Reign',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260861,0,0,'Sentry Welgrin',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(260862,0,0,'Sentry Egan',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(260863,0,0,'Sentry Rivers',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(260864,0,0,'Sentry Tillman',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(260969,0,0,'Twilight Instigator',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(261024,0,0,'Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(261025,0,0,'Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(261662,0,0,'Old Ironfang',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,4,0,2000,2000,1.0,1.0,1,0,2048,0,1,0,1,0,'',0,1.0,0,1714,0,0,1,0,0,'',NULL,-1),
(261710,0,0,'Twilight Brute',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(263073,0,0,'School of Fish',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(263369,0,0,'G45-B4G',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,9,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(263681,0,0,'Bear',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,4,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(263718,0,0,'Bristleback Bodyguard',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(263935,0,0,'Old Rusthowl',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,2,0,2000,2000,1.0,1.0,1,0,2048,0,1,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(264149,0,0,'Unstable Mana Rift',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(264176,0,0,'Rare Proxy Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(265190,0,0,'Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(266862,0,0,'Juvenile Paletusk',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,5,0,1,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(266956,0,0,'Invisible Bunny',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(267065,0,0,'Syndicate Smuggler',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(267963,0,0,'Quadcopter',NULL,'D.E.L.T.A',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,9,0,'',0,1.0,0,1721,0,0,1,0,0,'',NULL,-1),
(268153,0,0,'Seagull',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(268315,0,0,'(DNT) Pirate Beam Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(269133,0,0,'Skeleton',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(269453,0,0,'Theramore Elite',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(269467,0,0,'Arcane Manaling',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(269519,0,0,'(DNT) Lightning Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(270532,0,0,'Redridge Prisoner',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270573,0,0,'Credit',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(270574,0,0,'Credit',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(270664,0,0,'Venomweb Spitter',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,3,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(270807,0,0,'Hexed Larva',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(270846,0,0,'Twilight Shadowmancer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270847,0,0,'Twilight Neophyte',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270882,0,0,'Zul''Alai',NULL,'Staging Area 1',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270883,0,0,'Var''Taka',NULL,'Staging Area 2',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270884,0,0,'Captain Dreadrise',NULL,'Staging Area 3',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270885,0,0,'Deathless Marrow',NULL,'Staging Area 4',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,4,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270886,0,0,'Min''loth the Serpent',NULL,'Staging Area 6',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(270888,0,0,'Gill',NULL,'Staging Area 5',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(271008,0,0,'Rog''mar Shaman Initiate',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(271649,0,0,'Death Trap',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,11,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(271786,0,0,'Cerulean Prideclaw',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1698,0,0,1,0,0,'',NULL,-1),
(271863,0,0,'Veteran Adventurer''s Loyal Companion',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1698,0,0,1,0,0,'',NULL,-1),
(271898,0,0,'Greater Tarantula',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,3,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(271929,0,0,'Shen''dorei Windwell',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,10,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(271988,0,0,'Greater Tarantula',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,3,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(272012,0,0,'Cat Familiar',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,12,0,'',0,1.0,0,1699,0,0,1,0,0,'',NULL,-1),
(272112,0,0,'Kurothel',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(272377,0,0,'Methuselah Crab',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,8,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(272384,0,0,'Elder Daggermaw',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,6,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(272392,0,0,'Giant Moonstrider',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,12,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(272401,0,0,'Vale Screamer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,27,0,1,0,'',0,1.0,0,1694,0,0,1,0,0,'',NULL,-1),
(273164,0,0,'Invisible Stalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(273256,0,0,'Arrgrah Stonewall',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(273286,0,0,'Crimeon',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(273437,0,0,'Turlethion Moonrage',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(273567,0,0,'Glowing Pearl',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(273576,0,0,'Glowing Pearl',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(274297,0,0,'Black Dragon Whelp',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,2,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(274334,0,0,'Tallstrider Hatchling',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,12,0,'',0,1.0,0,1699,0,0,1,0,0,'',NULL,-1),
(274405,0,0,'Hyjal Protector',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(274770,0,0,'Slizzy Kreeg',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(274776,0,0,'Doctor Nimer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(274789,0,0,'Aradia',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(274940,0,0,'Annabella Junelight',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275022,0,0,'Furious Astranaar Sentinel',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275030,0,0,'Archivist Delv Fortuz',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275042,0,0,'Furious Brave',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275073,0,0,'Grom''gol Ravager',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275075,0,0,'Lakeshire Protector',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275077,0,0,'Ratchet Enforcer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275080,0,0,'Enraged Rog''mar Grunt',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275088,0,0,'Enraged Stonard Grunt',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(275210,0,0,'Teller Rames',NULL,'Banker',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(275212,0,0,'Teller Hanners',NULL,'Banker',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(275216,0,0,'Paymaster Alstein',NULL,'Banker',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(276078,0,0,'Twilight Laborer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(276247,0,0,'Lightning',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(276318,0,0,'Idrieth Mossgrove',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(276752,0,0,'Animated Hammer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(276799,0,0,'Gabrandal Matters',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,4,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277042,0,0,'Teuren Vineshade',NULL,'Barber',NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,4,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(277059,0,0,'Je''lu',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277151,0,0,'Kyle the Friendly',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277287,0,0,'Dwyer',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277295,0,0,'Farmer Bessey',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277368,0,0,'Gevreka',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277410,0,0,'Cereza Galeforce',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277630,0,0,'Morok''ra',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,1,0,'',0,1.0,0,1695,0,0,1,0,0,'',NULL,-1),
(277639,0,0,'Alyz',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277689,0,0,'Drake Ekans',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,4,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277694,0,0,'Sky Earthtotem',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277721,0,0,'Krazore',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277724,0,0,'Mattwyn "Q" Pons',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277727,0,0,'Deyrek Duke',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277729,0,0,'Arcane Elemental',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,1699,0,0,1,0,0,'',NULL,-1),
(277765,0,0,'Botika Montes',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,8,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277769,0,0,'Rown Leaftender',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277864,0,0,'"Reliable" Mike',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277881,0,0,'Bloodwing Bat',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,24,0,1,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(277993,0,0,'Mana Tide Totem IV',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,11,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278382,0,0,'Ravaging Storm Elemental',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,2,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278383,0,0,'Ravaging Quake Elemental',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278384,0,0,'Ravaging Flood Elemental',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278388,0,0,'Ravaging Drought Elemental',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278395,0,0,'Pumpkin',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,8,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278644,0,0,'Warbringer Construct',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,1693,0,0,1,0,0,'',NULL,-1),
(278978,0,0,'Violet Flames',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,10,0,'',0,1.0,0,1760,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(176546,0,0,0,0,0,1.35,1.0,1.0,1.0,199472,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(185331,0,0,0,0,0,1.0,1.0,1.0,1.0,209476,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(185332,0,0,0,0,0,1.0,1.0,1.0,1.0,209477,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(185403,0,0,0,0,0,1.05,1.0,1.0,1.0,209556,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(185404,0,0,0,0,0,1.05,1.0,1.0,1.0,209557,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(203079,0,0,0,0,0,3.0,1.0,1.0,1.0,231699,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(204070,0,0,0,0,0,3.0,1.0,1.0,1.0,233170,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(205278,0,0,0,0,0,1.05,1.0,1.0,1.0,234450,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(205382,0,0,0,0,0,1.0,1.0,1.0,1.0,234558,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208124,0,0,0,0,0,1.0,1.0,1.0,1.0,237357,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208812,0,0,0,0,0,1.0,1.0,1.0,1.0,238049,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208841,0,0,0,0,0,3.0,2.0,1.0,1.0,238078,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208842,0,0,0,0,0,45.0,1.0,1.0,1.0,238079,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208843,0,0,0,0,0,20.0,5.0,1.0,1.0,238080,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208844,0,0,0,0,0,25.0,1.0,1.0,1.0,238081,0,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208845,0,0,0,0,0,12.0,1.0,1.0,1.0,238082,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208846,0,0,0,0,0,24.0,1.0,1.0,1.0,238083,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(208847,0,0,0,0,0,100.0,1.0,1.0,1.0,238084,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(209742,0,0,0,0,0,1.0,1.0,1.0,1.0,240051,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(209928,0,0,0,0,0,1.0,1.0,1.0,1.0,257702,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(210107,0,0,0,0,0,1.2,1.0,1.0,1.0,257881,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(211764,0,0,0,0,0,3.0,1.0,1.0,1.0,261108,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(211765,0,0,0,0,0,3.0,1.0,1.0,1.0,261110,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(211951,0,0,0,0,0,3.0,1.0,1.0,1.0,261302,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(211967,0,0,0,0,0,1.02,1.0,1.0,1.0,261320,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(214208,0,0,0,0,0,1.0,1.0,1.0,1.0,263647,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(216463,0,0,0,0,0,1.5,1.0,1.0,2.0,265950,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(216670,0,0,0,0,0,3.0,1.0,1.0,1.0,266152,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217588,0,0,0,0,0,0.2,1.0,1.0,1.0,267081,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217589,0,0,0,0,0,0.2,1.0,1.0,1.0,267082,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217590,0,0,0,0,0,0.2,1.0,1.0,1.0,267083,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217683,0,0,0,0,0,1.2,1.0,1.0,1.0,267176,1207959552,6,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217836,0,0,0,0,0,1.1,1.0,1.0,1.0,267329,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218089,0,0,0,0,0,0.0,1.0,1.0,1.0,267584,134217728,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218090,0,0,0,0,0,0.0,1.0,1.0,1.0,267585,134217728,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218093,0,0,0,0,0,0.0,1.0,1.0,1.0,267588,134217728,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218095,0,0,0,0,0,0.0,1.0,1.0,1.0,267590,134217728,32,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218240,0,0,0,0,0,2.0,1.0,1.0,2.0,267742,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218273,0,0,0,0,0,3.0,1.0,1.0,1.0,267777,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218434,0,0,0,0,0,1.35,1.0,1.0,1.0,267940,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218460,0,0,0,0,0,1.35,1.0,1.0,1.0,267966,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218461,0,0,0,0,0,1.35,1.0,1.0,1.0,267967,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218462,0,0,0,0,0,1.35,1.0,1.0,1.0,267968,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221656,0,0,0,0,0,1.0,1.0,1.0,1.0,271465,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(222243,0,0,0,0,0,3.0,1.0,1.0,1.0,272065,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(222726,0,0,0,0,0,3.0,1.0,1.0,1.0,273523,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(223212,0,0,0,0,0,1.0,1.0,1.0,1.0,274015,134218752,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(224965,0,0,0,0,0,345.0,502.0,1.0,1.0,275906,134217736,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(227996,0,0,0,0,0,3.0,1.0,1.0,2.0,279179,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228143,0,0,0,0,0,1.0,1.0,1.0,1.0,279328,134218752,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228443,0,0,0,0,0,1.0,1.0,1.0,1.0,279645,134218752,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228611,0,0,0,0,0,1.25,1.0,1.0,1.0,279819,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228673,0,0,0,0,0,1.25,1.0,1.0,1.0,279886,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228721,0,0,0,0,0,15.0,10.0,1.0,1.0,279937,134217736,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228728,0,0,0,0,0,9.0,2.5,1.0,1.0,279944,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228814,0,0,0,0,0,4.0,1.0,1.0,1.0,280038,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228969,0,0,0,0,0,15.0,10.0,1.0,1.0,280199,134217736,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228970,0,0,0,0,0,15.0,10.0,1.0,1.0,280200,134217736,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(229485,0,0,0,0,0,1.0,1.0,1.0,1.0,280771,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(231661,0,0,0,0,0,30.0,2.0,1.0,1.0,282997,134217804,67108992,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(232215,0,0,0,0,0,8.5,2.0,1.0,1.0,283633,134217732,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(232216,0,0,0,0,0,8.5,2.0,1.0,1.0,283634,134217732,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(232556,0,0,0,0,0,8.5,2.0,1.0,1.0,283978,72,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(232557,0,0,0,0,0,8.5,2.0,1.0,1.0,283979,72,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(238374,0,0,0,0,0,1.0,1.0,1.0,1.0,317351,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(238637,0,0,0,0,0,8.5,2.0,1.0,2.0,317708,72,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(239942,0,0,0,0,0,1.3,1.0,1.0,1.0,319097,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(240792,0,0,0,0,0,3.0,1.0,1.0,1.0,320007,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(240797,0,0,0,0,0,514.0,1.0,1.0,1.0,320013,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(242577,0,0,0,0,0,3.0,3.0,1.0,1.0,321983,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(242827,0,0,0,0,0,3.0,1.0,1.0,1.0,322236,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(243046,0,0,0,0,0,3.0,1.0,1.0,1.0,322460,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(243509,0,0,0,0,0,1.0,1.0,1.0,1.0,322928,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(243893,0,0,0,0,0,3.5,2.0,1.0,1.0,323319,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(244188,0,0,0,0,0,1.5,1.0,1.0,1.0,323628,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(244612,0,0,0,0,0,1.25,1.0,1.0,1.0,323958,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(245332,0,0,0,0,0,12.0,1.0,1.0,1.0,324728,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(245423,0,0,0,0,0,8.5,2.0,1.0,1.0,324819,134217732,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(246991,0,0,0,0,0,1.3,1.0,1.0,1.0,326524,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249226,0,0,0,0,0,5.0,1.0,1.0,1.0,328796,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249231,0,0,0,0,0,15.0,1.0,1.0,1.0,328801,0,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249232,0,0,0,0,0,15.0,1.0,1.0,1.0,328802,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249233,0,0,0,0,0,3.35,1.0,1.0,1.0,328803,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249238,0,0,0,0,0,12.0,4.0,1.0,1.0,328808,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249399,0,0,0,0,0,1.0,1.0,1.0,1.0,328982,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249473,0,0,0,0,0,1.3,1.0,1.0,1.0,329055,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(249702,0,0,0,0,0,0.2,1.0,1.0,1.0,329290,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(250352,0,0,0,0,0,1.0,1.0,1.0,1.0,329945,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(250355,0,0,0,0,0,1.0,1.0,1.0,1.0,329948,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(250652,0,0,0,0,0,1.4,1.0,1.0,1.0,330249,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(251461,0,0,0,0,0,300.0,3.0,1.0,2.0,332269,134217732,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(251494,0,0,0,0,0,2.5,1.0,1.0,1.0,332302,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(252535,0,0,0,0,0,0.01,1.0,1.0,1.0,333375,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(252703,0,0,0,0,0,1.0,1.0,1.0,1.0,333543,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253275,0,0,0,0,0,4.0,1.0,1.0,2.0,334134,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253351,0,0,0,0,0,1.0,1.0,1.0,1.0,334234,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253353,0,0,0,0,0,1.0,1.0,1.0,1.0,334238,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253479,0,0,0,0,0,1.0,1.0,1.0,1.0,334364,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253529,0,0,0,0,0,1.0,1.0,1.0,1.0,334414,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253533,0,0,0,0,0,1.0,1.0,1.0,1.0,334418,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(254490,0,0,0,0,0,0.6,1.0,1.0,1.0,335395,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(254613,0,0,0,0,0,1.0,1.0,1.0,1.0,335519,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(254614,0,0,0,0,0,1.0,1.0,1.0,1.0,335520,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(254782,0,0,0,0,0,1.0,1.0,1.0,1.0,335688,134218752,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(254797,0,0,0,0,0,1.0,1.0,1.0,1.0,335703,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255174,0,0,0,0,0,1.1,1.0,1.0,1.0,336089,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255183,0,0,0,0,0,4.325,2.0,1.0,1.0,336098,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255272,0,0,0,0,0,1.05,1.0,1.0,1.0,336187,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255273,0,0,0,0,0,1.05,1.0,1.0,1.0,336188,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255277,0,0,0,0,0,2.5,2.0,1.0,2.0,336192,134217728,67108992,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255701,0,0,0,0,0,1.0,1.0,1.0,1.0,336909,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255703,0,0,0,0,0,1.0,1.0,1.0,1.0,336911,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255721,0,0,0,0,0,1.0,1.0,1.0,1.0,336929,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255724,0,0,0,0,0,1.0,1.0,1.0,1.0,336932,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255831,0,0,0,0,0,0.0,1.0,1.0,1.0,338867,1744830480,100663302,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255864,0,0,0,0,0,1.2,1.0,1.0,1.0,338901,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255877,0,0,0,0,0,1.1,1.0,1.0,1.0,338914,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255892,0,0,0,0,0,4.0,1.0,1.0,2.0,338929,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256346,0,0,0,0,0,3.0,1.0,1.0,1.0,339386,1207959552,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256738,0,0,0,0,0,1.0,1.0,1.0,1.0,339798,1744830464,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256739,0,0,0,0,0,1.0,1.0,1.0,1.0,339799,1744830464,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256740,0,0,0,0,0,1.0,1.0,1.0,1.0,339800,1744830464,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256741,0,0,0,0,0,1.0,1.0,1.0,1.0,339801,1744830464,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256800,0,0,0,0,0,3.0,1.1,1.0,2.0,339860,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256830,0,0,0,0,0,4.65,1.0,1.0,1.0,339890,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256881,0,0,0,0,0,2.5,1.3,1.0,2.0,339941,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256904,0,0,0,0,0,1.0,1.0,1.0,1.0,339969,0,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(257056,0,0,0,0,0,4.0,1.0,1.0,2.0,340123,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(257450,0,0,0,0,0,1.0,1.0,1.0,1.0,340522,0,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258491,0,0,0,0,0,4.3,1.0,1.0,2.0,341592,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258553,0,0,0,0,0,1.0,1.0,1.0,1.0,341654,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258595,0,0,0,0,0,3.4,1.0,1.0,2.0,341697,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258617,0,0,0,0,0,0.8,1.0,1.0,1.0,341719,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258626,0,0,0,0,0,3.2,1.0,1.0,2.0,341728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258652,0,0,0,0,0,1.0,1.0,1.0,1.0,341758,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(258922,0,0,0,0,0,1.15,1.0,1.0,1.0,342060,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259056,0,0,0,0,0,4.0,1.0,1.0,2.0,342236,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259179,0,0,0,0,0,1.0,1.0,1.0,1.0,342359,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259198,0,0,0,0,0,1.0,1.0,1.0,1.0,342378,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259209,0,0,0,0,0,1.0,1.0,1.0,1.0,342389,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259210,0,0,0,0,0,1.0,1.0,1.0,1.0,342390,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259211,0,0,0,0,0,1.0,1.0,1.0,1.0,342391,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259224,0,0,0,0,0,1.0,1.0,1.0,1.0,342404,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259263,0,0,0,0,0,1.0,1.0,1.0,1.0,342443,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(259363,0,0,0,0,0,0.05,1.0,1.0,1.0,342543,1207959552,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260017,0,0,0,0,0,1.0,1.0,1.0,1.0,343210,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260020,0,0,0,0,0,1.0,1.0,1.0,1.0,343213,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260023,0,0,0,0,0,1.1,1.0,1.0,1.0,343216,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260078,0,0,0,0,0,1.0,1.0,1.0,1.0,343271,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260091,0,0,0,0,0,0.05,1.0,1.0,1.0,343286,1207959552,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260128,0,0,0,0,0,1.0,1.0,1.0,1.0,343328,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260225,0,0,0,0,0,1.25,1.0,1.0,1.0,343431,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260300,0,0,0,0,0,1.0,1.0,1.0,1.0,343507,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260354,0,0,0,0,0,3.0,5.0,1.0,2.0,343561,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260425,0,0,0,0,0,1.0,1.0,1.0,1.0,343632,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260429,0,0,0,0,0,1.0,1.0,1.0,1.0,343636,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260466,0,0,0,0,0,1.5,1.0,1.0,1.0,343673,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260468,0,0,0,0,0,3.5,5.0,1.0,1.0,343675,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260478,0,0,0,0,0,3.0,5.0,1.0,2.0,343685,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260823,0,0,0,0,0,1.55,1.0,1.0,1.0,344030,0,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260861,0,0,0,0,0,1.25,1.0,1.0,1.0,344068,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260862,0,0,0,0,0,1.25,1.0,1.0,1.0,344069,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260863,0,0,0,0,0,1.25,1.0,1.0,1.0,344070,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260864,0,0,0,0,0,1.25,1.0,1.0,1.0,344071,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260969,0,0,0,0,0,1.0,1.0,1.0,1.0,344177,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(261024,0,0,0,0,0,1.0,1.0,1.0,1.0,344232,1224737792,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(261025,0,0,0,0,0,1.0,1.0,1.0,1.0,344233,1224737792,16,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(261662,0,0,0,0,0,1.5,1.0,1.0,1.0,344901,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(261710,0,0,0,0,0,1.2,1.15,1.0,1.0,344949,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263073,0,0,0,0,0,1.0,1.0,1.0,1.0,346379,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263369,0,0,0,0,0,1.5,1.0,1.0,1.0,346676,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263681,0,0,0,0,0,1.1,1.0,1.0,1.0,346995,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263718,0,0,0,0,0,1.0,1.0,1.0,1.0,347032,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263935,0,0,0,0,0,3.7,1.0,1.0,1.0,347255,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(264149,0,0,0,0,0,5.0,1.0,1.0,1.0,347481,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(264176,0,0,0,0,0,1.0,1.0,1.0,1.0,347514,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(265190,0,0,0,0,0,2.0,1.0,1.0,1.0,348698,1207959552,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(266862,0,0,0,0,0,0.8,1.0,1.0,1.0,350477,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(266956,0,0,0,0,0,1.35,1.0,1.0,1.0,350575,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(267065,0,0,0,0,0,1.0,1.0,1.0,1.0,350688,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(267963,0,0,0,0,0,1.2,1.0,1.0,1.0,351552,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(268153,0,0,0,0,0,0.2,1.0,1.0,1.0,351746,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(268315,0,0,0,0,0,1.0,1.0,1.0,1.0,351913,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(269133,0,0,0,0,0,1.0,1.0,1.0,1.0,352784,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(269453,0,0,0,0,0,3.0,1.0,1.0,2.0,353105,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(269467,0,0,0,0,0,0.5,1.0,1.0,1.0,353119,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(269519,0,0,0,0,0,1.0,1.0,1.0,1.0,353171,0,128,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(270532,0,0,0,0,0,1.0,1.0,1.0,1.0,354222,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270573,0,0,0,0,0,1.25,1.0,1.0,1.0,354264,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270574,0,0,0,0,0,1.25,1.0,1.0,1.0,354265,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270664,0,0,0,0,0,1.15,1.0,1.0,1.0,354356,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270807,0,0,0,0,0,0.35,1.0,1.0,1.0,354501,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270846,0,0,0,0,0,1.0,1.0,1.0,1.0,354543,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270847,0,0,0,0,0,1.0,1.0,1.0,1.0,354544,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270882,0,0,0,0,0,1.0,1.0,1.0,2.0,354581,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270883,0,0,0,0,0,1.0,1.0,1.0,2.0,354582,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270884,0,0,0,0,0,1.0,1.0,1.0,2.0,354583,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270885,0,0,0,0,0,1.0,1.0,1.0,2.0,354584,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270886,0,0,0,0,0,1.0,1.0,1.0,2.0,354585,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(270888,0,0,0,0,0,1.0,1.0,1.0,1.0,354587,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271008,0,0,0,0,0,1.1,1.0,1.0,1.0,354707,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271649,0,0,0,0,0,1.0,1.0,1.0,1.0,355373,134217792,67109958,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271786,0,0,0,0,0,1.0,1.0,1.0,1.0,355510,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271863,0,0,0,0,0,1.0,1.0,1.0,1.0,355587,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271898,0,0,0,0,0,1.0,1.0,1.0,1.0,355622,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271929,0,0,0,0,0,1.0,1.0,1.0,1.0,355654,134217728,67108870,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271988,0,0,0,0,0,1.0,1.0,1.0,1.0,355713,1207959553,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272012,0,0,0,0,0,1.0,1.0,1.0,1.0,355737,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272112,0,0,0,0,0,15.1,1.0,1.0,1.0,355841,134217728,67108864,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272377,0,0,0,0,0,1.0,1.0,1.0,1.0,356115,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272384,0,0,0,0,0,1.2,1.0,1.0,1.0,356122,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272392,0,0,0,0,0,1.0,1.0,1.0,1.0,356130,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272401,0,0,0,0,0,1.2,1.0,1.0,1.0,356139,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273164,0,0,0,0,0,1.0,1.0,1.0,1.0,356941,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273256,0,0,0,0,0,1.1,1.0,1.0,1.0,357041,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273286,0,0,0,0,0,1.1,1.0,1.0,1.0,357071,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273437,0,0,0,0,0,1.0,1.0,1.0,1.0,357225,0,16384,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273567,0,0,0,0,0,1.0,1.0,1.0,1.0,357355,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273576,0,0,0,0,0,1.0,1.0,1.0,1.0,357364,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274297,0,0,0,0,0,1.3,1.0,1.0,1.0,358100,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274334,0,0,0,0,0,1.0,1.0,1.0,1.0,358139,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274405,0,0,0,0,0,2.0,1.0,1.0,1.0,358220,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274770,0,0,0,0,0,1.0,1.0,1.0,1.0,358596,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274776,0,0,0,0,0,1.05,1.0,1.0,1.0,358602,134217728,67108928,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274789,0,0,0,0,0,1.0,1.0,1.0,1.0,358615,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(274940,0,0,0,0,0,1.0,1.0,1.0,1.0,358766,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275022,0,0,0,0,0,2.0,1.0,1.0,1.0,358848,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275030,0,0,0,0,0,1.0,1.0,1.0,1.0,358856,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275042,0,0,0,0,0,2.0,1.0,1.0,1.0,358868,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275073,0,0,0,0,0,2.0,1.0,1.0,1.0,358899,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275075,0,0,0,0,0,2.0,1.0,1.0,1.0,358901,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275077,0,0,0,0,0,2.0,1.0,1.0,1.0,358903,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275080,0,0,0,0,0,2.0,1.0,1.0,1.0,358906,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275088,0,0,0,0,0,2.0,1.0,1.0,1.0,358914,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275210,0,0,0,0,0,1.0,1.0,1.0,1.0,359036,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275212,0,0,0,0,0,1.0,1.0,1.0,1.0,359038,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(275216,0,0,0,0,0,1.0,1.0,1.0,1.0,359042,4096,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(276078,0,0,0,0,0,1.1,1.0,1.0,1.0,359943,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(276247,0,0,0,0,0,1.0,1.0,1.0,1.0,360128,1024,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(276318,0,0,0,0,0,1.0,1.0,1.0,1.0,360199,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(276752,0,0,0,0,0,1.25,1.0,1.0,1.0,360672,1207959552,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(276799,0,0,0,0,0,1.0,1.0,1.0,1.0,360719,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277042,0,0,0,0,0,1.0,1.0,1.0,1.0,360964,134221824,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277059,0,0,0,0,0,1.0,1.0,1.0,1.0,360981,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277151,0,0,0,0,0,1.0,1.0,1.0,1.0,361225,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277287,0,0,0,0,0,1.1,1.0,1.0,1.0,361361,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277295,0,0,0,0,0,1.0,1.0,1.0,1.0,361369,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277368,0,0,0,0,0,1.0,1.0,1.0,1.0,361442,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277410,0,0,0,0,0,1.0,1.0,1.0,1.0,361485,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277630,0,0,0,0,0,1.0,1.0,1.0,1.0,361705,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277639,0,0,0,0,0,1.1,1.0,1.0,1.0,361714,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277689,0,0,0,0,0,1.0,1.0,1.0,1.0,361764,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277694,0,0,0,0,0,1.0,1.0,1.0,1.0,361769,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277721,0,0,0,0,0,1.0,1.0,1.0,1.0,361796,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277724,0,0,0,0,0,1.0,1.0,1.0,1.0,361799,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277727,0,0,0,0,0,1.0,1.0,1.0,1.0,361802,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277729,0,0,0,0,0,1.0,0.0,1.0,1.0,361804,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277765,0,0,0,0,0,1.0,1.0,1.0,1.0,361840,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277769,0,0,0,0,0,1.0,1.0,1.0,1.0,361844,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277864,0,0,0,0,0,1.0,1.0,1.0,1.0,361939,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277881,0,0,0,0,0,1.0,1.0,1.0,1.0,361956,134217729,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277993,0,0,0,0,0,0.05,1.0,1.0,1.0,362072,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278382,0,0,0,0,0,1.15,1.25,1.0,1.0,362467,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278383,0,0,0,0,0,1.15,1.0,1.0,1.0,362468,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278384,0,0,0,0,0,1.15,1.0,1.0,1.0,362469,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278388,0,0,0,0,0,1.15,1.0,1.0,1.0,362473,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278395,0,0,0,0,0,0.01,1.0,1.0,1.0,362480,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278644,0,0,0,0,0,3.0,2.0,1.0,2.0,362733,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278978,0,0,0,0,0,1.0,1.0,1.0,1.0,363078,134217728,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(176546,0,15294,1.0,0.0,-1),
(185331,0,105306,1.0,0.0,-1),
(185332,0,105307,1.0,0.0,-1),
(185403,0,105323,1.0,0.0,-1),
(185404,0,105396,1.0,0.0,-1),
(203079,0,2679,1.0,1.0,-1),
(204070,0,433,2.0,1.0,-1),
(205278,0,11350,1.0,1.0,-1),
(205382,0,1933,1.0,1.0,-1),
(208124,0,9953,1.0,1.0,-1),
(208812,0,2378,1.0,1.0,-1),
(208841,0,113804,1.0,1.0,-1),
(208842,0,113925,1.0,1.0,-1),
(208843,0,13644,1.0,0.0,-1),
(208844,0,113913,1.0,1.0,-1),
(208845,0,113799,1.0,1.0,-1),
(208846,0,113805,1.0,1.0,-1),
(208847,0,848,1.0,1.0,-1),
(209742,0,10700,1.0,1.0,-1),
(209928,0,2378,1.0,1.0,-1),
(210107,0,2996,1.0,1.0,-1),
(211764,0,114451,1.0,1.0,-1),
(211765,0,114452,1.0,1.0,-1),
(211951,0,7837,1.0,0.0,-1),
(211967,0,711,1.0,1.0,-1),
(214208,0,115931,1.0,1.0,-1),
(216463,0,6120,1.0,0.0,-1),
(216670,0,830,1.0,0.0,-1),
(217588,0,117131,1.0,1.0,-1),
(217589,0,117132,1.0,1.0,-1),
(217590,0,5905,1.0,1.0,-1),
(217683,0,2699,1.0,0.0,-1),
(217836,0,15234,2.0,1.0,-1),
(218089,0,2493,1.0,1.0,-1),
(218090,0,1613,1.0,1.0,-1),
(218093,0,4700,1.0,1.0,-1),
(218095,0,4707,1.0,1.0,-1),
(218240,0,6909,1.0,0.25,-1),
(218240,1,8841,1.0,0.25,-1),
(218240,2,117362,1.0,0.25,-1),
(218240,3,117363,1.0,0.25,-1),
(218273,0,117401,1.0,1.0,-1),
(218434,0,11686,1.0,0.0,-1),
(218460,0,11686,1.0,0.0,-1),
(218461,0,11686,1.0,0.0,-1),
(218462,0,11686,1.0,0.0,-1),
(221656,0,118726,1.0,0.0,-1),
(222243,0,119043,1.0,1.0,-1),
(222726,0,119278,1.0,0.0,-1),
(223212,0,1126,1.0,0.0,-1),
(223212,1,15435,1.0,1.0,-1),
(224965,0,120171,2.5,1.0,-1),
(227996,0,121807,1.0,1.0,-1),
(228143,0,1126,1.0,0.0,-1),
(228143,1,15435,1.0,1.0,-1),
(228443,0,15435,1.0,1.0,-1),
(228611,0,121694,1.0,1.0,-1),
(228673,0,121694,1.0,1.0,-1),
(228721,0,12030,1.0,0.0,-1),
(228728,0,121866,1.0,1.0,-1),
(228814,0,121801,1.5,0.0,-1),
(228969,0,13031,1.0,0.0,-1),
(228970,0,13029,1.0,0.0,-1),
(229485,0,11686,1.0,1.0,-1),
(231661,0,123039,1.0,1.0,-1),
(232215,0,123080,1.0,1.0,-1),
(232216,0,123260,1.0,1.0,-1),
(232556,0,6371,1.0,1.0,-1),
(232557,0,114765,1.0,1.0,-1),
(238374,0,341,1.0,1.0,-1),
(238637,0,114765,1.0,1.0,-1),
(239942,0,11261,1.0,0.0,-1),
(240792,0,10346,1.25,0.25,-1),
(240792,1,10347,1.25,0.25,-1),
(240792,2,10348,1.25,0.25,-1),
(240792,3,10349,1.25,0.25,-1),
(240797,0,128857,1.35,1.0,-1),
(242577,0,15686,10.0,0.0,-1),
(242827,0,127,1.0,1.0,-1),
(243046,0,10342,1.0,1.0,-1),
(243509,0,358,1.0,1.0,-1),
(243893,0,10431,1.0,1.0,-1),
(244188,0,7046,1.0,0.0,-1),
(244612,0,16925,1.0,1.0,-1),
(245332,0,113799,1.0,1.0,-1),
(245423,0,123260,0.67,1.0,-1),
(246991,0,144436,1.1,0.0,-1),
(249226,0,8783,1.1,0.0,-1),
(249231,0,9017,1.5,0.0,-1),
(249232,0,123512,2.5,0.0,-1),
(249233,0,4629,2.0,1.0,-1),
(249238,0,7029,2.0,0.0,-1),
(249399,0,149127,1.0,0.0,-1),
(249473,0,1350,2.2,0.0,-1),
(249702,0,132025,0.25,1.0,-1),
(250352,0,644,1.0,1.0,-1),
(250355,0,136246,1.0,1.0,-1),
(250652,0,10700,1.0,0.0,-1),
(251461,0,137041,1.5,0.0,-1),
(251494,0,8834,1.5,1.0,-1),
(252535,0,11709,1.0,1.0,-1),
(252703,0,11686,1.0,1.0,-1),
(253275,0,9441,1.8,1.0,-1),
(253351,0,11686,1.0,0.0,-1),
(253353,0,11686,1.0,0.0,-1),
(253479,0,137875,1.15,1.0,-1),
(253529,0,3035,0.7,1.0,-1),
(253533,0,1274,0.5,0.5,-1),
(253533,1,6077,0.5,0.5,-1),
(254490,0,9031,0.8,1.0,-1),
(254613,0,1274,1.0,1.0,-1),
(254614,0,9411,1.0,1.0,-1),
(254782,0,1126,1.0,0.0,-1),
(254782,1,15435,1.0,1.0,-1),
(254797,0,152,1.0,1.0,-1),
(255174,0,11032,0.9,0.5,-1),
(255174,1,9074,0.9,0.5,-1),
(255183,0,138685,1.0,1.0,-1),
(255272,0,138878,1.0,1.0,-1),
(255273,0,138879,1.0,1.0,-1),
(255277,0,10482,1.0,1.0,-1),
(255701,0,139116,1.15,1.0,-1),
(255703,0,139386,1.15,1.0,-1),
(255721,0,139390,1.15,1.0,-1),
(255724,0,139114,1.15,1.0,-1),
(255831,0,7243,1.0,0.0,-1),
(255864,0,145740,1.15,1.0,-1),
(255877,0,139273,1.0,1.0,-1),
(255892,0,501,1.0,1.0,-1),
(256346,0,139570,0.75,1.0,-1),
(256738,0,139815,0.6,1.0,-1),
(256739,0,139816,1.0,1.0,-1),
(256740,0,139715,0.6,1.0,-1),
(256741,0,139815,1.0,1.0,-1),
(256800,0,142910,1.0,1.0,-1),
(256830,0,1148,1.25,0.0,-1),
(256881,0,139857,1.35,1.0,-1),
(256904,0,139863,1.0,0.5,-1),
(256904,1,139864,1.0,0.5,-1),
(257056,0,12433,1.0,1.0,-1),
(257450,0,140105,1.0,0.5,-1),
(257450,1,140106,1.0,0.5,-1),
(258491,0,11545,1.0,1.0,-1),
(258553,0,140825,0.25,1.0,-1),
(258595,0,703,1.0,1.0,-1),
(258617,0,8871,1.0,1.0,-1),
(258626,0,33,2.0,1.0,-1),
(258652,0,14428,1.0,1.0,-1),
(258922,0,1251,2.0,1.0,-1),
(259056,0,10169,1.0,1.0,-1),
(259179,0,269,1.0,1.0,-1),
(259198,0,141399,0.275,1.0,-1),
(259209,0,141413,0.25,1.0,-1),
(259210,0,141414,0.25,1.0,-1),
(259211,0,141415,0.25,1.0,-1),
(259224,0,11686,0.75,1.0,-1),
(259263,0,161,1.0,1.0,-1),
(259363,0,118573,0.25,1.0,-1),
(260017,0,142192,1.0,1.0,-1),
(260020,0,15435,0.375,1.0,-1),
(260023,0,142180,1.0,0.5,-1),
(260023,1,142181,1.0,0.5,-1),
(260078,0,15435,0.375,1.0,-1),
(260091,0,116031,1.0,1.0,-1),
(260128,0,142213,0.25,1.0,-1),
(260225,0,165,0.65,1.0,-1),
(260300,0,11686,1.0,1.0,-1),
(260354,0,11686,1.0,1.0,-1),
(260425,0,7237,1.0,0.7,-1),
(260425,1,4098,1.0,0.15,-1),
(260425,2,3912,1.0,0.15,-1),
(260429,0,7237,1.0,1.0,-1),
(260466,0,11553,0.8,1.0,-1),
(260468,0,142457,1.0,1.0,-1),
(260478,0,11686,1.0,1.0,-1),
(260823,0,142674,1.0,1.0,-1),
(260861,0,140909,1.0,1.0,-1),
(260862,0,140907,1.0,1.0,-1),
(260863,0,140907,1.0,1.0,-1),
(260864,0,140909,1.0,1.0,-1),
(260969,0,138242,1.0,0.5,-1),
(260969,1,139814,1.0,0.5,-1),
(261024,0,1126,1.0,0.0,-1),
(261024,1,15435,1.0,1.0,-1),
(261025,0,1126,1.0,0.0,-1),
(261025,1,15435,1.0,1.0,-1),
(261662,0,9567,1.0,0.0,-1),
(261710,0,10714,1.0,1.0,-1),
(263073,0,4878,1.0,0.0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(263369,0,143684,1.0,1.0,-1),
(263681,0,707,1.2,1.0,-1),
(263718,0,4757,0.95,1.0,-1),
(263935,0,9567,1.5,0.0,-1),
(264149,0,11686,1.0,1.0,-1),
(264176,0,15435,1.0,1.0,-1),
(265190,0,15435,1.0,1.0,-1),
(266862,0,144906,1.0,1.0,-1),
(266956,0,15435,1.0,0.0,-1),
(267065,0,144954,1.0,1.0,-1),
(267963,0,145219,1.0,0.0,-1),
(268153,0,145329,1.0,1.0,-1),
(268315,0,11686,1.0,1.0,-1),
(269133,0,7846,1.0,1.0,-1),
(269453,0,146076,1.0,0.5,-1),
(269453,1,146075,1.0,0.5,-1),
(269467,0,130209,0.35,0.0,-1),
(269519,0,11686,1.0,1.0,-1),
(270532,0,487,1.0,1.0,-1),
(270573,0,13069,1.0,1.0,-1),
(270574,0,13069,1.0,1.0,-1),
(270664,0,336,1.0,0.0,-1),
(270807,0,7571,1.0,0.0,-1),
(270846,0,138242,1.0,0.5,-1),
(270846,1,139814,1.0,0.5,-1),
(270847,0,139978,1.0,0.4,-1),
(270847,1,139979,1.0,0.4,-1),
(270847,2,140337,1.0,0.2,-1),
(270882,0,144475,4.0,1.0,-1),
(270883,0,144487,5.0,1.0,-1),
(270884,0,142144,3.0,1.0,-1),
(270885,0,142245,4.0,1.0,-1),
(270886,0,142286,4.0,1.0,-1),
(270888,0,144023,3.0,1.0,-1),
(271008,0,146522,1.0,0.5,-1),
(271008,1,146523,1.0,0.5,-1),
(271649,0,146718,1.0,1.0,-1),
(271786,0,146769,1.0,1.0,-1),
(271863,0,146837,1.0,1.0,-1),
(271898,0,146855,1.0,1.0,-1),
(271929,0,146866,1.0,1.0,-1),
(271988,0,146855,0.75,1.0,-1),
(272012,0,11709,1.0,1.0,-1),
(272112,0,522,1.0,0.0,-1),
(272377,0,147042,1.0,0.0,-1),
(272384,0,1609,1.0,0.0,-1),
(272392,0,147047,1.2,1.0,-1),
(272401,0,2699,1.0,0.0,-1),
(273164,0,114765,1.0,1.0,-1),
(273256,0,147344,1.0,1.0,-1),
(273286,0,147357,1.0,1.0,-1),
(273437,0,147396,1.0,1.0,-1),
(273567,0,147461,1.0,1.0,-1),
(273576,0,147461,1.0,1.0,-1),
(274297,0,497,1.0,1.0,-1),
(274334,0,147717,1.0,1.0,-1),
(274405,0,2451,1.0,1.0,-1),
(274770,0,148947,1.0,1.0,-1),
(274776,0,147845,1.0,1.0,-1),
(274789,0,147877,1.0,1.0,-1),
(274940,0,147963,1.0,1.0,-1),
(275022,0,148009,1.0,0.25,-1),
(275022,1,148010,1.0,0.25,-1),
(275022,2,148011,1.0,0.25,-1),
(275022,3,148012,1.0,0.25,-1),
(275030,0,148022,1.0,1.0,-1),
(275042,0,148035,1.0,0.25,-1),
(275042,1,148036,1.0,0.25,-1),
(275042,2,148037,1.0,0.25,-1),
(275042,3,148038,1.0,0.25,-1),
(275073,0,148065,1.0,0.5,-1),
(275073,1,148066,1.0,0.5,-1),
(275075,0,148071,1.0,0.5,-1),
(275075,1,148072,1.0,0.5,-1),
(275077,0,148075,1.0,0.5,-1),
(275077,1,148076,1.0,0.5,-1),
(275080,0,147978,1.0,0.25,-1),
(275080,1,147979,1.0,0.25,-1),
(275080,2,147980,1.0,0.25,-1),
(275080,3,147981,1.0,0.25,-1),
(275088,0,148090,1.0,0.5,-1),
(275088,1,148091,1.0,0.5,-1),
(275210,0,148176,1.0,1.0,-1),
(275212,0,148178,1.0,1.0,-1),
(275216,0,148184,1.0,1.0,-1),
(276078,0,143055,1.0,0.25,-1),
(276078,1,143056,1.0,0.25,-1),
(276078,2,143057,1.0,0.25,-1),
(276078,3,143058,1.0,0.25,-1),
(276247,0,15880,1.0,1.0,-1),
(276318,0,148588,1.0,1.0,-1),
(276752,0,148713,1.0,1.0,-1),
(276799,0,148733,1.0,1.0,-1),
(277042,0,149026,1.0,1.0,-1),
(277059,0,148779,1.0,1.0,-1),
(277151,0,1100,1.0,1.0,-1),
(277287,0,148845,1.0,1.0,-1),
(277295,0,148846,1.0,1.0,-1),
(277368,0,148862,1.0,1.0,-1),
(277410,0,148887,1.0,1.0,-1),
(277630,0,148945,1.0,1.0,-1),
(277639,0,148950,1.0,1.0,-1),
(277689,0,148996,1.0,1.0,-1),
(277694,0,149000,1.0,1.0,-1),
(277721,0,147926,1.0,1.0,-1),
(277724,0,149013,1.0,1.0,-1),
(277727,0,149015,1.0,1.0,-1),
(277729,0,129891,0.5,1.0,-1),
(277765,0,149022,1.0,1.0,-1),
(277769,0,149024,1.0,1.0,-1),
(277864,0,149113,1.0,1.0,-1),
(277881,0,149118,1.0,0.0,-1),
(277993,0,4587,1.0,1.0,-1),
(278382,0,5490,1.0,1.0,-1),
(278383,0,171,1.0,1.0,-1),
(278384,0,5562,1.0,1.0,-1),
(278388,0,2172,1.25,1.0,-1),
(278395,0,5586,1.0,1.0,-1),
(278644,0,8289,1.0,0.0,-1),
(278978,0,11686,0.5,1.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(185403,27,27),
(216463,38,38),
(217588,1,1),
(217589,1,1),
(217590,1,1),
(249399,50,50),
(253275,45,45),
(253529,42,43),
(253533,43,43),
(254490,37,38),
(255174,41,42),
(255864,40,40),
(256738,60,60),
(256739,60,60),
(256740,60,60),
(256741,60,60),
(256800,45,45),
(259179,38,39),
(260429,39,39),
(260861,40,40),
(260863,40,40),
(260864,40,40),
(261710,39,40),
(263369,38,38),
(263681,41,42),
(263718,42,43),
(264149,40,40),
(267065,35,35),
(269453,55,55),
(270664,37,38),
(271649,1,1),
(271898,19,19),
(271929,1,2),
(272377,60,60),
(273256,38,38),
(275042,55,55),
(277059,32,32),
(277287,46,46),
(277295,15,15),
(277368,42,42),
(277410,10,10),
(277639,27,27),
(277694,47,47),
(277724,31,31),
(277727,31,31),
(277769,28,28),
(277864,30,30),
(278382,38,38),
(278383,38,38),
(278384,38,38),
(278388,38,38);

-- from Karrz 2026_11_20_72_world_forever_eg_live_drops.sql
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((6,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(6,0,2589,31.65,0,1,0,1,1,'EG Link live 25/79');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((38,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(38,0,2589,32.61,0,1,0,1,1,'EG Link live 30/92');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((80,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(80,0,2589,29.41,0,1,0,1,1,'EG Link live 10/34');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((257,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(257,0,2589,27.69,0,1,0,1,1,'EG Link live 18/65');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((1667,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(1667,0,2589,60.0,0,1,0,1,1,'EG Link live 6/10');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((3098,0,289082));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(3098,0,289082,4.76,0,1,0,1,1,'EG Link live 3/63');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((3098,0,289087));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(3098,0,289087,6.35,0,1,0,1,1,'EG Link live 4/63');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((3098,0,289330));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(3098,0,289330,4.76,0,1,0,1,1,'EG Link live 3/63');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((253272,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(253272,0,4306,60.0,0,1,0,1,1,'EG Link live 3/5');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((254560,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(254560,0,4306,47.37,0,1,0,1,1,'EG Link live 9/19');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((254560,0,5431));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(254560,0,5431,15.79,0,1,0,1,1,'EG Link live 3/19');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255769,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255769,0,4306,15.62,0,1,0,1,1,'EG Link live 5/32');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255770,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255770,0,4306,17.39,0,1,0,1,1,'EG Link live 4/23');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255772,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255772,0,4306,26.83,0,1,0,1,1,'EG Link live 11/41');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255772,0,9355));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255772,0,9355,7.32,0,1,0,1,1,'EG Link live 3/41');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255901,0,3010));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255901,0,3010,20.0,0,1,0,1,1,'EG Link live 4/20');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255901,0,5524));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255901,0,5524,40.0,0,1,0,1,1,'EG Link live 8/20');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((255901,0,5569));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(255901,0,5569,35.0,0,1,0,1,1,'EG Link live 7/20');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((256383,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(256383,0,4306,25.0,0,1,0,1,1,'EG Link live 4/16');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((256434,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(256434,0,4306,27.27,0,1,0,1,1,'EG Link live 15/55');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((256434,0,4338));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(256434,0,4338,9.09,0,1,0,1,1,'EG Link live 5/55');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((256798,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(256798,0,4306,34.48,0,1,0,1,1,'EG Link live 10/29');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((256952,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(256952,0,4306,37.5,0,1,0,1,1,'EG Link live 9/24');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((257926,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(257926,0,4306,20.69,0,1,0,1,1,'EG Link live 6/29');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((258797,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(258797,0,4306,50.0,0,1,0,1,1,'EG Link live 3/6');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((259046,0,770));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(259046,0,770,100.0,0,1,0,1,1,'EG Link live 5/5');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((259979,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(259979,0,4306,25.0,0,1,0,1,1,'EG Link live 4/16');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((259987,0,4306));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(259987,0,4306,27.27,0,1,0,1,1,'EG Link live 3/11');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((260800,0,1697));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(260800,0,1697,22.22,0,1,0,1,1,'EG Link live 4/18');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((260800,0,3685));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(260800,0,3685,16.67,0,1,0,1,1,'EG Link live 3/18');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((260801,0,1697));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(260801,0,1697,60.0,0,1,0,1,1,'EG Link live 6/10');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((260801,0,3685));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(260801,0,3685,30.0,0,1,0,1,1,'EG Link live 3/10');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((262397,0,4603));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(262397,0,4603,7.84,0,1,0,1,1,'EG Link live 4/51');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((262397,0,5524));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(262397,0,5524,23.53,0,1,0,1,1,'EG Link live 12/51');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((262397,0,17058));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(262397,0,17058,31.37,0,1,0,1,1,'EG Link live 16/51');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((262473,0,4460));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(262473,0,4460,64.29,0,1,0,1,1,'EG Link live 9/14');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((262473,0,6444));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(262473,0,6444,21.43,0,1,0,1,1,'EG Link live 3/14');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263343,0,1464));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263343,0,1464,28.57,0,1,0,1,1,'EG Link live 10/35');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263343,0,3404));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263343,0,3404,31.43,0,1,0,1,1,'EG Link live 11/35');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263343,0,5829));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263343,0,5829,8.57,0,1,0,1,1,'EG Link live 3/35');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263343,0,11418));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263343,0,11418,14.29,0,1,0,1,1,'EG Link live 5/35');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263343,0,12037));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263343,0,12037,40.0,0,1,0,1,1,'EG Link live 14/35');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263348,0,5116));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263348,0,5116,25.0,0,1,0,1,1,'EG Link live 3/12');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263348,0,11416));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263348,0,11416,25.0,0,1,0,1,1,'EG Link live 3/12');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((263348,0,11418));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(263348,0,11418,33.33,0,1,0,1,1,'EG Link live 4/12');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((264081,0,878));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(264081,0,878,39.13,0,1,0,1,1,'EG Link live 9/23');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((264081,0,1475));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(264081,0,1475,17.39,0,1,0,1,1,'EG Link live 4/23');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((264081,0,3182));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(264081,0,3182,26.09,0,1,0,1,1,'EG Link live 6/23');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((266849,0,2590));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(266849,0,2590,71.43,0,1,0,1,1,'EG Link live 5/7');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((266850,0,1476));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(266850,0,1476,26.67,0,1,0,1,1,'EG Link live 4/15');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((266850,0,2590));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(266850,0,2590,40.0,0,1,0,1,1,'EG Link live 6/15');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((267006,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(267006,0,2589,33.33,0,1,0,1,1,'EG Link live 9/27');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((275437,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(275437,0,2589,36.59,0,1,0,1,1,'EG Link live 15/41');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((275662,0,2589));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(275662,0,2589,15.79,0,1,0,1,1,'EG Link live 6/38');
DELETE FROM `creature_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((275663,0,159));
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(275663,0,159,13.64,0,1,0,1,1,'EG Link live 3/22');

-- from Karrz 2026_11_20_77_world_forever_wowhead_quest_npcs.sql
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(212252,0,0,'Harvest Golem V000-A',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,9,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(212699,0,0,'Silverwing Archer',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(212703,0,0,'Silverwing Dryad',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(212706,0,0,'Silverwing Druid',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(212727,0,0,'Warsong Grunt',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(212728,0,0,'Warsong Raider',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(212729,0,0,'Warsong Shaman',NULL,NULL,NULL,NULL,0,0,29,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(215655,0,0,'Illari Duskfeather',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(216902,0,0,'Wulmort Jinglepocket',NULL,NULL,NULL,NULL,0,0,12,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(216915,0,0,'Strange Snowman',NULL,NULL,NULL,NULL,0,0,35,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(216924,0,0,'Kaymard Copperpinch',NULL,NULL,NULL,NULL,0,0,29,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(217957,0,0,'Slain Scarlet Crusader',NULL,NULL,NULL,NULL,0,0,12,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(217996,0,0,'Aeonas',NULL,NULL,NULL,NULL,0,0,12,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(218007,0,0,'Josh''s Kill Credit Creature 1',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(218238,0,0,'Josh''s Kill Credit Creature 2',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(221259,0,0,'Wyrmkin Nightstalker',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221260,0,0,'Terror Whelp',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221261,0,0,'Dreamfire Betrayer',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221262,0,0,'Dreamfire Hellcaller',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221263,0,0,'Vengeful Ancient',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,4,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221268,0,0,'Doran Dreambough',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221270,0,0,'Alyssian Windcaller',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221335,0,0,'Elianar Shadowdrinker',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221336,0,0,'Serlina Starbright',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221337,0,0,'Veanna Cloudsleeper',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221395,0,0,'Mellias Earthtender',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221399,0,0,'Jamniss Treemender',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221636,0,0,'Gregory',NULL,NULL,NULL,NULL,0,0,12,3,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221838,0,0,'Josh''s Kill Credit Creature P3',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(222789,0,0,'The Giant',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,5,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(228956,0,0,'Sebastian Jurgens',NULL,NULL,NULL,NULL,0,0,35,3,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(229018,0,0,'Rotting Dwarf Corpse',NULL,NULL,NULL,NULL,0,0,35,3,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,6,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(229037,0,0,'[DNT]',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(236496,0,0,'Master Feardred',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(253754,0,0,'[DNT] Kill Credit: Dispel the Accursed Skull',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(254930,0,0,'[DNT] Kill Credit: Mulara spoken with',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(255777,0,0,'Credit',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(256714,0,0,'Burrow Beetle',NULL,NULL,NULL,NULL,0,0,7,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(260417,0,0,'[DNT] Kill Credit: Ogre Miner',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263277,0,0,'[DNT] Kill Credit: Drained Crystal',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263435,0,0,'[DNT] Kill Credit: Western pylon repaired',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263436,0,0,'[DNT] Kill Credit: Eastern pylon repaired',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263458,0,0,'[DNT] Kill Credit: Pillar of Assimilation',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263460,0,0,'[DNT] Kill Credit: Regrowth Vestibule',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263461,0,0,'[DNT] Kill Credit: The Doors',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263462,0,0,'[DNT] Kill Credit: Destroyed Watcher',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(263806,0,0,'[DNT] Kill Credit: Work Stations Disrupted [Vessel]',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(264352,0,0,'[DNT] Kill Credit: Work Stations Disrupted [Slime]',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(264861,0,0,'KC Creature',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(266883,0,0,'[DNT] Kill Credit Young Paletusk',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(267462,0,0,'[DNT] Kill Credit',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(271182,0,0,'Credit',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(272307,0,0,'Legashi Satyr',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(272603,0,0,'[DNT] Kill Credit',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(273140,0,0,'Pikwin Dobblefritz',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(276250,0,0,'Credit',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1),
(277396,0,0,'Griss Rizzlefizz',NULL,NULL,NULL,NULL,0,0,12,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,7,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(278309,0,0,'Credit',NULL,NULL,NULL,NULL,0,0,35,0,1.0,1.14286,1.0,0,0,2000,2000,1.0,1.0,1,33554432,2048,0,0,0,1,0,'',0,1.0,0,0,0,0,1,0,128,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(212252,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(212699,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(212703,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(212706,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(212727,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(212728,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(212729,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(215655,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(216902,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(216915,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(216924,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217957,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(217996,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218007,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(218238,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221259,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221260,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221261,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221262,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221263,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221268,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221270,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221335,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221336,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221337,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221395,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221399,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221636,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221838,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(222789,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(228956,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(229018,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(229037,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(236496,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(253754,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(254930,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(255777,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(256714,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(260417,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263277,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263435,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263436,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263458,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263460,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263461,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263462,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(263806,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(264352,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(264861,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(266883,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(267462,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(271182,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272307,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(272603,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(273140,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(276250,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(277396,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(278309,0,0,0,0,0,1.0,1.0,1.0,1.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(212252,0,114515,1.0,1.0,-1),
(212699,0,4841,1.0,1.0,-1),
(212703,0,2723,1.0,1.0,-1),
(212706,0,4249,1.0,1.0,-1),
(212727,0,11861,1.0,1.0,-1),
(212728,0,12810,1.0,1.0,-1),
(212729,0,11865,1.0,1.0,-1),
(215655,0,116415,1.0,1.0,-1),
(216902,0,13349,1.0,1.0,-1),
(216915,0,13730,1.0,1.0,-1),
(216924,0,13342,1.0,1.0,-1),
(217957,0,1613,1.0,1.0,-1),
(217996,0,117310,1.0,1.0,-1),
(218007,0,2572,1.0,1.0,-1),
(218238,0,2572,1.0,1.0,-1),
(221259,0,118584,1.0,1.0,-1),
(221260,0,621,1.0,1.0,-1),
(221261,0,11333,1.0,1.0,-1),
(221262,0,11335,1.0,1.0,-1),
(221263,0,118592,1.0,1.0,-1),
(221268,0,10858,1.0,1.0,-1),
(221270,0,1719,1.0,1.0,-1),
(221335,0,10858,1.0,1.0,-1),
(221336,0,2459,1.0,1.0,-1),
(221337,0,2459,1.0,1.0,-1),
(221395,0,10858,1.0,1.0,-1),
(221399,0,1708,1.0,1.0,-1),
(221636,0,118721,1.0,1.0,-1),
(221838,0,2572,1.0,1.0,-1),
(222789,0,119313,1.0,1.0,-1),
(228956,0,121807,1.0,1.0,-1),
(229018,0,121859,1.0,1.0,-1),
(229037,0,15435,1.0,1.0,-1),
(236496,0,2011,1.0,1.0,-1),
(253754,0,52318,1.0,1.0,-1),
(254930,0,52318,1.0,1.0,-1),
(255777,0,10957,1.0,1.0,-1),
(256714,0,7511,1.0,1.0,-1),
(260417,0,52318,1.0,1.0,-1),
(263277,0,52318,1.0,1.0,-1),
(263435,0,52318,1.0,1.0,-1),
(263436,0,52318,1.0,1.0,-1),
(263458,0,52318,1.0,1.0,-1),
(263460,0,52318,1.0,1.0,-1),
(263461,0,52318,1.0,1.0,-1),
(263462,0,52318,1.0,1.0,-1),
(263806,0,52318,1.0,1.0,-1),
(264352,0,52318,1.0,1.0,-1),
(264861,0,2572,1.0,1.0,-1),
(266883,0,6807,1.0,1.0,-1),
(267462,0,11686,1.0,1.0,-1),
(271182,0,11686,1.0,1.0,-1),
(272307,0,2011,1.0,1.0,-1),
(272603,0,11686,1.0,1.0,-1),
(273140,0,147246,1.0,1.0,-1),
(276250,0,2467,1.0,1.0,-1),
(277396,0,148875,1.0,1.0,-1),
(278309,0,2467,1.0,1.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(212252,60,60),
(212699,25,25),
(212703,25,25),
(212706,25,25),
(212727,25,25),
(212728,25,25),
(212729,25,25),
(215655,40,40),
(216902,30,30),
(216915,35,35),
(216924,30,30),
(217957,40,40),
(217996,40,40),
(218007,1,1),
(218238,1,1),
(221259,41,41),
(221260,41,41),
(221261,41,41),
(221262,41,41),
(221263,41,41),
(221268,40,40),
(221270,40,40),
(221335,50,50),
(221336,50,50),
(221337,50,50),
(221395,50,50),
(221399,50,50),
(221636,45,45),
(221838,1,1),
(222789,52,52),
(228956,61,61),
(229018,56,57),
(229037,1,1),
(236496,53,53),
(253754,1,1),
(254930,1,1),
(255777,1,1),
(256714,56,57),
(260417,1,1),
(263277,1,1),
(263435,1,1),
(263436,1,1),
(263458,1,1),
(263460,1,1),
(263461,1,1),
(263462,1,1),
(263806,1,1),
(264352,1,1),
(264861,1,1),
(266883,1,1),
(267462,1,1),
(271182,1,1),
(272307,55,55),
(272603,1,1),
(273140,41,41),
(276250,1,1),
(277396,52,52),
(278309,1,1);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47600000,212252,0,0,0,'0',0,0,0,-1,0,0,-9922.66,1854.65,3.654,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600001,212252,0,0,0,'0',0,0,0,-1,0,0,-10538.66,1504.66,63.810,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600002,212699,1,0,0,'0',0,0,0,-1,0,0,3619.72,73.77,3.685,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600003,212703,1,0,0,'0',0,0,0,-1,0,0,3635.10,62.24,2.521,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600004,212706,1,0,0,'0',0,0,0,-1,0,0,3635.10,73.77,2.521,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600005,212727,1,0,0,'0',0,0,0,-1,0,0,3235.35,477.43,-1.442,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600006,212728,1,0,0,'0',0,0,0,-1,0,0,3235.35,477.43,-1.442,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600007,212729,1,0,0,'0',0,0,0,-1,0,0,3250.73,535.10,0.274,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600008,215655,0,0,0,'0',0,0,0,-1,0,0,-1846.92,-4243.47,2.136,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600024,221259,1,0,0,'0',0,0,0,-1,0,0,2827.92,-3120.94,182.381,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600025,221260,1,0,0,'0',0,0,0,-1,0,0,2935.54,-3224.74,169.205,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600026,221261,1,0,0,'0',0,0,0,-1,0,0,2966.29,-2809.54,212.554,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600027,221261,1,0,0,'0',0,0,0,-1,0,0,2958.61,-2809.54,212.554,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600028,221261,1,0,0,'0',0,0,0,-1,0,0,2912.48,-2821.08,210.887,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600029,221262,1,0,0,'0',0,0,0,-1,0,0,3012.42,-2809.54,203.009,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600030,221262,1,0,0,'0',0,0,0,-1,0,0,2927.86,-2809.54,212.895,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600031,221262,1,0,0,'0',0,0,0,-1,0,0,2889.42,-2809.54,205.849,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600032,221270,1,0,0,'0',0,0,0,-1,0,0,2589.61,-3605.34,134.181,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600042,221335,0,0,0,'0',0,0,0,-1,0,0,465.76,-3631.99,118.974,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600043,221336,0,0,0,'0',0,0,0,-1,0,0,234.74,-4308.85,117.729,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600044,221337,0,0,0,'0',0,0,0,-1,0,0,368.22,-3785.82,171.146,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600051,221395,1,0,0,'0',0,0,0,-1,0,0,-3079.59,1995.88,33.852,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600056,222789,1,0,0,'0',0,0,0,-1,0,0,-3394.80,2274.10,22.582,0,120,0,0,100,0,0,0,0,0,'',NULL,-1),
(47600059,236496,1,0,0,'0',0,0,0,-1,0,0,4503.21,-6380.86,126.811,0,300,5,0,100,1,0,0,0,0,'',NULL,-1),
(47600060,236496,1,0,0,'0',0,0,0,-1,0,0,4455.88,-6380.86,122.440,0,300,5,0,100,1,0,0,0,0,'',NULL,-1);

-- from Karrz 2026_11_20_79_world_forever_wowhead_ironforge_objects.sql
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650387,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650388,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650389,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650390,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650391,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650392,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650393,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650394,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650395,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650396,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650397,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650398,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650399,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650400,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650401,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650407,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650408,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650409,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650410,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650411,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650412,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650413,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650414,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650415,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650416,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650417,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650418,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650419,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650420,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650421,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650422,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650423,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650424,`type`,2470,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=171552;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650425,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650426,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650427,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650429,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650430,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650431,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650432,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650433,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650434,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650435,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650436,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650437,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650438,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650489,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650490,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650491,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650492,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650493,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650494,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650495,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650496,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650506,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650507,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650508,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650509,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650510,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650511,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650512,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650513,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650514,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650515,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650516,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650517,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650518,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175679;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650519,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175680;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650520,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175681;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650521,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175682;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650522,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175683;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650523,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175684;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650524,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175685;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650525,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175686;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650526,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175687;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650527,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175688;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650528,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175689;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650529,`type`,214,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=175685;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650573,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650574,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650575,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650576,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650579,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650580,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650581,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650584,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650585,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650587,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650588,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650589,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650590,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650591,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650592,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650594,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650595,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650596,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650597,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650599,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650600,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650607,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650608,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650609,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650610,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650611,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650612,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650613,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650614,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650615,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650616,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650617,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650618,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650619,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650620,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650628,`type`,273,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=1748;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650629,`type`,273,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=1748;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650630,`type`,2092,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=171715;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650631,`type`,2375,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=171716;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650632,`type`,2374,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=171717;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650655,`type`,679,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=171742;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650656,`type`,679,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=171742;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650664,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650665,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650667,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650668,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650669,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650670,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650671,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650672,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650673,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650674,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650675,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650676,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650677,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650678,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650679,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650680,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650681,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650682,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650683,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650688,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650689,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650690,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650698,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650699,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650700,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650701,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650702,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650703,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;
INSERT IGNORE INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 650709,`type`,197,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,`Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=26494;

-- from Karrz 2026_11_20_81_world_forever_wowhead_quest_item_drops.sql
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,220166,30.0,1,1,0,1,1,'Wowhead WoW Forever 6/20' FROM `creature_template_difficulty` d WHERE d.`Entry`=7135 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=220166);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,220166,29.63,1,1,0,1,1,'Wowhead WoW Forever 8/27' FROM `creature_template_difficulty` d WHERE d.`Entry`=7136 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=220166);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,246721,64.0,1,1,0,1,1,'Wowhead WoW Forever 80/125' FROM `creature_template_difficulty` d WHERE d.`Entry`=246991 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=246721);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,260237,87.1,0,1,0,1,1,'Wowhead WoW Forever 27/31' FROM `creature_template_difficulty` d WHERE d.`Entry`=255669 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=260237);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,262803,100.0,1,1,0,1,1,'Wowhead WoW Forever 159/159' FROM `creature_template_difficulty` d WHERE d.`Entry`=256714 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=262803);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,265837,100.0,1,1,0,1,1,'Wowhead WoW Forever 779/779' FROM `creature_template_difficulty` d WHERE d.`Entry`=256881 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=265837);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,266889,90.62,0,1,0,1,1,'Wowhead WoW Forever 29/32' FROM `creature_template_difficulty` d WHERE d.`Entry`=259056 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=266889);
INSERT IGNORE INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) SELECT d.`LootID`,0,268810,39.19,1,1,0,1,1,'Wowhead WoW Forever 301/768' FROM `creature_template_difficulty` d WHERE d.`Entry`=260429 AND d.`DifficultyID`=0 AND d.`LootID`<>0 AND NOT EXISTS (SELECT 1 FROM `creature_loot_template` l WHERE l.`Entry`=d.`LootID` AND l.`ItemType`=0 AND l.`Item`=268810);

-- from Karrz 2026_11_20_83_world_forever_wowhead_quest_objects.sql
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 422911,6366,'Sealed Barrel',1,422911,79677,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 441222,357,'Grave Mound',1,441222,81790,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 524260,5,'Highborne Tablet',1,524260,88884,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 524284,5,'Highborne Tablet',1,524284,88884,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 524298,5,'Highborne Tablet',1,524298,88884,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 524759,1387,'Sesspira''s Hoard',1,524759,88917,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 525677,621,'Mark of the Queen',1,525677,89038,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 570888,112227,'Totem of Ursol',1,570888,92066,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 570890,112227,'Totem of Ursoc',1,570890,92066,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 571511,112391,'Nordrassil Root Cap',1,571511,92343,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 584729,6913,'Mana Sieve',1,584729,96018,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 612179,116355,'Earth Song Splash',1,612179,93404,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 613761,312,'Spectral Iron Deposit',1,613761,93546,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 613764,312,'Spectral Iron Deposit',1,613764,93546,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 629472,4192,'Admiral''s Treasure Chest',1,629472,95124,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 648579,122940,'Drained Crystal Fragment',1,648579,95926,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 649097,126716,'Charged Crystal Fragment',1,649097,95928,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 649099,126717,'Fiery Crystal Fragment',1,649099,95928,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 649100,124788,'Noxious Crystal Fragment',1,649100,95928,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
INSERT IGNORE INTO `gameobject_template` (`entry`,`displayId`,`name`,`size`,`Data1`,`Data8`,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 649103,126718,'Moist Crystal Fragment',1,649103,95928,`type`,`IconName`,`castBarCaption`,`unk1`,`Data0`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,`Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,`Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,`ScriptName`,`StringId`,-1 FROM `gameobject_template` WHERE `entry`=629596;
DELETE FROM `gameobject_loot_template` WHERE (`Entry`,`ItemType`,`Item`) IN ((422911,0,213527),(423569,0,212347),(441222,0,220167),(461639,0,227686),(507731,0,235471),(507746,0,235470),(524260,0,238244),(524284,0,238245),(524298,0,238246),(524759,0,238347),(525677,0,238517),(570888,0,249693),(570890,0,249694),(571511,0,250773),(584729,0,255662),(612179,0,258296),(613761,0,259226),(613764,0,259226),(617262,0,262802),(617265,0,262818),(618822,0,264501),(629472,0,268506),(648579,0,271771),(649094,0,271892),(649097,0,271898),(649099,0,271894),(649100,0,271902),(649103,0,271912));
INSERT IGNORE INTO `gameobject_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`) VALUES
(422911,0,213527,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(423569,0,212347,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(441222,0,220167,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(461639,0,227686,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(507731,0,235471,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(507746,0,235470,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(524260,0,238244,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(524284,0,238245,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(524298,0,238246,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(524759,0,238347,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(525677,0,238517,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(570888,0,249693,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(570890,0,249694,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(571511,0,250773,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(584729,0,255662,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(612179,0,258296,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(613761,0,259226,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(613764,0,259226,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(617262,0,262802,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(617265,0,262818,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(618822,0,264501,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(629472,0,268506,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(648579,0,271771,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(649094,0,271892,50.0,1,1,0,1,1,'Wowhead WoW Forever'),
(649097,0,271898,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(649099,0,271894,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(649100,0,271902,100.0,1,1,0,1,1,'Wowhead WoW Forever'),
(649103,0,271912,100.0,1,1,0,1,1,'Wowhead WoW Forever');
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47500109,524260,1,0,0,'0',0,0,0,-1,3664.73,-5766.93,6.499,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500110,524298,1,0,0,'0',0,0,0,-1,3184.63,-5807.52,3.601,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500111,524759,1,0,0,'0',0,0,0,-1,3630.92,-5350.88,111.546,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500112,524759,1,0,0,'0',0,0,0,-1,3637.68,-5355.96,111.546,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500113,525677,1,0,0,'0',0,0,0,-1,2319.10,-6888.24,123.283,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500114,525677,1,0,0,'0',0,0,0,-1,2315.72,-6888.24,123.283,0,0,0,0,1,120,255,1,'',NULL,-1),
(47500115,584729,1,0,0,'0',0,0,0,-1,-2967.37,1082.00,147.840,0,0,0,0,1,120,255,1,'',NULL,-1);

-- from Karrz 2026_11_20_85_world_forever_wowhead_spawns_and_quests.sql
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600075,229018,0,0,0,'0',0,0,0,-1,0,0,1587.80,-3245.40,86.14,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=229018) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=229018 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600077,217957,0,0,0,'0',0,0,0,-1,0,0,-6331.50,1286.30,28.12,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=217957) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=217957 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600080,221263,1,0,0,'0',0,0,0,-1,0,0,2658.80,-3028.70,158.07,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221263) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221263 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600081,221268,1,0,0,'0',0,0,0,-1,0,0,3004.70,-3328.50,151.09,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221268) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221268 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600084,221399,1,0,0,'0',0,0,0,-1,0,0,-2736.60,2635.80,67.34,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=221399) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=221399 AND `guid` NOT BETWEEN 47600070 AND 47600199);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47500200,422911,0,0,0,'0',0,0,0,-1,-2149.30,-1633.50,-38.77,0,0,0,0,1,120,255,1,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=422911);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47500201,524284,1,0,0,'0',0,0,0,-1,3472.00,-5756.80,11.65,0,0,0,0,1,120,255,1,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=524284);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47500202,613761,1,0,0,'0',0,0,0,-1,-2639.40,1407.90,104.35,0,0,0,0,1,120,255,1,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=613761);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47500203,613764,1,0,0,'0',0,0,0,-1,-2907.20,1205.00,82.95,0,0,0,0,1,120,255,1,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=613764);

-- from Karrz 2026_11_20_90_world_forever_eg_live_vendor_items.sql
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(2519,0,270312,0,0,0,1,'',0,0,70938),
(2519,1,270313,0,0,0,1,'',0,0,70938),
(2672,23,253665,0,0,0,1,'',0,0,70959),
(2672,24,253668,0,0,0,1,'',0,0,70959);

-- from Karrz 2026_11_20_91_world_forever_wowhead_spawns_dev_heights_2.sql
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600203,255247,1,0,0,'0',0,0,0,-1,0,0,4523.50,-5056.60,164.43,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=255247) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=255247 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600204,255247,1,0,0,'0',0,0,0,-1,0,0,4395.00,-5117.50,143.35,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=255247) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=255247 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600207,256714,1,0,0,'0',0,0,0,-1,0,0,4492.80,-1625.50,1383.95,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=256714) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=256714 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600219,272307,1,0,0,'0',0,0,0,-1,0,0,4547.20,-5046.50,166.31,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=272307) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=272307 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600220,272307,1,0,0,'0',0,0,0,-1,0,0,4550.50,-5051.50,164.52,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=272307) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=272307 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600221,272307,1,0,0,'0',0,0,0,-1,0,0,4449.10,-5092.10,152.07,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=272307) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=272307 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600222,272307,1,0,0,'0',0,0,0,-1,0,0,4445.70,-5092.10,150.91,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=272307) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=272307 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47600223,272307,1,0,0,'0',0,0,0,-1,0,0,4482.90,-5102.30,160.76,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `creature_template` WHERE `entry`=272307) AND NOT EXISTS (SELECT 1 FROM `creature` WHERE `id`=272307 AND `guid` NOT BETWEEN 47600200 AND 47600399);
INSERT IGNORE INTO `gameobject` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`position_x`,`position_y`,`position_z`,`orientation`,`rotation0`,`rotation1`,`rotation2`,`rotation3`,`spawntimesecs`,`animprogress`,`state`,`ScriptName`,`StringId`,`VerifiedBuild`) SELECT 47500316,629472,0,0,0,'0',0,0,0,-1,-7410.80,-6280.90,0.72,0,0,0,0,1,120,255,1,'',NULL,-1 FROM DUAL WHERE EXISTS (SELECT 1 FROM `gameobject_template` WHERE `entry`=629472);

-- from Karrz 2026_11_20_93_world_forever_wowhead_npc_spawns_2.sql
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47600409,276788,0,0,0,'0',0,0,0,-1,0,0,-781.87,-603.73,15.235,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600410,276789,0,0,0,'0',0,0,0,-1,0,0,-781.87,-603.73,15.235,0,120,0,0,NULL,0,NULL,NULL,NULL,NULL,'',NULL,-1);

-- from Karrz 2026_11_21_22_world_forever_wowhead_incursion_bosses.sql
INSERT IGNORE INTO `creature_template` (`entry`,`KillCredit1`,`KillCredit2`,`name`,`femaleName`,`subname`,`TitleAlt`,`IconName`,`RequiredExpansion`,`VignetteID`,`faction`,`npcflag`,`speed_walk`,`speed_run`,`scale`,`Classification`,`dmgschool`,`BaseAttackTime`,`RangeAttackTime`,`BaseVariance`,`RangeVariance`,`unit_class`,`unit_flags`,`unit_flags2`,`unit_flags3`,`family`,`trainer_class`,`type`,`VehicleId`,`AIName`,`MovementType`,`ExperienceModifier`,`RacialLeader`,`movementId`,`WidgetSetID`,`WidgetSetUnitConditionID`,`RegenHealth`,`CreatureImmunitiesId`,`flags_extra`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(221265,0,0,'Larsera',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,2,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221266,0,0,'Zalius',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,3,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1),
(221267,0,0,'Shredder 9000',NULL,NULL,NULL,NULL,0,0,16,0,1.0,1.14286,1.0,1,0,2000,2000,1.0,1.0,1,0,2048,0,0,0,9,0,'',0,1.0,0,0,0,0,1,0,0,'',NULL,-1);
INSERT IGNORE INTO `creature_template_difficulty` (`Entry`,`DifficultyID`,`LevelScalingDeltaMin`,`LevelScalingDeltaMax`,`ContentTuningID`,`HealthScalingExpansion`,`HealthModifier`,`ManaModifier`,`ArmorModifier`,`DamageModifier`,`CreatureDifficultyID`,`TypeFlags`,`TypeFlags2`,`TypeFlags3`,`LootID`,`PickPocketLootID`,`SkinLootID`,`GoldMin`,`GoldMax`,`StaticFlags1`,`StaticFlags2`,`StaticFlags3`,`StaticFlags4`,`StaticFlags5`,`StaticFlags6`,`StaticFlags7`,`StaticFlags8`,`VerifiedBuild`) VALUES
(221265,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221266,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1),
(221267,0,0,0,0,0,1.0,1.0,1.0,2.0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,-1);
INSERT IGNORE INTO `creature_template_model` (`CreatureID`,`Idx`,`CreatureDisplayID`,`DisplayScale`,`Probability`,`VerifiedBuild`) VALUES
(221265,0,2717,1.0,1.0,-1),
(221266,0,11347,1.0,1.0,-1),
(221267,0,118042,1.0,1.0,-1);
INSERT IGNORE INTO `creature_classic_level` (`entry`,`level_min`,`level_max`) VALUES
(221265,43,43),
(221266,43,43),
(221267,43,43);
INSERT IGNORE INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(47600459,221265,1,0,0,'0',0,0,0,-1,0,0,2927.90,-3167.10,176.62,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600460,221265,1,0,0,'0',0,0,0,-1,0,0,2927.90,-3224.70,165.46,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600461,221265,1,0,0,'0',0,0,0,-1,0,0,2920.20,-3224.70,165.81,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600462,221266,1,0,0,'0',0,0,0,-1,0,0,2774.10,-2959.50,144.96,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600463,221266,1,0,0,'0',0,0,0,-1,0,0,2766.40,-2959.50,143.53,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600464,221266,1,0,0,'0',0,0,0,-1,0,0,2728.00,-2971.00,141.28,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600465,221267,1,0,0,'0',0,0,0,-1,0,0,2351.30,-3282.40,101.56,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600466,221267,1,0,0,'0',0,0,0,-1,0,0,2320.50,-3282.40,101.56,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1),
(47600467,221267,1,0,0,'0',0,0,0,-1,0,0,2305.20,-3282.40,101.57,0,300,5,0,NULL,1,NULL,NULL,NULL,NULL,'',NULL,-1);

-- from Karrz 2026_11_21_55_world_forever_wowhead_vendor_items.sql
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,0,159,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,1,1179,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,2,1205,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,3,1645,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,4,1708,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,5,4536,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,6,4537,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,7,4538,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,8,4539,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,9,4602,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,10,8766,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(252691,11,8953,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(255704,0,159,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(255704,1,1179,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(255704,2,1205,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(255704,3,1645,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(255704,4,1708,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(255704,5,8766,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(263440,2,2527,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(263440,3,251460,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,1,2417,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,2,2418,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,3,2419,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,4,2420,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,5,2421,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,6,2422,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,7,2429,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,8,2431,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,9,2432,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,10,2434,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,11,2448,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,12,2463,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,13,2464,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,14,2465,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,15,2467,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,16,2468,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,17,2469,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,18,3593,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,19,3594,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,20,3889,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,21,3890,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(272435,22,3891,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(257057,2,4599,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(257057,3,8952,0,0,0,1,NULL,0,0,0);
INSERT IGNORE INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES
(259962,1,274972,0,0,0,1,NULL,0,0,0);

-- Karrz UPDATEs (non-quest tables) from the same files

-- from Karrz 2026_11_18_55_world_forever_live_sniffs_1116_1117.sql
UPDATE `gameobject_template` SET `Data1` = 672508 WHERE `entry` = 672508;
UPDATE `creature_template` SET `npcflag` = `npcflag` | 128 WHERE `entry` = 4963;

-- from Karrz 2026_11_19_64_world_forever_live_givers_quests.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (263190,2706);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (263190,8115);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (256418,256655);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (256655);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (255897,256657);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (11863,1776);

-- from Karrz 2026_11_19_85_world_forever_eg_live_dungeon_abilities.sql
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (3654,3669,4278,4291,4292,4535,4805,4809,4814,4818,5048,6047,6211,6243,7351,8127,11791,12876) AND `AIName` = '' AND `ScriptName` = '';
UPDATE `smart_scripts` SET `action_param1` = 642, `comment` = 'EG live: Commander Springvale - below 25% health - Divine Shield (was Divine Protection 498)' WHERE `entryorguid` = 4278 AND `source_type` = 0 AND `action_type` = 11 AND `action_param1` = 498;

-- from Karrz 2026_11_19_92_world_forever_eg_live_dungeon_abilities_2.sql
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` IN (643,1729,4418,4978,13696) AND `AIName` = '' AND `ScriptName` = '';

-- from Karrz 2026_11_19_93_world_forever_eg_live_dalaran_trash.sql
UPDATE `creature_template` SET `AIName` = 'SmartAI' WHERE `entry` = 255069 AND `AIName` = '' AND `ScriptName` = '';

-- from Karrz 2026_11_20_71_world_forever_eg_live_new_quests.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (6707,6777);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (6777);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (6707);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (255897);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (255897);

-- from Karrz 2026_11_20_72_world_forever_eg_live_drops.sql
UPDATE `creature_template_difficulty` SET `LootID`=`Entry` WHERE `DifficultyID`=0 AND `LootID`=0 AND `Entry` IN (255774,256383,257926,258797,262473,266850);

-- from Karrz 2026_11_20_73_world_forever_rare_drops_two_sources.sql
UPDATE `creature_template_difficulty` SET `LootID`=`Entry` WHERE `DifficultyID`=0 AND `LootID`=0 AND `Entry` IN (259981);

-- from Karrz 2026_11_20_75_world_forever_eg_live_quests_2.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (263190);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (5492);

-- from Karrz 2026_11_20_78_world_forever_eg_live_quests_3.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (217300);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (235906,235909);

-- from Karrz 2026_11_20_81_world_forever_wowhead_quest_item_drops.sql
UPDATE `creature_template_difficulty` SET `LootID`=`Entry` WHERE `DifficultyID`=0 AND `LootID`=0 AND `Entry` IN (4668,4705,6146,6147,6148,6200,6201,6202,7135,7136,8408,218032,222233,236496,236867,236874,239971,246991,247006,247013,247195,247198,247206,247207,247209,247231,247234,247235,247237,247248,247249,249220,249221,249222,250023,250027,252063,252096,252116,253214,253215,253394,255207,255247,255262,255271,255276,255309,255347,255364,255377,255391,255394,255669,255997,256236,256714,256881,256899,257016,257079,258042,258100,258102,258104,258152,258264,258329,258508,258516,258668,258972,259056,259256,259874,259875,259876,260429,260826,261786,262685,262696,262697,263141,264867,268423,268834,268864,268865,269104,271780,271784,272307,277474);

-- from Karrz 2026_11_20_82_world_forever_eg_live_quests_4.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (5492);

-- from Karrz 2026_11_20_83_world_forever_wowhead_quest_objects.sql
UPDATE `gameobject_template` SET `Data8`=97047 WHERE `entry`=424002 AND `Data8`=0;
UPDATE `gameobject_template` SET `Data8`=93044 WHERE `entry`=587299 AND `Data8`=0;

-- from Karrz 2026_11_20_84_world_forever_wowhead_quest_item_drops_2.sql
UPDATE `creature_template_difficulty` SET `LootID`=`Entry` WHERE `DifficultyID`=0 AND `LootID`=0 AND `Entry` IN (1097,5974,5976,5978,7447,7448,7449,7455,7456,11447,11497,11498,249228,250034,269756);

-- from Karrz 2026_11_20_85_world_forever_wowhead_spawns_and_quests.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (5492,218160);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (228619);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (236770);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (239831);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (260271);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (14395);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (2687);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (11188);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (14395);

-- from Karrz 2026_11_20_90_world_forever_eg_live_vendor_items.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|128 WHERE `entry` IN (2519);

-- from Karrz 2026_11_20_92_world_forever_eg_live_quests_6.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (255683);
UPDATE `creature_template` SET `npcflag`=`npcflag`|1 WHERE `entry` IN (255685,255771,255773);

-- from Karrz 2026_11_20_94_world_forever_eg_live_quests_7.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (219);

-- from Karrz 2026_11_21_11_world_forever_eg_live_quests_8.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (11438,215643);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (215643);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (5492,221575);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221985);
UPDATE `creature_template` SET `faction`=12 WHERE `entry`=221575;
UPDATE `creature_template` SET `faction`=35 WHERE `entry` IN (221985,215643);
UPDATE `creature_template` SET `npcflag`=`npcflag`|1 WHERE `entry`=221575;

-- from Karrz 2026_11_21_12_world_forever_eg_live_quests_9.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (16016,230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230319);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);

-- from Karrz 2026_11_21_13_world_forever_eg_live_quests_10.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (3365,256388);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (246378);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (246378);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (11878);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (230317);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (1261);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (4731);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (4730);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (3362);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (3685);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (14395);
UPDATE `creature_template` SET `npcflag`=`npcflag`|1 WHERE `entry` IN (276730,276731,276732,276876,276877,276879);

-- from Karrz 2026_11_21_14_world_forever_wowhead_feralas_missions.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);

-- from Karrz 2026_11_21_22_world_forever_wowhead_incursion_bosses.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221471);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221479);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (221480);

-- from Karrz 2026_11_21_24_world_forever_eg_live_quests_11.sql
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (5495);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (215643);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (235906);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (244517);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (40833);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (40833);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (258697);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (256438);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (259961);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (262031);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (258031);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (260825);
UPDATE `creature_template` SET `npcflag`=`npcflag`|2 WHERE `entry` IN (267121);
UPDATE `creature_template` SET `npcflag`=`npcflag`|1 WHERE `entry`=215655;

-- from Karrz 2026_11_21_55_world_forever_wowhead_vendor_items.sql
UPDATE `npc_vendor` SET `maxcount`=4, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4357 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4361 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4363 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=4, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4364 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4371 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4382 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4389 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=3, `incrtime`=9000 WHERE `entry`=240654 AND `item`=4404 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=260487 AND `item`=4603 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=260487 AND `item`=6289 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=260487 AND `item`=6303 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=260487 AND `item`=6308 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=260487 AND `item`=6362 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=260487 AND `item`=6365 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=260487 AND `item`=6533 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=260487 AND `item`=8959 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=4, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4357 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4361 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4363 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=4, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4364 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4371 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4382 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4389 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=3, `incrtime`=9000 WHERE `entry`=260565 AND `item`=4404 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=270570 AND `item`=4817 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=270570 AND `item`=4818 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=257595 AND `item`=4603 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=257595 AND `item`=6289 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=257595 AND `item`=6303 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=257595 AND `item`=6308 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=257595 AND `item`=6362 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=257595 AND `item`=8959 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=3, `incrtime`=9000 WHERE `entry`=263230 AND `item`=3827 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=263230 AND `item`=271646 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=263230 AND `item`=271647 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=263230 AND `item`=271648 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=265346 AND `item`=2595 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=4, `incrtime`=9000 WHERE `entry`=265346 AND `item`=19221 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=265346 AND `item`=275892 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=270545 AND `item`=4603 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=270545 AND `item`=6289 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=270545 AND `item`=6303 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=270545 AND `item`=6308 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=270545 AND `item`=6362 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=1, `incrtime`=9000 WHERE `entry`=270545 AND `item`=6365 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=2, `incrtime`=9000 WHERE `entry`=270545 AND `item`=6533 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=5, `incrtime`=9000 WHERE `entry`=270545 AND `item`=8959 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=0;
UPDATE `npc_vendor` SET `maxcount`=4 WHERE `entry`=257004 AND `item`=10940 AND `ExtendedCost`=0 AND `type`=1 AND `maxcount`=2;
