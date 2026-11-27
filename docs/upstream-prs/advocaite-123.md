# advocaite/TrinityCore#123: DB/Loot: Flintfire's Shipment has loot

finelam, 2026-10-24, commit 8fad22a9df. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Flintfire's Shipment (gameobject 672508, Dun Morogh) says "There is no loot", so Flintfire's Shipment (quest
98321, collect 8 of item 280413) can't be finished. The chest has no loot id (`Data1` 0) and no loot rows.

**Check.**
- True here: on the release brought up to `everlake`, 672508 is a type 3 chest with `Data1` 0, `Data8` 0 and no
  `gameobject_loot_template` rows. The quest's only objective is 477369 (item 280413 x8), the same id, item and count as
  live Forever's own quest answer (EG Link, build 70862).
- The fix is the normal chest setup: `Data1` = loot id, `Data8` = the quest (the chest is only usable on the quest), one
  quest-only row for 280413 at 100%. Item 280413 is in the 70862 client's ItemSparse; Wowhead Forever has object 672508 as
  a container.
- Not fixed, and said so in the pull request: 6 spawns of 672508 against about 22 on Wowhead Forever. With 8 needed and
  the default respawn, the quest is slow in a group. Left for the spawn import.

**Test.** SQL, no code. Load test (scratch MySQL 8.0, world release `forever-tdb-2026-10-14` brought to `everlake` by the
updater's rules: 193 files, no errors; then every file of this group in name order): applies with no error; 1 template
row changed, 1 loot row inserted. Run again in the order a fresh world runs it (between the existing custom files): same
result. PTR check: take quest 98321, open a shipment, get one Flintfire's Shipment; without the quest the chest can't be
opened.

**Verdict:** take.
