-- WoW Forever paladin: Holy Shield and Redoubt rows checked against live (community paladin audit, 2026-11-16).
--
-- Holy Shield: "Damage caused by Holy Shield causes 20% additional threat" is on every rank's tooltip, but only rank 1 (20925) had
-- its spell_threat row (from VMaNGOS). Ranks 2 and 3 (20927, 20928) and the level 60 rank 4 (1239570, build 70755) dealt plain
-- threat. Rank 4 also had no block-only proc row (2026_11_06_10 covers ranks 1-3), so every hit taken used a charge and dealt the
-- shield's damage, blocked or not.
--
-- Redoubt (20127): every melee swing and melee ability aimed at the paladin rolls the 10% chance, whatever it resolves to
-- (dodged, parried, missed, fully blocked or absorbed included); ranged attacks roll nothing. Log counts from about forty paladins
-- on 1.60.1: 152 of 1394 avoided swings, 364 of 3501 damaging swings, 17 of 138 melee abilities, 0 of 62 ranged attacks (wowsims
-- Forever, docs/evidence/EV-0022). The client proc flags already give melee swings and abilities taken; without a hit mask the
-- core only rolled on landed hits.
-- Redoubt's buff (20128): "Lasts maximum of 5 blocks". Without a hit mask every landed hit used a charge; now only blocks do.
--
-- ProcFlags, Chance, Cooldown and Charges 0 keep the client's. Safe to run again.

DELETE FROM `spell_threat` WHERE `entry` IN (20927, 20928, 1239570);
INSERT INTO `spell_threat` (`entry`, `flatMod`, `pctMod`, `apPctMod`) VALUES
(20927, 0, 1.2, 0),
(20928, 0, 1.2, 0),
(1239570, 0, 1.2, 0);

-- HitMask: 0x40 BLOCK; 0x2477 NORMAL | CRITICAL | MISS | DODGE | PARRY | BLOCK | ABSORB | FULL_BLOCK
DELETE FROM `spell_proc` WHERE `SpellId` IN (1239570, 20127, 20128);
INSERT INTO `spell_proc` (`SpellId`, `SchoolMask`, `SpellFamilyName`, `SpellFamilyMask0`, `SpellFamilyMask1`, `SpellFamilyMask2`, `SpellFamilyMask3`,
`ProcFlags`, `ProcFlags2`, `SpellTypeMask`, `SpellPhaseMask`, `HitMask`, `AttributesMask`, `DisableEffectsMask`, `ProcsPerMinute`, `Chance`, `Cooldown`, `Charges`) VALUES
(1239570, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x40, 0, 0, 0, 0, 0, 0),
(20127, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x2477, 0, 0, 0, 0, 0, 0),
(20128, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0x40, 0, 0, 0, 0, 0, 0);
