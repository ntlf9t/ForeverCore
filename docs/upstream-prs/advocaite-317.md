# advocaite/TrinityCore#317: Fishing: Zephras Isle and the low-level waters catch fish

Karrz1, 2026-11-07, commits 417c55cc0e and 4de375a999. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** New fishers almost never catch anything on Zephras Isle, Southfury River or Lordamere Lake: the zones have
no `skill_fishing_base_level` row, so the vanilla rule (skill - zone skill + 5) gives about 6%. Zephras Isle gets -70
like the other starting zones, Southfury River and Lordamere Lake -20.

**Check.** True here: TDB has no row for 16593, 377 or 170; Durotar 14, Elwynn 12, Teldrassil 141 and Mulgore 215 are
-70, The Barrens 17, Silverpine 130 and Orgrimmar 1637 are -20. In the 70862 client's AreaTable (wago.tools) 16593 is
Zephras Isle (continent 2991), 377 Southfury River and 170 Lordamere Lake, all top-level zones (parent 0), so the zone row
is the one the catch rule reads. Values only make fishing there easier, never harder.

**Test.** Both files applied twice to a scratch MySQL 8.0 world (TDB + `everlake` updates): no errors; the three rows
are there. PTR: a character with fishing 1 catches most casts on Zephras Isle.

**Verdict:** take.
