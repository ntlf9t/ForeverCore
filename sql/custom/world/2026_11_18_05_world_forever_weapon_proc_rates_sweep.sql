-- WoW Forever: weapon chance-on-hit rates from wowsims/forever (MIT, tools/database/overrides/weapon_procs.go) that the earlier files did not
-- take. These weapons' proc spells state no rate (no proc row, or a chance column reading the 100 / 101 sentinel), so the core fell back to
-- the weapon-speed rate, which rolls only on white swings (about 1 a minute) and never on specials. Their rates are procs per minute on the
-- hitting weapon's base speed (Player::CastItemCombatSpell). The vanilla carry-overs wowsims keeps are not taken: those keep the VMaNGOS
-- rates of 2026_10_11_25. Safe to run again.
-- Measured in the EV-0136 Warcraft Logs sweep (27 weapons).
INSERT INTO `item_template_addon` (`Id`,`SpellPPMChance`) VALUES
(754,1), -- Shortsword of Vengeance
(869,2.8), -- Dazzling Longsword
(1982,2), -- Nightblade
(2099,4.3), -- Dwarven Hand Cannon
(2164,1.55), -- Gut Ripper
(2825,5.4), -- Bow of Searing Arrows
(3078,2.2), -- Naga Heartpiercer
(6469,2.05), -- Venomstrike
(6831,2), -- Black Menace
(6953,2.2), -- Verigans Fist
(8225,2.15), -- Tainted Pierce
(9372,1.5), -- Sulthraze the Lasher
(9412,4.25), -- Galganns Fireblaster
(9425,1.05), -- Pendulum of Doom
(9446,4.25), -- Electrocutioner Leg
(9467,2.1), -- Gahzrilla Fang
(9477,1), -- The Chiefs Enforcer
(10567,2.9), -- Quillshooter
(10761,2.85), -- Coldrage Dagger
(11817,2.1), -- Lord Generals Sword
(13952,1.9), -- Iceblade Hacker
(17752,2.1), -- Satyrs Lash
(267369,2.25), -- Wolfsbane
(272999,3.45), -- Barbaric Crossbow
(274293,1), -- Spellsever Crossbow
(279895,3.3), -- Ironforge Greathammer
(286430,1.95) -- Toofbreaker
ON DUPLICATE KEY UPDATE `SpellPPMChance` = VALUES(`SpellPPMChance`);

-- Log fits wowsims marks "not yet validated (EV-0136)": lower confidence, still better than the fallback (74 weapons).
INSERT INTO `item_template_addon` (`Id`,`SpellPPMChance`) VALUES
(809,1.05), -- Bloodrazor
(810,4.55), -- Hammer of the Northern Wind
(870,0.95), -- Fiery War Axe
(934,1.4), -- Stalvans Reaper
(937,0.9), -- Black Duskwood Staff
(1263,1), -- Brain Hacker
(1265,0.95), -- Scorpion Sting
(1318,1.9), -- Night Reaver
(1481,2.15), -- Grimclaw
(1726,0.85), -- Poison-tipped Bone Spear
(1727,1.1), -- Sword of Decay
(2163,1.05), -- Shadowblade
(2256,1.05), -- Skeletal Club
(2291,1), -- Kang the Decapitator
(2299,1.05), -- Burning War Axe
(2912,1), -- Claw of the Shadowmancer
(2915,0.9), -- Taran Icebreaker
(2942,2.4), -- Iron Knuckles
(3194,2.05), -- Black Malice
(5197,1.9), -- Cookies Tenderizer
(5756,2.25), -- Sliverblade
(6660,0.85), -- Julies Dagger
(6681,3.75), -- Thornspike
(6909,2.25), -- Strike of the Hydra
(7710,2.55), -- Lokseys Training Stick
(7730,2.25), -- Cobalt Crusher
(7753,0.95), -- Bloodspiller
(7961,2.25), -- Phantom Blade
(8006,3.6), -- The Ziggler
(8190,1.2), -- Hanzo Sword
(8708,2), -- Hammer of Expertise
(9379,2.35), -- Sangthraze the Deflector
(9485,1), -- Vibroblade
(9486,1.95), -- Supercharger Battle Axe
(9651,1.95), -- Gryphon Riders Stormhammer
(10758,2.1), -- Xcaliboar
(10772,2.4), -- Gluttons Cleaver
(10797,2.1), -- Firebreather
(10803,1.95), -- Blade of the Wretched
(10804,3.5), -- Fist of the Damned
(10805,1.65), -- Eater of the Dead
(11121,3.3), -- Darkwater Talwar
(11809,5.3), -- Flame Wrath
(11902,1.95), -- Linkens Sword of Mastery
(12590,0.5), -- Felstriker
(12592,1.15), -- Blackblade of Shahram
(12992,2.4), -- Searing Blade
(13016,0.95), -- Killmaim
(13032,1), -- Sword of Corruption
(13035,1.1), -- Serpent Slicer
(13051,1), -- Witchfury
(13054,1.1), -- Grim Reaper
(13204,3.2), -- Bashguuder
(13218,0.9), -- Fang of the Crystal Spider
(13246,1), -- Argent Avenger
(13285,2.05), -- The Blackrock Slicer
(13286,1.6), -- Rivenspike
(13401,2.1), -- The Cruel Hand of Timmy
(13984,2.2), -- Darrowspike
(14024,2.35), -- Frightalon
(14145,2.55), -- Cursed Felblade
(14487,1.8), -- Bonechill Hammer
(15814,1.1), -- Hameyas Slayer
(17738,2.45), -- Claw of Celebras
(18324,1.9), -- Waveslicer
(273819,2.8), -- Boneslicer
(273841,1.75), -- Twilight Maul
(274265,2.35), -- Brush Cutter
(274271,2), -- Deadhead Blade
(274484,2.15), -- Axe of Inevitable Ruin
(274952,1.75), -- Jom-joms Gabbar
(281665,3.15), -- Twilight Forgehammer
(285332,2.45), -- Puncturing Spear
(286650,2.05) -- Pyromancers Baton
ON DUPLICATE KEY UPDATE `SpellPPMChance` = VALUES(`SpellPPMChance`);
