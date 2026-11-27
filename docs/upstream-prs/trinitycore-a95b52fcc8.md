# TrinityCore a95b52fcc8: druid talent Orbital Strike

Aqua Deus, 2026-11-07, TrinityCore PR #30212. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Druid Orbital Strike: Celestial Alignment (383410) / Incarnation: Chosen of Elune (390414) also cast
390381, an area trigger (`at_dru_orbital_strike`, create properties 26768, template 30901) that moves at speed 45 and
casts Orbital Strike damage (361237) along its path, applying Stellar Flare (202347).

**Check.**
- Druid exists in 70862, but none of 383410, 390414, 390381, 361237, 202347 is in its `SpellName`. The "one id
  looks present" hit is 26768: in 70862 that is spell "Summon Giant Eye Tentacles", but in this commit 26768 is an
  `areatrigger_create_properties` id, not a spell, so it is unrelated.
- Forever's world DB already scripts 383410 / 390414 (`spell_dru_celestial_alignment`,
  `spell_dru_astral_communion_celestial_alignment`); this commit's DELETE is by its own two script names, so those stay.
- `areatrigger_template` 30901 and `areatrigger_create_properties` 26768 (IsCustom 0) are not in Forever's world DB
  release nor any fork `sql/updates`/`sql/custom` file: no collision. The INSERT leaves out `MaxSummons`/`MaxUnits`
  (NULL default, columns from 545be4dddc) and `SpeedIsTime` (default 0).
- No 70862 spell effect creates area trigger property 26768 (`SpellEffect`: no effect 179 with misc value 26768).
- All of batch H's SQL (20 files) ran without error on a scratch MySQL 8.0 holding Forever's `spell_script_names`, `spell_proc`, `areatrigger_template` and `areatrigger_create_properties` (schema and rows from `forever-tdb-2026-10-14`, plus 545be4dddc's columns): 26768 and 30901 go in with `MaxSummons`/`MaxUnits` NULL.

**Test.** None possible. Builds in the local UBSan build (`spell_druid.cpp` named to `verify.sh`).

**Verdict:** take, unreachable on Everlake.
