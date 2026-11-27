# Trixx34 b068f592b9: bot sessions without collections or a battle pet journal

Yves Troch, 2026-10-15, Trixx34/Trinity-Forever-Modules (GPL-2.0). Reviewed 2026-11-16 against `everlake` 0d9a4b9145. Ported as
an idea, not cherry-picked: their tree makes bots through a core `BotMgr`, ours through PlayerbotV2's `BotSession`.

**Claim.** Bots have no client and never use collections, battle pets, achievements or quest-objective criteria, so a bot session
should not allocate `BattlePetMgr`, `CollectionMgr`, `PlayerAchievementMgr` or `QuestObjectiveCriteriaMgr`. Every use a bot can
reach is guarded against a missing manager. Written for 1,500 bots; their RSS measurement is listed as still to do.

## Check

- **What a bot session holds today.** Every `WorldSession` makes a `CollectionMgr` and a `BattlePetMgr`. PlayerbotV2's
  `BotSession` calls `InitializeSession()`, which runs ten login-database queries for them (toys, battle pets, pet slots,
  heirlooms, mounts, appearances, favourite appearances, illusions, outfits, warband scenes) and loads the results. Each bot then
  grows its appearance bitset (`boost::dynamic_bitset`, one bit per `ItemModifiedAppearance` id up to the highest it touches)
  with every item it equips, loots or is rewarded, and `Player::SaveToDB` writes every non-empty bitset block, every mount and
  every toy back to the login database at every save.
- **Quest objectives need `QuestObjectiveCriteriaMgr`: kept.** 74 Forever quests (camping, "Raise your X skill to 20",
  Skyborne starters) use criteria-tree objectives (type 14). Without the manager bots could not finish them.
- **`PlayerAchievementMgr`: kept.** It holds little per bot, and PlayerbotV2 `/achieved` uses `HasAchieved`. Their version needed
  safe defaults on every Player achievement accessor for it; not worth it unless a measurement shows otherwise.
- **Player alts.** On Everlake a player's own alt can run as a bot (`.playerbot summon`, the add-on's Log In). Its session is a
  `BotSession` on the player's account, and its collections are the player's: account mounts are learned by the alt through
  `CollectionMgr::LoadCharacterData`, and what it collects goes to the account. Their change drops the managers for every bot
  session; ours only for bot pool accounts (`BotAccountMgr::is_pool_account`).
- **Mounts.** A mount a bot learns (bought from a vendor, `LearnSpell(spell, false)`) is a normal character spell and saved per
  character; the collection only re-teaches account mounts as dependent spells, which are not saved. So a pool bot keeps every
  mount it learned itself. What it loses is a mount learned by another bot on the same pool account: before, that mount came to
  every character on the account. Bots pick their mount from their spell list (`BotSnapshotBuilder`), so such a bot walks until it
  buys its own, as it would in Classic.
- **Guards.** `git grep 'GetCollectionMgr()\|GetBattlePetMgr()\|_collectionMgr\|_battlePetMgr'` in `src/` on `everlake`: 125 lines. Every use now
  checks for the manager (or sits in a handler that returns early without it). Criteria and conditions read a missing manager as
  "has none"; `PlayerHasMount` (modifier tree 183) falls back to the character's own mount spell. Nothing in `src/modules` uses
  either manager.
- **Their code.** Their `InitializeSessionCallback` tests `isBot`, a constructor argument that is not in scope there. Their tree
  has a session-level `SetBot()` and a different constructor; neither matches ours.

## What changes here

- `WorldSession::DropClientOnlyManagers()`: frees both managers, only on a bot session with no character loading or logged in
  (`MayDropClientOnlyManagers`). `GetCollectionMgr()` and `GetBattlePetMgr()` can then return nullptr.
- `InitializeSession` leaves the ten collection queries out of its holder for such a session, and the callback skips the loads.
  The other queries (character counts, account player data) are unchanged.
- `BotSession`'s constructor calls it before `InitializeSession()` for a pool account when `Playerbot.Perf.LeanBotSessions = 1`
  (default). `0` turns it off for bot sessions made after `.reload config`; no rebuild.
- Rows the pool bots already have in the login database (mounts, appearances...) stay; they are just no longer read or written.

## Test

`tests/game/BotSessionManagers.cpp`: a bot `WorldSession` is made with both managers, `DropClientOnlyManagers()` frees both, a
second call is harmless and the session ends cleanly without them; `MayDropClientOnlyManagers` refuses a player's session and a
bot with a character loading or in the world. Fails to build without the change (no `DropClientOnlyManagers`). Every changed
file passed a local syntax-only compile; CI builds and runs the tests.

## Measuring it

Not measured yet: this machine runs no realm. The expected win is modest per bot (the appearance bitset is a few to a few tens of
KB once a bot has worn gear, plus the hash maps and both objects) and the larger part is login-database work: ten queries per bot
login and the collection rows rewritten at every bot save. To measure on the test realm, same scenario twice:

1. `Playerbot.LoadTest.Enable = 1`, `Playerbot.LoadTest.Label = "lean0"`, `Playerbot.Perf.LeanBotSessions = 0`. Start, let the
   500 bots log in and play 20 minutes. The CSV (`playerbot_loadtest.csv`) has `rss_mb` per minute; the `[mem]` log line has
   `rss_mb` and `private_mb` with the bot count.
2. Same with `Label = "lean1"`, `LeanBotSessions = 1`, after a restart (a session made earlier keeps its managers).
3. Compare `rss_mb` at the same `bots_online`. For the database side, before step 1:
   `SELECT COUNT(*) FROM battlenet_item_appearances WHERE battlenetAccountId IN (<pool bnet ids>)` is the number of rows rewritten
   at each save of those bots; with the switch on it stops growing.

**Verdict:** take the idea for collections and battle pets, pool bots only, behind a switch; leave achievements and quest-objective
criteria as they are.
