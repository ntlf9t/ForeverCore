# TrinityCore 884f2575cd: Icecrown Citadel scripts use a speed override on MovePoint instead of speed hacks

Shauren, 2026-10-30. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** Lord Marrowgar and Professor Putricide set a speed on their `MovePoint` instead of changing their speed
rate around it (which a87071f4fb's aura changes would otherwise break).

**Check.** Icecrown Citadel scripts only; not Forever content. Taken to stay in line with the speed changes.

**Test.** None.

**Verdict:** take.
