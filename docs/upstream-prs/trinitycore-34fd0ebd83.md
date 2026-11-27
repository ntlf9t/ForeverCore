# TrinityCore 34fd0ebd83: update to retail 12.1.5

Shauren, 2026-10-14. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** Client data layouts (DB2 structures, load info, metadata, hotfix statements), update fields, about 300 changed
message numbers and several packets for retail 12.1.5.

**Check (first pass only).**
- Forever's builds since 70448 are on the same engine line, and `forever` already took many 12.1.5 layouts its own way:
  `everlake` has `ItemSquishEraID` and the `SpellVisualMissile` density fields, and the 70862 client's
  SpellItemEnchantment (wago.tools export) has the 12.1.5 column list with `ItemSquishEraID`. So this commit is
  neither "retail only" nor "take as is": it overlaps what `forever` did for its own builds.
- Cherry-picked on `everlake` it conflicts in 10 files (`HotfixDatabase.cpp`, `DB2LoadInfo.h`, `DB2Structure.h`,
  `Opcodes.h`, `SharedDefines.h`, packets, spells).
- Not done: the field-by-field compare of each changed DB2 layout with the 70862 client's, and of the message numbers
  with Forever's (`ClassicOpcodeNumbers` test and the 70862 opcode tables).

**Test.** None yet.

**Verdict:** hold, pending that compare. Whatever 70862 shares with 12.1.5 and `everlake` lacks comes in as its own
commits with tests; the rest goes to the retail realm's branch.
