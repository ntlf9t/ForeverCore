# TrinityCore 469f8908d0: build fix for 7c9289504c (FlatSet ordering)

Shauren, 2026-11-02. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** "Build fix" after 7c9289504c, which put `AuraStackDropInfo` (ordered by a hand-written `operator<=>`) in a
`FlatSet`: `FlatSet`'s defaulted `operator<=>` becomes
`friend auto operator<=>(FlatSet const& left, FlatSet const& right) { return left <=> right; }`. Which compiler failed
without it is not said.

**Check.** As written the new operator calls itself (same argument types), so comparing two FlatSets with `<=>` would
recurse forever. Nothing compares FlatSets: the function is a template member that is only compiled when used, so it
builds (TrinityCore's CI and ours) and never runs. TrinityCore master still has this line. Not fixed here; worth a note
upstream.

**Test.** Covered by the build.

**Verdict:** take (with 7c9289504c).
