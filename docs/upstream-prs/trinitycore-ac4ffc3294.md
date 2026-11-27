# TrinityCore ac4ffc3294: Learn Toy, Learn Any Toy and Learn Transmog criteria

brandon, 2026-10-14. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** Criteria types 185 (learn toy), 186 (learn any toy) and 192 (learn transmog appearance) are counted when a
toy or appearance is added (`CollectionMgr::AddToy`, `AddItemAppearance`), and modifier tree type 364 (item has
inventory type) is checked.

**Check.** 70862 Criteria (3,357 rows) has none of types 185, 186 or 192, so the new `UpdateCriteria` calls find
nothing to update. ModifierTree has 9 nodes of type 364 (trees 458582 ... 458609); no Criteria row uses those trees.
Before this commit an unknown modifier type returned false, so 364 can only go from "never true" to "sometimes true",
and nothing reads it. Inert on Everlake.

**Test.** None (no criteria of these types to drive).

**Verdict:** take (inert, keeps the files in line with TrinityCore).
