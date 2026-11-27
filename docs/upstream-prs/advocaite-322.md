# advocaite/TrinityCore#322: Auction house: full scans by add-ons such as Auctionator see the items

Karrz1, 2026-11-07, commit 31c33317b3. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Auctionator's full scan came back empty. The replicate scan (`CMSG_AUCTION_REPLICATE_ITEMS`) failed three ways:
a count of 0 returned nothing, a new scan after an earlier one got an empty answer until the 15 minute cooldown ran
out, and stackable goods were sent without their item.

**Check.**
1. Count 0: `BuildReplicate` returned at once for `!count`; TrinityCore `master` does the same. The pull request reads 0
   as "everything".
2. Restart: once a player has a throttle entry, any request whose change numbers don't match it is ignored. A new scan
   (0, 0, 0) never matches (the entry's `Global` is never 0), so it was ignored until `Update` dropped the entry at the end
   of the cooldown. That is TrinityCore's intended 15 minute limit for a finished scan; the problem is a scan that is
   never finished. A count-0 answer ends with cursor = last auction and tombstone 0, which counts as "in progress" until
   the client asks once more. The pull request restarts an unfinished scan at once.
3. Items: commodities were sent without `Item` (retail has a separate commodity scan; Classic 1.60 does not), so an
   add-on couldn't tell what they were. Now every auction carries its item.

**Our change on top.** With (1) and (2) together, a client or add-on that sends fresh scans in a loop got the whole auction
house on every request (the opcode is allowed 100 times a second, and each answer leaves the scan "in progress" again).
A restart now needs the last scan to be at least 60 s old (`ReplicateRestartDelay`); finished scans keep the 15 minute
`Auction.ReplicateItemsCooldown`.

**Risk.** A count-0 answer is one packet with every auction. With the auction bot's thousands of listings that is a
large packet (each `AuctionItem` now carries an item instance). Not measured; watch it on the PTR.

**Test.** None in `tests/`: `BuildReplicate` needs a `Player` and a filled auction house. In-game test for the PTR realm with
the auction bot running: open the auction house with Auctionator, run a full scan. Expected: it lists the items,
commodities included. Run it again at once: refused; after a minute: allowed. Note the scan time and the server's
world update time (`.server info`) during it.

**Verdict:** take, with our change on top.
