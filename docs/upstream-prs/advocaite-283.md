# advocaite/TrinityCore#283: Items: an item sells for its own sell price

Karrz1, 2026-11-06, commit 5b11797eb1. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Items without the gold-cost override flag are priced with the retail item level formula, so their sell and
buyback price differs from the tooltip, and items with no sell price can still be sold. The client always shows the
item's `SellPrice`.

**Check.**
- True. `Item::GetSellPrice(proto, quality, itemLevel)` uses `SellPrice` only with `ITEM_FLAG2_OVERRIDE_GOLD_COST`;
  otherwise it takes the `ImportPrice*`/`ItemPriceBase` formula times the `ItemClass` price modifier. TrinityCore `master`,
  `cata_classic` and `wotlk_classic` all do the same.
- Client data (`ItemSparse`, 1.60.1.70862, from wago.tools): 2538 of 19324 items have no override flag; 929 of them have a
  sell price (the pull request says 919), 1609 have none. Those 1609 could be sold before; now they can't
  (`Player::CanSellItem` refuses a price of 0), which matches the "No sell price" tooltip.
- Callers: vendor sell and buyback (`Player.cpp`), auction deposit (`AuctionHouseMgr`), transmog cost, auction bot buyer,
  and `Item::GetDisenchantLoot`. **Side effect:** the disenchant check refuses items whose sell price is 0. 422 of the
  1609 look disenchantable (uncommon or better, equippable, not quest-bound), for example 252424-252448 (rare
  "Black Whelp Slippers", "Defender's Leather Armor" ...). They could be disenchanted before; now they can't. Whether
  Forever lets you disenchant them is not in any public source we have. PTR check below.

**Test.** `tests/game/ItemSellPrice.cpp` (`[ItemSellPrice]`): price tables are loaded so the retail formula has numbers
(uncommon item level 20 shield = 100 copper); a shield without the flag and a 1234 copper sell price sells for 1234,
with the flag the same, and a 0 sell price stays 0 either way. Against the old code the first case gives 0 (the formula,
then no `ItemClass` row), so it fails; with the change all pass. PTR: sell a quest-reward green and check the
vendor pays the tooltip price; try disenchanting item 252424 (Black Whelp Slippers) to see whether it is refused.

**Verdict:** take. The user should know about the disenchant side effect (422 rare items lose disenchanting).

**Decision (user, 2026-11-09): keep the selling fix, keep disenchanting.** `Item::GetBaseDisenchantLoot` refused items whose
sell price is 0, and after #283 that price is the Classic one, so the 422 items lost disenchanting by accident. The check now
also accepts the retail price (`Item::GetRetailSellPrice`, the formula `GetSellPrice` used before #283), so exactly the items
that could be disenchanted before still can. Vendors still pay the tooltip price. No unit test for the disenchant half: the
retail price needs the ItemClass index, which only a full client data load builds. PTR: disenchant 252424 (Black Whelp
Slippers); it must give materials, and selling it must still be refused.
