-- WoW Forever: warrior Flurry (12966, 3 charges) - which attacks spend a charge.
-- Forever logs: every white swing spends one, whatever its outcome (misses, dodges and parries too); Heroic Strike and Cleave spend one per
-- cast, landed or not and on one target or two; other yellow attacks (Bloodthirst, Whirlwind, Revenge, Overpower, Slam) spend none.
-- Sources: magey/forever-warrior#12 (charge counts from swing timing), wowsims/forever EV-0138 (build 1.60.1.70938, Heroic Strike / Cleave
-- one charge per cast). Without this row the client's proc flags (0x14: melee swings and every melee ability) applied with the default hit
-- mask (normal / critical / absorb): a miss, dodge or parry spent nothing, and Bloodthirst or Whirlwind spent a charge.
-- ProcFlags 0x14 = DEAL_MELEE_SWING | DEAL_MELEE_ABILITY; family 4 (warrior) mask 0x40 Heroic Strike | 0x400000 Cleave, only checked on abilities;
-- SpellPhaseMask 0x1 (cast): one charge per Heroic Strike / Cleave cast, before its hits; HitMask 0x7FFF: every swing outcome.
DELETE FROM `spell_proc` WHERE `SpellId` = 12966;
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(12966, 0, 4, 0x400040, 0, 0, 0, 0x14, 0, 0, 0x1, 0x7FFF, 0, 0, 0, 100, 0, 0);
