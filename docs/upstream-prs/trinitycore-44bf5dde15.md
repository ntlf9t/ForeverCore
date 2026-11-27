# TrinityCore 44bf5dde15: build fix for 7644f2c8ad (vehicle seat check)

Ovahlord, 2026-10-19. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** Adds the missing brackets in `ValidateEffectValueParameters`:
`vehicleSeatId && (*vehicleSeatId < -1 || *vehicleSeatId > MAX_VEHICLE_SEATS)`.

**Check.** Without it the right side of `||` dereferences an empty `Optional<int8>` on every summon that has no seat
(undefined behaviour; with `-Werror` compilers also warn about the mixed `&&`/`||`). See the 7644f2c8ad log.

**Test.** Covered by the UBSan build; no separate test.

**Verdict:** take (with 7644f2c8ad).
