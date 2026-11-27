# TrinityCore 7b7de79d54: Auto Shot found by its class flags instead of spell id 75

Shauren, 2026-09-30. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** The special cases for Auto Shot (it doesn't break other casts and isn't broken by them, it isn't cancelled
when it can't fire) checked `Id == 75`. `SpellInfo::IsAutoShot` checks hunter family, class flag 0x1 and auto repeat.

**Check.** In 70862 eight spells repeat automatically. Two match: Auto Shot 75 and Auto Shot 413446 (family 9, mask
0x1); the wand's Shoot (5019) has no class family and doesn't. So the only change for Everlake is that 413446, if
anything uses it, gets the same rules as 75. Not checked which of the two Forever hunters learn.

**Test.** `tests/game/AutoShotSpell.cpp` ([AutoShotSpell]): hunter auto repeat with flag 0x1 is Auto Shot; wand
Shoot, another hunter auto repeat flag, and a non-repeating hunter spell with flag 0x1 are not. New function, so the
test doesn't exist without the commit.

**Verdict:** take.
