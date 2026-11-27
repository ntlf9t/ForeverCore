# TrinityCore da53b2abd9: spell_learn_spell refuses learning a talent, checked on the learned spell

Shauren, 2026-10-09. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** The "attempts learning talent spell, skipped" check looked at the learning spell instead of the learned one.

**Check.** True. On Everlake it changes nothing today: the 5 rows of `forever-tdb-2026-10-14` and the 8 rows of our
`sql/custom/world` files learn no talent spell. Note: the core marks talent spells from `Talent.SpellID`, and every
one of the 432 Talent rows of 70862 has `SpellID` 0 (Classic talents list their spells in `SpellRank_0..8`), so no
spell is marked a talent on Everlake at all. That affects this check and the auto-learn rule next to it; a follow-up.

**Test.** None: no Forever row is affected; the fix swaps which of two already-loaded spells is checked.

**Verdict:** take.
