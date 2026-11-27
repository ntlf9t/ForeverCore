# advocaite/TrinityCore#277: Chests: using an emptied vein again with its loot window open no longer reads freed loot

Karrz1, 2026-11-06, commit 02623a822f, after Lauris Mikulans (LatvjuAvs/TrinityCore 1a8e194f0c). Reviewed 2026-11-08
against `everlake` dab8f8aa45.

**Claim.** Using a mining vein or herb again while its emptied loot window is still open builds the loot reply from freed
memory.

**Check.** True, and only in `forever`: `GameObject::TryReopenChest` is the Classic 1.60 code that lets a copper vein be
mined 2-4 times. `GameObject::Use` (chest) passes `*GetLootForPlayer(player)` to `Player::SendLoot`, which first calls
`DoLootReleaseAll`. If the open window is this vein and it is fully looted, the release calls `TryReopenChest`, which
calls `ClearLoot` and frees `m_loot`. `SendLoot` then reads the freed `Loot` in `BuildLootResponse`. The fix releases the
window at the top of `Use`, before the loot is taken, so the reopened vein gets new loot in the same use.

**Test.** None in `tests/`: it needs a map, a game object and a player. In-game test for the PTR realm (ideally on an ASan
build): mine a copper vein that opens more than once, take everything but leave the window open, then right-click the
vein again. Expected: a fresh loot window with new ore, no crash.

**Verdict:** take.
