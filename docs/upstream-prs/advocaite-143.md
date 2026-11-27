# advocaite/TrinityCore#143: Spells/Warrior: Victorious and Overpower procs are no longer active from level 1

krakenunbound, 2026-10-27, commit e38d0fcc45. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** SkillLineAbility 48279 (Victorious State (DND) 402974) and 57190 (Offensive State (DND) 1282735) have
`AcquireMethod` 2 (learned with the skill by level), so every warrior has both passives from level 1, long before
Victory Rush (20) and Overpower (12). Fix: hotfix both rows to `AcquireMethod` 0 and teach each passive with its spell
(`spell_learn_spell`).

**Check.**
- The 70862 SkillLineAbility rows match the hotfix rows field for field except `AcquireMethod` (2 in the client):
  skill line 95, class mask 1, race masks -1. 402974 procs on a kill and triggers Victorious 402975; 1282735 procs on
  melee hits and triggers 1282733. Victory Rush 402927 (level 20) and Overpower 7384 (level 12) are trainer spells.
- Table hash 4282664694 is the hash in our client's `SkillLineAbility.db2` header. Push id 2000110 is used by no other
  custom hotfix file in `everlake` and by no other open upstream pull request.
- The hotfix rows also load into the server's DB2 store, so `LearnSkillRewardedSpells` stops giving the passives.
  `spell_learn_spell` teaches them with the spell, also at login for warriors who already know it.
- Applied to a scratch MySQL 8.0: the TDB 2026-10-14 hotfixes plus our hotfix SQL since, then this file (2 rows + 2
  `hotfix_data` rows, no rows existed before); the world file on the scratch world (2 rows, none before). No errors.

**Test.** SQL only (above). PTR: a new level 1 warrior kills a mob: no Victorious buff and Victory Rush stays unknown.
Train Overpower at 12: `.list auras` now shows Offensive State (DND). Also worth a look on
the PTR, not part of this pull request: by the client data Offensive State procs on every melee hit (no dodge
condition, no `spell_proc` row), so check that Overpower lights only after a dodge.

**Verdict:** take.
