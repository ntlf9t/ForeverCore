# Karrz 0.1.39: item procs

From Karrz1/ForeverCore `forever-bots` `b441bf74e0` (0.1.39), by hand: only what the PTR world did not have on 2026-11-22.
Most of Karrz's 0.1.39 item proc SQL is Everlake's own (his `2026_11_19_50` says "ported from Everlake, GPL, PR 81"), and its
rows were already on the PTR with the same values.

## Taken

| Item | Code | SQL |
|---|---|---|
| Fatal Wound / Wound (Pendulum of Doom, Blackhand Doomsaw and others: 10373, 16549, 18107, 18206, 1300185): more damage to a target below the stated health | `classic_spell_item_fatal_wound` | `2026_11_22_51` |
| Toofbreak 1320269 (Toofbreaker): x times as much if the target faces you | `classic_spell_item_toofbreak` | `2026_11_22_51` |
| Rend 14118 (x times to Dragonkin) and 1300787 (Barman Shanker, x times if applied from behind) | `classic_spell_item_rend_bonus` | `2026_11_22_51` |
| Pendulum of Doom 1293881: each swing alternates +100% / -50% attack speed, back to plain out of combat | `classic_spell_item_pendulum_of_doom` | `2026_11_22_51` (script + `spell_proc` on every swing) |
| Force of Will 15594 (trinket 11810): 6.2% per melee hit taken with its 30 s cooldown, not 100% on the first hit after each cooldown | - | `2026_11_19_91` (Karrz's file) |

`2026_11_22_51` is a file of ours made from Karrz's `2026_11_21_44_world_classic_item_proc_bonuses.sql`: its versus-bonus rows
are already in `2026_11_21_62` (#121), the rest is here.

Name change: Karrz's aura 319 is `SPELL_AURA_MOD_MELEE_HASTE_3`; here it is `SPELL_AURA_MOD_MELEE_HASTE_NO_REGEN`, whose handler
(`HandleModMeleeHasteNoRegen`) applies the attack time percent and reacts to `ChangeAmount`, which the Pendulum script uses.

## Left out

- Nature's Bounty 450608 (`classic_spell_item_natures_bounty`): ours is `classic_spell_item_feralheart_4p` (forever-bugs #523),
  same mana / energy / rage split; both bound would double the procs.
- Already on the PTR with the same rows: `2026_11_19_22` (item proc chances), `34` (Moonshadow Stave), `37` (Mark of the Chosen),
  `39` (Shahram), `50` (measured item proc rates, apart from Nature's Bounty), `52` (Argent Defender), `55` (weapon proc rates),
  `59` (Zandalarian Hero Badge / Caustic Smog).

## Checked

- `clang++ -fsyntax-only` with the CI warning flags on `classic_spell_scripts.cpp`: clean.
- The two SQL files run twice on a scratch MySQL with the stock world schema, the same rows both times.
- **Not done:** worldserver start, the items in game.
