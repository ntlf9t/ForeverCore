-- Classic 1.60 (WoW Forever) talents whose dummy effect nothing ran. C++: Custom/Classic/world/talents (classic_talents_warrior_rogue_hunter.cpp,
-- classic_talents_mage_shaman.cpp, classic_talents_warlock_druid.cpp) and classic_hunter_pet_scaling.cpp. Safe to run again.
-- Elemental Reach (Totemic Projection's cooldown) and Improved Aspect of the Monkey (the pet's dodge) are done in scripts already bound to
-- Totemic Call 437009 and the hunter pet passive 415429: no row here.

-- Hemorrhage 16511: $m5% weapon damage with a main hand dagger (effect 4, a dummy, was never read: always $m4%).
-- Premeditation 14183: the combo points are lost after $d unless added to or used (aura 560 had no handler).
-- Spirit Weapons 16268: the parry the tooltip gives (shamans never learn Parry).
-- Apocalypse 18096: Fire spell crits give Shadow damage done, Shadow spell crits give Fire damage done.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('classic_spell_rog_hemorrhage', 'classic_spell_rog_premeditation',
    'classic_spell_sha_spirit_weapons', 'classic_talent_warl_apocalypse');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(16511, 'classic_spell_rog_hemorrhage'),
(14183, 'classic_spell_rog_premeditation'),
(16268, 'classic_spell_sha_spirit_weapons'),
(18096, 'classic_talent_warl_apocalypse');

-- Premeditation: the aura reacts to the rogue's next abilities (done melee 0x10, ranged 0x100, no-class harmful 0x1000, on hit); its script
-- removes it once the combo points or their target changed. Apocalypse: ProcFlags 0 takes the client's (done harmful spell), damage spells
-- on hit, crits only; chance 0 takes the client's 100.
DELETE FROM `spell_proc` WHERE `SpellId` IN (14183, 18096);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(14183, 0, 0, 0, 0, 0, 0, 0x1110, 0, 0, 0x2, 0, 0, 0, 0, 100, 0, 0),
(18096, 0, 5, 0, 0, 0, 0, 0, 0, 0x1, 0x2, 0x2, 0, 0, 0, 0, 0, 0);

-- Apocalypse's Fire half: the client has no buff for it. 9971001 is a server-side spell: Fire damage done (school mask 4), the amount and the
-- 3 sec are set by the script (DurationIndex 27 is 3 sec as well).
DELETE FROM `serverside_spell` WHERE `Id` = 9971001;
INSERT INTO `serverside_spell` (`Id`, `DifficultyID`, `Attributes`, `CastingTimeIndex`, `ProcChance`, `DurationIndex`, `RangeIndex`, `EquippedItemClass`, `SpellName`, `SpellFamilyName`, `SchoolMask`) VALUES
(9971001, 0, 0, 1, 0, 27, 1, -1, 'Apocalypse', 5, 4);
DELETE FROM `serverside_spell_effect` WHERE `SpellID` = 9971001;
INSERT INTO `serverside_spell_effect` (`SpellID`, `EffectIndex`, `DifficultyID`, `Effect`, `EffectAura`, `EffectBasePoints`, `EffectMiscValue1`, `ImplicitTarget1`) VALUES
(9971001, 0, 0, 6, 79, 10, 4, 1);
