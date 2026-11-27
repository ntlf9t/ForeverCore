# advocaite/TrinityCore#141: DB/Trainers: junior gathering trainers and Zephras class trainers get their trainer lists

krakenunbound, 2026-10-27, commit 31a5187c51. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** "Train me." opens nothing at seven junior gathering trainers and six Zephras class trainers: they have no
`creature_trainer` row. Gives the juniors trainers 1221/1223/1224 and the class trainers mage 1, rogue 26, warrior 23 on
their class menus (41122, 41124, 41126), plus the trainer npcflags.

**Check.**
- Already fixed on `everlake` by two files upstream added on 2026-10-27:
  - 2026_10_24_20_world_forever_northshire_trainers_hunter_letter.sql has the same seven junior rows, value for value.
  - 2026_10_27_00_world_skyborne_class_trainers.sql gives the same six class trainers the same trainer lists and npcflags,
    but with `MenuID` 0 (the menu has no training option; `Player::PrepareGossipMenu` adds "Train me.").
- Taking it would make the result depend on file order: on a fresh world this file (2026_10_26_05) runs before
  2026_10_27_00 and the six rows end with `MenuID` 0; on a world that already ran 2026_10_27_00 it runs last and they end
  with 41122/41124/41126. Seen in the load test: `creature_trainer` differs between the two orders.

**Test.** SQL. Load test (as in advocaite-123.md): applies, 13 rows replaced, npcflag UPDATE matched 6 / changed 0; the
fresh-world order gives a different `creature_trainer`. Nothing to test in game: the trainers already train on `everlake`.

**Verdict:** drop (replaced by 2026_10_24_20 and 2026_10_27_00, and order-dependent if taken).
