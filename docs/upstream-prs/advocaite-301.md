# advocaite/TrinityCore#301: Items: charges go in the slot the client reads

Karrz1, 2026-11-07, commit dd534e0f87. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Healthstones and mana gems show 0 charges and are grey on the action bar. The client reads an effect's charges
from `SpellCharges[LegacySlotIndex]`; their one use effect is in slot 1, but the server wrote slot 0 (the effect's
index in the item's effect list).

**Check.**
- Client data (1.60.1.70862 `ItemEffect` + `ItemXItemEffect`, wago.tools): every healthstone (5509-5512, 9421, 19004 ...)
  and mana gem (5513, 5514, 8007, 8008) has its single effect in slot 1 with -1 charges. In all, 650 single-effect items
  have a slot other than 0 and 268 of them have charges, so this is wider than healthstones. 239695 is the only item with
  two effects in one slot (slot 1, charges -1 and 0), as the pull request says.
- TrinityCore `master` uses the effect index too (retail items are almost all slot 0, so it rarely shows).
- Every reader and writer of `ItemData::SpellCharges` goes through `FindSpellChargesSlot` (`GetSpellCharges`,
  `SetSpellCharges`: spells, vendor price, auctions, mail, trade, guild bank) or the save/load loops, and all of them now
  use the new slot. Saving stays in effect order, so items already in bags load into the right slot; no database change.
- A bonus list that adds effects after charges are set can move slots; that was already true of the old index.

**Our change on top.** `GetSpellChargesSlotForEffect` is declared in `Item.h` (it was `static` in `Item.cpp`) so a test can
call it without an `Item`.

**Test.** `tests/game/ItemSpellChargesSlot.cpp` (`[ItemSpellChargesSlot]`): Minor Healthstone and Mana Agate effects land in
slot 1, slots 0 and 1 stay, 239695's two slot-1 effects get 1 and 0, five effects with a doubled slot and one past the
end all get different slots, and indexes past the list pass through. Against the old rule (slot = effect index) the
healthstone, 239695 and five-effect cases fail. PTR: make a healthstone, put it on the action bar. Expected: not grey,
usable, and still usable after a relog.

**Verdict:** take, with our change on top (test hook only).
