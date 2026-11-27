# advocaite/TrinityCore#303: Camping: the sit emote starts the campfire rest, and tier 2/3 features give their buff

Karrz1, 2026-11-07, commit 9ce88b7063. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** (1) A typed /sit in another language (ruRU) reaches the server only as the sit text emote, so the campfire
rest (1289723) never started. (2) The Fermenter, Fishing Hut, Fishing Rack, Greenhouse, Master Forge and Plague
Doctor's Laboratory "provide all of the benefits" of the feature they replace, but gave nothing.

**Check.**
1. The text emote handler did nothing for `EMOTE_STATE_SIT`. Now, for a standing, unmounted player out of combat, it sets
   the sit stand state and runs the same campfire check as `HandleStandStateChangeOpcode` (moved into
   `WorldSession::UpdateCampfireRest`). When the client sends both packets, the second finds the player already sitting
   (emote first) or the rest aura already on (stand state first), so the rest is not cast twice. The emote handler
   already returns for dead players.
2. Client data (1.60.1.70862 `Spell`, `SpellEffect`, `SpellName`): each placement spell (1307242, 1307246, 1307247,
   1307248, 1307261, 1307265) summons exactly the game object the pull request lists (effect 50), and each description
   names the feature it replaces; the buffs match that feature's row. **But** none of the six game objects
   (612120, 612092, 612090, 612087, 612136, 612110) has a `gameobject_template` row in the 2026-10-14 world release or
   in the fork's SQL, so on our data the features can't be placed and these rows do nothing yet. The pull request was
   tested on Karrz's own world data.

**Test.** None in `tests/`: both parts need a player, a campfire and nearby game objects. In-game test for the PTR realm:
with the client set to ruRU (or any locale), type the local /sit next to a campfire. Expected: you sit and get the 60 s
rest, then Boosted Rest. Part 2 can only be tested once the six templates exist.

**Verdict:** take. Part 2 needs the six `gameobject_template` rows before it does anything here.
