# advocaite/TrinityCore#309: Hotfixes: live 70790 hotfixes and Blizzard's fixes of 4 and 5 November

Karrz1, 2026-11-07, commit 5ed4645e07. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** (1) `2026_11_06_40_hotfixes_forever_live_pushes_70790.sql`: the item, Curve/CurvePoint, trait curve and spell
records Blizzard pushed to the live 70790 client, unchanged, so a server without them stops giving old values.
(2) `2026_11_06_40_world_forever_blizzard_hotfixes_1104_1105.sql`: Defensive Stance raises threat by 80% (was 30%) and
Deathstalker Erland respawns in 60 s (was 300 s), from Blizzard's patch notes of 4 and 5 November.

**Where the data comes from.** The file header and Karrz1's generator (`tools/full_forever/live_hotfix_sql.py` in his
0.1.32 source release; it is not in advocaite's repository) read `DBCache.bin`, Blizzard's hotfix cache for live
Forever, from the public mirror `storage.googleapis.com/raidbots-static/wow/forever/enUS/DBCache.bin` that wowsims/forever
(MIT) builds from. No account is needed and nothing comes from player caches (WDB). This is the same public source
Everlake already pins (`tools/live-hotfixes`, wow-project-everlake #30). Allowed under the public-data rule.

**Check.** Every row of the hotfixes file was decoded against the public cache as it was on 2026-11-09 01:11Z (build
70862, 75,555 records), with the core's own DB2 layouts (`DB2Metadata.h` / `DB2LoadInfo.h`); `hotfix_blob` rows were
compared byte for byte with the record data.
- All 2,878 data rows (curve 470, curve_point 1,043, item 472, item_sparse 472, spell_effect 213, spell_name 47,
  hotfix_blob 47, spell_misc 37, trait_definition_effect_points 24, spell_x_spell_visual 19, other spell tables 33) are
  live records: 2,871 match the newest live push, 7 match an older one. The 7 are bound potions 287966-287977 (Minor
  Healing Potion, Swiftness Potion ...): live push 113731 later added the description "This potion cannot be used in
  profession recipes or quest turn-ins."; #318 does not carry it either. Tooltip only.
- All 3,033 `hotfix_data` rows (2,878 valid, 155 removed) have the status of the newest live record; one push id per
  record (2030000-2033032), every data row has its `hotfix_data` row and the other way round.
- Sample written out for the log: 2 rows per table chosen with `random.Random(309)` (37 rows, spell_shapeshift has
  only 1): all NEWEST.
- World file: live SpellEffect 686475 (Defensive Stance Passive 7376, effect 3, Threat) is 80 in the cache (push 113326)
  and in the 70862 client data, 30 in the 70790 data, so the `classic_spell_value` row (79 + 1 die side = 80) is right.
  The hotfixes file does not send 686475 (only spells changed since push 113535), so a 70790 client's tooltip keeps 30%;
  70862 has 80 in its own data. Erland 1978 had one spawn with 300 s, now 60 s.
- Overlap with `everlake`: 7 records are also in `2026_10_01_02_hotfixes_forever_sniff.sql` (beta build 70124 values);
  2 are the same, 5 change to the live values (spell_effect 1345686/1360666, spell_name 1310315 and two Spell tooltips).
  Push ids 2030000-2039999 are used by nothing else.

**Claims wrong for our code.** "Left out: records our own hotfix files own (custom items, racials, our spell fixes)" and
"spells changed since push 113535" refer to Karrz1's own files (`2026_10_27_05` racials, `2026_10_30_20/21`,
`2026_11_03_41`, `2026_11_04_40` ...), which are in his release but not in advocaite `forever` or in `everlake`. So on
`everlake` this file is a correct but partial set: live changes from before push 113535 (Defensive Stance above, for
one) are not sent. After #309 and #318, 24,203 of the 40,801 live records still have no hotfix row here (most of them
names_profanity, texts and other records that may be the same as the 70862 client data; not checked one by one).

**Overlap with Everlake's own pipeline.** wow-project-everlake #30 pins the same cache and loads it raw into
`acore_forever.src_live_hotfixes` (analysis only, not the hotfixes database). The only hotfix rows it writes into the core
are TACT keys 8283 and 8321 (push 9590000, `sql/everlake/2026_11_08_08_hotfixes_live_tact_keys.sql`). #309 touches no
tact_key row, no record and no push id that any Everlake hotfix file writes, so nothing is applied twice. (#297, another
group, sends the same two keys with the same bytes as pushes 970108/970109 and deletes the other rows for those keys by
table+record; same values, so harmless.)

**Recommendation: one owner.** The core owns live hotfix records: take Karrz1's live sets (#309, #318 and later ones)
as upstream ships them. Everlake's pipeline keeps the pinned cache as the check and, per client build, writes only what
the core lacks or holds with other values (as `tact_keys.py` already does for keys), under its own 95xxxxx push ids. A
widened `tact_keys.py` (all served tables, diffed against the core ref and the client build's DB2 files) would cover the
70862 changes and the pre-113535 records above without writing anything twice.

**Test.** Applied twice to a scratch MySQL 8.0 (hotfixes: TDB `forever-tdb-2026-10-14` + `everlake` updates; world:
same TDB + `everlake` world updates), no errors or warnings. Check: the decoder written for this review (a Python script reading the cache with
Everlake's `dbcache.py`, not committed here) gives NEWEST or OLDER for every row. PTR: Mild Spices 2678 sells for 1 copper; a Protection warrior's threat in Defensive Stance.

**Verdict:** take.
