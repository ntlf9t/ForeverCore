# TrinityCore a5fe07a7f2: damage pushes back the cast time of channelled spells too

Gildor, 2026-10-03, TrinityCore#31983 (from 3.3.5 25f70808e6). Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** A channelled spell with a cast time before its channel (Mind Control) got no pushback and no "damage
cancels" check during that cast time: only the generic spell slot was checked.

**Check.** True: `Unit::DealDamage` looked at `CURRENT_GENERIC_SPELL` only; a channelled spell sits in
`CURRENT_CHANNELED_SPELL` from the start, in state `PREPARING` during its cast time. The loop now checks both slots
with the same rules (only spells still preparing; the channel part keeps its own handling). Live on Everlake: 105
channelled spells in 70862 have a cast time, e.g. Mind Control (3 s), Eye of Kilrogg, Ritual of Summoning, Eyes of the
Beast, Seduction, several Blizzards and Death & Decay; most have interrupt flags 0xf, which includes
`DamagePushbackPlayerOnly`. Classic pushes back any cast time, so this matches the game.

**Test.** None in `tests/`: needs units and a spell in progress. PTR check: a priest starts Mind Control on a mob
while another mob hits the priest: the cast bar is pushed back.

**Verdict:** take.
