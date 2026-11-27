# TrinityCore dcd1dab142: reduce differences between branches (bank, Bloodmyst)

Shauren, 2026-10-23. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** `WorldSession::CanUseBank` moves from `ItemHandler.cpp` to `BankHandler.cpp` and the auto bank handler moves
below `HandleBankerActivateOpcode`; `CancelCast` reads its two fields in two lines; tidy-ups in the Bloodmyst Isle
escort script `npc_demolitionist_legoso` (empty-list checks, the event starter is cleared on reset).

**Check.** Code moved unchanged (compared side by side), same reads in the same order. Bloodmyst Isle is not Classic
content; the escort only runs where its NPC is spawned. Applied without conflict.

**Test.** Build only (`zone_bloodmyst_isle.cpp` is built in the local check).

**Verdict:** take.
