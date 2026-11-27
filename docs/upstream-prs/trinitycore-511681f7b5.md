# TrinityCore 511681f7b5: renumber duplicate item_index rows before the item_loot_items key is added

Shauren, 2026-10-06 (from TrinityCore 3.3.5 f635b8bd27). Reviewed 2026-11-09 against `everlake` 7b3a1b1998.

**Claim.** Existing rows can have the same `item_index` twice in one container, which would make ebc90650c6's
`ADD PRIMARY KEY` fail; renumber them first.

**Check.** True: the old key allowed it. The file adds a temporary auto-increment key, renumbers `item_index` per
container with `ROW_NUMBER() OVER (PARTITION BY container_id ORDER BY item_index, item_id) - 1`, and drops the
temporary key. `ROW_NUMBER` needs MySQL 8; Everlake runs `mysql:8.0`. Renumbering is safe for the code: on load each
row's `item_index` becomes the slot of that loot, and the window is rebuilt from the rows. The file also starts with
`DROP PROCEDURE IF EXISTS` so a half-applied run can be repeated. Everlake never applied the first version of the
file, so the edit in place (new hash) changes nothing for us.

**Test.** Together with ebc90650c6 on a scratch MySQL 8.0 (see that log): container 1 with indexes 0, 0, 2 became
0, 1, 2; container 2 unchanged.

**Verdict:** take.
