-- Feralheart Raiment 4-piece (450608, also Wildheart Raiment 6-piece and set 185's 5-piece): a dummy aura with proc flags and no trigger,
-- so the bonus did nothing (forever-bugs #523). classic_spell_item_feralheart_4p casts Nature's Bounty: mana on a spell cast (27782),
-- energy over 5 sec on a melee swing (27784), rage when struck by a melee attack (27783). spell_proc: the data's proc flags (0x1402c:
-- melee swing dealt, melee swing or ability taken, harmful or helpful spell dealt) at the effect's 5% chance. Safe to run again.
DELETE FROM `spell_script_names` WHERE `spell_id` = 450608 AND `ScriptName` = 'classic_spell_item_feralheart_4p';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(450608, 'classic_spell_item_feralheart_4p');

DELETE FROM `spell_proc` WHERE `SpellId` = 450608;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(450608, 0, 0, 0, 0, 0, 0, 0x1402c, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0);
