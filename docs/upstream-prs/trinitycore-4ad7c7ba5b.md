# TrinityCore 4ad7c7ba5b: area trigger MaxUnits no longer reads past the entering units (crash)

Shauren, 2026-10-21. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** With `MaxUnits` set, `HandleUnitEnterExit` used `MaxUnits - inside` as the number of entering units even
when fewer had entered, and read past the end of `enteringUnits`.

**Check.** True (545be4dddc). The fix takes the smaller of the two. Our commit after it moves the count into
`AreaTrigger::GetEnteringUnitsInsideLimit` (also never below 0; the loop treated a negative count as 0 already) so a
test can call it. Unreachable on Everlake today: no Forever row sets `MaxUnits` (545be4dddc's log).

**Test.** `tests/game/AreaTriggerMaxUnits.cpp` ([AreaTriggerMaxUnits]): no limit, fewer entering than the room left
(MaxUnits 5, nobody inside, one enters -> 1; 545be4dddc gave 5), room for some, full and over-full. With the
`std::min` taken out of the function, "Never more than the units that entered" fails.

**Verdict:** take.
