# advocaite/TrinityCore#127: Spells: Flametongue Weapon deals its Fire damage

finelam, 2026-10-25, commit 4a4d322f31. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Every Flametongue Weapon rank's enchantment (5, 4, 3, 523, 1665, 1666, 7567) applies the dummy proc aura
436519, which had no script, so hits dealt no Fire damage. Damage = the rank's "Flametongue Weapon Proc" points / 100 per
second of weapon speed, cast through Flametongue Attack.

**Check.**
- True in the 70862 client data: each enchantment's one effect is equip spell 436519 (`SPELL_AURA_DUMMY`, proc flags
  melee swing and melee ability); the proc spells 8026 ... 16344 carry 326, 479, 716, 1144, 1876, 2498 points; the
  tooltip of 8024 is `$8026m1/77` to `$8026m1/25`, the formula at 1.3 s and 4.0 s.
- **Replaced by #325**, which scripts the same aura under the same script name with the same formula (both can't land:
  two classes of one name). Compared line by line:
  - #127 casts 29469 / 29470 / 10444 per rank, #325 always 10444. In 70862 the three are the same spell (school damage,
    0 points, coefficient 0.1), so no difference in game.
  - #127 computes the rank's points with the shaman as caster, #325 without. The points grow per level (8026: 19 per
    level from 10 to 16; 16344: 78 per level from 56 to 64), and the tooltip's `$8026m1` includes that, so #127 is
    right here. We made that change on top of #325 (commit c9421cf285, credited to this pull request).
  - #325 also sets the weapon as the cast item; otherwise the same weapon check.

**Test.** See `advocaite-325.md` (`tests/game/ClassicProcRules.cpp`).

**Verdict:** drop, replaced by #325; its per-level points are taken over on top of #325.
