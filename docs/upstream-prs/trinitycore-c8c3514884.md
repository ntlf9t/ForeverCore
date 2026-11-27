# TrinityCore c8c3514884: aura update packets carry the spell's destination; saved with the aura

Shauren, 2026-10-18. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** An aura created by a spell that has a destination (ground-targeted spells) keeps that point
(`Aura::m_dst`, taken from `Spell::m_targets` in `DoSpellEffectHit`, moved again when the aura is refreshed) and
sends it in the aura update packet (`AuraDataInfo::DstLocation`). The point is saved with player and pet auras: five
new columns in `character_aura` and `pet_aura` (`dstLocationMapId` -1 = none, X, Y, Z, O) and checked on load
(unknown map or bad coordinates -> no point).

**Check.**
- Packet: our `AuraDataInfo` writer (`SpellPackets.cpp`) already writes `DstLocation` (after `ContentTuningID`) and
  sends zeros today. Every aura update the 70862 client gets goes through it, so the field is part of the client's
  layout; this commit only fills it. What the 1.60 client does with the point was not checked.
- SQL: `2026_10_18_00_characters.sql` is two plain `ALTER TABLE` statements (no DELIMITER). On MySQL 8.0.46:
  `origin/everlake`'s `sql/base/characters_database.sql` plus this file (and 2ae8e29d6c's) gives the same
  `SHOW CREATE TABLE` for `character_aura`, `pet_aura` and `characters` as the new base. `updates` row hash =
  sha1 of the file (CF46EA66...). Conflict in `sql/base`: the `updates` list ended with our 2026_10_05 row; both kept.
- Other code with these tables: `PlayerDump` and the realm transfer (`TokenHandler`) copy rows by table, not by a
  fixed column list; the bot module does not touch them. A dump made on a realm whose DB lacks the columns was not tried.
- Which 70862 spells end up with a point (an aura plus a destination) was not counted.

**Test.** None in `tests/`: auras need a unit and a map. PTR check: log out and in with buffs on the character and on a
hunter's pet; no `character_aura` / `pet_aura` error in the log, buffs come back, and `dstLocationMapId` is -1 on them.

**Verdict:** take.
