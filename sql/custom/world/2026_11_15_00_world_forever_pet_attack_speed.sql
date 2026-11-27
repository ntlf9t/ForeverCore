-- Hunter pets: the attack speed of every tameable beast, as its Faster Attack or Slower Attack passive.
-- Player report 14 Nov: a tamed Mystmane (259388, Zephras Isle rare) swings at 2.0 sec; Wowhead says 1.60 (Faster Attack II).
-- In WoW Forever every hunter pet swings once in 2.0 sec and a faster or slower beast knows one of ten passives of the
-- generic pet skill line (270), each a Mod Attack Speed aura in the 1.60 client: Faster Attack I to VII (1263099, 1263100,
-- 1263102, 1263104, 1263107, 1263109, 1263110: 1.7, 1.6, 1.5, 1.4, 1.3, 1.2 and 1.0 sec) and Slower Attack I to III
-- (1263111, 1263113, 1263114: 2.4, 2.5 and 2.7 sec). Until now a pet took its creature's own attack time
-- (creature_template.BaseAttackTime), which holds vanilla's speed for the vanilla beasts and 2.0 sec for every beast that is
-- new in Forever, so none of the new beasts had its speed. The core now starts every hunter pet at 2.0 sec and reads the
-- beast's passive from this table (Pet::SyncTameAttackSpeed: on taming and whenever the pet loads, so pets tamed before
-- this get it too, and a pet keeps no other speed passive).
-- Sources, 104 beasts:
--   87 rows from Wowhead's WoW Forever database, the NPC page's Quick Facts line "Attack Speed: <sec> (<passive>)",
--   wowhead.com/forever/npc=<id>, read 2026-11-14/15: every tameable beast that is new in Forever (id 200000 and up), and 72
--   vanilla ones, whose speed matched our BaseAttackTime in every case. A page that gives a speed but names no passive
--   (Black Bear 2.50, Bhag'thera 1.50) gets the passive of that speed.
--   17 rows marked "vanilla speed": vanilla beasts whose page has no attack speed line (nobody recorded it); the
--   passive of their BaseAttackTime (vanilla's speed).
-- Fifteen new Forever beasts change speed with this: Mystmane 1.60; Scrawny Ursera, Highlands Ursera, Ursera Scavenger,
-- Urs'anah and Matriarch Bristlefur 2.50; Prideclaw 1.40; Galestrider (both), Vulgara the Insatiable, Slydris and Coldrasp
-- 1.50; Ornery Galestrider, Fernfeather and Shal'ma 1.30.
-- A beast that is not listed swings at 2.0 sec. Wild creatures are not changed. The table is read once, so the rows take
-- effect after a worldserver restart. Safe to run again.
DELETE FROM `classic_pet_tame_spell` WHERE `SpellId` IN (1263099, 1263100, 1263102, 1263104, 1263107, 1263109, 1263110, 1263111, 1263113, 1263114);
INSERT INTO `classic_pet_tame_spell` (`CreatureEntry`, `SpellId`) VALUES
(118,1263102), -- Prowler: 1.50, Faster Attack III
(525,1263099), -- Mangy Wolf: 1.70, Faster Attack I
(681,1263107), -- Young Stranglethorn Tiger: 1.30, Faster Attack V
(682,1263107), -- Stranglethorn Tiger: 1.30, Faster Attack V
(683,1263107), -- Young Panther: 1.30, Faster Attack V
(684,1263102), -- Shadowmaw Panther: 1.50, Faster Attack III
(728,1263102), -- Bhag'thera: 1.50, Faster Attack III
(729,1263107), -- Sin'Dall: 1.30, Faster Attack V
(731,1263104), -- King Bangalash: 1.40, Faster Attack IV
(736,1263107), -- Panther: 1.30, Faster Attack V
(767,1263109), -- Swamp Jaguar: 1.20, Faster Attack VI
(768,1263100), -- Shadow Panther: 1.60, Faster Attack II
(772,1263107), -- Stranglethorn Tigress: 1.30, Faster Attack V
(822,1263113), -- Young Forest Bear: 2.50, Slower Attack II
(976,1263107), -- Kurzen War Tiger: 1.30, Faster Attack V
(977,1263107), -- Kurzen War Panther: 1.30, Faster Attack V
(1085,1263107), -- Elder Stranglethorn Tiger: 1.30, Faster Attack V
(1129,1263113), -- Black Bear: 2.50, Slower Attack II
(1199,1263102), -- Juvenile Snow Leopard: 1.50, Faster Attack III
(1713,1263102), -- Elder Shadowmaw Panther: 1.50, Faster Attack III
(1922,1263099), -- Gray Forest Wolf: 1.70, Faster Attack I
(2033,1263104), -- Elder Nightsaber: 1.40, Faster Attack IV
(2034,1263102), -- Feral Nightsaber: 1.50, Faster Attack III
(2042,1263104), -- Nightsaber: 1.40, Faster Attack IV
(2043,1263104), -- Nightsaber Stalker: 1.40, Faster Attack IV
(2069,1263107), -- Moonstalker: 1.30, Faster Attack V
(2070,1263107), -- Moonstalker Runt: 1.30, Faster Attack V
(2071,1263107), -- Moonstalker Matriarch: 1.30, Faster Attack V
(2175,1263102), -- Shadowclaw: 1.50, Faster Attack III
(2237,1263107), -- Moonstalker Sire: 1.30, Faster Attack V
(2384,1263109), -- Starving Mountain Lion: 1.20, Faster Attack VI
(2385,1263109), -- Feral Mountain Lion: 1.20, Faster Attack VI
(2406,1263104), -- Mountain Lion: 1.40, Faster Attack IV
(2407,1263104), -- Hulking Mountain Lion: 1.40, Faster Attack IV
(2681,1263099), -- Vilebranch Raiding Wolf: 1.70, Faster Attack I
(2731,1263107), -- Ridge Stalker: 1.30, Faster Attack V
(2734,1263107), -- Ridge Stalker Patriarch: 1.30, Faster Attack V
(2850,1263110), -- Broken Tooth: 1.00, Faster Attack VII
(2958,1263102), -- Prairie Wolf: 1.50, Faster Attack III
(2959,1263102), -- Prairie Stalker: 1.50, Faster Attack III
(2960,1263104), -- Prairie Wolf Alpha: 1.40, Faster Attack IV
(3121,1263107), -- Durotar Tiger: 1.30, Faster Attack V
(3241,1263107), -- Savannah Patriarch: 1.30, Faster Attack V
(3243,1263102), -- Savannah Highmane: 1.50, Faster Attack III
(3245,1263107), -- Ornery Plainstrider: 1.30, Faster Attack V
(3415,1263102), -- Savannah Huntress: 1.50, Faster Attack III
(3416,1263099), -- Savannah Matriarch: 1.70, Faster Attack I
(3425,1263104), -- Savannah Prowler: 1.40, Faster Attack IV
(3825,1263107), -- Ghostpaw Alpha: 1.30, Faster Attack V
(3862,1263109), -- Slavering Worg: 1.20, Faster Attack VI, vanilla speed
(4067,1263107), -- Twilight Runner: 1.30, Faster Attack V
(4124,1263109), -- Needles Cougar: 1.20, Faster Attack VI
(4126,1263100), -- Crag Stalker: 1.60, Faster Attack II
(4250,1263102), -- Galak Packhound: 1.50, Faster Attack III
(4304,1263102), -- Scarlet Tracking Hound: 1.50, Faster Attack III, vanilla speed
(4534,1263109), -- Tamed Hyena: 1.20, Faster Attack VI, vanilla speed
(5766,1263109), -- Savannah Cub: 1.20, Faster Attack VI
(5807,1263109), -- The Rake: 1.20, Faster Attack VI
(5823,1263100), -- Death Flayer: 1.60, Faster Attack II
(5828,1263107), -- Humar the Pridelord: 1.30, Faster Attack V
(5865,1263102), -- Dishu: 1.50, Faster Attack III
(6505,1263102), -- Ravasaur: 1.50, Faster Attack III, vanilla speed
(6506,1263102), -- Ravasaur Runner: 1.50, Faster Attack III, vanilla speed
(6507,1263102), -- Ravasaur Hunter: 1.50, Faster Attack III, vanilla speed
(6508,1263102), -- Venomhide Ravasaur: 1.50, Faster Attack III
(7430,1263102), -- Frostsaber Cub: 1.50, Faster Attack III
(7431,1263102), -- Frostsaber: 1.50, Faster Attack III
(7432,1263102), -- Frostsaber Stalker: 1.50, Faster Attack III
(7433,1263102), -- Frostsaber Huntress: 1.50, Faster Attack III
(7434,1263102), -- Frostsaber Pride Watcher: 1.50, Faster Attack III
(8299,1263109), -- Spiteflayer: 1.20, Faster Attack VI
(8300,1263107), -- Ravage: 1.30, Faster Attack V
(9416,1263102), -- Scarshield Worg: 1.50, Faster Attack III, vanilla speed
(9684,1263102), -- Lar'korwi: 1.50, Faster Attack III, vanilla speed
(9696,1263102), -- Bloodaxe Worg: 1.50, Faster Attack III, vanilla speed
(10077,1263109), -- Deathmaw: 1.20, Faster Attack VI
(10200,1263102), -- Rak'shiri: 1.50, Faster Attack III
(10375,1263102), -- Spire Spiderling: 1.50, Faster Attack III, vanilla speed
(10644,1263107), -- Mist Howler: 1.30, Faster Attack V
(10806,1263111), -- Ursius: 2.40, Slower Attack I
(10979,1263102), -- Scarlet Hound: 1.50, Faster Attack III, vanilla speed
(11368,1263110), -- Bloodseeker Bat: 1.00, Faster Attack VII, vanilla speed
(11370,1263114), -- Razzashi Broodwidow: 2.70, Slower Attack III, vanilla speed
(14222,1263104), -- Araga: 1.40, Faster Attack IV
(14430,1263104), -- Duskstalker: 1.40, Faster Attack IV
(14965,1263110), -- Frenzied Bloodseeker Bat: 1.00, Faster Attack VII, vanilla speed
(15546,1263102), -- Hive'Zara Swarmer: 1.50, Faster Attack III, vanilla speed
(15621,1263102), -- Yauj Brood: 1.50, Faster Attack III, vanilla speed
(16698,1263110), -- Corpse Scarab: 1.00, Faster Attack VII, vanilla speed
(250926,1263113), -- Scrawny Ursera: 2.50, Slower Attack II
(250928,1263113), -- Highlands Ursera: 2.50, Slower Attack II
(250937,1263113), -- Ursera Scavenger: 2.50, Slower Attack II
(251115,1263113), -- Urs'anah: 2.50, Slower Attack II
(251245,1263104), -- Prideclaw: 1.40, Faster Attack IV
(251661,1263102), -- Galestrider: 1.50, Faster Attack III
(251707,1263107), -- Ornery Galestrider: 1.30, Faster Attack V
(254589,1263102), -- Vulgara the Insatiable: 1.50, Faster Attack III
(255887,1263102), -- Slydris: 1.50, Faster Attack III
(256492,1263107), -- Fernfeather: 1.30, Faster Attack V
(259388,1263100), -- Mystmane: 1.60, Faster Attack II
(262523,1263102), -- Galestrider: 1.50, Faster Attack III
(274300,1263102), -- Coldrasp: 1.50, Faster Attack III
(276189,1263113), -- Matriarch Bristlefur: 2.50, Slower Attack II
(276198,1263107); -- Shal'ma: 1.30, Faster Attack V
