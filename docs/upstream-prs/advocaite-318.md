# advocaite/TrinityCore#318: Hotfixes: live hotfixes of build 70840 (items, Gore Drinker, Kidney Shot, Gouge, Soulstone, texts)

Karrz1, 2026-11-07, commits d8167d2aee and 796cf1f066. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** One hotfixes file with every record that is new or changed on live since the 70790 import of #309: 278
items, Gore Drinker, the new Kidney Shot and Gouge, Use Soulstone, druid and rogue tooltips, 35 curves, 11 texts, 4
quests, sounds. The second commit writes line breaks in texts as `\r\n` escapes.

**Where the data comes from.** Same as #309: the public mirror of live Forever's `DBCache.bin` (wowsims/forever builds
from it), made with Karrz1's `live_hotfix_sql.py --records <list> --statuses 1,2 --max-push 2000000000`. No player cache
data. Unlike #309 it includes the per-item shop pushes above 16 million (items 274598, 275006 ...).

**Check** against the public cache of 2026-11-09 01:11Z (build 70862), same decoder as #309:
- All 988 data rows (item 278, item_sparse 278, item_search_name 240, sound_kit 40, curve 33, curve_point 26,
  hotfix_blob 21, spell_misc 15, spell_effect 12, broadcast_text 11, spell_name 8, modifier_tree 6, quest_v2 4, others
  16) match the newest live push.
- All 1,021 `hotfix_data` rows (988 valid, 33 removed) have the newest live status; push ids 2040000-2041020, one per
  record.
- Sample written out for the log: 2 rows per table chosen with `random.Random(318)` (39 rows; spell_categories, spell_cooldowns and spell_power have 1 row each): all NEWEST.
- Pushes after this file: the 70862 cache has pushes 113762-113815 (72 curve points, 36 curves, 10 items and others) that
  neither #309 nor #318 has. That is for the Everlake delta (see #309).

**Claim wrong for our code.** "None of our own hotfix files owns any of these records" is not true on `everlake`: 395 of
the records are also in `2026_10_01_02_hotfixes_forever_sniff.sql` (beta 70124 sniff). 390 have the same values; 5 change
to the live values (Icemail Jerkin 1981 stats, Nightblade 1982 speed, sell prices of 274292 and 285100, Gore Drinker's
tooltip). The file sorts after the sniff and deletes the sniff's `hotfix_data` rows for those records, so live wins;
that is the right result.

**Overlap with Everlake's pipeline.** None: no tact_key rows, no record or push id that an Everlake hotfix file writes.
Ownership recommendation in the #309 log.

**Test.** Applied twice to the scratch MySQL 8.0 hotfixes database after #309, no errors or warnings. PTR: Nightblade's
weapon speed and Icemail Jerkin's stats in their tooltips; Kidney Shot and Gouge for a rogue; the Defias / SI:7 lines in
Westfall.

**Verdict:** take.
