# Sakhwoow/WoWForever 637626e264: Ghost Wolf back to 2645

Sakhwoow/WoWForever `forever` (the Azeroth project's hardcore realm, GPL-2.0), commit 637626e264 by PlayDargoon, 2026-11-15.
Reviewed 2026-11-16 against `everlake` 0d9a4b9145.

**Claim** (translated). In the 70938 client spell 1238640 has no SkillLineAbility row, so Ghost Wolf is not in the spellbook
and the client does not cast it. Trainers teach 2645 again and characters and buttons move back (undoes `2026_11_13_80` and
`2026_11_13_82`, which came to both of us with Karrz 0.1.36). Applied on their live realm 2026-11-15.

**Check.**
- `everlake` has both 11-13 files: every shaman trainer row for 2645 became 1238640 (from EG Link's 70888 trainer data), and
  characters were moved over.
- 70938 client data (wago.tools, `SkillLineAbility` build 1.60.1.70938, 7853 rows): 2645 has row 8700 (skill line 373, shaman
  class mask 64); 1238640 has none. `SpellName` has both ("Ghost Wolf").
- Our hotfix files add no `skill_line_ability` row for 1238640 (the only 70888 one is ID 1861, spell 3326). The live hotfix that
  gives live clients the row is not in the caches we imported.
- The bots already handle either spell (`ApClassicHeal.h`: `GHOST_WOLF` / `GHOST_WOLF_LIVE`).

**Change.** Two new files, the same as theirs in our words: world `2026_11_16_40` (trainer rows and ability requirements
1238640 -> 2645) and characters `2026_11_16_41` (known spells and action buttons 1238640 -> 2645). The 11-13 files stay (a
deployed file is never changed). When we have the live SkillLineAbility hotfix for 1238640, the switch can be made again
together with that row.

**Test.** SQL load test on a scratch MySQL 8.0 (`trainer_spell` as in the world, `character_spell` and `character_action` from
`sql/base/characters_database.sql`): two shaman trainers teaching 2645 plus a row requiring it, two characters knowing it with a
button each. After the 11-13 files (today's `everlake`): every row says 1238640, the check fails. After the 11-16 files: every row
says 2645, nothing with 1238640 is left, the check passes; a second run changes nothing. PTR check: a level 20 shaman learns Ghost
Wolf from a trainer, it is in the spellbook and casts; a shaman who learned it last week has it back after the restart.

**Verdict:** taken.
