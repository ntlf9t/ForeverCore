# advocaite/TrinityCore#330: Classic: poisons and weapon buffs go on weapons below the spell level

Karrz1, 2026-11-08, commit 8d0019b911. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A level 20 rogue could not put Instant or Crippling Poison on any weapon ("Target is too low level"):
`Spell::CheckItems` has the retail rule that a temporary enchantment's target must be at least the spell's base level
(by required level, else item level). Vanilla has no such rule.

**Check.**
- True for our code and reachable: the rule applies to `SPELL_EFFECT_ENCHANT_ITEM_TEMPORARY` and `_2` without
  `SPELL_ATTR2_ALLOW_LOW_LEVEL_BUFF`.
- Which spells it hits, by the 70862 client data (temporary enchantment spells with a base level above 1 and without the
  attribute): the 20 rogue poisons (Instant I-VI 20-60, Deadly I-V 30-60, Crippling I-II 20/50, Mind-numbing I-III,
  Wound I-IV) and Windfury Weapon ranks 1-4 (base levels 30-60). So a level 30 shaman could not put Windfury on a level
  20 weapon either. **The claim that sharpening stones, weightstones, oils and the other imbues are hit is wrong:** they
  have base level 0. Harmless.
- VMaNGOS `Spell::CheckItems` (1.12): the item level check is on `SPELL_EFFECT_ENCHANT_ITEM` only, not on the temporary
  one. The pull request does the same; permanent enchantments keep their check, and the too-high check (`MaxLevel`)
  stays.
- TrinityCore `master` keeps the retail rule; Classic only.

**Test.** No unit test: the check sits inside `Spell::CheckItems` on a live cast, and after the change there is no rule
left to call. PTR: a level 20 rogue applies Instant Poison to a level 5 dagger; a level 30 shaman applies Windfury
Weapon to a weapon with required level 20; a permanent enchant on a too-low item is still refused.

**Verdict:** take.
