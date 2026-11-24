// BotNamePool — central allocator for bot character names.
//
// Two tiers of first names:
//   1. `{shared}.playerbots_race_names` — the curated, lore-flavoured pool:
//      names authored per race and sex (dwarven first names for dwarves,
//      Shen'dorei-style names for the Skyborne races, ...). Consumed exactly
//      like the generic pool (is_used / used_by_guid), so a name is still
//      unique server-wide — the race column only gates WHICH race may draw it.
//   2. `{shared}.playerbots_names` — the generic 107K pool (real human names,
//      race-agnostic). The fallback once a race's curated bucket is empty.
//   3. BotComposition::RollUniqueName stays the last resort below both.
//
// Surnames come from two shared tables, consumed non-destructively (last names
// repeat freely):
//   * `{shared}.playerbots_surnames` — whole surnames ("Bronzebeard", "Skyseer")
//   * `{shared}.playerbots_surname_parts` — combinable halves, so a ~50-part
//     per-race list yields ~10^3 compound surnames ("Hammer"+"fist").
//
// Each call to Acquire picks an unused name and atomically flags it as taken.
// Names are released on bot deletion. On boot, ReconcileOnBoot() walks both
// tables and frees names whose used_by_guid no longer maps to an existing
// characters row — this catches manual SQL wipes that didn't release names
// through the C++ delete paths.
//
// Why a pool instead of the syllable generator (BotComposition::
// RollUniqueName): the syllable generator can produce names that fail
// `ObjectMgr::CheckPlayerName` (triple-consonant rule, banned words,
// length-after-suffix). The curated pool contains real human names that
// have already passed validation, so name-side Create failures vanish.

#pragma once

#include "Bot/BotTypes.h"
#include <string>

namespace Playerbot::V2::Fleet {

class BotNamePool
{
public:
    // Reserve a name from the pool. `race` selects the curated bucket first
    // (playerbots_race_names rows for that race, then its race=0 any-race
    // rows); `gender` then filters inside it (0 male, 1 female, 2 universal —
    // universal names match any gender). Empty `race` skips the curated tier
    // entirely. Returns empty if every pool is exhausted (caller falls back
    // to syllable gen).
    //
    // Cross-DB: the name tables live in the shared database (Playerbot.
    // SharedDatabase, usually `playerbot`/`wowc_playerbot`), but the
    // `playerbot` MySQL user has access to both schemas, so the queries
    // explicitly qualify with `{shared}.<table>`.
    static std::string Acquire(uint8 gender, uint8 race = 0);

    // A surname for the character — race-flavoured (race=0 rows = universal),
    // gender-filtered like Acquire. Roughly half the results are compound
    // (Playerbot.Names.SurnameCompoundChance). Never consumes the row: last
    // names are shared by construction. Returns empty when the surname tables
    // are missing or hold nothing for this race.
    static std::string AcquireSurname(uint8 race, uint8 gender);

    // Non-destructive sample of what Acquire(gender, race) could hand out —
    // for `.playerbot selftest botnames` previews. Picks randomly from the
    // same bucket order without consuming.
    static std::string PreviewName(uint8 gender, uint8 race);

    // Bind a previously-acquired name to a created character. Stores
    // the character's guid in used_by_guid so the row can be reverse-
    // looked-up from `.playerbot wipe` and from ReconcileOnBoot.
    static void BindToCharacter(std::string const& name, uint64 guid_low);

    // Release a name back to the pool — called when a bot is deleted
    // (via hygiene cron or `.playerbot delete`). No-op if the name was
    // never in our pools (e.g. legacy V1 syllable names).
    static void Release(std::string const& name);

    // Boot-time housekeeping: scans is_used=1 rows and clears the flag
    // when the referenced character no longer exists. Covers the SQL-
    // wipe case where the DBA bypassed the C++ delete path. Cheap;
    // one JOIN scan per boot. Also loads the surname tables.
    static void ReconcileOnBoot();

    // Diagnostic — returns (available, total) for /popstats. `available`
    // counts both name pools; `surnames` counts whole surnames loaded.
    struct PoolStats { uint32 available; uint32 total; uint32 surnames; };
    static PoolStats GetStats();
};

} // namespace Playerbot::V2::Fleet
