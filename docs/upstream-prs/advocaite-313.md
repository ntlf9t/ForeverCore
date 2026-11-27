# advocaite/TrinityCore#313: Exploring the Alliance: Mekkatorque, Magni and Tyrande can be talked to

Karrz1, 2026-11-07, commit 92de50bdf8. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The "Speak with" objectives of Exploring the Alliance (93963) can't be done: High Tinker Mekkatorque 7937,
King Magni Bronzebeard 2784 and Tyrande Whisperwind 7999 have only the quest-giver flag, so with no quest to offer a
click opens nothing and the talk-to credit never comes. Adds the gossip flag, "as was done for Vol'jin and Nazgrel on the
Horde side".

**Check.** True here: in our world 93963 has talk-to objectives (type 3) on 7937, 2784 and 7999, and all three had
npcflag 2. The talk-to credit comes from the gossip hello, which the client only sends with the gossip flag. The fix is
right.

**Claim wrong for our code.** The Horde side ("2026_10_27_16") is a file in Karrz1's own repository, not in advocaite
`forever` or in `everlake`. Here Exploring the Horde (93739) is still broken: Vol'jin 10540 (talk-to objective) has
npcflag 0, Nazgrel 3230 and Lady Sylvanas 10181 (credit on gossip hello) only the quest-giver flag. A search of our world
for talk-to objectives on NPCs without the gossip flag finds only Vol'jin, and the two script credits above.

**Our change on top.** Karrz1's `2026_10_27_16_world_forever_talk_to_npcs_gossip_flag.sql` unchanged (line endings LF),
same file name so a later upstream copy is the same file: gossip flag for Nazgrel, Vol'jin, Lady Sylvanas and Ott 3539
(Ott's Masterwork; that quest isn't in our world yet). Each has a gossip menu in our world (44858, 44861, 44863,
91003539).

**Test.** Both files applied twice to a scratch MySQL 8.0 world (TDB + `everlake` updates): no errors; npcflag 2 -> 3
for 7937/2784/7999/3230/10181, 0 -> 1 for Vol'jin. PTR: Exploring the Alliance and Exploring the Horde can be finished.

**Verdict:** take, with our change on top.
