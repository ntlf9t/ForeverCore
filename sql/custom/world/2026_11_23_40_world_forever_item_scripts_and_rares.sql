-- Classic 1.60 (WoW Forever): item spells whose dummy effect nothing ran, and rares whose loot nobody could get. C++:
-- Custom/Classic/world/classic_spell_scripts.cpp (and Libram of Light / Idol of Synthesis in the paladin and druid talent files, which
-- read their equip auras with no row here). Safe to run again.
--
-- 1306410 Restore Mathystral Amulet: 20 fragments make the amulet. 1292052 Bag of Ashen Warlock Bones: the credit for A Fitting End.
-- 13006 Shrink Ray, 1270941 Poultryizer: the outcomes their dummies name. 1295271 Everlook Delivery Bot: the strike after 6 to 8 hits.
-- 1309550 Claymore of Two Moons: Waxing or Waning Moon on a proc.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('classic_spell_item_restore_mathystral_amulet', 'classic_spell_item_ashen_warlock_bones',
    'classic_spell_item_shrink_ray', 'classic_spell_item_forever_poultryizer', 'classic_spell_item_everlook_delivery_bot',
    'classic_spell_item_claymore_of_two_moons');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1306410, 'classic_spell_item_restore_mathystral_amulet'),
(1292052, 'classic_spell_item_ashen_warlock_bones'),
(13006, 'classic_spell_item_shrink_ray'),
(1270941, 'classic_spell_item_forever_poultryizer'),
(1295271, 'classic_spell_item_everlook_delivery_bot'),
(1309550, 'classic_spell_item_claymore_of_two_moons');

-- Claymore of Two Moons: 1.35 a minute on landed melee hits (wowsims/forever, MIT, EV-0163; the client row reads 100 per hit).
-- Everlook Delivery Bot: the mark hears the hits its target takes (the client's proc flags), every one; the script counts the engineer's.
DELETE FROM `spell_proc` WHERE `SpellId` IN (1309550, 1295271);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1309550, 0, 0, 0, 0, 0, 0, 0x14, 0, 0x1, 0x2, 0, 0, 0, 1.35, 0, 0, 0),
(1295271, 0, 0, 0, 0, 0, 0, 139944, 0, 0, 0x2, 0, 0, 0, 0, 100, 0, 0);

-- A Fitting End (96435): "Throw the warlock bones onto the bone pile near the slime pools." The bag's aura reaches the nearby kill credit
-- 266513 (its target type 38 needs a condition), which now stands on the Bone Pile 652449 (Mount Hyjal, 40.7 80.2).
DELETE FROM `conditions` WHERE `SourceTypeOrReferenceId` = 13 AND `SourceEntry` = 1292052;
INSERT INTO `conditions` (`SourceTypeOrReferenceId`, `SourceGroup`, `SourceEntry`, `SourceId`, `ElseGroup`, `ConditionTypeOrReference`, `ConditionTarget`, `ConditionValue1`, `ConditionValue2`, `ConditionValue3`, `ConditionStringValue1`, `NegativeCondition`, `ErrorType`, `ErrorTextId`, `ScriptName`, `Comment`) VALUES
(13, 1, 1292052, 0, 0, 31, 0, 3, 266513, 0, '', 0, 0, 0, '', 'Bag of Ashen Warlock Bones - the bone pile''s kill credit');

-- Rares whose loot nothing else gives, never spawned: Needletooth 217836 (Needletooth's Needletooth 282703, Arathi Highlands, Witherbark
-- Village), Death Wailer 249226 (Wail of Death 281600, Mount Hyjal) and Komuk 259056 (Komuk's Warmaul 266889, which starts quest 94926;
-- Riverglades, "patrols between Bolder'ok and Rog'mar"). Wowhead Forever's map points (Arathi 67-69/63-68, Hyjal 22-23/53-56, Riverglades
-- 66-73/31-38), turned into world positions by the client's UiMapAssignment.
-- INFERRED: each stands two yards from the nearest known spawn inside those points (ground of known height), wanders 10 yards, and comes
-- back after an hour. "Pyromancer" Braxton 260468 is in a dungeon with no map point: not placed.
DELETE FROM `creature` WHERE `guid` IN (26651300, 21783600, 24922600, 25905600);
INSERT INTO `creature` (`guid`,`id`,`map`,`zoneId`,`areaId`,`spawnDifficulties`,`phaseUseFlags`,`PhaseId`,`PhaseGroup`,`terrainSwapMap`,`modelid`,`equipment_id`,`position_x`,`position_y`,`position_z`,`orientation`,`spawntimesecs`,`wander_distance`,`currentwaypoint`,`curHealthPct`,`MovementType`,`npcflag`,`unit_flags`,`unit_flags2`,`unit_flags3`,`ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(26651300,266513,1,0,0,'0',0,0,0,-1,0,0,4447.18,-2338.13,1117.34,0.000,300,0,0,100,0,NULL,NULL,NULL,NULL,'',NULL,0),
(21783600,217836,0,0,0,'0',0,0,0,-1,0,0,-1729.6,-3372.4,32.3,0.000,3600,10,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(24922600,249226,1,0,0,'0',0,0,0,-1,0,0,5003.1,-1712.7,1331.9,0.000,3600,10,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0),
(25905600,259056,0,0,0,'0',0,0,0,-1,0,0,-7535.5,-5193.5,58.5,0.000,3600,10,0,100,1,NULL,NULL,NULL,NULL,'',NULL,0);
