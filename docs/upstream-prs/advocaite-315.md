# advocaite/TrinityCore#315: Light's Hope Chapel: the Argent Sentries walk instead of floating

Karrz1, 2026-11-07, commit ba30f6e175. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The Argent Sentries 16378 lie flat while walking and hang in the air while standing: their difficulty row
kept the retail `CREATURE_STATIC_FLAG_FLOATING` (0x20000000). Clears that bit for 16378.

**Check.** True here: TDB has one `creature_template_difficulty` row for 16378 (difficulty 0) with StaticFlags1
0x20080000; 23 spawns. The floating flag turns gravity off and plays the hover animation, wrong for foot guards. After:
0x00080000, the other bit kept. The statement only clears one bit, so running it again changes nothing.

**Test.** Applied twice to a scratch MySQL 8.0 world (TDB + `everlake` updates): no errors, value as above. PTR: the
sentries at Light's Hope Chapel stand and walk on the ground.

**Verdict:** take.
