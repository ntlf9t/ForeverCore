# advocaite/TrinityCore#323: Transmog: saving an outfit is no longer refused over a different price

Karrz1, 2026-11-07, commit a5568b9364. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Saving an outfit played the purchase sound and kept the old outfit ("player sent invalid cost"). The 1.60 client
and the server disagree on the price in some cases, and a new outfit with no stored slots read past the end of the list.

**Check.**
- **Out-of-bounds read, real.** `HandleTransmogOutfitUpdateSlots` walked the stored slots with one iterator: it searched
  from the last match onward and stepped past it. A slot not stored (or sent out of order) left the iterator at
  `end()`, and the next line dereferenced it (`oldSlotItr->ItemModifiedAppearanceID`), reading past the end of the
  update field's vector. TrinityCore `master` has the same loop. The pull request searches from the start for each slot
  and treats a missing slot as appearance 0 / illusion 0, which is right: a new slot is a change and costs money.
- **Price mismatch.** The server now charges its own price and logs the client's at WARN instead of refusing. The
  player can't pay less by sending a lower price; the only effect is that the charge may differ from what the window
  showed. The comment calls this a "single-player / friends realm"; that isn't true for Everlake, but the change is
  safe either way. Watch `entities.player` for "client price ... differs" to find the cause later.

**Test.** None in `tests/`: the price sits inside the packet handler with the transmog tables, the outfit update fields and
the player's money. In-game test for the PTR realm (best on an ASan build): make a new outfit, assign three slots in a
different order than the character window lists them, save. Expected: saved, money taken equals the window's price or
a WARN line explains the difference; no ASan report.

**Verdict:** take.
