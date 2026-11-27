-- WoW Forever warrior Reckless Swings (1329555: "Your next $n melee attacks generate additional Rage", proc 1329554).
-- Hotfix 1.60.1.70938 (16 November 2026): "Warrior: Fury: Fixed an issue where Reckless Swings was not activated by Cleave or Heroic Strike."
-- The client aura options give ProcTypeMask 0x4 (white swings only). ProcFlags 0x14 = DEAL_MELEE_SWING | DEAL_MELEE_ABILITY; family 4
-- (warrior) mask 0x40 Heroic Strike | 0x400000 Cleave, only checked on abilities (the same mask as Flurry's row, 2026_11_16_40);
-- SpellPhaseMask 0x2 (hit), default hit mask, charges and chance from the client data.
-- Hotfix 1.60.1.70790 (6 November 2026): "Warrior: Fixed the tooltip for Reckless Swings to mention that it activates Gore Drinker." Casting
-- it gives the Gore Drinker buff like Bloodrage and Berserker Rage do (2026_10_14_01). Safe to run again.
DELETE FROM `spell_proc` WHERE `SpellId` = 1329555;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1329555, 0, 4, 0x400040, 0, 0, 0, 0x14, 0, 0, 0x2, 0, 0, 0, 0, 0, 0, 0);
DELETE FROM `spell_script_names` WHERE `spell_id` = 1329555 AND `ScriptName` = 'classic_spell_warr_gore_drinker';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1329555, 'classic_spell_warr_gore_drinker');
