# Karrz 0.1.39 / 0.1.39.1: bots

The bot part of Karrz1/ForeverCore `forever-bots` from 0.1.38 (`8e679df0e1`, merged in #105) to 0.1.39.1 (`7509ecbfcc`),
taken as a three-way patch of `src/modules/PlayerbotV2` and `sql/playerbot_v2`, plus the core pieces the bots call. Not a
whole-tree merge: the rest of 0.1.39 comes in its own reviewed PRs (#118-#121).

## What the bots get (Karrz's 0.1.39 notes)

- Naxxramas: a plan for every boss (Patchwerk to Kel'Thuzad), still being tuned; AQ40 Sartura, Fankriss, Twin Emperors,
  C'Thun; BWL Razorgore's Conflagration. Raid healers cover the tank before the next hit; raid buffs no longer drink
  between blessings.
- Dungeon routes (`sql/playerbot_v2/0043`-`0053`): Alcaz Prison, Blackmaw Hold, Shaper's Terrace, Krol'dok Stronghold,
  the Drowned City, City of Dalaran, Hall of Thanes, Dire Maul, Blackrock Depths, Upper Blackrock Spire, Sunken Temple and
  Maraudon. The bot dungeon finder lists the Forever dungeons.
- Tanks wait for Polymorph, kill summoners first, walk round exit portals; the group leaves a crowd-controlled mob alone.
- Hunter companions get their pet at once; druid tanks stay in bear form; bots ride their own race's mount; each faction's
  zones hold that faction's bots; gear choice (shields, off-hands, armor type, unique rings and trinkets).
- Bot chat in Russian too; "gather on" skins the group's kills; "enchant <item>"; trades to your own bot are gifts.
- Bots plan around closed doors (they stood at the Hall of Thanes' shut Iron Door for two minutes before) and keep their
  swim depth without cutting into a bank.

## Core pieces taken with it

- Closed doors for paths planned off the map thread: `ClosedDoorShape.h` (new), `Map::PublishClosedDoors` /
  `GetPublishedClosedDoors` / `SetClosedDoorPlanThroughCheck`, `PathGenerator::ClosedDoorTest` (the door callback now
  returns None / Live / Published instead of a bool).
- `PathGenerator::FinishPath` replaces our `AdjustWaterRoute` (core PR #110). Karrz took our swim fix into his tree and
  extended it; the module side (`BotSwimRouteDepth`) now also keeps a lowered point at the navmesh height when its leg
  would cut into a bank. `docs/everlake-changes.md` updated.
- `Map`: an asked-for respawn (`.respawn`, a boss script) no longer waits for the old corpse to decay.
- `Group`: a raid the leader made by hand (`CMSG_CONVERT_RAID`) is not turned back into a party; members go back to
  sub group 1 when a raid becomes a party (party auras and totems check the sub group). `BotGroupRules::RevertBotRaidToParty`
  takes the new `chosenByLeader` argument; `tests/game/ClassicBotGroupRules.cpp` follows.
- `WorldSession`: `IsKickRequested()` and an atomic `forceExit` (Karrz PR #370), for bot sessions with no socket.
- Add Friend on a bot: `WorldSession::SetAutomatedAccountCheck` / `AddCharacterFriend` (`SocialHandler.cpp`) and
  `FriendsService` make a bot a character friend instead of a Battle.net invitation nobody answers;
  `sql/custom/auth/2026_11_19_83_auth_bot_friend_invitations.sql` deletes the invitations already sent to bot accounts.
  `FriendsService` is Karrz's version of our own `.battletag` code (he took it from us), with a surname-optional character
  lookup for Add Friend and `UPDATE IGNORE` on a tag race.
- `WORLD_SEL_BOT_REALM_ITEMS` (`WorldDatabase`), used by the bots' gear lists.

## Conflicts

- `BotItemScorer.cpp`, `BotSnapshotBuilder.cpp`: ours (`ITEM_FLAG5_CLASSIC_REDUCED_CASTER_DPS`, our flag name).
- `RaidBrain.cpp`: a comment on the resist formula; ours (it describes our formula).
- `BotSwim.h`, `PlayerbotV2Scripts.cpp`, `PathGenerator.h` / `.cpp`: Karrz's (see above). `LootDrainRules.cpp`: his
  `SkinnableForBot`, with our `/*now_ms*/` kept (CI builds warnings as errors).
- `BotPopulationManager.cpp`: both include lists. `FriendsService.h` / `.cpp`: his.
- `RaidMechanics_Naxx.cpp`: `kMarkLastsMs` is unused in Karrz's tree too; `[[maybe_unused]]` so clang's warning doesn't stop CI.

Our later bot commits checked: AH bot faction houses (c5093d94c7), caster weapon flags (de1b2d4327), gcc warning
(c04c69f97d), Preservation Evoker (91ba86daf2) still apply as they were; the warning cleanup (7bf619c488) and gear
scoring (d9d961403b) are in, with the flag rename on top.

Not taken: Karrz's new tests (this fork doesn't carry them), `CombatLogWatch` (only `WorldSession.cpp`'s call to it, left
out), `NormalizeDependentChoices` (declared in `WorldSession.h` with the friend changes, not defined or called here).

## Checked

- `clang++ -fsyntax-only` with the CI warning flags (`-Wall -Wextra ...`) on all 77 changed `.cpp` files: clean.
- **Not done:** a build and link (CI), bots in game, the playerbot_v2 migrations on a database.
