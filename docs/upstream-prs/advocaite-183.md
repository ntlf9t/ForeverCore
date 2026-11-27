# advocaite/TrinityCore#183: sql/hotfixes: bandage and healing potion tooltips show their heal

Duy Hoang (dqhoang), 2026-10-27, commit 67c0765093. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Bandage and healing potion tooltips read "Heal 0 damage" because the client keeps old zeroed SpellEffect
records in its hotfix cache and never fetches them again. Advertising the 45 SpellEffect records as hotfixes (push ids
985000-985044, status valid, no rows in `spell_effect`) makes the client ask the server for them, and the server answers
with its own DB2 record. Clients clear their Cache folder once.

**Check.**
- The 45 records are the heal effects of Healing Potion 439/440/441/2024/4042/17534, the First Aid spells of the
  bandages (746, 1159, 3267 ... 30020, 1290863/5/7), Triage 20804, Apply Bandage 1290242, the Discolored and Restored
  Healing Potions (wago.tools SpellEffect + SpellName, builds 70790 and 70862). In both builds the client's own data has
  the real values (Healing Potion 440: 160, First Aid 3267: 23 per tick), and the records are the same in 70790 and
  70862. Live Forever's public hotfix cache (70862) has no hotfix for any of them.
- So the server sends the client's own values back. That only matters for a client whose cache holds a wrong copy, which
  the pull request does not explain (an older server must have sent one). Harmless either way: the server has a
  SpellEffect store, so `DB2Manager::LoadHotfixData` accepts a status-valid row with no row in `spell_effect` and
  serves the record from the store.
- Push ids 985000-985044 and these table+record pairs are used by no other file in `everlake`, in the other open pull
  requests or in Everlake's own hotfix SQL.

**Test.** Applied twice to a scratch MySQL 8.0 hotfixes database (TDB `forever-tdb-2026-10-14` + every `everlake`
hotfixes update), no errors. PTR: with an empty Cache folder and with a cache from before, the tooltips of Linen Bandage,
Minor Healing Potion and Healing Potion show their heal.

**Verdict:** take. Low value for a fresh install, no risk.
