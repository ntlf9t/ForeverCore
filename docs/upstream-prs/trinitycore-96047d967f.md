# TrinityCore 96047d967f: highest threat update sent when a threat reference comes back online

Gildor, 2026-10-04, TrinityCore#32012 (from 3.3.5 092eb27b20). Reviewed 2026-11-09 against `everlake` 5cc43b6f87. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellMisc, SpellClassOptions, SpellInterrupts, SpellCastTimes, SpellEffect, Talent).

**Claim.** When the top threat target becomes valid again (was offline: out of reach, immune, phased), the client was
not told who has the highest threat, so threat meters and the threat bar showed the old target.

**Check.** The three booleans become `ThreatListClientUpdateFlags`; `UpdateOffline` sets `ForceHighestUpdate`
when a reference comes back online, so the next `UpdateVictim` sends `SMSG_HIGHEST_THREAT_UPDATE` even if the
victim didn't change. Same message as before, sent once more; it is registered for the Forever client already
(`Opcodes.cpp`), so no new message. Everlake code has no other user of the old booleans (builds).

**Test.** None in `tests/`: needs a threat manager with units. PTR check: tank a mob, step out of its reach (or get
feared far) and back: the threat display goes back to the tank.

**Verdict:** take.
