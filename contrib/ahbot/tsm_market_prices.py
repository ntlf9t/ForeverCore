#!/usr/bin/env python3
# This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
#
# This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public
# License as published by the Free Software Foundation; either version 2 of the License, or (at your option) any later
# version.
"""Auction house bot market prices from TradeSkillMaster's public WoW Forever pricing data.

TradeSkillMaster publishes a free CSV of region-wide prices for WoW Forever (no account or key):
    https://public-data.tradeskillmaster.com/forever/<us|eu>/region/items.csv      (https://tradeskillmaster.com/public-data)
This script turns it into SQL for world.auctionhousebot_market_price (read by AuctionHouseBot.Vanilla.MarketPrices = 1 and
AuctionHouseBot.Vanilla.MarketPrices.Only = 1). UnitPrice is TSM's marketValue in copper per unit. Items TSM does not list
keep their row, so nothing loses a price.

TSM's terms: use the data freely in your own servers, bots and tools; download each file at most once per update (it
changes daily; this script asks only for a newer file than its cache); do not republish the data in bulk. So the prices are
fetched by each server and must not be committed to a repository. Pricing data from TradeSkillMaster
(https://tradeskillmaster.com).

Usage:
    contrib/ahbot/tsm_market_prices.py --region us > tsm_prices.sql
    mysql world < tsm_prices.sql          # then restart the worldserver (the bot reads the table when it starts)
Options: --cache FILE (default: tsm-forever-<region>-items.csv next to this script), --csv FILE (use a file you already
have, no download).
"""
import argparse, csv, email.utils, os, sys, urllib.error, urllib.request

URL = "https://public-data.tradeskillmaster.com/forever/{region}/region/items.csv"


def download(url, cache):
    """Fetch url into cache unless TSM's file is not newer than the cached copy (If-Modified-Since)."""
    req = urllib.request.Request(url, headers={"User-Agent": "TrinityCore auction house bot price import"})
    if os.path.exists(cache):
        req.add_header("If-Modified-Since", email.utils.formatdate(os.path.getmtime(cache), usegmt=True))
    try:
        with urllib.request.urlopen(req, timeout=60) as r:
            data = r.read()
            modified = r.headers.get("Last-Modified")
    except urllib.error.HTTPError as e:
        if e.code == 304:
            print(f"-- {url} not changed since the cached copy, using {cache}", file=sys.stderr)
            return
        raise
    tmp = cache + ".tmp"
    with open(tmp, "wb") as f:
        f.write(data)
    os.replace(tmp, cache)
    if modified:
        t = email.utils.parsedate_to_datetime(modified).timestamp()
        os.utime(cache, (t, t))
    print(f"-- downloaded {url}", file=sys.stderr)


def main():
    a = argparse.ArgumentParser(description=__doc__.split("\n")[0])
    a.add_argument("--region", choices=("us", "eu"), default="us")
    a.add_argument("--cache")
    a.add_argument("--csv", help="read this file instead of downloading")
    a = a.parse_args()

    path = a.csv
    if not path:
        path = a.cache or os.path.join(os.path.dirname(os.path.abspath(__file__)), f"tsm-forever-{a.region}-items.csv")
        download(URL.format(region=a.region), path)

    rows, scans = [], set()
    with open(path, newline="", encoding="utf-8") as f:
        r = csv.DictReader(f)
        need = {"itemId", "marketValue", "soldPerDay", "updatedAt"}
        if not need <= set(r.fieldnames or []):
            sys.exit(f"unexpected columns in {path}: {r.fieldnames} (need {sorted(need)})")
        for row in r:
            try:
                item, price = int(row["itemId"]), int(row["marketValue"] or 0)
                sold = min(round(float(row["soldPerDay"] or 0)), 4294967295)
            except ValueError:
                continue
            if item > 0 and price > 0:
                rows.append((item, price, sold))
                scans.add(row["updatedAt"])
    if len(rows) < 1000:
        sys.exit(f"only {len(rows)} priced items in {path}: refusing (format change or bad download?)")

    out = sys.stdout
    out.write(f"-- Auction house bot market prices: {len(rows)} items, TSM WoW Forever {a.region} region data "
              f"(scan {', '.join(sorted(scans))}). Pricing data from TradeSkillMaster (https://tradeskillmaster.com).\n"
              "-- Quantity = TSM soldPerDay (informational), Samples = 0. Items not listed keep their row. Safe to run again.\n")
    out.write("START TRANSACTION;\n")
    for i in range(0, len(rows), 1000):
        out.write("INSERT INTO `auctionhousebot_market_price` (`ItemID`, `UnitPrice`, `Quantity`, `Samples`) VALUES "
                  + ",".join(f"({x},{p},{q},0)" for x, p, q in rows[i:i + 1000])
                  + " ON DUPLICATE KEY UPDATE `UnitPrice`=VALUES(`UnitPrice`), `Quantity`=VALUES(`Quantity`), `Samples`=0;\n")
    out.write("COMMIT;\n")
    print(f"-- {len(rows)} items written", file=sys.stderr)


if __name__ == "__main__":
    main()
