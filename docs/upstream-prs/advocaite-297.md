# advocaite/TrinityCore#297: Classic 1.60.1.70840: auth support and its TACT keys

Karrz1, 2026-11-07, commits 9d1b5818f9 and a9dae04997. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** A `build_info` row for 70840 (same message numbers and DB2 layouts as 70790), TACT keys 8283 and 8321 (70790)
and 8341-8343 (70840) sent as TactKey hotfixes, and the same five keys built into CascLib for the extractor.

**Check.**
- Auth: only the build row (the second commit leaves the realm build to our 70862 file). Applied after our chain on a
  scratch MySQL 8.0, twice: one row, realms stay on 70862. Lets 70840 clients join with `Realm.AlsoAcceptBuilds`.
- Key bytes: all five lookup/key pairs in the CascLib hunk match wowdev/TACTKeys `WoW.txt`, and the SQL bytes match the
  CascLib bytes. 8283 and 8321 are byte for byte the rows Everlake already ships in
  `sql/everlake/2026_11_08_08_hotfixes_live_tact_keys.sql` (from the live 70862 hotfix cache), so the id-to-key pairing
  of those two is confirmed. For 8341-8343 the pairing rests on the pull request; Everlake's 70862 cache run listed only
  8283 and 8321 as missing, so live 70862 does not send 8341-8343 with key bytes. Sending a correct key is harmless.
- hotfix_data ids 970108-970112 continue our `2026_09_28_01` file (970000-970107); no other file uses them. UniqueIds
  follow the same rule, no duplicates.
- Overlap with Everlake's file (push 9590000, keys 8283 and 8321): applied in both orders on scratch databases.
  Core first, then Everlake: both pushes carry the two keys (harmless). Everlake first, then core: the core file's
  `DELETE ... WHERE TableHash = TactKey AND RecordId IN (8283,8321)` removes Everlake's two rows and push 970108/970109
  carries them instead. Same bytes either way. When Everlake builds from this fork its tact key file is redundant.

**Test.** SQL applied to scratch hotfixes (`sql/base/dev/hotfixes_database.sql` + our custom tact keys) and auth
databases, twice each, in both orders with Everlake's file; checked rows, ids and UniqueIds as above.

**Verdict:** take.
