# advocaite/TrinityCore#142: DB/Trainers: class trainer spells require their spell level

krakenunbound, 2026-10-27, commit 70483b9ec7. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** 110 `trainer_spell` rows on class-trainer lists have `ReqLevel` 0, so e.g. paladin list 29 sells Holy Light
rank 2 and Divine Protection at level 1. Each gets the spell's `SpellLevels.SpellLevel` (70532), only where still 0.

**Check.**
- All 110 values equal the 70862 client's `SpellLevels.SpellLevel` (difficulty 0) for the spell.
- On `everlake`, 80 of the 110 rows are still 0; the other 30 were set by later files (same values), so their guarded
  UPDATEs match nothing.
- Against live Forever's trainer windows (EG Link, all builds): 78 of the 110 spells were seen; 69 show the same level.
  The other 9 (Earth Shock 8042 on lists 10 and 11, Teleport: Orgrimmar 3567 on seven mage lists) show level 0 in every
  recording. EG Link's level is what the trainer window showed the recording player; it is 0 for spells that player
  couldn't learn, which fits Teleport: Orgrimmar seen by Alliance mages, but not obviously Earth Shock. The client's spell
  level is the better source here; a PTR look at a level 1-3 shaman's trainer settles Earth Shock.
- Order: guarded by `ReqLevel = 0`, and the later trainer files don't reset these rows; the load test gives the same
  `trainer_spell` in both orders.
- Same file-name prefix as #181 (2026_10_26_06_...). They touch different tables, so their order doesn't matter.

**Test.** SQL. Load test (as in advocaite-123.md): 110 UPDATEs, 80 rows changed, no error; same `trainer_spell` checksum
in fresh-world order. PTR check: a level 1 paladin at a paladin trainer sees Divine Protection and Holy Light rank 2 as
"requires level 6"; a level 1-3 shaman sees Earth Shock at level 4.

**Verdict:** take.
