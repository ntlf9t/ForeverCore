-- Migration: 0064_playerbot_rpg_names_data
-- Date:    2026-11-23
-- Purpose: Seed data for 0063_playerbot_rpg_names: curated lore first names
--          (995 rows across all 10 races x 2 sexes, incl. Skyborne races 95/96),
--          404 whole surnames and 551 compound surname parts.
--          All INSERT IGNORE - safe to re-run.
-- Reverts: yes (DELETE FROM the three tables; the generic playerbots_names
--          pool is untouched).

-- @target: shared

INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Bera',3,1),('Dagny',3,1),('Elsa',3,1),('Gretta',3,1),('Hildy',3,1),
('Inga',3,1),('Kelga',3,1),('Mira',3,1),('Ottla',3,1),('Runa',3,1),
('Sigrun',3,1),('Thyra',3,1),('Valdis',3,1),('Brynja',3,1),('Dissa',3,1),
('Frida',3,1),('Gimla',3,1),('Hedda',3,1),('Jorunn',3,1),('Kelda',3,1),
('Liv',3,1),('Magga',3,1),('Nilda',3,1),('Olga',3,1),('Petra',3,1),
('Ragna',3,1),('Tora',3,1),('Ulva',3,1),('Vigdis',3,1),('Yrsa',3,1),
('Astrid',3,1),('Bergit',3,1),('Dalva',3,1),('Edda',3,1),('Fjola',3,1),
('Gerda',3,1),('Hulda',3,1),('Ingred',3,1),('Kaia',3,1),('Marna',3,1),
('Nyra',3,1),('Odda',3,1),('Runhild',3,1),('Selva',3,1),('Toril',3,1),
('Unnur',3,1),('Varda',3,1),('Wera',3,1),('Ylva',3,1),('Asdis',3,1),
('Borghild',3,1),('Dagnil',3,1),('Estrid',3,1),('Gunda',3,1),('Hervor',3,1);

-- =====================================================================
-- source: namegen/fn_dwarf_m.sql
-- =====================================================================

-- fn_dwarf_m.sql — dwarf male first names (race 3, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Baeldin',3,0),('Bardin',3,0),('Beldrum',3,0),('Bjorun',3,0),('Brumnur',3,0),
('Dagni',3,0),('Daldin',3,0),('Dorin',3,0),('Durnan',3,0),('Ebenus',3,0),
('Faldrin',3,0),('Fendrig',3,0),('Galmin',3,0),('Grumnal',3,0),('Hadrin',3,0),
('Halmis',3,0),('Hoddir',3,0),('Jandri',3,0),('Karln',3,0),('Kelv',3,0),
('Khardun',3,0),('Maldur',3,0),('Modrum',3,0),('Nalduk',3,0),('Olgren',3,0),
('Ragnor',3,0),('Rolfur',3,0),('Skarn',3,0),('Stenmir',3,0),('Thadur',3,0),
('Thorfin',3,0),('Ulfar',3,0),('Valdun',3,0),('Yorgur',3,0),('Zaldrin',3,0),
('Andrein',3,0),('Balwark',3,0),('Corvin',3,0),('Drambor',3,0),('Eldurm',3,0),
('Fargrim',3,0),('Golban',3,0),('Hurgan',3,0),('Jorlath',3,0),('Kreggan',3,0),
('Lormand',3,0),('Mungo',3,0),('Norvald',3,0),('Odrim',3,0),('Paldin',3,0),
('Roklin',3,0),('Sorvin',3,0),('Taldric',3,0),('Ulfgar',3,0),('Vardum',3,0),
('Woldram',3,0),('Yngvar',3,0),('Borvik',3,0),('Dulfin',3,0),('Gamwold',3,0);

-- =====================================================================
-- source: namegen/fn_gnome_f.sql
-- =====================================================================

-- fn_gnome_f.sql — gnome female first names (race 7, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Bink',7,1),('Bixie',7,1),('Callie',7,1),('Celzi',7,1),('Dassa',7,1),
('Dilli',7,1),('Emmi',7,1),('Eppi',7,1),('Fira',7,1),('Fizzi',7,1),
('Ginni',7,1),('Gwinni',7,1),('Heddie',7,1),('Izzi',7,1),('Jemma',7,1),
('Kelsi',7,1),('Kiki',7,1),('Lissa',7,1),('Lotti',7,1),('Minni',7,1),
('Mitzi',7,1),('Nella',7,1),('Nixie',7,1),('Otti',7,1),('Penny',7,1),
('Piri',7,1),('Quilla',7,1),('Rosie',7,1),('Selli',7,1),('Tinsie',7,1),
('Twixi',7,1),('Vella',7,1),('Wren',7,1),('Zazie',7,1),('Bitti',7,1),
('Cissi',7,1),('Dodi',7,1),('Effi',7,1),('Gelli',7,1),('Jilli',7,1),
('Kippi',7,1),('Melli',7,1),('Pelli',7,1),('Rilla',7,1),('Trixi',7,1),
('Vikki',7,1),('Wimzi',7,1),('Yelli',7,1),('Zinni',7,1),('Pipzi',7,1);

-- =====================================================================
-- source: namegen/fn_gnome_m.sql
-- =====================================================================

-- fn_gnome_m.sql — gnome male first names (race 7, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Bibble',7,0),('Boddli',7,0),('Crankle',7,0),('Dibbler',7,0),('Dink',7,0),
('Fizzle',7,0),('Flimflam',7,0),('Gizmik',7,0),('Gizmo',7,0),('Hoddle',7,0),
('Jink',7,0),('Kipple',7,0),('Klinko',7,0),('Lofthold',7,0),('Muddle',7,0),
('Nackle',7,0),('Nibbit',7,0),('Pindle',7,0),('Poggle',7,0),('Quirk',7,0),
('Razzle',7,0),('Rindle',7,0),('Sprocket',7,0),('Tinker',7,0),('Toggi',7,0),
('Whittle',7,0),('Wimzy',7,0),('Wix',7,0),('Ziggy',7,0),('Bombit',7,0),
('Coggles',7,0),('Dabble',7,0),('Fendle',7,0),('Gimble',7,0),('Jigget',7,0),
('Knobbit',7,0),('Miggle',7,0),('Noddle',7,0),('Pimwit',7,0),('Quibble',7,0),
('Scribble',7,0),('Toddle',7,0),('Wabble',7,0),('Wiggle',7,0),('Zindle',7,0),
('Blinko',7,0),('Pendle',7,0),('Kwick',7,0),('Plunket',7,0),('Sniggle',7,0);

-- =====================================================================
-- source: namegen/fn_human_f.sql
-- =====================================================================

-- fn_human_f.sql — human female first names (race 1, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Adelaide',1,1),('Alys',1,1),('Amelia',1,1),('Ariana',1,1),('Aryenda',1,1),
('Bess',1,1),('Brianna',1,1),('Carissa',1,1),('Celeste',1,1),('Clarice',1,1),
('Darcy',1,1),('Dellia',1,1),('Edna',1,1),('Elaina',1,1),('Elinor',1,1),
('Elsbeth',1,1),('Fiona',1,1),('Giselle',1,1),('Gwendolyn',1,1),('Helena',1,1),
('Imelda',1,1),('Isabel',1,1),('Jenna',1,1),('Katrin',1,1),('Kiera',1,1),
('Lenora',1,1),('Liliane',1,1),('Lucinda',1,1),('Madeline',1,1),('Marcella',1,1),
('Marguerite',1,1),('Miriam',1,1),('Nadia',1,1),('Odette',1,1),('Ophelia',1,1),
('Penelope',1,1),('Philippa',1,1),('Rowena',1,1),('Sabine',1,1),('Selma',1,1),
('Sylvia',1,1),('Teresa',1,1),('Vanessa',1,1),('Verena',1,1),('Violet',1,1),
('Willa',1,1),('Yvette',1,1),('Annika',1,1),('Bridget',1,1),('Coralie',1,1),
('Delphina',1,1),('Estelle',1,1),('Harriet',1,1),('Josephine',1,1),('Lorelei',1,1);

-- =====================================================================
-- source: namegen/fn_human_m.sql
-- =====================================================================

-- fn_human_m.sql — human male first names (race 1, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aiden',1,0),('Aleric',1,0),('Ambrose',1,0),('Ander',1,0),('Anton',1,0),
('Baldric',1,0),('Baros',1,0),('Benedict',1,0),('Bertram',1,0),('Brant',1,0),
('Caelan',1,0),('Carevin',1,0),('Corwin',1,0),('Daelin',1,0),('Daren',1,0),
('Dorian',1,0),('Duthorian',1,0),('Edmund',1,0),('Elric',1,0),('Emmett',1,0),
('Emeric',1,0),('Galen',1,0),('Garrick',1,0),('Godric',1,0),('Grayson',1,0),
('Haldor',1,0),('Harwin',1,0),('Henze',1,0),('Joren',1,0),('Kasper',1,0),
('Landen',1,0),('Leoric',1,0),('Mathias',1,0),('Meric',1,0),('Nathaniel',1,0),
('Osric',1,0),('Padrig',1,0),('Quintus',1,0),('Randell',1,0),('Robb',1,0),
('Roland',1,0),('Ryman',1,0),('Severin',1,0),('Stefan',1,0),('Tavin',1,0),
('Thaddeus',1,0),('Walden',1,0),('Willem',1,0),('Wyatt',1,0),('Yorick',1,0),
('Zaldimar',1,0),('Aldous',1,0),('Cedwin',1,0),('Dunstan',1,0),('Falkner',1,0);

-- =====================================================================
-- source: namegen/fn_nightelf_f.sql
-- =====================================================================

-- fn_nightelf_f.sql — night elf female first names (race 4, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aelith',4,1),('Aeryn',4,1),('Aluria',4,1),('Celadyne',4,1),('Daelyshia',4,1),
('Elandra',4,1),('Faelara',4,1),('Galenia',4,1),('Ilyssia',4,1),('Jadzia',4,1),
('Kiradyn',4,1),('Lyriana',4,1),('Mylissa',4,1),('Nyssara',4,1),('Olania',4,1),
('Priara',4,1),('Sylvara',4,1),('Telandria',4,1),('Umbrala',4,1),('Velandra',4,1),
('Wylinia',4,1),('Xylara',4,1),('Ylandra',4,1),('Zephira',4,1),('Aelaria',4,1),
('Calithra',4,1),('Delaria',4,1),('Elunara',4,1),('Feyanna',4,1),('Gwenaella',4,1),
('Ithilwen',4,1),('Kelindra',4,1),('Lunara',4,1),('Mirabella',4,1),('Nerissa',4,1),
('Oriellis',4,1),('Quelara',4,1),('Selanna',4,1),('Thalindra',4,1),('Vaelara',4,1),
('Yseria',4,1),('Zylithra',4,1),('Alynara',4,1),('Delphira',4,1),('Iseldra',4,1),
('Melora',4,1),('Nymra',4,1),('Saelindra',4,1),('Velyssa',4,1),('Zelindra',4,1);

-- =====================================================================
-- source: namegen/fn_nightelf_m.sql
-- =====================================================================

-- fn_nightelf_m.sql — night elf male first names (race 4, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aethis',4,0),('Alendris',4,0),('Althair',4,0),('Balthule',4,0),('Cylarian',4,0),
('Dareth',4,0),('Elendril',4,0),('Faelen',4,0),('Felarion',4,0),('Gaerolas',4,0),
('Jarin',4,0),('Kaelen',4,0),('Kaylendri',4,0),('Laethir',4,0),('Melithar',4,0),
('Naelion',4,0),('Orenthil',4,0),('Pylarin',4,0),('Rethion',4,0),('Sarin',4,0),
('Taladan',4,0),('Thandris',4,0),('Ulendar',4,0),('Vethan',4,0),('Yelandar',4,0),
('Zephiran',4,0),('Aelorin',4,0),('Caladris',4,0),('Dorathil',4,0),('Erythis',4,0),
('Fenlath',4,0),('Haladris',4,0),('Ithran',4,0),('Kelithar',4,0),('Loranel',4,0),
('Mithralis',4,0),('Nyldris',4,0),('Ormel',4,0),('Quelar',4,0),('Seldrin',4,0),
('Thalanir',4,0),('Valerion',4,0),('Xalith',4,0),('Ylthar',4,0),('Zandalaris',4,0),
('Anarion',4,0),('Delmiran',4,0),('Illyndar',4,0),('Olanthir',4,0),('Telarius',4,0);

-- =====================================================================
-- source: namegen/fn_orc_f.sql
-- =====================================================================

-- fn_orc_f.sql — orc female first names (race 2, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Brakha',2,1),('Dagra',2,1),('Gahla',2,1),('Gorga',2,1),('Greka',2,1),
('Grishna',2,1),('Kagra',2,1),('Kargha',2,1),('Mahka',2,1),('Morgha',2,1),
('Nargha',2,1),('Olgra',2,1),('Raksha',2,1),('Shagra',2,1),('Tarah',2,1),
('Thresha',2,1),('Urga',2,1),('Vashka',2,1),('Zagora',2,1),('Zarka',2,1),
('Agra',2,1),('Besha',2,1),('Draga',2,1),('Froska',2,1),('Gharza',2,1),
('Harga',2,1),('Jalga',2,1),('Kesha',2,1),('Lorga',2,1),('Mazga',2,1),
('Nekra',2,1),('Osha',2,1),('Ragha',2,1),('Sorka',2,1),('Talgra',2,1),
('Urska',2,1),('Volka',2,1),('Worga',2,1),('Zelka',2,1),('Brokha',2,1),
('Dreka',2,1),('Gorsha',2,1),('Krasha',2,1),('Norga',2,1),('Shura',2,1),
('Togra',2,1),('Usha',2,1),('Varga',2,1),('Yagra',2,1),('Zirka',2,1);

-- =====================================================================
-- source: namegen/fn_orc_m.sql
-- =====================================================================

-- fn_orc_m.sql — orc male first names (race 2, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Borgash',2,0),('Brog',2,0),('Drak',2,0),('Drokar',2,0),('Garnok',2,0),
('Goram',2,0),('Gornak',2,0),('Grom',2,0),('Grum',2,0),('Gul''mash',2,0),
('Harruk',2,0),('Jarg',2,0),('Kargol',2,0),('Karnok',2,0),('Koruk',2,0),
('Krogar',2,0),('Magrosh',2,0),('Mok''gore',2,0),('Narg',2,0),('Ogroth',2,0),
('Ragash',2,0),('Rokgar',2,0),('Ruzgash',2,0),('Skarg',2,0),('Targ',2,0),
('Throk',2,0),('Ugrah',2,0),('Vork',2,0),('Zarg',2,0),('Zor''khan',2,0),
('Zug',2,0),('Bolg',2,0),('Durg',2,0),('Gharok',2,0),('Grotan',2,0),
('Kagrot',2,0),('Kurga',2,0),('Morzul',2,0),('Nazrok',2,0),('Orgash',2,0),
('Rakgor',2,0),('Shargal',2,0),('Trogar',2,0),('Urzog',2,0),('Varguk',2,0),
('Wor''gash',2,0),('Zalkar',2,0),('Brakor',2,0),('Gulzan',2,0),('Krull',2,0);

-- =====================================================================
-- source: namegen/fn_skyborne_a_f.sql
-- =====================================================================

-- fn_skyborne_a_f.sql — High Order Skyborne female first names (race 95, gender 1)
-- Shen'dorei flavour: celestial, orderly high-elven names.
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aeliana',95,1),('Aeritha',95,1),('Celestine',95,1),('Cyraena',95,1),('Elowen',95,1),
('Elunessa',95,1),('Faelithe',95,1),('Gaerila',95,1),('Ilaris',95,1),('Iridess',95,1),
('Junia',95,1),('Kelessa',95,1),('Kelissa',95,1),('Luminara',95,1),('Miravel',95,1),
('Nerida',95,1),('Orianna',95,1),('Orianthi',95,1),('Pelagia',95,1),('Quelira',95,1),
('Selvanna',95,1),('Sylfira',95,1),('Thalwen',95,1),('Tiriel',95,1),('Valyssa',95,1),
('Vesperia',95,1),('Ysoria',95,1),('Zephyrine',95,1),('Aetheria',95,1),('Auroriel',95,1),
('Caelindra',95,1),('Dawnya',95,1),('Erianthe',95,1),('Firmia',95,1),('Haloise',95,1),
('Ilarwen',95,1),('Luminess',95,1),('Nerovia',95,1),('Ondine',95,1),('Seraphen',95,1),
('Solaria',95,1),('Theralina',95,1),('Vaelith',95,1),('Zenithia',95,1),('Astraea',95,1);

-- =====================================================================
-- source: namegen/fn_skyborne_a_m.sql
-- =====================================================================

-- fn_skyborne_a_m.sql — High Order Skyborne male first names (race 95, gender 0)
-- Shen'dorei flavour: celestial, orderly high-elven names.
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aelorian',95,0),('Aethalion',95,0),('Caelus',95,0),('Celerion',95,0),('Dorindal',95,0),
('Eryndor',95,0),('Evandir',95,0),('Gaelion',95,0),('Galion',95,0),('Helion',95,0),
('Ilmarion',95,0),('Ithilion',95,0),('Kael''ron',95,0),('Kelador',95,0),('Luminar',95,0),
('Naeron',95,0),('Nerovion',95,0),('Oriol',95,0),('Perion',95,0),('Quel''aran',95,0),
('Rhosyn',95,0),('Selaris',95,0),('Seraphel',95,0),('Talaeron',95,0),('Thaelion',95,0),
('Vailion',95,0),('Valandor',95,0),('Zephon',95,0),('Zeruon',95,0),('Aetherion',95,0),
('Aurelian',95,0),('Castoril',95,0),('Daemion',95,0),('Elrion',95,0),('Firmion',95,0),
('Heleth',95,0),('Iridion',95,0),('Lor''thalon',95,0),('Nimrodel',95,0),('Orphelias',95,0),
('Solandor',95,0),('Theralion',95,0),('Vaelion',95,0),('Zarion',95,0),('Lumiron',95,0);

-- =====================================================================
-- source: namegen/fn_skyborne_h_f.sql
-- =====================================================================

-- fn_skyborne_h_f.sql — Windshaper Skyborne female first names (race 96, gender 1)
-- Wilder wind/storm-elven flavour.
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aerona',96,1),('Aurae',96,1),('Avia',96,1),('Breeza',96,1),('Celinde',96,1),
('Ciela',96,1),('Cyrene',96,1),('Eolina',96,1),('Eolande',96,1),('Eteri',96,1),
('Galea',96,1),('Iona',96,1),('Kira',96,1),('Levana',96,1),('Mistrana',96,1),
('Nimbra',96,1),('Sirona',96,1),('Skyla',96,1),('Talia',96,1),('Tempesta',96,1),
('Veila',96,1),('Venti',96,1),('Windessa',96,1),('Zephra',96,1),('Aelira',96,1),
('Breezea',96,1),('Caelia',96,1),('Dovra',96,1),('Eolanne',96,1),('Gustina',96,1),
('Hurika',96,1),('Kestra',96,1),('Mistrea',96,1),('Ostraea',96,1),('Squala',96,1),
('Talindra',96,1),('Vayla',96,1),('Windrissa',96,1),('Zephyrana',96,1),('Nimbelle',96,1);

-- =====================================================================
-- source: namegen/fn_skyborne_h_m.sql
-- =====================================================================

-- fn_skyborne_h_m.sql — Windshaper Skyborne male first names (race 96, gender 0)
-- Wilder wind/storm-elven flavour.
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Aeolian',96,0),('Aeron',96,0),('Borin',96,0),('Brontis',96,0),('Corvus',96,0),
('Cyclas',96,0),('Drafton',96,0),('Galeth',96,0),('Galewin',96,0),('Hurik',96,0),
('Keplan',96,0),('Kestrel',96,0),('Mistral',96,0),('Nimbus',96,0),('Norwind',96,0),
('Ostro',96,0),('Sirocco',96,0),('Stratos',96,0),('Tempar',96,0),('Thurim',96,0),
('Ventus',96,0),('Vortan',96,0),('Windham',96,0),('Zephyr',96,0),('Aethon',96,0),
('Boran',96,0),('Caelith',96,0),('Dovran',96,0),('Furion',96,0),('Gustan',96,0),
('Helvion',96,0),('Kestian',96,0),('Nimbor',96,0),('Ostrel',96,0),('Skaran',96,0),
('Taylon',96,0),('Vaelstrom',96,0),('Wyndar',96,0),('Zephron',96,0),('Aurelios',96,0);

-- =====================================================================
-- source: namegen/fn_tauren_f.sql
-- =====================================================================

-- fn_tauren_f.sql — tauren female first names (race 6, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Adlha',6,1),('Amara',6,1),('Ayasha',6,1),('Ceyla',6,1),('Chapa',6,1),
('Dahana',6,1),('Dyami',6,1),('Elu',6,1),('Eyuna',6,1),('Fola',6,1),
('Gahana',6,1),('Halona',6,1),('Hinto',6,1),('Islen',6,1),('Kaga',6,1),
('Kimimela',6,1),('Lomena',6,1),('Lowanna',6,1),('Mahu',6,1),('Minda',6,1),
('Nara',6,1),('Niabi',6,1),('Onawa',6,1),('Ootah',6,1),('Paiwuna',6,1),
('Pamuy',6,1),('Quina',6,1),('Sahkyo',6,1),('Sihu',6,1),('Taima',6,1),
('Tiyana',6,1),('Wachiwi',6,1),('Wawetseka',6,1),('Zihna',6,1),('Aponi',6,1),
('Chilam',6,1),('Enola',6,1),('Galena',6,1),('Hateya',6,1),('Kachina',6,1),
('Liluye',6,1),('Magena',6,1),('Nizhoni',6,1),('Orenda',6,1),('Powaqa',6,1),
('Shada',6,1),('Talulah',6,1),('Winona',6,1),('Yuma',6,1),('Zaltana',6,1);

-- =====================================================================
-- source: namegen/fn_tauren_m.sql
-- =====================================================================

-- fn_tauren_m.sql — tauren male first names (race 6, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Achak',6,0),('Ahanu',6,0),('Bemat',6,0),('Bidziil',6,0),('Chogan',6,0),
('Dohasan',6,0),('Doru',6,0),('Elan',6,0),('Elki',6,0),('Harb',6,0),
('Hotah',6,0),('Ituha',6,0),('Jorak',6,0),('Kohana',6,0),('Koharu',6,0),
('Lomac',6,0),('Luyu',6,0),('Mashua',6,0),('Motega',6,0),('Nataka',6,0),
('Nodin',6,0),('Orno',6,0),('Otaktay',6,0),('Pakwau',6,0),('Payat',6,0),
('Quanah',6,0),('Rookhaw',6,0),('Skah',6,0),('Tahu',6,0),('Tokala',6,0),
('Urek',6,0),('Veren',6,0),('Wapi',6,0),('Wulmort',6,0),('Awena',6,0),
('Cheveyo',6,0),('Dakota',6,0),('Etalpomo',6,0),('Honon',6,0),('Kele',6,0),
('Makya',6,0),('Nantan',6,0),('Osceola',6,0),('Rowtag',6,0),('Tasunke',6,0),
('Viho',6,0),('Wamblee',6,0),('Yantse',6,0),('Zhoni',6,0),('Kuruk',6,0);

-- =====================================================================
-- source: namegen/fn_troll_f.sql
-- =====================================================================

-- fn_troll_f.sql — troll female first names (race 8, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Alza',8,1),('Bawon',8,1),('Biru',8,1),('Chaka',8,1),('Dambi',8,1),
('Dambala',8,1),('Ezili',8,1),('Ezra',8,1),('Faiza',8,1),('Femi',8,1),
('Haiti',8,1),('Imani',8,1),('In''kaya',8,1),('Jalia',8,1),('Jamila',8,1),
('Kan''zuri',8,1),('La''shana',8,1),('Mambi',8,1),('Mawu',8,1),('N''gara',8,1),
('Nzinga',8,1),('On''ya',8,1),('Oya',8,1),('Prisca',8,1),('Quin''dara',8,1),
('Shango',8,1),('Shiriki',8,1),('T''wana',8,1),('Uzuri',8,1),('Zalika',8,1),
('Zola',8,1),('An''zara',8,1),('Bel''mora',8,1),('Daz''lima',8,1),('Gan''tala',8,1),
('Jin''ka',8,1),('Kal''fani',8,1),('Lo''zana',8,1),('Nin''jali',8,1),('Rin''zara',8,1),
('Tan''zila',8,1),('Vel''nara',8,1),('Zen''kara',8,1),('Zul''mira',8,1),('Fal''zana',8,1),
('Hex''mala',8,1),('Jub''wa',8,1),('Mon''tali',8,1),('Sul''yani',8,1),('Zan''tira',8,1);

-- =====================================================================
-- source: namegen/fn_troll_m.sql
-- =====================================================================

-- fn_troll_m.sql — troll male first names (race 8, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Bajin',8,0),('Bal''gor',8,0),('Cho''na',8,0),('Divo',8,0),('Dun''jo',8,0),
('Echigo',8,0),('Fen''ri',8,0),('Gabok',8,0),('Gon''tay',8,0),('Hun''zi',8,0),
('Jin''gok',8,0),('Ju''kar',8,0),('Kaz''ro',8,0),('Ken''zig',8,0),('Lom''bara',8,0),
('Luz''jin',8,0),('Mok''tembe',8,0),('N''kolai',8,0),('Naz''jin',8,0),('On''jin',8,0),
('Pun''jol',8,0),('Raj''tik',8,0),('Sujin',8,0),('Tajin',8,0),('Un''jari',8,0),
('Vex''jin',8,0),('Wazir',8,0),('Xol''jin',8,0),('Yayo''jin',8,0),('Zul''khan',8,0),
('Bal''jek',8,0),('Den''sai',8,0),('Gam''boko',8,0),('Jal''mak',8,0),('Kel''zan',8,0),
('Mal''jin',8,0),('Nin''zal',8,0),('Rok''han',8,0),('Sen''tai',8,0),('Tan''zul',8,0),
('Vol''jik',8,0),('Zan''kojo',8,0),('Bom''bay',8,0),('Dre''zul',8,0),('Gan''jin',8,0),
('Hak''kar',8,0),('Kil''jan',8,0),('Ren''zhul',8,0),('Zeb''khan',8,0),('Tok''jin',8,0);

-- =====================================================================
-- source: namegen/fn_undead_f.sql
-- =====================================================================

-- fn_undead_f.sql — undead female first names (race 5, gender 1)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Agnes',5,1),('Alberta',5,1),('Beatrix',5,1),('Belladonna',5,1),('Claudia',5,1),
('Cordelia',5,1),('Delphine',5,1),('Drusilla',5,1),('Elspeth',5,1),('Eudora',5,1),
('Fedora',5,1),('Francine',5,1),('Gertrude',5,1),('Griselda',5,1),('Helga',5,1),
('Hester',5,1),('Imogene',5,1),('Irena',5,1),('Lilith',5,1),('Maudlin',5,1),
('Narcissa',5,1),('Octavia',5,1),('Odile',5,1),('Pandora',5,1),('Priscilla',5,1),
('Ravenna',5,1),('Selene',5,1),('Seraphine',5,1),('Tabitha',5,1),('Theodosia',5,1),
('Ursula',5,1),('Verity',5,1),('Vivian',5,1),('Wilhelmina',5,1),('Winifred',5,1),
('Zylphia',5,1),('Amarantha',5,1),('Berenice',5,1),('Circe',5,1),('Desdemona',5,1),
('Eleanora',5,1),('Felicia',5,1),('Hecuba',5,1),('Isolde',5,1),('Lenore',5,1),
('Morgause',5,1),('Odelia',5,1),('Petronia',5,1),('Sabrina',5,1),('Thalassa',5,1);

-- =====================================================================
-- source: namegen/fn_undead_m.sql
-- =====================================================================

-- fn_undead_m.sql — undead male first names (race 5, gender 0)
INSERT IGNORE INTO {SHARED}.`playerbots_race_names` (`name`,`race`,`gender`) VALUES
('Algernon',5,0),('Almaric',5,0),('Balthasar',5,0),('Bartholomew',5,0),('Casper',5,0),
('Cedric',5,0),('Cornelius',5,0),('Damien',5,0),('Dedlow',5,0),('Eckart',5,0),
('Edgar',5,0),('Fenwick',5,0),('Fester',5,0),('Gerrard',5,0),('Gideon',5,0),
('Hector',5,0),('Horace',5,0),('Ignatius',5,0),('Ivor',5,0),('Jergan',5,0),
('Kaspian',5,0),('Kevern',5,0),('Leviticus',5,0),('Lucien',5,0),('Magnus',5,0),
('Mortimer',5,0),('Nicodemus',5,0),('Norbert',5,0),('Oswald',5,0),('Percival',5,0),
('Phineas',5,0),('Quentin',5,0),('Reginald',5,0),('Rodion',5,0),('Seymour',5,0),
('Silas',5,0),('Tobias',5,0),('Ulric',5,0),('Uriah',5,0),('Vincent',5,0),
('Vladimir',5,0),('Wendel',5,0),('Worley',5,0),('Xerxes',5,0),('Zachariah',5,0),
('Zagreus',5,0),('Amsel',5,0),('Barnaby',5,0),('Cyrus',5,0),('Ebenezer',5,0);

-- =====================================================================
-- source: namegen/sn_dwarf.sql
-- =====================================================================

-- sn_dwarf.sql — dwarf surnames (race 3): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Alebelly',3,2),('Anvilsong',3,2),('Barrelbelly',3,2),('Bellowsmoke',3,2),('Bitterbrew',3,2),
('Boldbarrel',3,2),('Bronzebrow',3,2),('Caskhelm',3,2),('Cinderbrew',3,2),('Coalbeard',3,2),
('Copperpot',3,2),('Darkquarry',3,2),('Deepforge',3,2),('Deephammer',3,2),('Drumstout',3,2),
('Emberflint',3,2),('Flintfoot',3,2),('Forgehammer',3,2),('Frostbeard',3,2),('Goldgrubber',3,2),
('Gravelgut',3,2),('Grimaxe',3,2),('Hammerstone',3,2),('Ironbrew',3,2),('Ironhand',3,2),
('Ironjaw',3,2),('Kegbelly',3,2),('Krakbrew',3,2),('Leadfoot',3,2),('Longbeard',3,2),
('Malthorn',3,2),('Maulgrim',3,2),('Moltenshield',3,2),('Oakbarrel',3,2),('Orebender',3,2),
('Pewterpot',3,2),('Rockfist',3,2),('Rustnail',3,2),('Saltbeard',3,2),('Slaghammer',3,2),
('Stonegrip',3,2),('Thundertankard',3,2),('Underhill',3,2),('Whitebeard',3,2),('Winterforge',3,2),
('Whettingstone',3,2),('Yellowsmoke',3,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Ale',0,3),('Anvil',0,3),('Barrel',0,3),('Battle',0,3),('Bellow',0,3),
('Bitter',0,3),('Black',0,3),('Bold',0,3),('Brass',0,3),('Bronze',0,3),
('Cinder',0,3),('Coal',0,3),('Copper',0,3),('Crag',0,3),('Deep',0,3),
('Ember',0,3),('Flint',0,3),('Forge',0,3),('Frost',0,3),('Gold',0,3),
('Granite',0,3),('Gravel',0,3),('Grim',0,3),('Hammer',0,3),('Iron',0,3),
('Keg',0,3),('Lead',0,3),('Molten',0,3),('Oak',0,3),('Ore',0,3),
('Pewter',0,3),('Red',0,3),('Rock',0,3),('Rust',0,3),('Salt',0,3),
('Slag',0,3),('Steel',0,3),('Stone',0,3),('Stout',0,3),('Thunder',0,3),
('Under',0,3),('Winter',0,3),
('axe',1,3),('barrel',1,3),('beard',1,3),('belly',1,3),('bender',1,3),
('boot',1,3),('braid',1,3),('brew',1,3),('brow',1,3),('chin',1,3),
('cleaver',1,3),('crusher',1,3),('fist',1,3),('foot',1,3),('forge',1,3),
('frame',1,3),('grip',1,3),('gut',1,3),('hammer',1,3),('hand',1,3),
('helm',1,3),('hide',1,3),('hook',1,3),('jaw',1,3),('keg',1,3),
('knuckle',1,3),('marrow',1,3),('plate',1,3),('pot',1,3),('quarry',1,3),
('shield',1,3),('shoulder',1,3),('song',1,3),('spine',1,3),('stout',1,3),
('tankard',1,3),('vein',1,3),('wrench',1,3);

-- =====================================================================
-- source: namegen/sn_gnome.sql
-- =====================================================================

-- sn_gnome.sql — gnome surnames (race 7): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Brassbolt',7,2),('Clockspring',7,2),('Cogspinner',7,2),('Dizzlespark',7,2),('Fanglebolt',7,2),
('Fizzlebang',7,2),('Gearspring',7,2),('Gearwhistle',7,2),('Hotsprocket',7,2),('Hotwrench',7,2),
('Jiggsworth',7,2),('Klackspring',7,2),('Klickclack',7,2),('Looscrew',7,2),('Mechabolt',7,2),
('Megafuse',7,2),('Nimblebolt',7,2),('Nutwrench',7,2),('Oilspark',7,2),('Overlock',7,2),
('Pistonfist',7,2),('Pistonrod',7,2),('Quickcoil',7,2),('Quickspring',7,2),('Razzlebang',7,2),
('Rustbolt',7,2),('Sparkwhistle',7,2),('Sprocketslip',7,2),('Tinkerton',7,2),('Togglebolt',7,2),
('Underbolt',7,2),('Voltspring',7,2),('Voltwrench',7,2),('Widgetwhirl',7,2),('Wobblegear',7,2),
('Zippyfuse',7,2),('Bumblegear',7,2),('Crankshaft',7,2),('Fidgitspark',7,2),('Wrenchbolt',7,2),
('Zappanoodle',7,2),('Steamwhistle',7,2),('Nutmegger',7,2),('Kerfuffle',7,2),('Whirligig',7,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Brass',0,7),('Bumble',0,7),('Clock',0,7),('Cog',0,7),('Crank',0,7),
('Dabble',0,7),('Dizzle',0,7),('Fangle',0,7),('Fiddle',0,7),('Fizz',0,7),
('Gear',0,7),('Gizmo',0,7),('Hot',0,7),('Jig',0,7),('Klack',0,7),
('Klick',0,7),('Mega',0,7),('Nimble',0,7),('Nut',0,7),('Oil',0,7),
('Over',0,7),('Piston',0,7),('Quick',0,7),('Razzle',0,7),('Rust',0,7),
('Spark',0,7),('Sprocket',0,7),('Spring',0,7),('Steam',0,7),('Tinker',0,7),
('Toggle',0,7),('Volt',0,7),('Whiz',0,7),('Widget',0,7),('Wobble',0,7),
('Zippy',0,7),
('bang',1,7),('bolt',1,7),('bung',1,7),('clack',1,7),('coil',1,7),
('crank',1,7),('doo',1,7),('fist',1,7),('fuse',1,7),('gear',1,7),
('gleam',1,7),('hopper',1,7),('klack',1,7),('knob',1,7),('lock',1,7),
('noodle',1,7),('rod',1,7),('screw',1,7),('shaft',1,7),('spark',1,7),
('spin',1,7),('spring',1,7),('spurt',1,7),('ton',1,7),('trill',1,7),
('whistle',1,7),('whirl',1,7),('wrench',1,7),('zap',1,7),('zip',1,7);

-- =====================================================================
-- source: namegen/sn_human.sql
-- =====================================================================

-- sn_human.sql — human surnames (race 1): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Ashford',1,2),('Blackwood',1,2),('Brackwell',1,2),('Brightwood',1,2),('Carver',1,2),
('Coldwell',1,2),('Cromley',1,2),('Crowe',1,2),('Dalton',1,2),('Decker',1,2),
('Dunmore',1,2),('Fairbrook',1,2),('Fairwind',1,2),('Farmer',1,2),('Fletcher',1,2),
('Goodwin',1,2),('Greystone',1,2),('Harlow',1,2),('Hartley',1,2),('Hawthorne',1,2),
('Hayward',1,2),('Highvale',1,2),('Hollis',1,2),('Kettleman',1,2),('Langston',1,2),
('Lightfoot',1,2),('Lockwood',1,2),('Longstreet',1,2),('Marshfield',1,2),('Miller',1,2),
('Mirewood',1,2),('Northwall',1,2),('Oakley',1,2),('Redfield',1,2),('Salisbury',1,2),
('Sheldon',1,2),('Stonewall',1,2),('Talbot',1,2),('Thatcher',1,2),('Wainwright',1,2),
('Westbrook',1,2),('Whitfield',1,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Ash',0,1),('Black',0,1),('Bright',0,1),('Brook',0,1),('Cold',0,1),
('Crow',0,1),('East',0,1),('Fair',0,1),('Field',0,1),('Fox',0,1),
('Gray',0,1),('Green',0,1),('Grim',0,1),('Hart',0,1),('Hawk',0,1),
('Hearth',0,1),('High',0,1),('Holly',0,1),('Kettle',0,1),('Lang',0,1),
('Light',0,1),('Lock',0,1),('Long',0,1),('Marsh',0,1),('Mill',0,1),
('North',0,1),('Oak',0,1),('Red',0,1),('Stone',0,1),('Thatch',0,1),
('Wain',0,1),('West',0,1),('Whit',0,1),('Win',0,1),
('brook',1,1),('bury',1,1),('comb',1,1),('croft',1,1),('dale',1,1),
('down',1,1),('field',1,1),('ford',1,1),('gate',1,1),('ham',1,1),
('hill',1,1),('holt',1,1),('land',1,1),('ley',1,1),('man',1,1),
('mill',1,1),('more',1,1),('stead',1,1),('stone',1,1),('stow',1,1),
('ton',1,1),('vale',1,1),('wall',1,1),('ward',1,1),('well',1,1),
('wick',1,1),('wood',1,1),('worth',1,1);

-- =====================================================================
-- source: namegen/sn_nightelf.sql
-- =====================================================================

-- sn_nightelf.sql — night elf surnames (race 4): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Duskbloom',4,2),('Duskrunner',4,2),('Feathersong',4,2),('Leafshade',4,2),('Lightweave',4,2),
('Mistwalker',4,2),('Moonshadow',4,2),('Nightbreeze',4,2),('Nightwind',4,2),('Pinebough',4,2),
('Quillfeather',4,2),('Raincaller',4,2),('Ravenwood',4,2),('Shadowglade',4,2),('Shadowleaf',4,2),
('Silvershade',4,2),('Skywhisper',4,2),('Spiritwind',4,2),('Starfall',4,2),('Stargazer',4,2),
('Starsong',4,2),('Swiftarrow',4,2),('Thornbrush',4,2),('Treeshade',4,2),('Umbersong',4,2),
('Wildgrove',4,2),('Willowshade',4,2),('Dewdancer',4,2),('Emberfall',4,2),('Fernwalker',4,2),
('Leafwhisper',4,2),('Moonweave',4,2),('Oakshade',4,2),('Rosethorn',4,2),('Silverleaf',4,2),
('Starwhisper',4,2),('Thistledown',4,2),('Willowmere',4,2),('Wispglade',4,2),('Zephyrshade',4,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Dew',0,4),('Dusk',0,4),('Ember',0,4),('Feather',0,4),('Fern',0,4),
('Leaf',0,4),('Light',0,4),('Mist',0,4),('Moon',0,4),('Night',0,4),
('Pine',0,4),('Quill',0,4),('Rain',0,4),('Raven',0,4),('Rose',0,4),
('Shadow',0,4),('Silver',0,4),('Sky',0,4),('Spirit',0,4),('Star',0,4),
('Thistle',0,4),('Thorn',0,4),('Tree',0,4),('Umber',0,4),('Wild',0,4),
('Willow',0,4),('Wisp',0,4),('Zephyr',0,4),
('bloom',1,4),('bough',1,4),('breeze',1,4),('brush',1,4),('caller',1,4),
('dancer',1,4),('fall',1,4),('feather',1,4),('flower',1,4),('gazer',1,4),
('glade',1,4),('grove',1,4),('leaf',1,4),('mere',1,4),('moon',1,4),
('runner',1,4),('shade',1,4),('shadow',1,4),('song',1,4),('spirit',1,4),
('star',1,4),('stride',1,4),('walker',1,4),('weave',1,4),('whisper',1,4),
('wind',1,4),('wing',1,4),('wood',1,4);

-- =====================================================================
-- source: namegen/sn_orc.sql
-- =====================================================================

-- sn_orc.sql — orc surnames (race 2): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Axegrinder',2,2),('Battlefang',2,2),('Blackhowl',2,2),('Bloodmaw',2,2),('Bloodrage',2,2),
('Bonecrusher',2,2),('Darkmaul',2,2),('Doomfist',2,2),('Dreadtusk',2,2),('Firemaul',2,2),
('Grimfist',2,2),('Grimskull',2,2),('Ironjaw',2,2),('Ironmaul',2,2),('Rageclaw',2,2),
('Rocksmash',2,2),('Scarshield',2,2),('Skullcleaver',2,2),('Spinesnap',2,2),('Stonefist',2,2),
('Stormfist',2,2),('Thunderfist',2,2),('Tuskbreaker',2,2),('Warbringer',2,2),('Warscar',2,2),
('Wolfbane',2,2),('Wolfslayer',2,2),('Axebite',2,2),('Bloodtusk',2,2),('Bonegrinder',2,2),
('Darkrage',2,2),('Doommaul',2,2),('Goremaul',2,2),('Grimtusk',2,2),('Hellfist',2,2),
('Irontusk',2,2),('Ragehowl',2,2),('Skullmaul',2,2),('Warrunner',2,2),('Wolfrunner',2,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Axe',0,2),('Battle',0,2),('Black',0,2),('Blood',0,2),('Bone',0,2),
('Dark',0,2),('Doom',0,2),('Dread',0,2),('Fire',0,2),('Gore',0,2),
('Grim',0,2),('Hell',0,2),('Iron',0,2),('Rage',0,2),('Rock',0,2),
('Scar',0,2),('Skull',0,2),('Spine',0,2),('Stone',0,2),('Storm',0,2),
('Thunder',0,2),('Tusk',0,2),('War',0,2),('Wolf',0,2),
('bane',1,2),('bite',1,2),('breaker',1,2),('cleaver',1,2),('crusher',1,2),
('fang',1,2),('fist',1,2),('fury',1,2),('grinder',1,2),('howl',1,2),
('jaw',1,2),('maw',1,2),('maul',1,2),('rage',1,2),('rend',1,2),
('ripper',1,2),('runner',1,2),('scar',1,2),('shield',1,2),('slayer',1,2),
('smash',1,2),('snap',1,2),('tusk',1,2);

-- =====================================================================
-- source: namegen/sn_skyborne_a.sql
-- =====================================================================

-- sn_skyborne_a.sql — High Order Skyborne surnames (race 95): whole + compound parts
-- Celestial/orderly theme: spires, dawn, stars, the firmament.
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Aetherwind',95,2),('Aurorawing',95,2),('Aurumcrest',95,2),('Brightfeather',95,2),('Brightspire',95,2),
('Celestwing',95,2),('Cloudrest',95,2),('Dawnbearer',95,2),('Dawnseeker',95,2),('Dawnspire',95,2),
('Dawnwhisper',95,2),('Empyreal',95,2),('Firmament',95,2),('Galecrest',95,2),('Heavenfield',95,2),
('Highfeather',95,2),('Highspire',95,2),('Lightspire',95,2),('Skycrown',95,2),('Skylance',95,2),
('Skysong',95,2),('Starborne',95,2),('Starspire',95,2),('Sunfeather',95,2),('Sunspire',95,2),
('Zenithwing',95,2),('Dawncrown',95,2),('Halofern',95,2),('Lumenspire',95,2),('Skywarden',95,2),
('Starscepter',95,2),('Aureliawing',95,2),('Celestborne',95,2),('Dawnlight',95,2),('Heavenspire',95,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Aether',0,95),('Aurora',0,95),('Aurum',0,95),('Bright',0,95),('Celest',0,95),
('Cloud',0,95),('Dawn',0,95),('Empyr',0,95),('Firm',0,95),('Gale',0,95),
('Halo',0,95),('Heaven',0,95),('High',0,95),('Light',0,95),('Lumen',0,95),
('Sky',0,95),('Solar',0,95),('Star',0,95),('Sun',0,95),('Zenith',0,95),
('Zephyr',0,95),
('borne',1,95),('crest',1,95),('crown',1,95),('feather',1,95),('fern',1,95),
('field',1,95),('lance',1,95),('light',1,95),('mant',1,95),('rest',1,95),
('scepter',1,95),('seeker',1,95),('song',1,95),('spire',1,95),('warden',1,95),
('whisper',1,95),('wing',1,95);

-- =====================================================================
-- source: namegen/sn_skyborne_h.sql
-- =====================================================================

-- sn_skyborne_h.sql — Windshaper Skyborne surnames (race 96): whole + compound parts
-- Wind/storm theme: gales, tempests, sky and weather.
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Aetherborn',96,2),('Breezeborn',96,2),('Cloudweaver',96,2),('Cyclonewind',96,2),('Galehart',96,2),
('Galewing',96,2),('Hurricrest',96,2),('Mistralwind',96,2),('Skybreaker',96,2),('Skyreaver',96,2),
('Squallrunner',96,2),('Stormbinder',96,2),('Stormfeather',96,2),('Stormwing',96,2),('Tempestborn',96,2),
('Thundercrest',96,2),('Twisterwind',96,2),('Windcaller',96,2),('Windrider',96,2),('Windshard',96,2),
('Zephyrhart',96,2),('Zephyrlight',96,2),('Aetherstorm',96,2),('Galesinger',96,2),('Nimbuswing',96,2),
('Skyseeker',96,2),('Stormrider',96,2),('Tempestwing',96,2),('Vortexwind',96,2),('Windweaver',96,2),
('Zephyrborn',96,2),('Breezewing',96,2),('Cyclonecrest',96,2),('Galeshard',96,2),('Stormsinger',96,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Aether',0,96),('Breeze',0,96),('Cloud',0,96),('Cyclone',0,96),('Gale',0,96),
('Gust',0,96),('Hurri',0,96),('Mistral',0,96),('Nimbus',0,96),('Sky',0,96),
('Squall',0,96),('Storm',0,96),('Tempest',0,96),('Thunder',0,96),('Twister',0,96),
('Vortex',0,96),('Wind',0,96),('Zephyr',0,96),
('binder',1,96),('born',1,96),('breaker',1,96),('breeze',1,96),('caller',1,96),
('crest',1,96),('feather',1,96),('hart',1,96),('light',1,96),('reaver',1,96),
('rider',1,96),('runner',1,96),('seeker',1,96),('shard',1,96),('shaper',1,96),
('singer',1,96),('storm',1,96),('weaver',1,96),('wind',1,96),('wing',1,96);

-- =====================================================================
-- source: namegen/sn_tauren.sql
-- =====================================================================

-- sn_tauren.sql — tauren surnames (race 6): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Amberhide',6,2),('Bisonmane',6,2),('Bloodtusk',6,2),('Cloudmane',6,2),('Darkhorn',6,2),
('Dawnhorn',6,2),('Dustmane',6,2),('Eaglefeather',6,2),('Earthbinder',6,2),('Farstalker',6,2),
('Flintmane',6,2),('Goldenmane',6,2),('Greathoof',6,2),('Greyhoof',6,2),('Hawksight',6,2),
('Ironhide',6,2),('Kindspirit',6,2),('Longhorn',6,2),('Misthoof',6,2),('Mountainfoot',6,2),
('Plainstrider',6,2),('Proudhorn',6,2),('Redmane',6,2),('Riverstone',6,2),('Rockhorn',6,2),
('Runningwater',6,2),('Skychaser',6,2),('Stonehoof',6,2),('Stormhide',6,2),('Strongtotem',6,2),
('Sundancer',6,2),('Swiftmane',6,2),('Swiftstride',6,2),('Tallhorn',6,2),('Thunderhorn',6,2),
('Truenorth',6,2),('Whitetail',6,2),('Winterhoof',6,2),('Crestmane',6,2),('Hornrider',6,2),
('Palehide',6,2),('Spiritwalker',6,2),('Windsinger',6,2),('Youngbull',6,2),('Meadowrun',6,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Amber',0,6),('Bison',0,6),('Blood',0,6),('Cloud',0,6),('Dark',0,6),
('Dawn',0,6),('Dust',0,6),('Eagle',0,6),('Earth',0,6),('Flint',0,6),
('Golden',0,6),('Grass',0,6),('Great',0,6),('Grey',0,6),('Hawk',0,6),
('Hill',0,6),('Iron',0,6),('Kind',0,6),('Long',0,6),('Meadow',0,6),
('Mist',0,6),('Mountain',0,6),('Pale',0,6),('Plain',0,6),('Proud',0,6),
('Rain',0,6),('Red',0,6),('River',0,6),('Rock',0,6),('Running',0,6),
('Sky',0,6),('Spirit',0,6),('Stone',0,6),('Storm',0,6),('Strong',0,6),
('Sun',0,6),('Swift',0,6),('Tall',0,6),('Thunder',0,6),('True',0,6),
('White',0,6),('Wild',0,6),('Wind',0,6),('Winter',0,6),('Young',0,6),
('binder',1,6),('bull',1,6),('chaser',1,6),('crest',1,6),('dancer',1,6),
('feather',1,6),('foot',1,6),('hide',1,6),('hoof',1,6),('horn',1,6),
('mane',1,6),('north',1,6),('rider',1,6),('runner',1,6),('sight',1,6),
('singer',1,6),('spirit',1,6),('stalker',1,6),('stone',1,6),('stride',1,6),
('strider',1,6),('tail',1,6),('totem',1,6),('tusk',1,6),('walker',1,6),
('water',1,6),('winds',1,6);

-- =====================================================================
-- source: namegen/sn_troll.sql
-- =====================================================================

-- sn_troll.sql — troll surnames (race 8): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Bloodhex',8,2),('Darkfetish',8,2),('Doomfetish',8,2),('Gravesnake',8,2),('Hexbinder',8,2),
('Hexweaver',8,2),('Jujudoctor',8,2),('Mambozen',8,2),('Mojo''kan',8,2),('Rattlesnake',8,2),
('Shadowjuje',8,2),('Spirithex',8,2),('Voodoomask',8,2),('Zan''mojo',8,2),('Zul''tembe',8,2),
('Bloodmojo',8,2),('Doomsnake',8,2),('Fetishweaver',8,2),('Hexmojo',8,2),('Junglefang',8,2),
('Mojohex',8,2),('Shadowfang',8,2),('Snakebinder',8,2),('Spiritmojo',8,2),('Voodoohex',8,2),
('Zul''fetish',8,2),('Darkmojo',8,2),('Gravemojo',8,2),('Hexsnake',8,2),('Jujufang',8,2),
('Mojoweaver',8,2),('Shadowmojo',8,2),('Snakehex',8,2),('Spiritfang',8,2),('Voodoosnake',8,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Blood',0,8),('Dark',0,8),('Doom',0,8),('Fetish',0,8),('Grave',0,8),
('Hex',0,8),('Jinx',0,8),('Juju',0,8),('Jungle',0,8),('Mamba',0,8),
('Mojo',0,8),('Rattle',0,8),('Shadow',0,8),('Snake',0,8),('Spirit',0,8),
('Voodoo',0,8),('Zan',0,8),('Zul',0,8),
('binder',1,8),('bok',1,8),('doctor',1,8),('fang',1,8),('fetish',1,8),
('hex',1,8),('jin',1,8),('kan',1,8),('mask',1,8),('mojo',1,8),
('snake',1,8),('tek',1,8),('tembe',1,8),('weave',1,8),('weaver',1,8),
('zen',1,8),('zin',1,8),('zul',1,8);

-- =====================================================================
-- source: namegen/sn_undead.sql
-- =====================================================================

-- sn_undead.sql — undead surnames (race 5): whole surnames + compound parts
INSERT IGNORE INTO {SHARED}.`playerbots_surnames` (`surname`,`race`,`gender`) VALUES
('Ashdown',5,2),('Ashenfell',5,2),('Blackvein',5,2),('Bleakmore',5,2),('Coffinshaw',5,2),
('Coldgrave',5,2),('Crowsbane',5,2),('Dampmere',5,2),('Darkhallow',5,2),('Direwind',5,2),
('Dreadmore',5,2),('Dustshroud',5,2),('Evenfall',5,2),('Fellbrook',5,2),('Frostvein',5,2),
('Ghastwell',5,2),('Gloomrest',5,2),('Gravemore',5,2),('Gravewind',5,2),('Hollowfell',5,2),
('Morrowsong',5,2),('Mournvale',5,2),('Nightshade',5,2),('Palewind',5,2),('Ratcatcher',5,2),
('Rotwell',5,2),('Shadebourne',5,2),('Shadowend',5,2),('Sorrowfield',5,2),('Stillsong',5,2),
('Stillwater',5,2),('Thorngrave',5,2),('Tombwalker',5,2),('Undercroft',5,2),('Vexhart',5,2),
('Withermere',5,2),('Wormwood',5,2),('Ashenbourne',5,2),('Bleakhollow',5,2),('Coldmere',5,2);

INSERT IGNORE INTO {SHARED}.`playerbots_surname_parts` (`part`,`half`,`race`) VALUES
('Ash',0,5),('Bleak',0,5),('Carrion',0,5),('Cold',0,5),('Crow',0,5),
('Dark',0,5),('Dire',0,5),('Dusk',0,5),('Dust',0,5),('Even',0,5),
('Fell',0,5),('Frost',0,5),('Ghast',0,5),('Gloom',0,5),('Grave',0,5),
('Grey',0,5),('Hollow',0,5),('Mourn',0,5),('Night',0,5),('Pale',0,5),
('Rat',0,5),('Rot',0,5),('Shade',0,5),('Sorrow',0,5),('Still',0,5),
('Thorn',0,5),('Tomb',0,5),('Under',0,5),('Wither',0,5),('Worm',0,5),
('bane',1,5),('bourne',1,5),('breeze',1,5),('crest',1,5),('croft',1,5),
('down',1,5),('fall',1,5),('fell',1,5),('field',1,5),('grave',1,5),
('hallow',1,5),('hollow',1,5),('mere',1,5),('more',1,5),('rest',1,5),
('shade',1,5),('shaw',1,5),('shroud',1,5),('song',1,5),('vale',1,5),
('vein',1,5),('walker',1,5),('well',1,5),('wind',1,5),('wood',1,5),
('wright',1,5);

INSERT INTO {SHARED}.playerbot_v2_schema_version (version, sha256) VALUES
    (64, REPEAT('0', 64))
ON DUPLICATE KEY UPDATE applied_at = CURRENT_TIMESTAMP;
