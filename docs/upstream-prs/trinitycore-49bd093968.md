# TrinityCore 49bd093968: saving stored aura teleport locations binds the spell id

Kevin Xu, 2026-10-15, TrinityCore#32071. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** `Player::_SaveStoredAuraTeleportLocations` left parameter 1 (spell) of
`CHAR_DEL_CHARACTER_AURA_STORED_LOCATION` unbound, so the DELETE matched nothing and the next INSERT hit a duplicate
key; a saved location was also written again on every save.

**Check.** True, and already fixed in `everlake`: advocaite 669c8de4ec ("Core: stale trades, BG port ticket slot,
vanilla mount rules and other fixes", advocaite/TrinityCore#49, 2026-10-13) makes the same three changes (both
`setUInt32(1, itr->first)` lines and `State = UNCHANGED`), with a comment. The cherry-pick conflicts only on that
comment and is empty once resolved, so nothing is picked.

**Test.** None needed; no code change.

**Verdict:** already in (advocaite 669c8de4ec); nothing to pick. When TrinityCore's version and ours are compared
again, the difference is the comment only.
