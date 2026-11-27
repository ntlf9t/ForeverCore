# TrinityCore 7c9289504c: auras whose stacks each run out on their own

Shauren, 2026-11-01. Taken with 469f8908d0 (its build fix). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** New attribute `SPELL_ATTR15_AURA_HAS_SEPARATE_STACK_DURATIONS` (Attributes 15, 0x400, was `UNK10`): each
added stack keeps its own drop time and falls off on its own (`Aura::m_stackDropTimes`), instead of all stacks sharing
one refreshed duration. Nothing changes for spells without the attribute.

**Check.** No spell carries it on Everlake: 0 of the 32,461 SpellMisc rows of 70862 have 0x400 in `Attributes_15`, and
0 of the 4,401 rows of Forever's `serverside_spell` have it in `AttributesEx15`. Nothing in our code used the old name
`SPELL_ATTR15_UNK10`. The member move in `Aura` (`m_timeCla` after `m_periodicCosts`) keeps the constructor's
initialiser order valid (`m_timeCla` is still before `m_updateTargetMapInterval`).

**Test.** None: no spell to drive it.

**Verdict:** take (inert on Everlake).
