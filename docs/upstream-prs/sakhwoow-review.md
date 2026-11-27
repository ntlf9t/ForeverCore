# Sakhwoow/WoWForever `forever`: review of the 65 commits ahead of Karrz1/TrinityCore `forever`

Sakhwoow/WoWForever is the Azeroth project's hardcore ("Героический") realm, a fork of Karrz1/TrinityCore (GPL-2.0, `COPYING`
inherited; no separate data licence). Branch `forever` at `637626e264` (2026-11-15), 65 commits ahead of `karrz/forever`
(`e6399e4fcb`). Reviewed 2026-11-16 against `everlake` `0d9a4b9145`. Commit messages are mostly Russian; the subjects below are
translated.

## Where their data comes from

Their world and hotfix SQL is made from their own packet captures of the official WoW Forever beta and live servers
(builds 70245-70450, ruRU client), turned into SQL with ForeverSniffTools, which is not published, and neither are the captures.
The repository is GPL-2.0, but the files only state where the data came from, not a licence for it. The underlying content is
Blizzard's. That is the same footing as the 70124 sniff files we already carry. We can't check their numbers against the
captures, only against other sources.

Most of it already reached us: Karrz's data batch 1a (`627e2d8be6`, `karrz-data-1a.md`) took the Azeroth sniffs as
`2026_10_27_70..74` (440 spawns, 40 paths, vendors, trainers, object spawns and node pools, shared bug fixes, the Forever health
curve behind `Classic.ForeverCreatureHealth`), and the kill XP rule came in behind `Classic.ForeverKillXp`.

## Commits

### Taken (new PRs)

| Commit | Subject | PR |
|---|---|---|
| 2e10d8b714 | Network: the address's place is freed when the connection closes; Adventure Guide on | #62 (WorldSocket part; game rule 42 is a realm choice, not taken) |
| 637626e264 | Ghost Wolf: 2645 again (undo 2026_11_13_80/82) | #63 |
| a5c2b04dcb | Scheduled restarts (`ServerAutoShutdown.*`) | #65 (reworked, off by default; `sakhwoow-scheduled-restarts.md`) |

### Already ours

| Commit | Subject | Where |
|---|---|---|
| 749ae0811e | Same name, different surnames (advocaite#68) | merged `cd30a80742` |
| 2554363cd2, c3607900f6, 156295dd47 | advocaite#128, #125, #122 | same patches in `everlake` |
| e9ef292f6c, 53594215b0, b89e91af60 | advocaite#129, #114, #130 | merged |
| e242aa9dd8, 1f6ff8707d, cf6b11c7e7, 89e9abdc42, 33d0f37845, cc9e947402 | advocaite #111, #95, TC#32047, #119, #110, #109 | merged |
| 8f63957824, 2f6ad14c91, 89d424c63f, fefeab465d, ef3fa0796a | Karrz: Zephras class quests, ranged shot models, pet 4 s after login, ticket create time, hunter trainer ranks | merged |
| acadc27a3c, cdc050d79e | Secured-account backpack slots option; keep the saved backpack size | `87e2714e18` (#93) and `Player::_LoadInventory` |
| 9d6cad6fef | Power Word: Shield applies Weakened Soul (advocaite#134) | `classic_spells_priest.cpp` |
| 366cba072f | Shaman Shrine as spell focus (advocaite#133) | our own fix: focus objects at the shrines (`2026_10_27_06`, `2026_11_08_60`) |
| bf1f5bc95f, 3ce8adcedd, 4a0747a8a8 (+ build fixes a69102cb68, 6bb21a08ff, 52f24181e9, 6ec293d9dd) | Classic client hung creating a character on the declined names packet; error dialog; dialog every login | `SetPlayerDeclinedNames::Read` reads the real layout (advocaite#130), answers success when unread or when declined names are off; the flag is sent when there is nothing to ask |
| 39c55ed26e | Crash sending a bug report, suggestion or complaint | fixed the other way round in ours (`fefeab465d`: the statements bind createTime) |
| f9dc07b00e | Crash on a group kill when the loot recipient is not on the map | the assert is gone in ours (falls back to `tappers[0]`); their "a tapper of the same group" choice is a small difference, not taken |
| 4e22868612 (core part) | Kill XP from the lower mob's own base | `Classic.ForeverKillXp` |
| 8b28f54059, 89d8835b8c, 8a0cb2ab23, b81a69ad38, 1dcff213dc, 7ebc96f3ee, a760b433e2, e40e39db70, 1040943c5d, aaa6858a83, 2a5d69c060 | Zephras givers, class masks, Mark of Akir, wardrobe, listen credits, peacekeepers, rogue trainers, deathguards, Dun Morogh/Elwynn, Ironforge trainers, tracking group | see "Zephras and bug-report SQL" |
| 859aaedf14 | Zephras duplicate spawns | Aamelia Windfield: `2026_10_28_83`; Malfunctioning Cyclone Construct: not taken (both spawns are in our own 70124 sniff, 16 yd apart, scripted) |

### Dropped earlier (same verdict)

| Commit | Subject | Why |
|---|---|---|
| a5b8d94066 | 70532 preliminary support (advocaite#121) | obsolete (`advocaite-121.md`) |
| ec23d04264 | Mail recipient lookup (advocaite#70) | replaced by #275 (`advocaite-70.md`) |
| 488e2bde13 | Flametongue damage (advocaite#127) | replaced by #325 (`advocaite-127.md`) |

### Not taken

| Commit | Subject | Why |
|---|---|---|
| 493c7689d0 | Resurrection sickness 10 min at every level (advocaite#135) | vanilla scales it 1 min per level from 11 to 19; no Forever source says otherwise; closed upstream unmerged |
| 83a8c1458f, 82bf3b91be | `.xp rate` personal XP x1-x5 | a gameplay feature, the user's call; see "Features" |
| 2fc2a17357, 46749c2416, 30e2191795 | Hardcore build without bots; #68 back on hardcore; death recap in Russian | their realm only |
| 80e9455fc0, da89a6ddc0, c6f777e112 | Russian book pages, greetings, translations, undead start texts | Russian text only (Samuel's Remains drop in c6f777e112: advocaite#129 is ours) |
| 5cfa05a8ba, 362caeb49d, 20e2aca16b, 4e22868612 (SQL), 89e7cb2b7c | Official server sniff data | see "Data comparison" |
| 78c891d3c2, adba91fd14 | Merges of advocaite `forever` | upstream, reviewed through advocaite |

## Features

**`.xp rate`** (`scripts/World/xp_rate.cpp`, 192 lines, characters table `character_xp_rate`). Every player picks x1-x5;
`OnGivePlayerXP` multiplies the XP, so it covers kills, quests and exploration (all go through `Player::GiveXP`), before the rested
bonus (rest drains as many times faster). Ignored when `Classic.Hardcore = 1`. It works, but as written it is not ready for us:
- on by default (`XpRateCommand.Enable = 1`): merging it would change every realm's rules at once;
- the player messages are Russian only;
- the login reads the rate with a synchronous `PQuery` on the world thread, and writes with formatted `PExecute`, not prepared
  statements or the login query holder;
- the client's quest window still shows the base XP (it computes it itself), only the chat line and the bar show the multiplied XP.

Whether Everlake should have a personal rate at all is a realm rule, not a fix. If yes: port it off by default, with English
`trinity_string` messages, prepared statements and the rate loaded with the character.

**Scheduled restarts** (`World::InitAutoRestartTime`, `ServerAutoShutdown.*`, off by default). Once at startup it works out the
next restart (every N days or one weekday, at `Time` and an optional `Time2`) and, `PreAnnounce.Seconds` before it, starts the
normal `ShutdownServ` countdown. The design is sound (one computation per run; the restarted process computes the next one), but:
- it exits with `SHUTDOWN_EXIT_CODE` (0), not `RESTART_EXIT_CODE` (2) as `.server restart` does. Our containers restart either
  way (`restart: unless-stopped`), but anything that reads the exit code takes it for a stop;
- `mktime` keeps the `tm_isdst` of the current day, so a restart computed across a daylight saving change lands an hour off
  (server time is Toronto, which has DST); `tm_isdst = -1` fixes it;
- the time calculation is in an anonymous namespace in `World.cpp` and has no test.

Taken in #65 with both fixes, a countdown already running left alone, and the calculation tested.

## Zephras and bug-report SQL

Every fix is already in our world, by our own files:

- Rogue and shaman class quests 92483/92484 (giver Rorian, enders Akeri Duskblade / Windshaper Boro, previous 92461): in the
  world since before 10-14, plus `2026_10_24_61`.
- The 60 class masks from Questie: all 60 already carry the same `AllowableClasses` (`2026_10_27_94`, `2026_10_27_95` and earlier).
- Falaath Village 92529 (Mark of Akir 1254832 on accept, the "lost my mark" gossip): `2026_10_27_73`, `2026_11_01_45`.
- Among the Faithful wardrobe 254128 (Eavesdropping 1261177, credit 1254871): `2026_10_26_26`, `2026_11_01_00/01`.
- "Listen" credits for 92708, 93737, 92679: `2026_10_27_29`; Peacekeeper Elite feign death: `2026_10_27_73`; Zephras rogue
  trainers: `2026_10_27_71`, `2026_10_31_50`.
- Father Gavin and the other quest enders without the quest flag, Flintfire's Shipment, Lost Book: the world has them (Lost Book at
  35%, theirs 40%).
- Ironforge: Eldrun Stormbreaker (trainer 10) `2026_10_31_70`; Riley Peltskinner is trainer 1224.
- One form of tracking at a time: in the core (`SpellInfo.cpp`, `SPELL_SPECIFIC_TRACKER`), not a spell group.

No proposal is left.

## Data comparison

Their sniff files (81 files) against our world (the 2026-10-14 world plus every `sql/custom` file of `everlake` and
`wow-everlake-world-data`), by key:

| Table | Theirs | New to us | Notes |
|---|---|---|---|
| quest_template | 152 | 0 | 18 titles differ only because theirs are Russian |
| creature_template | 505 | 1 | Botika Montes 277765, Russian name only (batch 1a left it out for that) |
| creature spawns | 879 | 4 spots | 875 are within 5 yd of ours |
| gameobject_template | 2,085 | 392 | all Russian-named (ruRU capture): Ironforge braziers, chairs, district signs, museum plaques |
| gameobject spawns | 1,675 | 800 spots | 790 use those 392 templates; 748 of them sit within 2 yd of our own object (the same sign, brazier or chair under its vanilla entry); about 42 have nothing of ours near |
| npc_vendor | 427 | 0 | 16 vendors sell more in ours (PvP quartermasters, from Wowhead) |
| trainer_spell, quest_offer_reward, quest_poi, creature_text | 11 / 111 / 156 quests / 61 groups | 1 / 1 / 3 / 11 | small |
| creature faction | | | 10 conflicts (Archmage Celindra 252085 3562 vs our 3591, cockroaches and squirrels 188 vs 5, ...) |

Conflicts with the source order (client/CDN > Wowhead > Questie > Icy Veins): their numbers come from live captures we can't
see; ours mostly from the 70124 sniff, EG Link (live) and Wowhead. Nothing above outranks what we have, and the open factions
need a Wowhead check one by one.

**Recommendation:** take no more of their sniff data. What's useful already came through batch 1a. What's left is Russian text,
copies of objects we already have under vanilla entries (taking them would double them in Ironforge), and about 60 small
rows. Those would come from captures nobody can check and that carry no licence of their own. If we want the ~42 object spots
with nothing of ours near them, or the 11 NPC text groups, take them one by one with English names from Wowhead, the way batch 1a
did. Two core fixes were worth taking (#62, #63). Their `.xp rate` and scheduled restarts are features for the user to decide.
