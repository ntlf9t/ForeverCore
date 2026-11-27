# advocaite/TrinityCore#181: sql/world: the demons summoned in "The Binding" spawn hostile

dqhoang, 2026-10-27, commit 46b35e83f6. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** In the warlock "The Binding" quests the summoned Voidwalker (5676), Succubus (5677) and Felhunter (6268) are
faction 35 (friendly) and can't be attacked. Sets faction 90 (Demon) and makes the voidwalker and succubus attack their
summoner when summoned.

**Check.**
- Faction: true on `everlake`; all three are 35. 6268's own script (626800 row 6, "Start Attacking Closest Player") can't
  work on a friendly creature, as the pull request says.
- `SMART_EVENT_JUST_SUMMONED` is raised by `SmartAI::IsSummonedBy` with the summoner as invoker, so target 7 (invoker) is
  the summoner. 5676 row 4 is new.
- 5677 row 2 is not free on `everlake`: 2026_10_26_20_world_quest_summons_hostile.sql (added upstream 2026-10-27) already gives the succubus the VMaNGOS script, rows 2-4 (on summon start timed event 1; after 4 s
  faction 14 and attack the summoner). This file deletes row 2 and inserts its own. On a fresh world it runs first and
  2026_10_26_20 puts row 2 back; on a world that already ran 2026_10_26_20 it runs last and leaves rows 3-4 with nothing to
  start them. Seen in the load test: `smart_scripts` differs between the two orders.
- Same file-name prefix as #142 (2026_10_26_06_...): different tables, order doesn't matter between those two.

**Our change on top.** `sql/custom/world/2026_11_08_70_world_everlake_binding_succubus_script.sql` runs 2026_10_26_20's
succubus rows again after both, so every world ends with the 2026_10_26_20 script plus faction 90 from this pull request
(the succubus is hostile at once and turns to 14 after 4 s, as 2026_10_26_20 already does).

**Test.** SQL. Load test (as in advocaite-123.md): 3 templates changed, 1 SmartAI row deleted, 2 inserted, no error. With
our file the branch's files give the same checksum for every world table in both orders (fresh world and stepped from
`everlake`). PTR check, one per demon: summon it at the quest circle (voidwalker 1471/1504/1689, succubus
1474/1513/1739, felhunter 1795); it attacks the summoner and can be killed. The author only tried the voidwalker.

**Verdict:** take, with our change on top.
