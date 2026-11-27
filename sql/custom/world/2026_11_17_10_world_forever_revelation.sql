-- WoW Forever Revelation (weapon enchant 8217): proc aura 1248806 and the class buffs, checked against the live client data (build
-- 70707) and wowsims/forever (MIT, https://github.com/wowsims/forever) evidence EV-0028 and EV-0129. Script classic_spell_enchant_revelation
-- in src/server/scripts/Custom/Classic/world/classic_spell_scripts.cpp.
--  * 1248806: direct damage or heal hits that do not crit (helpful and harmful spells). Flamestrike's ground ticks count. The chance
--    falls with the wearer's spell crit (12.1% x (1 - crit)^4, fitted to EV-0129) and is rolled in the script, so the row says 100.
--  * Class buffs (+100% crit chance to the next spell their class flags name, one charge, 15 sec): only a spell the crit mod changed
--    spends the charge. The mage's goes as the cast completes (EV-0028: 81 of 84 in the millisecond of the cast's success, no ground
--    tick spends it); the other classes' with the spell's hit.
--  * Mage buff 1248808: Pyroblast (class flag 0x400000), Fireball (0x1) and Frostfire Bolt (0x1000 in the second word) join its crit mod. The client mask (0x20a21af2, 0x8000, 0, 0x8)
--    leaves both out, but in game both buffed Pyroblasts spent the charge and crit (EV-0028), and the enchant tooltip (1248805) says
--    "the next non-periodic spell cast". No log shows a Fireball under the buff; it follows the tooltip and the Pyroblast logs, which
--    show the client mask is not what the game uses. The only other mage spell with 0x1 is the item-set aura 21230 (not cast); only
--    Frostfire Bolt has the second word's 0x1000. Frostfire Bolt is the last Forever mage damage spell outside the client mask; the
--    others (Living Bomb, Living Flame, Deep Freeze, Frozen Orb, Arcane Surge, Spellfrost and Balefire Bolt) are Season of Discovery
--    runes Forever leaves out. The damage over time of Fireball, Pyroblast and Frostfire Bolt does not take the crit (Player.cpp).
-- Safe to run again.

DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_enchant_revelation';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1248806, 'classic_spell_enchant_revelation');

DELETE FROM `spell_proc` WHERE `SpellId` IN (1248806, 1248808, 1323377, 1323392, 1323400, 1323410, 1323418, 1323419);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`, `ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1248806, 0, 0, 0, 0, 0, 0, 0x14000, 0, 3, 2, 0x1, 0, 0, 0, 100, 0, 0), -- Revelation (enchant): non-crit direct damage and heal hits (chance in the script)
(1248808, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 1, 0, 8, 0, 0, 100, 0, 1), -- Revelation (mage): spent as the cast completes
(1323377, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 2, 0, 8, 0, 0, 100, 0, 1), -- Revelation (priest)
(1323392, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 2, 0, 8, 0, 0, 100, 0, 1), -- Revelation (warlock)
(1323400, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 2, 0, 8, 0, 0, 100, 0, 1), -- Revelation (druid)
(1323410, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 2, 0, 8, 0, 0, 100, 0, 1), -- Revelation (hunter)
(1323418, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 2, 0, 8, 0, 0, 100, 0, 1), -- Revelation (shaman)
(1323419, 0, 0, 0, 0, 0, 0, 0x14000, 0, 7, 2, 0, 8, 0, 0, 100, 0, 1); -- Revelation (paladin)

-- classic_spell_effect (created by 2026_10_13_11_world_classic_curse_of_the_elements.sql): aura 107 (flat modifier), misc 7 (crit chance)
-- as in the client, class mask with Pyroblast's 0x400000, Fireball's 0x1 (0x20e21af3) and Frostfire Bolt's 0x1000 (0x9000) added
REPLACE INTO `classic_spell_effect` (`spell_id`,`effect_index`,`apply_aura`,`misc_value`,`class_mask0`,`class_mask1`,`class_mask2`,`class_mask3`,`spell_name`) VALUES
(1248808,0,107,7,551688947,36864,0,8,'Revelation');
