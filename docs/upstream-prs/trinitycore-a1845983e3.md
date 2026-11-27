# TrinityCore a1845983e3: movement speed bonuses add up; creature run rate only for run; limit auras

Shauren, 2026-10-28. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** (1) Speed bonuses add (1 + main% + stacking%) instead of multiplying, like retail. (2)
`creature_template.speed_run` applies only to run speed, and not to player pets. (3) The speed limit auras get their
own handlers and movement types.

**Check.**
- (1) is a ruleset change. Example with 70862 spells: a 100% mount with Mithril Spurs (+4%, aura 130, stacking) is
  2.08x today, 2.04x added up. The user decided (2026-11-09) to keep multiplicative stacking on Everlake, as on Evermore.
  Our commit "Speed: movement speed bonuses stay multiplicative" restores the old rule as
  `Unit::CombineSpeedBonuses` and keeps (2) and (3). The Legacy perk The Quick and the Dead (1225500) multiplies, as
  before; the cherry-pick's conflict there was resolved to TrinityCore's additive form first, then our commit.
- (2) Creatures no longer swim and fly at their run rate. Player pets ignore their template run rate (Forever's pet
  catch-up sets their speed separately).

**Test.** `tests/game/SpeedBonusStacking.cpp` ([SpeedBonusStacking]): mount + stacking spurs = 2.08, stacking vs
non-stacking takes the larger, main bonus alone. With TrinityCore's additive line the first case gives 2.04 and fails.

**Verdict:** take, with our commit keeping multiplicative stacking.
