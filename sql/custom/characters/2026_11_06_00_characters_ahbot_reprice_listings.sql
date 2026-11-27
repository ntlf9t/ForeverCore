-- 0.1.31 raises the auction house bot prices (AuctionHouseBot.Vanilla.ValueCurve.* in zz-1-wow-forever-realm.conf).
-- Bot listings made before stay at the old low price until they run out, up to 3 days. This ends the bot listings
-- nobody has bid on at the next start (the same as ".ahbot rebuild" in the server console), so the seller lists
-- them again at the new price. Player listings and bot listings with a bid are not touched. Safe to run again.
UPDATE `auctionhouse` SET `endTime` = UNIX_TIMESTAMP()
WHERE `bidAmount` = 0 AND `endTime` > UNIX_TIMESTAMP()
  AND (`owner` = 0 OR `owner` IN (SELECT `guid` FROM `characters` WHERE `account` = 2000000001));
