# TrinityCore 8b54039f30: no extra 0.5 s cast time for ranged-slot spells

Shauren, 2026-09-28. Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** `SpellInfo::CalcCastTime` added 500 ms to every spell that uses the ranged slot (not auto repeat, not
`SPELL_ATTR9_COOLDOWN_IGNORES_RANGED_WEAPON`). Retail no longer does; the line goes.

**Check.** On Everlake this would change 182 spells of the 70862 client: everything with `SPELL_ATTR0_USES_RANGED_SLOT`,
e.g. Aimed Shot (19434: client cast time 2.0 s), Multi-Shot (2643: instant), Arcane Shot, Concussive Shot, Serpent
Sting, Shoot Bow / Gun / Crossbow (1.0 s). The rule is old (3.3.5), when the client itself showed ranged shots 0.5 s longer than
their data. What matters is what the Forever client does: if its cast bar for Multi-Shot shows 0.5 s, the server must
keep adding it, or the server finishes the shot before the client's bar does; if the bar shows instant, the server
has been half a second slow.

**Test.** Not testable without the client. PTR check: with a hunter, look at the cast bar of Multi-Shot and Aimed Shot
(note the times), then compare with the server's spell finish time (`.debug` or the combat log timestamps). Take this
commit only if the client shows the client data's times (Multi-Shot instant).

**Verdict:** hold, until that PTR check.
