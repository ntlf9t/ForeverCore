# TrinityCore 8d501e89ce: Skull of Impending Doom (Flee) percent drain moved to a script

Shauren, 2026-10-19. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Master's half of a 3.3.5 commit that moved the percent power drain special cases out of the aura code: a new `spell_item_skull_of_impending_doom` on 5024 Flee sets the periodic damage (effect 1) to 12% of max health and the mana leech (effect 2) to 12% of max mana per tick.

**Check.**
- **Flee 5024 is live in 70862** and its item, Skull of Impending Doom 4984, is in the client (ItemSparse 4984, ItemEffect 97904 casts 5024). Effects in 70862: 0 = run speed +60%, 1 = periodic damage 300 every 2 s, 2 = periodic mana leech 300 every 2 s. The script's hooks match those effects, so it **would bind and change the item on Everlake**.
- Everlake today has no special case for 5024 in `SpellAuraEffects.cpp` (checked), so Flee does a flat 300 damage and drains 300 mana per tick, exactly what the 70862 tooltip says: "deals $s2 damage and drains $s3 mana every 2 seconds" ($s2 / $s3 = 300).
- The 12% version is the old TrinityCore 3.3.5 behaviour. Whether live Forever (or Classic Era) uses 12% or the flat 300 is not known from the client data; the client data points to flat.
- On master the commit changes no core code (only this script and its row), so other drain spells such as Viper Sting 3034 and Drain Mana 5138 are not affected either way.

**Test.** None (held).

**Verdict:** hold. It would change a live Classic item against the 70862 tooltip. Settle by checking live Forever / Classic Era Skull of Impending Doom damage per tick (flat 300 or 12% of max health). Not on the branch.
