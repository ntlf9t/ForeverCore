# TrinityCore 545be4dddc: area trigger summon limit (MaxSummons) and units-inside limit (MaxUnits)

Shauren, 2026-10-19. Reviewed 2026-11-09 against `everlake` 7b3a1b1998. Taken with 4ad7c7ba5b (its crash fix) and our fix of its `MaxUnits` check.

**Claim.** Two new columns in `areatrigger_create_properties`: `MaxSummons` (a caster's oldest trigger of the same
kind is removed when there are more, `SpellModOp::AreaTriggerMaxSummons` applies) and `MaxUnits` (only that many
units count as inside). Six retail triggers get `MaxSummons` (Angelic Feather 3, Binding Shot, Freezing Trap, Tar Trap,
High Explosive Trap, Implosive Trap 1), and their scripts' own "remove the old one" code goes.

**Check.**
- The SQL on a scratch MySQL 8.0 with Forever's own table (schema and 407 rows from `forever-tdb-2026-10-14`): the
  columns go in after `SpellForVisuals` (Forever's table has it), the six rows exist and get their value, row count
  unchanged.
- None of those six triggers is made by a spell in the 70862 client, and no 70862 spell has a flat or percent modifier
  with `SpellModOp` 36, so on Everlake nothing changes in game until a row sets a limit.
- `HandleUnitEnterExit` now keeps units already inside and adds entering ones up to the limit. Without a limit it lets
  every entering unit in, as before. With a limit it read `enteringUnits` past its end when fewer units entered than
  the room left: fixed by 4ad7c7ba5b.
- **Bug, fixed on top:** the loader checked `*MaxSummons < 1` where it meant `*MaxUnits < 1`: a row with `MaxUnits`
  set and `MaxSummons` NULL dereferenced an empty `Optional`; a row with `MaxUnits` 0 kept it and no unit could ever
  be inside. Our commit "AreaTriggers: check MaxUnits itself when loading areatrigger_create_properties". Still wrong
  in TrinityCore `master` on 2026-11-09.
- Conflict in `spell_hunter.cpp`: the enum around the removed trap ids also holds talents from TrinityCore commits not
  taken yet (Horsehair Tether, Take Aim); resolved by removing only this commit's three ids.

**Test.** `tests/game/AreaTriggerMaxUnits.cpp` ([AreaTriggerMaxUnits]) on the entry count, see 4ad7c7ba5b. The loader
fix has no unit test (it needs the world database); it is the one-word change named above.

**Verdict:** take, with our loader fix.
