# advocaite/TrinityCore#328: PlayerbotV2: talent builds on non-English realms, questrun, traitcheck assert, round-robin setup

MShkolenko, 2026-11-08, commits f8cbc20857, 2116d65b8b, edcf207ea4 (all three carry the same message). Targets
advocaite's `forever-bots`; its base 19bdc6af66 is the `forever-bots` copy already in `everlake`, so it merged cleanly.
Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim and check, by part.**
- **Talent builds on non-English realms** (`Api/ClassicSpec.cpp`). The builds name talents in English, but the class talent
  index was keyed by the realm's DBC locale and `TalentKey` drops non-ASCII bytes, so on ruRU every pick was "not
  found". The index now also takes a built-in table of English names for 399 class talents, 1.12 spellings first.
  Checked the table against the 1.60.1.70862 `SpellName`: all 396 spells present have exactly the 1.60 name listed; 3
  (20234, 22571, 407669) aren't in that table and are harmless. 40 rows carry an older 1.12 name (Improved Fireball →
  Accelerant, Elemental Mastery → Lightning Mastery ...). **This also changes enUS realms:** the 1.12 names now go in
  first, so where 1.60 renamed a talent to another talent's old name, a build's old name now picks the old talent. That
  is what the builds mean, but enUS bots may place a few points differently than before.
- **`.playerbot questrun <bot> <questId> [specId]`** (`Commands/cs_playerbot_v2.cpp`), GM only, bots only (`is_bot` check).
  Each call does one step: spec and talents, level up, repair, **destroys every non-quest item in the bot's bags**, regears,
  teleports to the giver, accepts. Caches are function-static (`s_givers`, `s_specDone`, `s_prepared`) with no lock;
  safe while commands run on the world thread, as console and chat commands do here. Test tooling, not gameplay.
  `BOT_COMMANDS.md` doesn't list it yet.
- **traitcheck assert.** True: a `TraitDefinitionEffectPoints` row naming an effect index the spell lacks made
  `SpellInfo::GetEffect` assert (`index < _effects.size()`), crashing the world server from a GM command. Now it's
  reported as a `DATA:` note. `EffectIndex` is `int32`, so the `< 0` test is meaningful.
- **Round-robin setup pass** (`Fleet/BotPopulationManager.cpp`). True as described: the pass walked the registry from the
  front each tick and stopped after 30 ms, so one bot whose setup never finished could starve the rest. The pass now
  rotates the list to start after the last visited bot (static cursor, advanced in a scope guard by the number visited).
  The bot where a pass stopped (budget or 10 driven) is first next time.

**Test.** No unit tests: every part needs live bots, a session or the trait tables. PTR (bots on): `.playerbot traitcheck`
on a level 43-45 warlock and mage bot: no crash, `DATA:` lines in TraitCheck.tsv where the data is short;
`.playerbot questrun <bot> <quest>` repeated until "accepted"; watch that bots' setup states all reach done after a
restart (none stuck at 0 for long).

**Verdict:** take.
