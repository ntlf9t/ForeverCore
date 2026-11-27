# advocaite/TrinityCore#266: Core/UpdateFields: don't write PetSpellPower in Classic values updates

dqhoang, 2026-10-29, commit 5b06615389. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Summoning a Voidwalker (with the soul shard in the fifth bag) crashed the client. The Classic client has no
PetSpellPower field; the server still wrote it in ActivePlayerData updates.

**Check.**
- True for our code. `ClassicActivePlayerDataBit70291` maps TC bit 116 (PetSpellPower) to nothing, so the Classic
  changes-mask header never announces it, and `WriteCreate` already leaves it out. `WriteUpdate` still wrote the int32
  when bit 116 was set: 4 bytes the client does not expect, and every later field of that update is read 4 bytes off.
- Reachable on every pet summon: `Guardian::SetBonusDamage` (StatSystem.cpp) calls `Player::SetPetSpellPower`, which
  marks bit 116. The crash shows up when a later field of the same update makes the shift fatal (the report: an
  InvSlots guid after the soul shard left the bag).
- The fix (stop writing it) is right and complete: nothing else reads the field for the client, and
  `ClearChangesMask` still clears the bit.
- TrinityCore `master` writes PetSpellPower because retail has it; Classic only.
- Not checked: the 70862 client binary's reader itself. The core uses its 70425-or-later bit map for 70862, which drops
  bit 116 like the 70291 map.

**Test.** `tests/game/ClassicPetSpellPowerUpdate.cpp` (`[ClassicPetSpellPowerUpdate]`): writes an ActivePlayerData
update with and without the PetSpellPower bit (alone, and next to TransmogCostMinScalingLevel of the same group) and
requires the bytes to be identical. With the old `WriteUpdate` both sections differ by the 4 bytes of the int32. Not run
locally (no local builds); CI runs it.

**Verdict:** take.
