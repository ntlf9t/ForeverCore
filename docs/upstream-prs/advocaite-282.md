# advocaite/TrinityCore#282: Vendors: currency and partial stacks can't be bought for free

Karrz1, 2026-11-06, commit ea6f852f98. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** (1) The currency price `Money * count` is a 32-bit product that wraps. (2) The item and currency turn-in counts
per purchase wrap the same way. (3) A currency row without a stack size divides by zero. (4) Part of a stack (arrows) was
priced as nothing.

**Check.**
1. Not true here: `ItemExtendedCostEntry::Money` is `uint64`, so the product was already 64-bit. The change (refuse a
   purchase past the money cap instead of quietly buying less) is still better.
2. **True, and the real exploit.** `ItemCount` (uint16) and `CurrencyCount` (uint32) times `stacks` is a 32-bit product.
   With a large enough count it wraps, to 0 at worst; `HasItemCount(item, 0)` passes, then `AddCurrency` gives the
   currency and `DestroyItemCount` takes the wrapped (small) count. The pull request guards the currency purchase only.
3. Can't happen from the database: `ObjectMgr::IsVendorItemValid` refuses currency rows with `maxcount` 0. Harmless guard.
4. Mostly not true: the old code already raised a priced item to at least 1 copper after the reputation discount. What
   was wrong: part of a stack rounded down (199 arrows cost 9 copper, not 10), and a 100% price aura applied after that
   floor could take it to 0. The pull request rounds up and moves the 1-copper floor to the end. Right.

**Our change on top.** The sums move into `Player/VendorPrice.h` (`ForItems`, `ForCurrency`, `TurnInCount`) so they can be
tested. Item purchases with an extended cost get the same turn-in guard as currency purchases. `ForItems` prices whole
stacks and the rest apart, so it can't overflow for any count the money cap lets through.

**Test.** `tests/game/VendorPrice.cpp`: whole stacks, part stacks rounding up, stack size 0, the largest count, currency
past the money cap and past 64 bits, turn-in counts past 32 bits (2 x 2^31 used to be 0). Run against the old sums
(32-bit turn-in product, truncating division, no money cap check) on 2026-11-08, 15 checks fail: every turn-in
overflow, every part-stack price and the three currency cap checks. With the change all pass.

**Verdict:** take, with our change on top.
