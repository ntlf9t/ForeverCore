# advocaite/TrinityCore#279: Taxi: a node index outside the taxi mask is refused, not read or written

Karrz1, 2026-11-06, commit 16a0531f90. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** `PlayerTaxi::SetTaximaskNode` and `IsTaximaskNodeKnown` index the taxi mask without a check: node 0 wraps to a
huge field number, and a node past the end reads or writes outside the mask.

**Check.** True of the two functions (TrinityCore `master` has the same code). Every caller today already passes a
valid node: the taxi handlers look the node up in `sTaxiNodesStore` first, `EffectDiscoverTaxi` does the same, and the
starting nodes in `InitTaxiNodesForLevel` are fixed numbers. So it is hardening, not a crash anyone can cause now; it
keeps a future caller (a script, the bot module) from writing past the mask.

**Test.** `tests/game/TaxiMaskBounds.cpp`: TaxiNodes rows up to id 100 give a 16-byte mask (nodes 1-128). Nodes inside it
can be learned and are known; node 0, 129 and larger are refused and leave the mask untouched. Run on the old
`PlayerTaxi.h` (2026-11-08, local UBSan build), the refused-node case crashes the test binary with SIGSEGV at node 0;
with the change all pass.

**Verdict:** take.
