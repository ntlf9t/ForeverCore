-- Recipe, plans, pattern, formula, schematic and manual items that our world had no source for: the drops and vendors that
-- Wowhead's WoW Forever database lists for them (www.wowhead.com/forever, item pages read 22 Nov 2026). Drop chance = Wowhead's
-- count over kills on live, given for every row. A drop goes in only where the creature has a spawn and its loot id is its own
-- entry (no other creature's loot changes) and Wowhead recorded at least 100 kills. Vendors: the item's own price applies.
-- Left out (not in our world, not spawned, too few kills on Wowhead, or a quest reward of a quest we do not have):
--   Formula: Frozen Heart of the Mountain: drop Mor Grayhoof (16080), creature has no spawn in our world (may be summoned by a script)
--   Recipe: Savory Turtle Stew: drop Child of Tortolla (249224), creature not in our world database
--   Recipe: Flank au Poivre: drop Ghostfang Alpha (249225), creature not in our world database
--   Recipe: Steaming Stag Steak: quest Now We're Cooking (92433), quest not in our world database
--   Recipe: Prehistoric Pulled Raptor: drop Ravasaur Juvenile (262689), creature not in our world database
--   Recipe: Giant Scrambled Eggs: drop Lost One Cook (1106), only 24 kills recorded on Wowhead
--   Recipe: Potion of Beast Slaying: quest Gettin' Buzzed (89013), quest not in our world database
--   Plans: Blessed Plate Helm: drop Scarlet Paladin (1834), only 62 kills recorded on Wowhead
--   Plans: Blessed Plate Chest: drop Wormwing Harpy (249220), creature not in our world database
--   Plans: Blessed Plate Chest: drop Wormwing Windwitch (249221), creature not in our world database
--   Plans: Blessed Plate Chest: drop Wormwing Ambusher (249222), creature not in our world database
--   Plans: Blessed Plate Chest: drop Zarrat Wormwing (260826), creature not in our world database
--   Pattern: Charged Scorpid Shoulders: drop Swamp Talker (950), only 97 kills recorded on Wowhead
--   Pattern: Blue Dragonscale Helm: drop Azurepetal Trapper (261770), only 3 kills recorded on Wowhead
--   Pattern: Blue Dragonscale Helm: drop Azurepetal Flayer (261774), only 15 kills recorded on Wowhead
--   Pattern: Blue Dragonscale Helm: drop Emerald Flayer (262164), only 12 kills recorded on Wowhead
--   Pattern: Blue Dragonscale Helm: drop Emberleaf Flayer (262188), only 5 kills recorded on Wowhead
--   Pattern: Blue Dragonscale Helm: drop Emberleaf Germinator (262190), only 7 kills recorded on Wowhead
--   Pattern: Blue Dragonscale Helm: drop Quickpetal Flayer (262197), only 13 kills recorded on Wowhead
--   Pattern: Mooncloth Reagent Bag: vendor Dala Fairmaw (256629), vendor not in our world database
--   Pattern: Ghostweave Hood: drop Withered Protector (7149), only 38 kills recorded on Wowhead
--   Manual: Surgical Tourniquet: drop Scarlet Trainee (6575), creature has no spawn in our world (may be summoned by a script)
--   Manual: Powerful Poultice: quest Transmuted Tincture (86812), quest not in our world database
--   Schematic: EZ-Thro Dark Bomb: drop Abomination (8545), only 46 kills recorded on Wowhead
--   Blueprint: Repair Bot: drop Sneed (643), already in his loot (6.76%)
--   Blueprint: Anarchist's Workbench: drop Ezra Grimm (11058), creature has no spawn in our world (may be summoned by a script)
--   Recipe: Sweetpaw Jam: vendor Dala Fairmaw (256629), vendor not in our world database
--   Formula: Enchant Gloves - Lotus Claw: vendor Dala Fairmaw (256629), vendor not in our world database
--   Recipe: Plated Armorfish: object Recipe: Raw Plated Armorfish (694054), object has no spawn in our world
-- Safe to run more than once.
DROP TEMPORARY TABLE IF EXISTS `forever_recipe_drops_1122`;
CREATE TEMPORARY TABLE `forever_recipe_drops_1122` (`Entry` INT UNSIGNED NOT NULL, `Item` INT UNSIGNED NOT NULL, `Chance` FLOAT NOT NULL, PRIMARY KEY (`Entry`,`Item`));
INSERT INTO `forever_recipe_drops_1122` (`Entry`,`Item`,`Chance`) VALUES
(701,254018,1.44), -- Pattern: Earthen Silk Gloves, Bloodscalp Mystic (239 of 16596 kills)
(752,249883,3.81), -- Recipe: Sunny Tea, Marsh Oracle (32 of 840 kills)
(759,251463,1.17), -- Plans: Mithril Stiletto, Lost One Hunter (32 of 2731 kills)
(760,255728,12.81), -- Manual: Potent Anti-Venom, Lost One Muckdweller (352 of 2748 kills)
(873,254022,1.76), -- Pattern: Gilded Handwraps, Saltscale Oracle (11 of 625 kills)
(910,255724,10.57), -- Manual: Clever Poultice, Defias Enchanter (223 of 2110 kills)
(937,251388,1.78), -- Plans: Hard Gold Leggings, Kurzen Jungle Fighter (243 of 13631 kills)
(1907,251395,1.21), -- Plans: Shining Mithril Helm, Naga Explorer (193 of 15994 kills)
(2243,255727,12.83), -- Manual: Superior Poultice, Syndicate Sentry (491 of 3827 kills)
(2252,251391,1.47), -- Plans: Hard Gold Pauldrons, Crushridge Ogre (209 of 14193 kills)
(2376,249881,4.77), -- Recipe: Root Tea, Torn Fin Oracle (829 of 17363 kills)
(2589,255723,14.53), -- Manual: Greater Healing Potion, Syndicate Mercenary (1203 of 8279 kills)
(2739,255726,12.35), -- Manual: Leather Tourniquet, Shadowforge Tunneler (241 of 1952 kills)
(2893,251461,1.45), -- Plans: Mithril Claws, Stonevault Bonesnapper (146 of 10040 kills)
(2894,251394,1.49), -- Plans: Shining Mithril Boots, Stonevault Shaman (38 of 2544 kills)
(2906,251389,1.2), -- Plans: Hard Gold Coif, Dustbelcher Warrior (11 of 916 kills)
(2907,254034,1.83), -- Pattern: Earthen Silk Shoulders, Dustbelcher Mystic (13 of 712 kills)
(3711,251337,1.25), -- Plans: Sterling Silver Gauntlet, Wrathtail Myrmidon (58 of 4628 kills)
(3725,249475,1.45), -- Formula: Enchant Bracer - Minor Healing Power, Dark Strand Cultist (63 of 4352 kills)
(3727,251455,1.81), -- Plans: Bronze Dory, Dark Strand Enforcer (52 of 2871 kills)
(3771,251456,1.32), -- Plans: Iron Fists, Bleakheart Hellcaller (50 of 3800 kills)
(3931,250385,1.22), -- Recipe: Elixir of Strength, Shadethicket Oracle (4 of 329 kills)
(4022,250382,0.99), -- Recipe: Elixir of Spirit, Bloodfury Harpy (117 of 11759 kills)
(4095,250389,0.91), -- Recipe: Elixir of Intellect, Galak Mauler (36 of 3966 kills)
(4101,251385,1.47), -- Plans: Hard Gold Cuirass, Screeching Roguefeather (166 of 11267 kills)
(4116,254000,1.34), -- Pattern: Earthen Leggings, Gravelsnout Surveyor (10 of 746 kills)
(4151,251457,2.04), -- Plans: Steel Spear, Saltstone Crystalhide (219 of 10741 kills)
(4281,264207,0.71), -- Schematic: SAF-T Bronze Bomb, Scarlet Scout (8 of 1128 kills)
(4329,249511,1.28), -- Formula: Enchant 2H Weapon - Lesser Agility, Firemane Scout (40 of 3133 kills)
(4357,250184,6.31), -- Recipe: Raptor Rouladen, Bloodfen Lashtail (232 of 3674 kills)
(4359,254020,1.24), -- Pattern: Earthen Silk Cuffs, Mirefin Murloc (44 of 3538 kills)
(4362,251459,1.07), -- Plans: Mithril Shortsword, Mirefin Coastrunner (69 of 6452 kills)
(4632,250370,1.19), -- Recipe: Elixir of Fortitude, Kolkar Centaur (45 of 3781 kills)
(4681,249488,2.29), -- Formula: Enchant Bracer - Agility, Mage Hunter (20 of 872 kills)
(4711,251387,1), -- Plans: Hard Gold Bracers, Slitherblade Naga (47 of 4710 kills)
(4719,254016,1.23), -- Pattern: Earthen Silk Hood, Slitherblade Sea Witch (30 of 2439 kills)
(5236,255725,17.03), -- Manual: Superior Healing Potion, Gordunni Shaman (482 of 2830 kills)
(5249,251462,1.38), -- Plans: Mithril Claymore, Woodpaw Mongrel (35 of 2537 kills)
(5254,249882,4.87), -- Recipe: Triage Tea, Woodpaw Mystic (96 of 1971 kills)
(5336,249513,1.33), -- Formula: Enchant 2H Weapon - Lesser Strength, Hatecrest Sorceress (70 of 5269 kills)
(5474,264219,1.1), -- Schematic: Tru-Trigger Frag Bomb, Dunemaul Brute (62 of 5635 kills)
(6196,249516,1.3), -- Formula: Enchant Gloves - Advanced Skinning, Spitelash Myrmidon (22 of 1688 kills)
(6505,252914,1.67), -- Pattern: Supple Scorpid Leggings, Ravasaur (40 of 2401 kills)
(6508,250181,6.11), -- Recipe: Raging Raptor Ribs, Venomhide Ravasaur (60 of 982 kills)
(6556,249515,0.99), -- Formula: Lesser Eternal Wand, Muculent Ooze (6 of 609 kills)
(7379,249884,3.86), -- Recipe: Sage's Tea, Deadwind Ogre Mage (10 of 259 kills)
(7446,250178,6.61), -- Recipe: Bear Bruscitti, Rabid Shardtooth (17 of 257 kills)
(7855,251397,1.49), -- Plans: Shining Mithril Gauntlet, Southsea Pirate (149 of 9988 kills)
(10498,264229,1.35), -- Schematic: EZ-Thro Field Transporter: Gadgetzan, Spectral Tutor (9 of 666 kills)
(10758,251339,2.22), -- Plans: Sterling Silver Breastplate, Grimtotem Bandit (155 of 6991 kills)
(11489,273120,8.65), -- Blueprint: Seed Hybridizer, Tendris Warpwood (32 of 370 kills)
(12178,254132,1.43), -- Pattern: Earthenweave Cuffs, Tortured Druid (6 of 419 kills)
(247248,251453,4.69), -- Plans: Breastplate of Salvation, Legashi Summoner (15 of 320 kills)
(250027,264231,0.54), -- Schematic: EZ and SAF Field Transporter: Mt. Hyjal, Blackmaw Headhunter (6 of 1106 kills)
(253214,250183,1.11), -- Recipe: Prehistoric Pulled Raptor, Ravasaur Hunter (4 of 360 kills)
(253215,250183,0.33), -- Recipe: Prehistoric Pulled Raptor, Ravasaur Matriarch (1 of 303 kills)
(258516,252893,5.96), -- Pattern: Timbermaw Tunic, Blackmaw Druid (9 of 151 kills)
(261898,250183,2.65), -- Recipe: Prehistoric Pulled Raptor, Ravasaur Juvenile (4 of 151 kills)
(261934,250183,0.96); -- Recipe: Prehistoric Pulled Raptor, Ravasaur Stalker (3 of 311 kills)
INSERT INTO `creature_loot_template` (`Entry`,`ItemType`,`Item`,`Chance`,`QuestRequired`,`LootMode`,`GroupId`,`MinCount`,`MaxCount`,`Comment`)
SELECT `s`.`Entry`,0,`s`.`Item`,`s`.`Chance`,0,1,0,1,1,'Wowhead Forever' FROM `forever_recipe_drops_1122` `s`
JOIN `creature_template_difficulty` `d` ON `d`.`Entry`=`s`.`Entry` AND `d`.`DifficultyID`=0 AND `d`.`LootID`=`s`.`Entry`
WHERE NOT EXISTS (SELECT 1 FROM `creature_loot_template` `x` WHERE `x`.`Entry`=`s`.`Entry` AND `x`.`ItemType`=0 AND `x`.`Item`=`s`.`Item`)
  AND NOT EXISTS (SELECT 1 FROM `creature_template_difficulty` `o` WHERE `o`.`LootID`=`s`.`Entry` AND `o`.`Entry`<>`s`.`Entry`);
DROP TEMPORARY TABLE IF EXISTS `forever_recipe_drops_1122`;

-- Maria Lumere (1313)
DELETE FROM `npc_vendor` WHERE `entry`=1313 AND `item`=250999 AND `ExtendedCost`=0 AND `type`=1; -- Recipe: Potion of Beast Slaying
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (1313,0,250999,0,0,0,1,NULL,0,0,0);
-- Algernon (4610)
DELETE FROM `npc_vendor` WHERE `entry`=4610 AND `item`=250999 AND `ExtendedCost`=0 AND `type`=1; -- Recipe: Potion of Beast Slaying
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (4610,0,250999,0,0,0,1,NULL,0,0,0);
-- Qia (11189)
DELETE FROM `npc_vendor` WHERE `entry`=11189 AND `item`=250173 AND `ExtendedCost`=0 AND `type`=1; -- Recipe: Savory Stag Sliders
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (11189,0,250173,0,0,0,1,NULL,0,0,0);
-- Meilosh (11557)
DELETE FROM `npc_vendor` WHERE `entry`=11557 AND `item`=251469 AND `ExtendedCost`=0 AND `type`=1; -- Plans: Stormcarver
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (11557,0,251469,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=11557 AND `item`=251470 AND `ExtendedCost`=0 AND `type`=1; -- Plans: Bagh Nakh
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (11557,0,251470,0,0,0,1,NULL,0,0,0);
-- Aendel Windspear (15293)
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275586 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Bileblister Claws
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275586,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275587 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Bileblister Girdle
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275587,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275588 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Bileblister Boots
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275588,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275589 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Hivethrasher's Claws
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275589,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275590 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Hivethrasher's Girdle
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275590,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275591 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Hivethrasher's Boots
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275591,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275592 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Scalegut Clenchers
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275592,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275593 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Scalegut Belt
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275593,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275594 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Scalegut Treaders
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275594,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275595 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Broodwatcher's Clenchers
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275595,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275596 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Broodwatcher's Belt
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275596,0,0,0,1,NULL,0,0,0);
DELETE FROM `npc_vendor` WHERE `entry`=15293 AND `item`=275597 AND `ExtendedCost`=0 AND `type`=1; -- Pattern: Broodwatcher's Treaders
INSERT INTO `npc_vendor` (`entry`,`slot`,`item`,`maxcount`,`incrtime`,`ExtendedCost`,`type`,`BonusListIDs`,`PlayerConditionID`,`IgnoreFiltering`,`VerifiedBuild`) VALUES (15293,0,275597,0,0,0,1,NULL,0,0,0);
