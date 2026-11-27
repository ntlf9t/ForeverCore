# advocaite/TrinityCore#305: Rohashi Spires portal and the Lorthuna battle work for both Confront Lorthuna quests

Karrz1, 2026-11-07, commit 95b005dd4b. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Confront Lorthuna exists twice (92646 and 93835, one per story line). The portal's cast condition and Ayessa's
gossip and credit knew only 92646, so a player on 93835 stood in the portal and nothing happened.

**Check.**
- World release 2026-10-14: both quests exist with the same title and zone (16593), both start at 253590, both have one
  objective, monster 256634 "Confront Lorthuna Credit" x1, and both follow 93958. They end at different NPCs (251968 and
  252475), which fits one quest per story line.
- The portal spell 1271396 had conditions ElseGroup 0 (93958 taken) and 1 (92646 taken); the new row is ElseGroup 2
  (93835 taken). The SQL deletes its own row first, so it can run twice; applied twice to a scratch MySQL 8.0 holding
  the release's `conditions` table: clean, three groups afterwards. Spell, game object 586726 and both quests exist.
- Script: `HasConfrontQuest` covers both in gossip hello and select; the credit is given for both (`ClassicSceneCredit`
  only credits players with that quest incomplete, and the credit entry is shared).
- **Not covered:** phase 29805 in area 16593 is shown while Prepare for Battle (93065) is rewarded and 92646 is neither
  complete nor rewarded. A player who finishes 93835 keeps that phase. Whether the 93835 story line goes through 93065 at
  all isn't in our public data; worth a look on the PTR.

**Test.** SQL applied twice as above. In-game test for the PTR realm: with 93835 in the log, use the Portal To Rohashi Spires,
talk to Ayessa, run the battle. Expected: the portal takes you, the gossip option shows, the quest completes. Then
check whether phase 29805 still shows after turning 93835 in.

**Verdict:** take.
