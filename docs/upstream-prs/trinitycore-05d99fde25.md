# TrinityCore 05d99fde25: custom chat channel leak with AllowTwoSide.Interaction.Channel

Gildor, 2026-10-03, TrinityCore#32027. Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** Loading a custom chat channel that both factions already had leaked a `Channel`.

**Check.** Already in `everlake` as d4e75e9bd4 (same patch id), picked into `forever` by advocaite (merge 931914ca4e,
advocaite/TrinityCore#154).

**Test.** None needed; already in.

**Verdict:** already in (d4e75e9bd4).
