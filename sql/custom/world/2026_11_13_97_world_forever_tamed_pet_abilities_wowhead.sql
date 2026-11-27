-- Hunter pets (audit 11-13), follow-up to 2026_11_10_70: what a beast knows when it is tamed, for the beasts that list leaves out.
-- Player report 13 Nov: a Skyborne hunter tamed a Zephras Isle bear and it came with no ability. 2026_11_10_70 holds VMaNGOS's
-- vanilla list only, so none of the new Forever beasts were in it: they came with nothing and could teach the hunter nothing
-- (Pet::LearnTameSpells and Pet::CheckLearning read only this table).
-- Source: Wowhead's WoW Forever database, the "Taught by" tab of every hunter pet ability rank (wowhead.com/forever/spell=<pet
-- spell>, read 2026-11-13). That tab lists the beasts that know the rank when tamed, with their pet family. Every pet spell that a
-- Beast Training rank (skill line 261) teaches, and Sonic Blast, was read. Rows below are the beasts of that tab that our table
-- did not have for that ability. Mother Fang (471) and Savannah Patriarch (3241) had another rank of the same ability from
-- VMaNGOS; Wowhead's Forever rank replaces it.
-- Not added: beasts that are not in our creature_template (Wildplains Patriarch 259054, Wildplains Huntress 259055, Kackle 210107,
-- Ombassa 263315, Vale Screamer 272401, and the bats 255174 and 277881), and the Faster/Slower Attack ranks, whose taught-by lists
-- are empty. Sonic Blast has no Beast Training rank in the 1.60 client, so a tamed bat keeps it but cannot teach it.
-- Wowhead's lists only hold beasts that its users have seen, so a beast that is missing here may still know something on live.
-- Pets tamed before this keep what they learned; this only changes what a beast knows when it is tamed. GetTameSpells reads
-- the table once, so the rows take effect after a worldserver restart. Safe to run again.
DELETE FROM `classic_pet_tame_spell` WHERE (`CreatureEntry` = 471 AND `SpellId` = 17255) OR (`CreatureEntry` = 3241 AND `SpellId` = 1753);

-- Vanilla rows that Forever's families no longer allow (the ability is in none of the beast's CreatureFamily skill lines in the
-- 1.60 client) and that Wowhead's Forever lists do not have: in Forever Demoralizing Screech is a Carrion Bird ability only, bats
-- learn Dive from Rank 2, and spiders do not dive. A tamed beast learned them anyway (Pet::LearnTameSpells does not check the
-- family). Drywallow Snapper's Claw (4343, 16831) stays: Wowhead's Forever list has it.
DELETE FROM `classic_pet_tame_spell` WHERE (`CreatureEntry`, `SpellId`) IN (
(4425,23145), (4538,23145), (4539,23145), (4861,23145), -- Blind Hunter, Kraul Bat, Greater Kraul Bat, Shrike Bat: Dive Rank 1
(4861,24577), (8602,24579), (8927,24578),               -- Shrike Bat, Monstrous Plaguebat, Dark Screecher: Demoralizing Screech
(7097,24578), (7456,24579),                             -- Ironbeak Owl, Winterspring Screecher: Demoralizing Screech
(11370,23148));                                         -- Razzashi Broodwidow: Dive Rank 3
INSERT IGNORE INTO `classic_pet_tame_spell` (`CreatureEntry`, `SpellId`) VALUES
(471,17253), -- Mother Fang: Bite, pet level 1, replaces VMaNGOS Rank 2
(3241,1755), -- Savannah Patriarch: Cower, pet level 35, replaces VMaNGOS Rank 2
(199,24423), -- Young Fleshripper: Demoralizing Screech, pet level 8
(217,1265843), -- Venom Web Spider: Web, pet level 12
(539,1265843), -- Pygmy Venom Web Spider: Web, pet level 12
(685,1265066), -- Stranglethorn Raptor: Savage Rend, pet level 24
(687,1265067), -- Jungle Stalker: Savage Rend, pet level 36
(731,24452), -- King Bangalash: Prowl, pet level 40
(830,1264735), -- Sand Crawler: Pinch, pet level 12
(855,1265066), -- Young Stranglethorn Raptor: Savage Rend, pet level 24
(858,1265880), -- Sorrow Spinner: Web, pet level 36
(922,1264739), -- Silt Crawler: Pinch, pet level 36
(930,1265878), -- Black Widow Hatchling: Web, pet level 24
(1015,1265066), -- Highland Raptor: Savage Rend, pet level 24
(1016,1265066), -- Highland Lashtail: Savage Rend, pet level 24
(1017,1265066), -- Highland Scytheclaw: Savage Rend, pet level 24
(1018,1265066), -- Highland Razormaw: Savage Rend, pet level 24
(1019,1265066), -- Elder Razormaw: Savage Rend, pet level 24
(1021,1265066), -- Mottled Screecher: Savage Rend, pet level 24
(1022,1265066), -- Mottled Scytheclaw: Savage Rend, pet level 24
(1023,1265066), -- Mottled Razormaw: Savage Rend, pet level 24
(1111,1265843), -- Leech Stalker: Web, pet level 12
(1150,1264927), -- River Crocolisk: Dismember, pet level 24
(1151,1264927), -- Saltwater Crocolisk: Dismember, pet level 24
(1184,1265843), -- Cliff Lurker: Web, pet level 12
(1188,1264494), -- Grizzled Black Bear: Swipe, pet level 12
(1216,1264735), -- Shore Crawler: Pinch, pet level 12
(1400,1264758), -- Wetlands Crocolisk: Dismember, pet level 12
(1417,1264758), -- Young Wetlands Crocolisk: Dismember, pet level 12
(1693,1264758), -- Loch Crocolisk: Dismember, pet level 12
(1780,1265843), -- Moss Stalker: Web, pet level 12
(1797,1264494), -- Giant Grizzled Bear: Swipe, pet level 12
(1811,23148), -- Plaguewing Vulture: Dive, pet level 50
(2172,17256), -- Strider Clutchmother: Bite, pet level 16
(2172,1265899), -- Strider Clutchmother: Dust Cloud, pet level 12
(2232,1264735), -- Tide Crawler: Pinch, pet level 12
(2235,1264735), -- Reef Crawler: Pinch, pet level 12
(2236,1264735), -- Raging Reef Crawler: Pinch, pet level 12
(2322,1265899), -- Foreststrider: Dust Cloud, pet level 12
(2349,1265878), -- Giant Moss Creeper: Web, pet level 24
(2356,1264497), -- Elder Gray Bear: Swipe, pet level 24
(2561,1265067), -- Highland Fleshstalker: Savage Rend, pet level 36
(2970,16827), -- Swoop: Claw, pet level 1
(2971,24423), -- Taloned Swoop: Demoralizing Screech, pet level 8
(3246,1265899), -- Fleeting Plainstrider: Dust Cloud, pet level 12
(3255,1265065), -- Sunscale Screecher: Savage Rend, pet level 12
(3819,1265843), -- Wildthorn Stalker: Web, pet level 12
(3820,1265878), -- Wildthorn Venomspitter: Web, pet level 24
(4007,1265843), -- Deepmoss Venomspitter: Web, pet level 12
(4127,1265038), -- Hecklefang Hyena: Tendon Rip, pet level 12
(4248,1265039), -- Pesterhide Hyena: Tendon Rip, pet level 24
(4249,1265039), -- Pesterhide Snarler: Tendon Rip, pet level 24
(4342,1264929), -- Drywallow Vicejaw: Dismember, pet level 36
(4724,23099), -- Sandstrider: Dash, pet level 30
(4724,1265901), -- Sandstrider: Dust Cloud, pet level 24
(5268,1264498), -- Ironfur Bear: Swipe, pet level 36
(7097,1265057), -- Ironbeak Owl: Mine!, pet level 40
(7455,1265057), -- Winterspring Owl: Mine!, pet level 40
(7456,1265058), -- Winterspring Screecher: Mine!, pet level 50
(8958,1264501), -- Angerclaw Mauler: Swipe, pet level 48
(10357,1264478), -- Ressan the Needler: Sonic Blast, pet level 12, no Beast Training rank
(11738,1265881), -- Sand Skitterer: Web, pet level 48
(12347,1264736), -- Enraged Reef Crawler: Pinch, pet level 24
(12432,1264494), -- Old Vicejaw: Swipe, pet level 12
(14228,17258), -- Giggler: Bite, pet level 32
(14228,1265039), -- Giggler: Tendon Rip, pet level 24
(14268,24423), -- Lord Condar: Demoralizing Screech, pet level 8
(14280,1264497), -- Big Samras: Swipe, pet level 24
(248299,16828), -- Elmpaw: Claw, pet level 8
(250868,17253), -- Vuldren: Bite, pet level 1
(250873,17253), -- Juvenile Vuldren: Bite, pet level 1
(250926,16827), -- Scrawny Ursera: Claw, pet level 1
(250927,16828), -- Shadowgale Ursera: Claw, pet level 8
(250928,16827), -- Highlands Ursera: Claw, pet level 1
(250937,16827), -- Ursera Scavenger: Claw, pet level 1
(251115,16827), -- Urs'anah: Claw, pet level 1
(251245,1742), -- Prideclaw: Cower, pet level 5
(253282,1742), -- Shriekling Fledgling: Cower, pet level 5
(254588,16828), -- Windsong Crawler: Claw, pet level 8
(254589,17255), -- Vulgara the Insatiable: Bite, pet level 8
(255851,26179), -- Mature Paletusk: Charge, pet level 36
(255887,17253), -- Slydris: Bite, pet level 1
(255901,1264739), -- Sand Crawler: Pinch, pet level 36
(256492,17255), -- Fernfeather: Bite, pet level 8
(256807,1264741), -- Shore Crawler: Pinch, pet level 48
(259046,1264929), -- Freshwater Crocolisk: Dismember, pet level 36
(259267,17258), -- Plains Coyote: Bite, pet level 32
(259269,16831), -- High Plains Buzzard: Claw, pet level 32
(259388,1264494), -- Mystmane: Swipe, pet level 12
(263343,16831), -- Low Plains Buzzard: Claw, pet level 32
(263348,1755), -- Roving Tallstrider: Cower, pet level 35
(263348,1265902), -- Roving Tallstrider: Dust Cloud, pet level 36
(266851,17253), -- Ukorsbane: Bite, pet level 1
(268530,17255), -- Bloodtalon Matriarch: Bite, pet level 8
(268831,17258), -- Plains Prowler: Bite, pet level 32
(270196,1265054), -- Jai'vhanel: Mine!, pet level 10
(270298,1265054), -- Child of Jai'vhanel: Mine!, pet level 10
(271334,1264497), -- Maddened Rotclaw: Swipe, pet level 24
(274300,24604), -- Coldrasp: Furious Howl, pet level 10
(276101,1265054), -- Nightscreech: Mine!, pet level 10
(276111,16828), -- Ghostfang: Claw, pet level 8
(276189,16828), -- Matriarch Bristlefur: Claw, pet level 8
(276198,1742), -- Shal'ma: Cower, pet level 5
(277645,1310612), -- Gray Fox: Trickster's Dance, pet level 20
(277882,1264478);  -- Foothills Duskbat: Sonic Blast, pet level 12, no Beast Training rank
