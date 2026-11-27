# TrinityCore ec16076f34: Healing Rain rewrite (area trigger)

Aqua Deus, 2026-10-29, TrinityCore PR #32073. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Spell data: wago.tools export of the 1.60.1.70862 client (SpellName, SpellEffect, Spell, ItemEffect); world rows: Forever's `forever-tdb-2026-10-14` release.

**Claim.** Healing Rain becomes an area trigger (create properties 43227, template 43923, spell 1298679); the old invisible-stalker code, `spell_sha_deluge_healing_rain` and `spell_sha_healing_rain_aura` go; Deluge and Hailstorm adjusted.

**Check.**
- 73920, 1298679, 200075, 147490, 70391, 1307888 absent from 70862 (Healing Rain is not a Classic spell). Forever's DB binds `spell_sha_healing_rain` and `spell_sha_deluge_healing_rain` to 73920 only. All of these ids are absent from the 70862 SpellName, so the spell script never binds on Everlake (no `spell_script_names` row matches a client spell; for script names on absent ids the loader skips them) and nothing changes in game. Taken to keep the file in line with TrinityCore so later fixes apply.
- SQL: new create properties 43227 / template 43923 (not in Forever's DB, not created by any 70862 spell), deletes the deluge row for 73920, script name for 1298679.

**Test.** None: no reachable code on Everlake. Build check: local UBSan build of the tests binary, the game library and the changed `spell_*.cpp` files (see the batch G PR).

**Verdict:** take, unreachable on Everlake.
