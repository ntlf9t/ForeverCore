# advocaite/TrinityCore#314: World: Camp Tent objects removed from the adventurer camps

Karrz1, 2026-11-07, commit 4db9c0315f. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Tents float over the starting-zone camps. Seven Camp Tent object spawns (gameobject 528996) are other
players' camps that a data dump stored; Karrz1's quest data restore (`2026_11_05_99`) brought them back. The creature
version was removed before. Deletes the object spawns and their addon rows.

**Check.** Not true here as written: our world (TDB + `everlake` updates) has no gameobject 528996 spawn, because
`2026_11_05_99` is only in Karrz1's repository. The file changes nothing on `everlake`. What is here is the "creature
version": four Camp Tent creature spawns (263398) at Zephras Isle (map 2991), Brill, Kharanos and Razor Hill, which
Karrz1 removed in `2026_11_05_75`, also not in advocaite `forever`. Camp Tent 263398 has no template data beyond the name
and no spawn in the public sources, which fits the "other players' camps" explanation.

**Our change on top.** Karrz1's `2026_11_05_75_world_forever_camp_tent_spawns.sql` unchanged (line endings LF, same file
name): deletes the 263398 creature spawns and their addon rows. Not taken: the orphan spawns of 242267 (no template;
the worldserver already skips them with an error; Karrz1 deletes them in `2026_10_25_30`, a different fix).

**Test.** Both files applied twice to a scratch MySQL 8.0 world: no errors; 263398 spawns 4 -> 0, 528996 stays 0.
PTR: no tent hanging over the camps at Brill, Kharanos, Razor Hill and on Zephras Isle.

**Verdict:** take, with our change on top.
