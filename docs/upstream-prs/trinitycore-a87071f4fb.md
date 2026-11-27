# TrinityCore a87071f4fb: movement speed auras: new ones, raw speed override, flight speed names

Shauren, 2026-10-27. Reviewed 2026-11-09 against `everlake` 481808222d. Spell and power data: wago.tools export of the 1.60.1.70862 client (SpellEffect, SpellName, PowerType, ChrClasses).

**Claim.** Implements 373 (speed while not in control) and 527 (backward speed); 437 becomes a raw speed override
(`SET_SPEED`) instead of a minimum; 191 (`SPEED_LIMIT_MAX`) and 305 (`SPEED_LIMIT_MIN_PCT`) become limits
applied at the end; flight speed auras renamed and stacked like run speed.

**Check.**
- Forever data: 373 none, 527 one test spell, 191 six (Silithus flags, Lethargy ...), 305 two (Snare Limit 50,
  Imperial March 80), 437 two (Furnace Surge 6, On Fire!! 14: values that read as a raw speed in yards per second, as
  the new meaning says), flight auras 206-211 none.
- **Conflict with Forever's code:** `UpdateSpeed` ends with Forever's pet catch-up (pets that fall behind run faster
  and only send a new speed when it changed enough). Resolved by clamping to the limits first, then the catch-up
  check, so a pet under a speed limit stays inside it.
- No Forever code uses the renamed aura names (one comment in the bot module).

**Test.** `tests/game/SpeedBonusStacking.cpp` covers the bonus rule (see a1845983e3); limits need a unit. PTR check: a
hunter pet still keeps up (catch-up) and its speed packets are not sent every step.

**Verdict:** take.
