# TrinityCore 28b1670baf: Auto Shot waits for a channel it would interrupt; channel interrupts stop only the channel

Shauren, 2026-09-26. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** (1) While a hunter channels a spell that keeps the combat timers running (`SPELL_ATTR2_DO_NOT_RESET_COMBAT_TIMERS`)
but is interrupted by an action (channel interrupt flags `Action` or `ActionDelayed`), Auto Shot fired anyway and its
shot interrupted the channel (retail: Rapid Fire). Now such a channel counts as casting for Auto Shot, so Auto Shot
waits. (2) An aura interrupt that ends a channel called `InterruptNonMeleeSpells`, which also stopped a cast in
progress and the auto repeat spell; now only the channel is interrupted.

**Check.**
- (1) is live on Everlake: 11 channels in 70862 have `DO_NOT_RESET_COMBAT_TIMERS`, and 10 of them have channel
  interrupt flags 0x7c0c, which include `Action` (0x4): Volley (1510, 14294, 14295), Blizzard (10, 6141, 8427, 10185,
  10186, 10187) and Chill (1308651). Only Auto Shot is affected (`isAutoshoot`), so the case that changes is a hunter
  with Auto Shot on who channels Volley: Auto Shot now pauses until Volley ends instead of firing and cancelling it.
  Not checked against how Classic Era behaves.
- (2) The interrupt in `RemoveAurasWithInterruptFlags` is about the channelled spell's own interrupt flags, so
  stopping only that spell is the narrower, intended effect; generic casts are stopped by their own interrupt checks.

**Test.** None in `tests/`: it needs a unit, an auto repeat spell and a channel. PTR check: hunter with a bow, Auto
Shot on, channel Volley on a group: Volley channels to the end (all waves), Auto Shot resumes after it.

**Verdict:** take.
