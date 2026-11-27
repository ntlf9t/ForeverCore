# TrinityCore ebc90650c6: item_loot_items gets the primary key (container_id, item_index)

Shauren, 2026-10-05 (from TrinityCore 3.3.5 05cb7ab07d). Reviewed 2026-11-09 against `everlake` 7b3a1b1998. Taken
together with 511681f7b5, which rewrites the same update file.

**Claim.** The stored loot of an openable item (`item_loot_items`) is keyed by its loot slot, `item_index`, not by
item id.

**Check.**
- True and needed. The old key (`container_id`, `item_type`, `item_id`) allows one row per item id, but
  `StoredLootContainer::AddLootItem` writes one row per loot slot (`LootListId` as `item_index`), and a container can
  hold the same item in two slots. The second INSERT then failed with a duplicate key and that stack was lost on the
  next restart. Shown on a scratch MySQL 8.0 with Everlake's old table: two rows of item 100 in one container ->
  `ERROR 1062 Duplicate entry '4-0-100'`; after the update both rows go in.
- `CHAR_DEL_ITEMCONTAINER_ITEM` already deletes by `item_index` (plus the old key columns), and loading reads
  `item_index` back as the slot, so the new key matches how the code uses the table.
- **Everlake problem, fixed on top:** the update file creates a procedure between `DELIMITER ;;` and `DELIMITER ;`.
  Everlake's DB updater does not use the mysql command line client; it splits files itself and sends the statements
  over its own connection, and the server does not know `DELIMITER`. Sent as it is, the file fails with error 1064
  (shown on the scratch server) and the worldserver stops at start. Our commits "DB updater: the SQL statement
  splitter moves into SqlStatementSplitter.h" and "DB updater: follow DELIMITER lines in update files" teach the
  splitter `DELIMITER`; with them the file runs (scratch server, the statements sent the way the updater sends them).
  This is the only TrinityCore update since 2026-09-25 that uses `DELIMITER`, but TrinityCore uses it now and then.
- `sql/base/characters_database.sql`: the key change and the `updates` row for the file (hash of the final file,
  `9F10D43D...`, checked with `shasum`) are taken; the row for TrinityCore's `2026_10_18_00_characters.sql` in the same
  hunk is left out, it comes with c8c3514884.
- Found while reading the save code, not fixed here: `AddLootItem` binds parameter 13 twice (`context` then
  `bonus_list_ids`) and never binds 12, so `context` is always stored as 0. Same in TrinityCore `master`. Listed as a
  follow-up.

**Test.** `tests/common/SqlStatementSplitter.cpp` ([SqlStatementSplitter]) for the splitter, using this file's
procedure as one case: without the DELIMITER commit the `DELIMITER` lines end up inside the statements and the test
fails. The SQL itself on a scratch MySQL 8.0 (Everlake's version) with Everlake's old table and rows with a duplicate
`item_index` in one container: after the update the key is (`container_id`, `item_index`), indexes are 0, 1, 2 in
(old index, item id) order, other containers unchanged, and the same item twice in one container is accepted.
PTR check: the worldserver applies `2026_10_05_00_characters.sql` at start without error; open a container item with
loot (a clam or lockbox), leave some of it, restart, and the rest is still there.

**Verdict:** take, with our DB updater fix.
