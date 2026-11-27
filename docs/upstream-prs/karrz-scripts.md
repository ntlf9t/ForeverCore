# Karrz scripts batch: Classic scripts, City of Dalaran, raid bosses, class talents

**Source:** branch `karrz-releases`, tag `karrz-v0.1.33` (Karrz1, 2026-11-08). Stacked on Karrz data batch 1a (#22).
**Verdict:** taken, with the changes below.

## What it brings

- `src/server/scripts`: every file Karrz changed (60), merged three-way against his base (advocaite `forever` `f63ffc12`) so our
  own changes stay. New: City of Dalaran (seven bosses, Shade of the Archmage, sewer grate, doors and Purple Parlor portals),
  Excavation Site in the Wetlands, rogue abilities, priest spells, Dragons of Nightmare world event. Updated: Classic talent and
  spell scripts (warrior/rogue/hunter, mage/shaman, warlock/druid, priest/paladin), Zul'Gurub (Thekal trio), Ruins of Ahn'Qiraj
  (Rajaxx waves, Andorov), Blackwing Lair (Chromaggus lever), Molten Core (runes and Ragnaros options), Scholomance, Blackrock
  Spire, Alterac Valley (assaults, commanders, armor upgrades, reinforcement counter), Arathi Basin / Warsong Gulch scoreboard.
- Core, only what these scripts need: `ClassicLegacyPerks.h` and `ClassicAuraCaster.h` (header-only, pure data/logic) and the
  `Battleground.AlteracValley.ReinforcementDefeat` option (World.h/.cpp, worldserver.conf.dist; default 1 as Karrz ships it,
  0 = vanilla rules).
- SQL: the 75 Karrz files held back from batch 1a minus 2 (below): they bind spells and NPCs to these scripts and take 203
  retail spell scripts off Classic spells (Karrz: they fail Validate() on the 1.60 client and never attach; they were 266 error
  lines in every start log).

## Merge decisions

- About 120 conflict blocks. 90 were "both added", ours a subset of Karrz's; 26 more differed only by our no-PCH `#include`
  lines (kept) or comments; the rest were read one by one. Karrz's side won where it is the later form of the same code
  (Molten Core options, Skyborne racials, Alterac Valley armor upgrade moved to `UpgradeArmor`).
- Arathi Basin / Warsong Gulch: Karrz's PvP stat ids (122/123, 42/44) are the 1.60 client's; ours (926-929) belong to the
  remakes, which left those scoreboard columns empty.
- `cs_debug.cpp` and `KhazAlgar/TheStoneVault/boss_edna.cpp` stay ours: Karrz's one-line changes adapt them to his core API.
- One block of the Blackrock Spire instance script came out twice from the merge; removed. Every merged file was scanned for
  other repeated blocks: none.
- **advocaite/TrinityCore#325 vs Karrz's talent scripts.** Both handle some of the same procs; Karrz's world never had #325, so
  a spell carrying both is untested. Rule: where Karrz's data gives a spell its own script, Karrz owns it; #325 stays where
  Karrz has nothing.
  - Kept from #325 (in `classic_spell_scripts.cpp`, with our `ClassicProcRules.h`): Flametongue, Windfury, Grave Touch and the
    proc-chance script on the talents Karrz leaves alone.
  - Karrz's implementation: Lightning Shield, Reckoning, Missile Barrage (same script names), Nightfall, Reckoning's attack
    counter; and the proc-chance script comes off Frostbite, Winter's Chill, Arcane Concentration, Unbridled Wrath, Improved
    Kick, Initiative, Ruthlessness, Improved Starfire and Illumination
    (`2026_11_09_60_world_karrz_scripts_proc_owners`).

## Left out

- `2026_10_21_30_world_classic_warrior_overpower_probe`, `2026_10_21_31_world_classic_warrior_execute_damage_probe`: Karrz's
  debug probes, logging an ERROR line on every Overpower / Execute cast (hundreds of warrior bots). The C++ is built, unused.

## Our additions

- `2026_11_09_61_world_karrz_scripts_strat_service_entrance`: Karrz's quest-data restore (batch 1a) writes the Stratholme
  Service Entrance Gate (175368) back without its ScriptName although `classic_go_strat_service_entrance` is still built.

## How it was checked

- Compile: every changed or new `.cpp` (52) with CI's no-PCH clang-17 flags, warnings as errors (Docker image built from the
  fork's no-PCH recipe), no errors. Script loader is Karrz's, unchanged: all 204 `AddSC_` it declares are defined. Not linked or
  run locally: CI builds, links and runs the tests.
- SQL, scratch MySQL holding the live world + batch 1a: all 74 world files apply. Every script name the world uses exists in
  this branch's code, except 6 that were already missing before (`npc_fb_hire_broker` comes with the bots module; 5 are missing
  in Karrz's code too). No creature loses a working script or AI. 162 creatures already had SmartAI rows while running a C++
  script; this batch adds one (252481). The gate fix gives 175368 its script back.

## Known gaps

- `ClassicLegacyPerks.h` is also used by Karrz's core for the Legacy perks (Second Chance, Conquering Hero); that core code is
  not in this batch.
- Karrz's 148 new unit test files are not ported yet.
- Not tested in game: City of Dalaran, raid bosses, Alterac Valley. Karrz says some Dalaran numbers are best guesses (no live
  recording).
