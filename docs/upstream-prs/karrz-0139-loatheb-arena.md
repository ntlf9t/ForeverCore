# Karrz 0.1.39: Loatheb's Corrupted Mind, arena crash fixes

Taken by hand from Karrz1/ForeverCore `forever-bots` `b441bf74e0` (0.1.39).

## Loatheb: Corrupted Mind

Loatheb's 29201 gives each healer 29185 / 29194 / 29196 / 29198; their next heal casts the 60 s lock 29184 / 29195 / 29197 /
29199 (aura `SPELL_AURA_OVERRIDE_CLASS_SCRIPTS`, misc value 4327). Nothing read misc value 4327, so healers healed through the
whole fight, and with no `spell_proc` row any helpful spell (buffs, Inner Focus, Resurrection) set off the lock.

- `Spell::CheckCast` (`src/server/game/Spells/Spell.cpp`, before the script hook): under the lock, a spell with a heal
  effect or a periodic heal aura fizzles, and so does Holy Shock on a friend. Triggered spells and item spells (potions,
  healthstones, bandages) still work. Karrz's block as he wrote it.
- `sql/custom/world/2026_11_19_60_world_classic_loatheb_corrupted_mind_heals_only.sql`: `spell_proc` for the four
  triggers, only a heal that lands sets them off. The PTR had no rows for them.

## Arena crash fixes

- `BattlegroundMgr::CreateNewBattleground`: a template that only picks another one ("All Arenas" 6, the random
  battlegrounds) has no start points, and `SendToBattleground` read them for everyone who entered, so playing it
  crashed the server (`.debug arena 6`). It is now refused with an error in the log.
- `BattlegroundMgr::ToggleArenaTesting`: the arena test plays the template itself, so it refuses one without start points.
- `BattlegroundScore::GetAttr`: the statistics row asks for 5 values; on a map with fewer pvp stats `std::next` stepped
  past the end of the map. It now checks the index first.

Left out: Karrz's `MissingMapData` part of the same change (turns a battleground off when its map files are missing
on the server, with join refusals and log lines). It is for installs with incomplete game data and is not a crash fix.

## Checked

- `clang++ -fsyntax-only` on `Spell.cpp`, `BattlegroundMgr.cpp`, `BattlegroundScore.cpp`: clean.
- The SQL file runs twice on a scratch MySQL with the stock world schema, 4 rows both times.
- **Not done:** worldserver start, Loatheb fight, an arena in game.
