# TrinityCore e3916b2adc: hasted power regen; spell haste separate from casting speed

Shauren, 2026-10-05. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** (1) Powers whose PowerType row has `RegenAffectedByHaste` (0x400) regenerate faster with haste
(`UnitData::ModHasteRegen`). (2) Casting speed (`ModCastingSpeed` / `ModCastingSpeedNeg`), spell haste
(`ModSpellHaste`) and regen haste are kept apart instead of one aura changing all three. (3) Haste and slow auras get
their retail names and handlers: 65 `MOD_CASTING_SPEED` (was `_NOT_STACK`), 193 `MOD_MELEE_RANGED_CASTING_HASTE`
(was `MELEE_SLOW`), 216 / 217 / 252 / 355 / 581 the "slow, no stack" auras, 319 / 342 / 615 haste that does not
speed up regen.

**Check.**
- 70862's PowerType table has 6 rows (mana, rage, focus, energy, combo points, happiness). `RegenAffectedByHaste` is
  set on Energy and Focus only.
- What feeds regen haste on Everlake: melee haste in 70862 is aura 319 (367 spells: Slice and Dice, Blade Flurry,
  Thunder Clap, Bloodlust, Mind Control ...), which this commit makes "no regen". So Slice and Dice and Blade Flurry
  do **not** speed up Energy. Aura 138 has no spell in 70862; 140 (ranged haste, 31 spells: Rapid Fire, Quick Shots)
  and 193 (20, mostly boss and test spells) do. Combat ratings for haste: Classic items don't use them.
- (2) The client data for 65 (Curse of Tongues -50, Mind-numbing Poison -40, 122 spells) keeps the same stacking rule
  (spell group exclusivity, `GetHighestExclusiveSameEffectSpellGroupValue`), only it no longer changes regen haste;
  cooldowns scaled by `ModHasteRegen` (`SpellHistory`) are therefore no longer slowed by Curse of Tongues.
- Forever's special `ModCastingSpeedNeg` handling in `UpdateFields.cpp` (the 1.60 client divides by it; 0 is sent as
  1) stays; the commit initialises it to 1 for players and creatures, which agrees.
- The player loops over `GetPowerTypes()` read `GetPowerTypeEntry(power)->` without a null check, like
  `Player.cpp` already does at log-in and level-up: only the class's own powers, all of which exist in 70862.
- **Forever's own code, fixed on top** (would not build): `classic_boss_bug_trio.cpp` used the old name of aura 65
  (renamed, same id); Forever's aura 557 (quiver and ammo pouch haste) used the old ranged haste handler, which now
  also changes regen haste. 557 maps to the new "no regen" handler, which does exactly what the old one did.

**Test.** None in `tests/`: haste fields need a unit. PTR checks: a rogue's Energy ticks at the same rate with and
without Slice and Dice; a priest under Curse of Tongues casts 50% slower; a hunter's Rapid Fire and a quiver still
speed up Auto Shot. And watch Energy and Focus regen for anything faster than before.

**Verdict:** take, with our fixes for Forever's code.
