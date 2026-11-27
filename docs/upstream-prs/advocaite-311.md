# advocaite/TrinityCore#311: Quests: Russian titles and objectives for 273 Forever quests

Karrz1, 2026-11-07, commit 752fe997b6. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Russian clients show English titles and objectives for 273 Forever quests. One file adds
`quest_template_locale` ruRU rows (LogTitle, LogDescription) taken from Wowhead's Russian Forever quest tooltips; it
only fills an empty Russian field and keeps an existing one.

**Check.**
- Only `quest_template_locale`, only `locale = 'ruRU'`, 273 quest ids. The `ON DUPLICATE KEY UPDATE` keeps any non-empty
  field, so it never overwrites. Applied twice to a scratch MySQL 8.0 world (TDB `forever-tdb-2026-10-14` + `everlake`
  world updates): no errors (MySQL 8.0 warns that `VALUES()` in `ON DUPLICATE KEY UPDATE` is deprecated; it works).
- **Licence is not the same as the locale text the fork already ships.** `everlake`'s ruRU texts come from TrinityCore
  TDB 3.3.5 (`2026_10_11_51..54_*_ruRU_tdb335.sql`, GPL-2.0). This file's text is scraped from Wowhead tooltips, which
  carry no licence (the text itself is Blizzard's). Everlake already pins Wowhead tooltips as a public source, so it is
  inside the public-data rule, but it is a different licence situation. 227 of the 273 titles are identical to
  QuestieDB's Forever ruRU lookup (`l10n/Forever/lookupQuests/ruRU.lua`, GPL-3.0, commit c1b50fefb1), so most of this
  could come from a licensed source instead; 46 titles are only in Wowhead.
- Two rows are scraping leftovers: 91738 and 99191 have LogDescription "Requirements:  - <item>" (English word in the
  Russian field, a tooltip line, not a quest objective). 99191's English LogDescription is empty, so ruRU players would
  see text English players don't.
- **Only 64 of the 273 quests exist in our world** (the rest came with Karrz1's quest data restore `2026_11_05_99`,
  which is not in advocaite `forever` or in `everlake`). The other 209 rows are dead until Everlake's own Forever quest
  import adds those quests.

**Test.** Applied twice, no errors; rows checked against QuestieDB as above.

**Verdict:** hold. The user decides whether Wowhead-scraped text may go into the core (or whether to take the 227
QuestieDB-matching rows from QuestieDB under GPL-3.0 instead). If taken, drop or fix 91738 and 99191 and run it after the
Forever quest import, which owns those quests on Everlake.
