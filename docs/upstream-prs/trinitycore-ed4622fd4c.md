# TrinityCore ed4622fd4c: Mechanar, Mechano-Lord Capacitus rewritten

offl, 2026-10-01, TrinityCore#31982. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Polarity Charge becomes periodic aura scripts on 39088 and 39091 (replacing four `spell_linked_spell` rows),
the damage script is renamed `spell_capacitus_polarity_charge_damage`, texts replaced (6 rows for 19219), and a
`SpellMgr` correction sets RecoveryTime 0 on 35158 / 35159 (Reflective Magic / Damage Shield) so their periodic
auras keep triggering.

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. The `SpellMgr` part is the only change outside the dungeon script and it is global, so checked first:
35158, 35159 (and 35173, 35174) are not in 70862, so `ApplySpellFix` only logs "Spell info correction specified for
non-existing spell" twice at start-up, like the many other retail ids in that function. 39088, 39090, 39091, 39093 are
not in 70862 either. The four `spell_linked_spell` rows deleted (39088, 39091, -39088, -39091) are TrinityCore's TBC
rows in Forever's release; Forever has no other row on those spells. The rename changes Forever's two rows
(39090, 39093) from `spell_capacitus_polarity_charge`; no Forever code uses the old name (grep `src/`).

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable; two more start-up log lines).
