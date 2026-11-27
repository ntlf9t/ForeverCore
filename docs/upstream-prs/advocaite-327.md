# advocaite/TrinityCore#327: DB: drop 77 quest-only loot rows no quest can unlock, lift the Sentinel Hill graveyard above ground

MShkolenko, 2026-11-08, commits 502a1e97f4 and ce773e4039. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** (1) 77 creature and gameobject loot rows have `QuestRequired` 1 for items no quest needs (no item objective, no
`ItemDrop`), so `LootItem::AllowedForPlayer` never shows them: 16 VMaNGOS rows on the Westfall Defias (2374-2377) at 15-45%
for gems, a herb, recipes and a green; Teronis' Journal (5505, a quest start item, not loot); 60 rows of 1.12 items whose
quest doesn't exist. (2) `world_safe_locs` 4 (Sentinel Hill) is at z 31.97 under 35.5 terrain; the core lifts it on every
release. Sets 36.0.

**Check.**
- Every DELETE names entry, item type, item and `QuestRequired` = 1; together they remove exactly 77 rows (39 items), no
  more. For each item: no quest on `everlake` has it as item objective, `ItemDrop1-4` or start item, except 5505, which is
  quest 1023's start item, as the pull request says.
- Live Forever (EG Link quest answers, 3,490 quests from builds 70790 and 70862): no quest needs any of the 39 items; 5505 is
  1023 Raene's Cleansing's start item there too. Wowhead Classic tooltips for 20021, 7271 and 20018 say "Quest Item" but no
  1.12 quest uses them, which fits "quest removed before release".
- The 16 Defias rows: the same items have 25-1,741 ordinary (`QuestRequired` 0) rows elsewhere, so deleting rather than
  clearing the flag is right (clearing it would make rare recipes 45% drops).
- The pull request body says Faded Photograph (11108) has 14 rows; the file deletes 15. All 15 match.
- Graveyard: `Player::SnapBuriedLocToFloor` exists here and is called on arrival at a graveyard. The UPDATE is guarded by
  `LocZ < 35`. The terrain height (35.5) wasn't checked here (no map tools in this review); the core already lifts it, so
  36.0 changes only the log line.

**Test.** SQL. Load test (as in advocaite-123.md): 77 rows deleted (one per statement), 1 graveyard row changed, no error;
same result in fresh-world order. PTR check: release a ghost in Westfall; it appears on the ground at Sentinel Hill with no
"buried graveyard" line in the server log.

**Verdict:** take.
