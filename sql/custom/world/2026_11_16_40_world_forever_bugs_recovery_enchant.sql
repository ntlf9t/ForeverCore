-- Recovery weapon enchant (aura 1248761, heals 1248759): "heals you for 5% of your maximum health when your attack is dodged or
-- parried, no more than once every 10 sec" (forever-bugs #172, fixed on live, also in cat and bear form). The client proc data has
-- melee swings and melee abilities (0x14) and the 10 s proc cooldown but no hit mask, so the server used the default one (normal and
-- critical hits): it healed on hits and never on a dodge or parry. Safe to run again.
DELETE FROM `spell_proc` WHERE `SpellId` = 1248761;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1248761, 0, 0, 0, 0, 0, 0, 0x14, 0, 0, 2, 0x30, 0, 0, 0, 100, 10000, 0);
