-- WoW Forever: the vanilla weapon proc rates wowsims/forever (MIT, tools/database/overrides/weapon_procs.go) carries over from 1.12 for
-- weapons Forever logs do not cover yet, in place of the core's own vanilla rates (VMaNGOS, 2026_10_11_25) or the weapon-speed fallback
-- where the core had none. Unmeasured on Forever; wowsims' choice of vanilla source where the two differ (Thunderfury 6 against 9.5,
-- Nightfall 2 against 1.375, Earthshaker 2.1 against 2.15, Darkmoon Card: Heroism 2 against 3). Safe to run again.
INSERT INTO `item_template_addon` (`Id`,`SpellPPMChance`) VALUES
(880,1.4), -- Staff of Horrors
(899,2), -- Venom Web Fang
(2000,1), -- Archeus
(2243,1), -- Hand of Edward the Odd
(3336,1), -- Flesh Piercer
(4090,2), -- Mug O Hurt
(5182,0.5), -- Shiver Blade
(6622,1.8), -- Sword of Zeal
(12777,1), -- Blazing Rapier
(12790,1), -- Arcanite Champion
(12792,1), -- Volcanic Hammer
(12794,0.5), -- Masterwork Stormhammer
(12795,1), -- Blood Talon
(12797,1), -- Frostguard
(13053,0.75), -- Doombringer
(13060,3), -- The Needler
(17073,2.1), -- Earthshaker
(17182,0.7), -- Sulfuras, Hand of Ragnaros
(17193,1), -- Sulfuron Hammer
(17223,1.5), -- Thunderstrike
(17704,1.2), -- Edge of Winter
(17733,1), -- Fist of Stone
(19019,6), -- Thunderfury, Blessed Blade of the Windseeker
(19099,1.4), -- Glacial Blade
(19100,1.4), -- Electrified Dagger
(19169,2), -- Nightfall
(19170,0.4), -- Ebon Hand
(19323,0.5), -- The Unstoppable Force
(19324,0.4), -- The Lobotomizer
(21134,0.4) -- Dark Edge of Insanity
ON DUPLICATE KEY UPDATE `SpellPPMChance` = VALUES(`SpellPPMChance`);
-- Darkmoon Card: Heroism 19287 (equip aura 23689): 2 a minute (2026_10_11_09 set 3)
UPDATE `spell_proc` SET `ProcsPerMinute` = 2 WHERE `SpellId` = 23689;
