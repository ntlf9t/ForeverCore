# Karrz 0.1.39: hotfix records

From Karrz1/ForeverCore `forever-bots` `b441bf74e0`, one file: `sql/custom/hotfixes/2026_11_22_70_hotfixes_forever_karrz_0139_records.sql`.

Karrz's hotfix files delete records by ID across every build, then insert his copy. The PTR already had 21 of his items,
23 ItemSparse rows (several on build 71037, newer than his 70959 rows), 14 SpellMisc rows and a few more; those deletes would
have removed our newer rows. So only records the PTR did not have are taken, each with its own `hotfix_data` rows.

| Karrz file | What it brings (records the PTR lacked) |
|---|---|
| `2026_11_19_75` live pushes 70959 _c, `2026_11_19_77` _d, `2026_11_20_32` _e, `2026_11_21_10` / `_11` live sniffs 1120 | Blizzard's live hotfix records of pushes 114190-114326 (items, spell effects / misc / names, criteria, broadcast texts, quests, visuals), values unchanged |
| `2026_11_20_31` player cache items 13 | six 1.10 dungeon-set boss drops that had no item data (Hammer of Revitalization, Tome of Divine Right, Idol of Rejuvenation, ...) |
| `2026_11_20_10` Holy Strike visual | spell visual rows for all 8 Holy Strike ranks (ids 990000-990007) |
| `2026_11_20_40` - `_43` | server-only equip effects (item effects 9900101-9900312): Trogg Scepter, hidden / classic weapon spell power, low-level staves |

Table hashes for the `hotfix_data` rows were matched to their tables by record id inside each file.

Left out:

- The records the PTR already has (above).
- 1,122 `hotfix_data` rows of blob and removal entries in the push files. Those belong to our own live push import (the one
  behind `2026_11_18_50`), which reads Blizzard's public hotfix file directly.
- `2026_11_19_52` (Merchant's Favor recipe costs) and `2026_11_19_53` (mount displays): ours already, `2026_11_19_81` and
  `2026_11_19_80`.

Checked: the file runs three times on a scratch MySQL (tables made from the file's own column lists, PTR primary keys), with
the same row counts each time. hotfix_data ids 2102000-2105590 and 2190000-2190007 were free on the PTR. Not done: a client
check of the new records.
