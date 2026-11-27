-- WoW Forever: Shadow Weaving 15257 stacks on every landed Shadow damage spell of the priest, its application included: Shadow Word:
-- Pain, Devouring Plague and Mind Flay land with no damage on the cast and stacked nothing (the client's proc flag is 0x10000, a harmful
-- spell landing, not a periodic tick). Spell type 1 | 4 (damage or none) on the hit phase; ClassicProcRules.h names the spells
-- (wowsims/forever, MIT, sim/priest/talents_shadow.go). Replaces the row 2026_10_21_41 set. Safe to run again.
DELETE FROM `spell_proc` WHERE `SpellId` = 15257;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(15257, 32, 0, 0, 0, 0, 0, 0, 0, 5, 2, 0, 0, 0, 0, 0, 0, 0);
