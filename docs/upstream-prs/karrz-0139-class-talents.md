# Karrz 0.1.39: class and talent fixes

From Karrz1/ForeverCore `forever-bots` `b441bf74e0` (0.1.39), by hand. Of Karrz's 0.1.39 class and talent files, only the
parts the PTR world did not already have: most of his class SQL wires scripts and procs that Everlake's own mechanics audit
(#108) and earlier Karrz merges had put in already. Each row was checked against the PTR on 2026-11-22.

## Taken

| Talent / spell | Code | SQL |
|---|---|---|
| Vindication 9452 (paladin): melee hits lower the target's attack power by a third of 440667 per rank, 5 procs a minute | `classic_spell_pal_vindication` | `2026_11_21_42` (script + `spell_proc`) |
| Oath of Light 1328548 / Boundless Light 1328550 (paladin): the Oath's bonus healing on Holy Light, Flash of Light and Holy Shock; Holy Shock crit on other allies | `classic_spell_pal_oath_of_light_heal` | `2026_11_21_42` |
| Consecration ticks 1280345-1280349: the first four enemies take the full tick (spell power), the rest the base part; `Forever.VanillaAoE = 1` leaves all full | `classic_spell_pal_consecration_tick` | `2026_11_19_66` |
| Judgement of Fury: a real 4 s taunt (server-side spell 9970901, `SPELL_AURA_MOD_TAUNT`) after the threat match, so the mob turns even below the 110/130% threshold | our `classic_spell_pal_judgement_of_fury` (it already ran the taunt after the damage) + the cast of 9970901 | `2026_11_19_65` |
| Unsealed Wrath 1310735 (paladin): our script `classic_spell_pal_unsealed_wrath` never ran, the aura had no proc entry | - | `2026_11_19_87` (`spell_proc`) |
| Improved Berserker Rage 20500 (warrior): Berserker Rage gives the rage and the chance to break movement impairing effects | `classic_spell_warr_improved_berserker_rage` | `2026_11_21_40` |
| Remorseless Attacks 14144 (rogue): a kill gives Remorseless 14143 for the next strike | `classic_spell_rog_remorseless_attacks` | `2026_11_21_41` |
| Arcane Wrath 1326079 (mage): the rank the talent teaches had no script (the trainer ranks had it) | our `classic_spell_mage_arcane_wrath` | `2026_11_21_43` |
| Cleave 19983 (Sapphiron, Vaelastrasz and other NPCs): the chain only takes targets within 5 y of the first, not the whole raid | `classic_spell_cleave_melee_reach` | `2026_11_18_160` |

## Left out

- Already on the PTR with the same rows (Everlake's #108 or earlier Karrz merges): `2026_11_19_20`, `21`, `23`-`27`, `29`-`33`,
  `35`, `36`, `38`, `51`, `53`, `56`, `57`, `58`, `2026_11_21_66` (rogue and druid attack power shares, threat, Omen of Clarity,
  Poised, Shadow Word: Death, Dark Sacrifice, Elune's Grace, Venom / Boot Knife / Death Mark, Slice and Dice, Shadow Weaving,
  Shifting Power, racial stat offsets, Flurry, warrior threat, Totem of Flowing Water, warrior attack power shares, the rogue
  trainer's Shank and Poised).
- Dark Inspiration (`2026_11_19_28` and Karrz's two scripts): we already have it (`classic_spell_pri_dark_inspiration` on
  Mind Blast procs, and in `classic_spell_pri_mind_flay` for a full channel); his would cast the buff twice.
- Seal of Righteousness coefficient (`2026_11_19_54`): it updates `classic_spell_value` rows the PTR doesn't have; no effect.
- Loatheb's Corrupted Mind (`2026_11_19_60`): ported in #120.
- Item procs (Moonshadow Stave, Argent Defender, Mark of the Chosen, Force of Will, Hero Badge, measured proc rates, Fatal Wound,
  Toofbreak, Rend, Pendulum of Doom): not class or talent changes, left for their own port.

## Checked

- `clang++ -fsyntax-only` with the CI warning flags on `classic_spell_scripts.cpp`, `classic_talents_priest_paladin.cpp`,
  `classic_talents_warrior_rogue_hunter.cpp`: clean.
- The eight SQL files run twice on a scratch MySQL with the stock world schema, the same rows both times.
- **Not done:** worldserver start, any of these in game.
