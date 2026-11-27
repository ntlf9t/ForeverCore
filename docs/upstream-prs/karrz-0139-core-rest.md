# Karrz 0.1.39 core: the rest

The core part of Karrz's 0.1.38 -> 0.1.39 diff (8e679df0e1..7509ecbfcc) that the earlier Karrz PRs did not already bring,
applied 3-way. Bots (PlayerbotV2) came in their own PR; world, hotfix and quest data in theirs; Karrz's unit tests are left
out (Everlake does not carry most of them).

## Taken

- Auction house: "usable only" checks weapon and armor proficiency; buying exactly to a stack's end works; the deposit given
  back is the bought share of what is left (no double refunds); a won listing with many stacks goes out in several mails.
- Loot rolls refuse votes the roll does not offer; a disenchanted item leaves the corpse.
- Pet trainers open the ordinary trainer window.
- Realm list: a wrong client build gets "version mismatch" instead of looking like a closed realm. Client 71037 build row.
- Legacy achievements: each one keeps its owner and date and is sent to the client (account-wide Legacy Points).
- Bank: quest objectives count only what was moved; guild repair paid before the repair; money objectives on turn-in;
  customization choices normalised at login (and the Skyborne feather fix for existing characters).
- Languages: characters no longer get the other faction's language at 1/300 (core, plus a characters cleanup).
- Shieldsworn (spells can be blocked, aura 528), Redemption Armor 2-piece, Unflinching Morale, Sweeping Strikes not flagging
  PvP, the druid energy-tick null fix, flat damage reduction capped at half the hit, creature spell twins.
- First-tag rule: a player who joined the tag owner's group can still add to the tag.
- Commands: `.gm combatlog [group|off]` (RBAC 1003), `.deathrecap [name]` (RBAC 1004), `.modify currenthp`.
- Players lose `.summon` (they bring their bots with the bot commands).
- Instance and boss fixes in Dire Maul, Razorfen Kraul, Naxxramas (Gluth, Kel'Thuzad), City of Dalaran, The Drowned City.
- Battleground MissingMapData check (a battleground whose map files are missing is turned off). It does nothing on a full
  install; it came with the rest of the battleground changes.

## Kept as Everlake's

- The three dungeons Everlake built itself (Alcaz Prison, Blackmaw Hold, The Shaper's Terrace) and Krol'dok: Karrz wrote
  its own instance scripts for them; ours match our world data.
- Everlake's BattleTag (`.battletag`): Karrz's separate BattleTag code is not taken.
- Daze chance (Everlake's live audit formula), no per-level spell resistance bonus, health regen multiplier, reputation
  discount helper, ground-area damage ticks, Viktor the Vile event, Ruins of Lordaeron boss tracking.
- Pieces already ported in the earlier Karrz PRs (weapon damage, versus bonus, class and item scripts) are kept once.
- Deleted characters still count for account Legacy achievements.
