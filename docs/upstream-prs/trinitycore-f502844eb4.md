# TrinityCore f502844eb4: movement slows apply to walk, run, run back, swim and flight

Shauren, 2026-10-26. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** `SPELL_AURA_MOD_DECREASE_SPEED` (33) slowed every movement type `UpdateSpeed` handles; now not swim back or
flight back. The aura's handler updates walk instead of the two back speeds.

**Check.** 460 spells in 70862 use aura 33 (Frostbolt, Slow, Cripple, Cold Eye ...). Run, run back, swim and
flight are slowed as before; only backwards swimming and flying are no longer slowed. Small.

**Test.** None: needs a unit.

**Verdict:** take.
