# TrinityCore 05413dae1a: paladin talent Golden Path (heals from Consecration)

Aqua Deus, 2026-11-07, TrinityCore PR #30620. Reviewed 2026-11-09 against `everlake` 029c5dd9ca.

**Claim.** Paladin Golden Path (377128): while talented, each Consecration (26573) area trigger casts Golden Path heal
(377129) on its position; a target selector keeps the caster and a random set of allies up to effect 1 of the talent.
Both scripts are attached to 26573.

**Check.** This is the one live spell in batch H: Consecration 26573 is Forever's rank 1 Consecration.
- 377128 and 377129 are **not** in the 70862 `SpellName`. Both scripts' `Validate()` require them
  (`ValidateSpellInfo({377128, 377129})` and `ValidateSpellEffect({377128, EFFECT_1})`), so at start-up both fail
  and `ObjectMgr::ValidateSpellScripts` does not attach them to 26573 ("did not pass Validate() ... script will be not
  added"). They never run on Everlake.
- Even if they were attached: `spell_pal_golden_path` binds `EFFECT_0 SPELL_AURA_PERIODIC_DUMMY`, but in 70862
  26573 effect 0 is a plain dummy (3); effect 1 creates area trigger 41311, effect 2 is the periodic dummy aura (226,
  every 1 s). And `Load()` stops it without aura 377128. So Forever's Consecration is unchanged.
- Forever's own script stays: the world DB has `(26573, 'classic_spell_pal_consecration')` (`classic_spell_scripts.cpp`,
  `EFFECT_2` tick); the commit's SQL deletes only rows with its two new script names. Ranks 2-5 (20116, 20922-20924)
  are not touched. All of batch H's SQL (20 files) ran without error on a scratch MySQL 8.0 holding Forever's `spell_script_names`, `spell_proc`, `areatrigger_template` and `areatrigger_create_properties` (schema and rows from `forever-tdb-2026-10-14`, plus 545be4dddc's columns): afterwards 26573 has `classic_spell_pal_consecration` plus the two new rows.
- Side effect: two extra start-up error lines (the failed Validate for 26573), like other retail scripts.
- Note for TrinityCore: the target selector is bound to `TARGET_UNIT_DEST_AREA_ALLY` on effect 0 of 26573 although
  its comment says 377129; not our concern while 377128 is absent.

**Test.** None possible in game (talent missing). Builds in the local UBSan build (`spell_paladin.cpp` named to
`verify.sh`; it adds `#include "ListUtils.h"`, present in `src/common`).

**Verdict:** take, no change to Forever's Consecration.
