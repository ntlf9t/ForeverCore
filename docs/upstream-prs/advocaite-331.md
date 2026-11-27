# advocaite/TrinityCore#331: Classic: ranged shots use a plain arrow, not a fire arrow

Karrz1, 2026-11-08, commit b748d4ff07. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Shots with ammo that has the generic 1.60 display (Rough Arrow, Sharp Arrow, every bullet), and thrown
weapons without a display, fell back to ammo display 23211, which is item 19082 "Monster - Fire Arrow", so they flew as
burning arrows. The fallback becomes 5996, the plain arrow the creature branch already uses.

**Check.**
- True by the 70862 client data: ItemDisplayInfo 23211 -> model resource 17481 -> file 137239
  `arrowfireflight_01.m2`; item 19082 -> ItemAppearance 68547 -> display 23211. Display 5996 -> model resource 17490 ->
  file 137240 `arrowflight_01.m2`, with material 19706 (the same material 23211 has); the generic 737993 has the same
  model with no material (the white box the old comment describes).
- `Spell::GetSpellCastDataAmmo`: the creature branch already sends 5996, so players and creatures now match. Thrown
  weapons without a display also get the plain arrow (before: the fire arrow); still an arrow for a thrown knife, but no
  worse than before.
- Custom Classic code; TrinityCore `master` has no ammo slot.

**Test.** No unit test: a constant display id in a packet field. PTR: a hunter with Rough Arrows shoots a plain arrow;
same with bullets; a thrown weapon without a display shows a plain arrow.

**Verdict:** take.
