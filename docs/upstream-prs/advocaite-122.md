# advocaite/TrinityCore#122: Spells: Lightning Shield damages attackers

finelam, 2026-10-24, commit 61363583d1. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Every Lightning Shield rank (324, 325, 905, 945, 8134, 10431, 10432) triggers 26545, whose only effect is a
dummy nothing scripts, so attackers took no damage. The script casts the rank's old damage spell on the attacker instead.

**Check.**
- True in the 70862 client data (wago.tools export of 1.60.1.70862): each rank is `PROC_TRIGGER_SPELL` with trigger
  26545, and 26545 is one `SPELL_EFFECT_DUMMY`. The damage spells exist with the ranks' levels (8 to 56) and base points
  13, 24, 40, 64, 96, 134, 178, spell power coefficient 0.267; the tooltip of 324 names `$26364s1`. The script's table
  matches the client.
- Charges (3), the 3.5 s proc recovery and the proc flags (melee, ranged and harmful spells taken) come from
  SpellAuraOptions; the script keeps them. No `spell_script_names` or `spell_proc` row for these spells in the world
  database (TDB `forever-tdb-2026-10-14` plus our SQL since), so the binding replaces nothing.
- Creatures that cast these ranks get the damage too, which is right.
- TrinityCore `master` has only the retail Lightning Shield (192106); nothing to take from there.
- #325 does not touch Lightning Shield. Both add a script at the same place, so the #325 merge had a text conflict:
  kept both.

**Test.** No unit test: the work is a proc on a live aura. SQL applied to a scratch MySQL 8.0 world (TDB 2026-10-14 +
our world SQL since): 7 rows. PTR: a shaman with Lightning Shield rank 1 is hit by a mob; the mob takes 13 Nature damage
(plus 0.267 x spell power), one ball is used, at most one every 3.5 s, the shield ends after 3.

**Verdict:** take.
