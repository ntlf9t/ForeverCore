# Karrz 0.1.39: items stronger against one kind of enemy

From Karrz1/ForeverCore `forever-bots` `b441bf74e0` (0.1.39), by hand.

Many Classic weapons and trinkets say "Deals $s2 times as much damage to Plants", "attacks against Dwarves are $s2 times
as likely to activate this effect" or "restores $s1 times as much if attacking an Earth Elemental". The factor is a second
spell effect (a dummy) that nothing read, and the enemy groups (Trolls, Plants, Naga, Satyrs...) are in no creature field,
so these items had no bonus at all.

## What is in it

- `src/server/game/Spells/ClassicVersusBonus.h` (new): the groups, the kinds (damage, proc chance, restore) and the match rule.
- `SpellMgr::LoadClassicVersusBonus()` + `GetClassicVersusBonus` / `GetClassicVersusGroups` / `GetClassicVersusFactor`,
  loaded in `World.cpp` after the creature templates. A player's group comes from the race (troll, orc, dwarf).
- Hooks, as Karrz wrote them:
  - `Spell::EffectSchoolDMG` (direct damage)
  - `AuraEffect::HandlePeriodicDamageAurasTick` (damage per tick)
  - `Aura::CalcProcChance` (proc chance)
  - `Aura::GetProcEffectMask` (the factor effect never procs on its own: Hand of Justice gave a second extra attack)
  - `AuraEffect::HandleProcTriggerSpellAuraProc` (restore: Fist of Stone's mana)
- `sql/custom/world/2026_11_21_60_world_classic_versus_bonus.sql`: table `spell_versus_bonus`, 23 rows (The Chief's
  Enforcer, Sul'thraze, Angerforge's Battle Axe, Heart of Wyrmthalak, Ironfoe, Hand of Justice, the Plant cutters, Gahz'rilla
  Fang, Rot-Covered Harpoon, Waveslicer, Stoneslayer, Stoneshatter, Fist of Stone, Hammer of Expertise, Verigan's Fist,
  Highborne Research Tablet, Serpentbane Crown). Factors and groups from the client spell data and tooltips, checked
  against wowsims/forever (MIT).
- `sql/custom/world/2026_11_21_61_world_classic_versus_groups.sql`: table `creature_versus_group`, 1,550 creatures,
  written by `tools/classic_versus_groups/` from creature names, types and families. A creature that isn't in this world
  is skipped at load with one log line.
- `classic_spell_item_versus_bonus` in `classic_spell_scripts.cpp` + `2026_11_21_62_world_classic_versus_bonus_scripts.sql`:
  six weapon procs against creature types (Drain Life, Corpse Eater, Smite vs Undead; Lightning Bolt vs Mechanical; Holy
  Cleaver vs Undead and boars; Blazewind Blast vs wolves). In Karrz's tree these script rows sit in
  `2026_11_21_44_world_classic_item_proc_bonuses.sql` with other item fixes (Fatal Wound, Toofbreak, Rend, Pendulum of Doom);
  only the six are taken here, in a file of ours.

Already here before: the item stats "attack power / spell damage versus a creature type"
(`Player::GetClassicAttackPowerVersus`, `GetClassicSpellDamageVersus`).

## Checked

- `clang++ -fsyntax-only` on `SpellMgr.cpp`, `SpellAuras.cpp`, `SpellAuraEffects.cpp`, `SpellEffects.cpp`, `World.cpp`,
  `classic_spell_scripts.cpp`: clean.
- The three SQL files run twice on a scratch MySQL with the stock world schema: 23 / 1,550 / 6 rows both times. Neither
  table existed on the PTR, and the six spells had no script there.
- **Not done:** worldserver start, any of these items in game.
