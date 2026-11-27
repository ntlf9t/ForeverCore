# TrinityCore 2ae8e29d6c: the companion out at logout comes back after login

Oreocide, 2026-10-31 (TrinityCore PR 32079). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (SpellName, SpellEffect, SpellMisc, SummonProperties, BattlemasterList, Criteria, ModifierTree, MountCapability); world data: the Forever TDB of 2026-10-14.

**Claim.** The summoned companion (battle pet), or the one temporarily dismissed (mounted, dead), is saved in a new
`characters.lastSummonedBattlePet` column and summoned again at login.

**Check.**
- SQL: one `ALTER TABLE characters ADD COLUMN ... AFTER summonedPetNumber`. On MySQL 8.0.46 the old base plus this file
  gives the same `characters` table as the new base; `updates` row hash = sha1 of the file (73AB199A...). Only
  `CHAR_UPD_CHARACTER` writes it (new characters get the default 0); `CHAR_SEL_CHARACTER` and `LoadFromDB` read it in
  the same place; the hunks applied without moving any of Forever's columns.
- Conflicts:
  - `Player::LoadFromDB`: Forever's stable-slot load (`character_stable_slots`) and TrinityCore's line sit at the same
    place; both kept.
  - `HandlePlayerLogin`: Forever does not summon the pet there; it calls `DelayPetResummon(4000)` (Karrz #107: a
    creature made while the 1.60 client is still on its loading screen froze the client). Kept, and TrinityCore's
    immediate `ResummonBattlePetTemporaryUnSummonedIfAny()` there left out. Our commit right after summons the
    companion from `Player::Update` when the same 4 s delay runs out, next to the pet.
- Companions are battle pets on the Forever client (`BattlePetMgr` summons them; `UnsummonBattlePetTemporaryIfAny`
  already kept the guid while mounted), so this is live on Everlake.

**Test.** None in `tests/` (needs a session). PTR check: summon a companion, log out, log in: it comes back about 4 s
after the world appears and the client does not freeze; dismiss it, relog: it stays away.

**Verdict:** take, with our change to summon it with the delayed pet.
