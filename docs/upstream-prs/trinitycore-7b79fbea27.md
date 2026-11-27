# TrinityCore 7b79fbea27: phase conditions for Lady Liadrin in capital cities

Foldor1, 2026-10-12, TrinityCore#31935. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. World data: Forever world DB release
`forever-tdb-2026-10-14` (file not in its `updates` table). Client data: wago.tools export of 1.60.1.70862 (Phase,
AreaTable, QuestV2).

**Claim.** The four phase conditions for phases 27731-27734 (areas 16079, 5151, 5170, 15042) should test quest 86852
(not rewarded) instead of 88719.

**Check.** The release has the four `conditions` rows (type 26) with quest 88719; after applying the file on a scratch
MySQL 8.0 they test 86852, nothing else changes. In 70862: phases 27731-27734 are not in `Phase` (106 rows), the
four area ids are not in `AreaTable`, and quests 86852 and 88719 are not in `QuestV2` (which does have the Classic
quests, e.g. 386 and 391). The release has no `phase_area` rows for these phases. Retail (The War Within) content.

**Test.** None: no code.

**Verdict:** take. Inert on Everlake (phases, areas and quests absent from the Forever client); keeps
`sql/updates/world` in line with TrinityCore.
