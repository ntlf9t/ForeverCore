# TrinityCore 73e86e6bd5: reduce differences between branches (vendor errors, misc)

Shauren, 2026-10-10. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** `Player::SendBuyError` loses its unused fourth argument and both buy and sell errors take a `const`
creature; a stray include goes from `SocialHandler.cpp`; `.gobject add` takes the spawn's data from the new object; a
comment fix in `_LoadInventory`.

**Check.** No change in what is sent. Forever code that would not build: Everlake's currency price overflow check in
`BuyCurrencyFromVendorSlot` (`Trinity::VendorPrice::ForCurrency`) passed the old fourth argument. Fixed in our commit
"Forever code: SendBuyError without the unused fourth argument", right after the pick. `SocialHandler.cpp` in Forever
(Battle.net friends, contact list) uses no database type from the removed `DatabaseEnv.h`. No other caller of
`SendBuyError` / `SendSellError` in `src/server/scripts` or `src/modules`.

**Test.** Build only (the changed script files `cs_debug.cpp`, `cs_gobject.cpp` are built in the local check).

**Verdict:** take, with our build fix.
