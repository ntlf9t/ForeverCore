# TrinityCore 7720c7f0c0: SMSG_BUY_FAILED carries the vendor slot

Shauren, 2026-10-10 (cherry-picked from TrinityCore aa1e26ae5b on 3.3.5). Reviewed 2026-11-09 against `everlake`
029c5dd9ca.

**Claim.** The `Muid` of `SMSG_BUY_FAILED` is the vendor slot plus 1 (the number the vendor list gives each item), not
the item or currency id.

**Check.** Same writer (vendor GUID, uint32 Muid, int32 reason). On Everlake the vendor list already sends
`MuID = slot + 1` (`ItemHandler.cpp`, "client expects counting to start at 1") and `SMSG_BUY_SUCCEEDED` already sends
`vendorslot + 1`, so the failure now names the item the same way the success does. Error paths without a slot (buyback,
charters, `.debug`) send 0 + 1. Forever code left behind: Everlake's currency price overflow check in
`BuyCurrencyFromVendorSlot` still passed the currency id; our commit "Forever code: SMSG_BUY_FAILED gets the vendor slot
in the overflow check" passes `vendorSlot`.

**Test.** None in `tests/` (needs a vendor). PTR check: try to buy an item you can't afford, and one above your
reputation: the right error text, nothing else changes in the vendor window.

**Verdict:** take, with our fix for the overflow check.
