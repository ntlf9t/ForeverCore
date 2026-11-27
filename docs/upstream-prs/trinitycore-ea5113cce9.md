# TrinityCore ea5113cce9: speed limit and set-speed handlers run again when the amount changes

Shauren, 2026-10-29. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** Auras 191, 305 and 437 now re-run their handlers on an amount change, so a changed limit takes effect.

**Check.** Handler mode flags only. 10 spells in 70862 use these auras (see a87071f4fb).

**Test.** None.

**Verdict:** take.
