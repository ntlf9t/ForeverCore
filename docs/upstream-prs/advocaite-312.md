# advocaite/TrinityCore#312: World: Forever quest chains need the quest before them again

Karrz1, 2026-11-07, commit af5ac2e411. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Many Forever quests can be taken without the quest before them (player report: the whole Westfall
Moonbrook/Deadmines chain 92745-92753 at once). 86 quests get their previous quest back: `PrevQuestID` for one, `conditions`
(source 19, type 8) for all-of or any-of groups, an exclusive group for Unnerving Silence / A Sacrifice in Vain. Checked
against QuestieDB's Forever data (GPL-3.0) and Wowhead quest series.

**Where the data comes from.** QuestieDB (public, GPL-3.0; its chains come from Questie users' traces on live) and
Wowhead. Both are public sources Everlake already pins. Nothing recorded on a live account by us.

**Check.**
- Section 1 (42 `PrevQuestID` rows from Questie): all 42 match QuestieDB `master` c1b50fefb1 (data/Forever +
  src/corrections/Forever, corrections over data).
- Section 3 (99 condition rows on 19 quests): every all-of group equals Questie's `preQuestGroup`, every any-of group
  equals Questie's `preQuestSingle`. Section 4 matches Questie's `exclusiveTo`.
- Section 2 (25 rows from Wowhead, Questie has none): 6 checked on Wowhead's Forever pages. 4 agree (91861 <- 91860,
  95125 <- 95111, 98396 <- 98394; 94872 has no series box, unclear). 2 disagree: **98221 From the Ashes** follows 464
  War Banners in Wowhead's series (473, 464, 98221, 465, 474), not 473; **88758 Sentiments of the Lost** follows 88757
  Accessories of the Lost (87318, 88757, 88758), not 87318. Both quests are missing from our world, so it changes
  nothing here; it is for the Forever import to get right.
- **Most of these quests are not in our world.** Of 193 quest ids the file names, 90 exist in `everlake`'s world (TDB +
  updates); the Westfall chain of the report does not exist here at all. The rest came with Karrz1's quest data restore
  (`2026_11_05_99`, not in advocaite `forever`). On our world the file links 37 quests whose previous quest also exists.
  For the others it leaves 47 `quest_template_addon` rows without a quest (with #316) and condition rows on missing
  quests, which the worldserver reports at start and skips. One existing quest gets a previous quest that doesn't
  exist (99052 Threat from Below <- 99051), but 99052 has no quest giver here, so nothing is lost.
- Risk for the world import: the orphan `quest_template_addon` rows will be there when Everlake's Forever import adds
  these quests. An import that does a plain `INSERT` into `quest_template_addon` would fail on them; one that deletes and
  writes its keys would silently drop these chain links. The import's dry run needs a check for both.

**Test.** Applied twice to a scratch MySQL 8.0 world (TDB `forever-tdb-2026-10-14` + `everlake` world updates): no
errors. PTR: Westfall chain once the import has it; on today's world, a quest from section 1 that exists here (95216 The
New Plague needs 451 A Recipe For Death).

**Verdict:** take. The two Wowhead disagreements and the import overlap are findings, not blockers.
