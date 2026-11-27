# advocaite/TrinityCore#329: Classic: healing and spell damage item stats and enchantments count

Karrz1, 2026-11-08, commit 8e34ca9129. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** "Increases healing done by up to X and damage done by up to Y" gear gave nothing: in 1.60 that bonus is item
stats 41 (`ITEM_MOD_SPELL_HEALING_DONE`) and 42 (`ITEM_MOD_SPELL_DAMAGE_DONE`), which `_ApplyItemBonuses` ignored. The
same two stats on enchantments, and the Classic school damage / skill / penetration stats (83-123) on stat enchantments,
fell into `default: break;` of `ApplyEnchantment`.

**Check.**
- True for our code: neither function has a case for 41 / 42, and the enchantment switch has no Classic branch.
- 70862 client data: 395 items carry stat 41 and 325 carry 42 (the pull request says 393 / 322; same order, likely a
  slightly different build). Enchantments 8208, 8209, 8212, 8219, 8694 (and 7882) use 41 / 42; 7646 (84), 8700 (85), 8213
  (86), 7647 (89), 8210 (114, Skinning), 8706 (119), 8714 (121) use the Classic stats. 8203 "Spirit +$k1" carries 124, so
  leaving 124 out of the enchantment branch is right.
- No double counting: of the items with 41 / 42, only Atiesh (a party aura) and Eye of the Dead (an on-use effect) also
  have a damage or healing done spell, and those are different effects.
- Callers: the two totals are read in `Unit::SpellBaseDamageBonusDone` (magic schools only, as the tooltip says) and
  `SpellBaseHealingBonusDone`, which feed every spell's damage / healing bonus and the character sheet
  (`UpdateSpellDamageAndHealingBonus`). Apply and remove use the same value, so equip / unequip and enchant / disenchant
  balance. Physical damage and plain spell power (45) are unchanged.
- TrinityCore `master`: retail has no use of 41 / 42; Classic only.

**Test.** No unit test: the totals live on a `Player`, which a test can't build. PTR: a mage equips an item with "healing
by up to 22 and damage by up to 8": the character sheet shows +8 bonus damage for every magic school, +22 healing, no
change to physical; a Frostbolt hits 8 x coefficient harder; unequip returns both to the old values. Enchant 8208 on a
weapon adds 8 / 3 the same way.

**Verdict:** take.
