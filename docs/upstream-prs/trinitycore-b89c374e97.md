# TrinityCore b89c374e97: rune regeneration follows haste changes during a cooldown

Shauren, 2026-10-10. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** Rune cooldowns become progress values (0..1) advanced by the rune power regen each update, so a haste change
mid-cooldown takes effect at once.

**Check.** Death Knight only. 70862 has no Death Knight class (ChrClasses: 9 classes, no 6) and no Runes power type;
the rune code runs only for a class with the Runes power (`GetPowerIndex(POWER_RUNES)` guard). It also removes
`GetRuneBaseCooldown`, which read `GetPowerTypeEntry(POWER_RUNES)` without a null check (that row doesn't exist in
70862). Taken to stay in line.

**Test.** None: unreachable on Everlake.

**Verdict:** take.
