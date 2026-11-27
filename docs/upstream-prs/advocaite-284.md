# advocaite/TrinityCore#284: Auction house: each player's auctions are kept in a set, not a multimap

Karrz1, 2026-11-06, commit bae281da6f. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Removing one auction from the owner multimap walks every auction of that owner. The auction bot sellers own
thousands each, so expiring them after a long stop took minutes and froze the world thread.

**Check.** True. `Trinity::Containers::MultimapErasePair` walks the owner's whole equal range, so removing all n
auctions of one owner costs n^2/2 steps. TrinityCore `master` has the same multimap. The pull request uses an
`unordered_set<uint32>` per player for owned and bid-on auctions, and drops the player's entry when the set is empty.
Every reader and writer of the two containers changed: add, remove, owned list, bidded list.

**Conflict.** `everlake` has `AuctionHouseObject::GetOwnedAuctionIds` from forever-bots (used by the PlayerbotV2
`auction_cancel_all` and the bot snapshot), which read the old multimap. Resolved by making it copy the owner's set;
nothing else conflicted. Neither caller depends on the order of the ids (a multimap equal range had none either).

**Also seen, not changed:** a bid placed after start-up adds the bidder to `BidderHistory` (AuctionHouseHandler.cpp)
but not to `_playerBidderAuctions`, so "Bids" doesn't list that auction until the next restart. Same in TrinityCore
`master`, older than this pull request.

**Test.** None in `tests/`: the bookkeeping is inside `AddAuction`/`RemoveAuction`, which need items, the auction manager and a
database transaction. In-game test for the PTR realm: post three auctions, cancel one, check "Auctions" lists two;
let the auction bot fill the house, restart after its auctions expire and time the start-up and the first expiry pass
(world thread lag in `.server info`).

**Verdict:** take (conflict resolved as above).
