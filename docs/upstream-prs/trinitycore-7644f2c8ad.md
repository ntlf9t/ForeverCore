# TrinityCore 7644f2c8ad: `summon_properties_addon` decides what a summon effect's value means

Ovahlord, 2026-10-19. Taken with 44bf5dde15 (its build fix). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** `Spell::EffectSummonType` used a hard-coded list of 15 SummonProperties ids whose effect value is a number of
creatures; vehicle summons always cast a ride spell (the hard-coded one, or the effect value if it was a spell with
`CONTROL_VEHICLE`, or a seat if small). Now a world table `summon_properties_addon` (78 rows) says per SummonProperties
id what the value is: number of units (min 1, or fail below 1), seat, ride spell (health, creature level, totem slot:
not used yet). The ride cast happens after the creator is set and for any summon category with such a row.

**Check.**
- 70862 SummonProperties has 132 rows; only 8 of the 78 ids in the new table exist (41, 61, 63, 64, 65, 66, 67, 81).
  The other 70 are skipped at start with an error line each ("does not exist in DB2 files"): log noise, nothing else.
- Every summon effect (effect 28) in 70862 SpellEffect (1,533) and in Forever's `serverside_spell_effect` (110), number
  summoned before and after: no change.
  - 61, 64, 66 were in the old list and are type 2 (same).
  - 41 (companions, 171 spells; Zergling, Murky, Tiny dragons have value 2) becomes "number of units", but its Title is
    Companion and that path summons one creature whatever the number. 67 (control Pet: Earth/Fire Elemental, Imp,
    Doomguard) has values 0 or 1 -> 1. 63 and 81 (totems) are "health", not implemented -> 1 as before; totem health
    still comes from the value. 65 (Eye of Kilrogg, Dream Vision; value 1) "fail below 1" -> 1.
  - Vehicle summons: SummonProperties 5896 is the only control 4 row and no client or serverside spell uses it; there
    is no control 5. So the ride-spell change cannot happen on Everlake. Serverside spell 148164 uses 2986, which 70862
    doesn't have (the effect stops at the missing SummonProperties, before and after).
- World SQL: `DROP TABLE IF EXISTS` + `CREATE` + one INSERT; applied on MySQL 8.0.46, 78 rows. The Forever world
  release of 2026-10-14 has no such table.
- 7644f2c8ad alone has a bad check, `vehicleSeatId && *vehicleSeatId < -1 || *vehicleSeatId > MAX_VEHICLE_SEATS`,
  which reads an empty optional for every summon; 44bf5dde15 adds the brackets. Both are in this PR.

**Test.** None in `tests/` (needs a caster and a map). PTR check: Eye of Kilrogg, a companion, a hunter's tamed pet
summon and a shaman totem each summon one creature, as before.

**Verdict:** take.
