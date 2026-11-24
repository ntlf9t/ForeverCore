#include "BotNamePool.h"

#include "CharacterCache.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Log.h"

#include <fmt/format.h>
#include <algorithm>
#include <mutex>
#include <random>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace Playerbot::V2::Fleet {

// ---- In-memory pool ---------------------------------------------------------
//
// Earlier version queried the DB on every Acquire (COUNT + SELECT-OFFSET +
// UPDATE + verify-SELECT × 8 retries = up to 32 sync queries per bot create).
// Under the boot-time spawn burst the world thread spent >60s in those
// queries and tripped the FreezeDetector. Worse: the verify SELECT races
// the async UPDATE (PExecute is non-blocking), so it constantly read the
// pre-update state and falsely concluded "someone took my name", driving
// the retry loop to exhaustion.
//
// Fix: keep the entire pool in memory. Boot loads is_used=0 rows once;
// Acquire/Release mutate the in-memory pool (O(1) under a single mutex)
// and fire-and-forget an async UPDATE to keep the DB row in sync. The
// async DB write doesn't have to land before the next Acquire — we
// already removed the entry from memory so we won't hand it out again.
namespace {

// pool: which table the name lives in. Consumption (is_used/used_by_guid)
// is per-realm state on the shared copy, same as playerbots_names.
constexpr uint8 POOL_GENERIC = 0;   // playerbots_names
constexpr uint8 POOL_CURATED = 1;   // playerbots_race_names

struct NameEntry
{
    uint32      name_id;
    std::string name;
    uint8       gender;     // 0 male, 1 female, 2 universal
    uint8       pool;       // POOL_GENERIC / POOL_CURATED
    uint8       race;       // POOL_CURATED: the row's race (0 = any race)
};

struct GenderBuckets
{
    std::vector<NameEntry> male;
    std::vector<NameEntry> female;
    std::vector<NameEntry> uni;
};

std::mutex                                    g_mutex;
GenderBuckets                                 g_generic;
// Curated per-race buckets, keyed by the row's race (0 = "any race"
// curated names — drawn after the exact-race bucket, before generic).
std::unordered_map<uint8, GenderBuckets>      g_curated;

// Reverse lookup: name → where to return it on Release. Names from the
// syllable-generator fallback aren't in this map; Release no-ops them.
struct NameMeta { uint32 name_id; uint8 gender; uint8 pool; uint8 race; };
std::unordered_map<std::string, NameMeta> g_name_to_meta;

// Surname content (never consumed — last names repeat freely).
struct SurnameEntry { std::string text; uint8 gender; };
std::unordered_map<uint8, std::vector<SurnameEntry>> g_surnames;      // race -> whole surnames (0 = any)
std::unordered_map<uint8, std::vector<std::string>>  g_surname_pre;   // race -> compound prefixes
std::unordered_map<uint8, std::vector<std::string>>  g_surname_suf;   // race -> compound suffixes

thread_local std::mt19937 g_rng{std::random_device{}()};

// Picks a random index from a non-empty vector and swap-erases it.
// Returns the popped entry. Caller must hold g_mutex.
NameEntry PopRandom_locked(std::vector<NameEntry>& v)
{
    std::uniform_int_distribution<size_t> dist(0, v.size() - 1);
    size_t idx = dist(g_rng);
    NameEntry e = std::move(v[idx]);
    v[idx] = std::move(v.back());
    v.pop_back();
    return e;
}

void PushByGender_locked(GenderBuckets& b, NameEntry e)
{
    switch (e.gender)
    {
        case 0:  b.male.push_back(std::move(e));   break;
        case 1:  b.female.push_back(std::move(e)); break;
        default: b.uni.push_back(std::move(e));    break;
    }
}

// Single config-driven home for all instance-shared playerbot data
// (Playerbot.SharedDatabase, default "playerbot"). Read once. Used to
// qualify cross-DB queries so swapping the active world/character DB never
// strands the shared bot data. NOTE: the realm-specific `characters` join below
// is intentionally NOT this schema (it uses the connection's own database).
std::string const& SharedDb()
{
    static std::string const db =
        sConfigMgr->GetStringDefault("Playerbot.SharedDatabase", "playerbot", true);
    return db;
}

std::string EscapeForSql(std::string const& s)
{
    std::string out;
    out.reserve(s.size() + 4);
    for (char c : s)
    {
        if (c == '\'') out += "''";
        else out += c;
    }
    return out;
}

char const* NameTable(uint8 pool)
{
    return pool == POOL_CURATED ? "playerbots_race_names" : "playerbots_names";
}

// Which of our tables actually exist in the shared schema. The surname /
// curated tables come from the bot migrations 0063/0064; a server that has
// not run them yet must not spam a failing SELECT every boot.
bool g_probed        = false;
bool g_has_race_names = false;
bool g_has_surnames   = false;
bool g_has_parts      = false;

void ProbeTables()
{
    auto res = CharacterDatabase.Query(fmt::format(
        "SELECT TABLE_NAME FROM information_schema.TABLES "
        "WHERE TABLE_SCHEMA='{}' AND TABLE_NAME IN "
        "('playerbots_race_names','playerbots_surnames','playerbots_surname_parts')",
        SharedDb()).c_str());
    std::unordered_set<std::string> have;
    if (res)
    {
        do { have.emplace(res->Fetch()[0].GetString()); } while (res->NextRow());
    }
    g_has_race_names = have.count("playerbots_race_names") != 0;
    g_has_surnames   = have.count("playerbots_surnames") != 0;
    g_has_parts      = have.count("playerbots_surname_parts") != 0;
    g_probed = true;
    if (!g_has_race_names || !g_has_surnames || !g_has_parts)
        TC_LOG_WARN("playerbot.v2",
            "[BotNamePool] RPG-name tables missing in {} (race_names={} surnames={} parts={}) — "
            "the bot migrations 0063/0064 (sql/playerbot_v2) add them.",
            SharedDb(), g_has_race_names, g_has_surnames, g_has_parts);
}

// One-time load. Called from ReconcileOnBoot (which is the bootstrap path).
bool g_loaded = false;
void Load_locked()
{
    g_generic = {};
    g_curated.clear();
    g_surnames.clear();
    g_surname_pre.clear();
    g_surname_suf.clear();
    g_name_to_meta.clear();

    if (!g_probed)
        ProbeTables();

    // ---- generic pool ------------------------------------------------------
    // Load every is_used=0 row. ORDER BY name_id keeps the load deterministic
    // for testing; the in-memory pick is random so distribution is uniform.
    auto res = CharacterDatabase.Query(fmt::format(
        "SELECT name_id, name, gender FROM {}.playerbots_names "
        "WHERE is_used=0 ORDER BY name_id", SharedDb()).c_str());
    if (res)
    {
        do {
            Field* f = res->Fetch();
            NameEntry e;
            e.name_id = f[0].GetUInt32();
            e.name    = f[1].GetString();
            e.gender  = f[2].GetUInt8();
            e.pool    = POOL_GENERIC;
            e.race    = 0;
            g_name_to_meta[e.name] = {e.name_id, e.gender, e.pool, e.race};
            PushByGender_locked(g_generic, std::move(e));
        } while (res->NextRow());
    }

    // ---- curated per-race pool ---------------------------------------------
    uint32 curated = 0;
    if (g_has_race_names)
    {
        if (auto res2 = CharacterDatabase.Query(fmt::format(
                "SELECT name_id, name, race, gender FROM {}.playerbots_race_names "
                "WHERE is_used=0 ORDER BY name_id", SharedDb()).c_str()))
        {
            do {
                Field* f = res2->Fetch();
                NameEntry e;
                e.name_id = f[0].GetUInt32();
                e.name    = f[1].GetString();
                e.race    = f[2].GetUInt8();
                e.gender  = f[3].GetUInt8();
                e.pool    = POOL_CURATED;
                g_name_to_meta[e.name] = {e.name_id, e.gender, e.pool, e.race};
                PushByGender_locked(g_curated[e.race], std::move(e));
                ++curated;
            } while (res2->NextRow());
        }
    }

    // ---- surnames + compound parts ------------------------------------------
    uint32 surnames = 0, parts = 0;
    if (g_has_surnames)
    {
        if (auto res3 = CharacterDatabase.Query(fmt::format(
                "SELECT surname, race, gender FROM {}.playerbots_surnames", SharedDb()).c_str()))
        {
            do {
                Field* f = res3->Fetch();
                SurnameEntry s;
                s.text   = f[0].GetString();
                uint8 r  = f[1].GetUInt8();
                s.gender = f[2].GetUInt8();
                g_surnames[r].push_back(std::move(s));
                ++surnames;
            } while (res3->NextRow());
        }
    }
    if (g_has_parts)
    {
        if (auto res4 = CharacterDatabase.Query(fmt::format(
                "SELECT part, half, race FROM {}.playerbots_surname_parts", SharedDb()).c_str()))
        {
            do {
                Field* f = res4->Fetch();
                std::string part = f[0].GetString();
                uint8 half       = f[1].GetUInt8();
                uint8 r          = f[2].GetUInt8();
                (half == 0 ? g_surname_pre[r] : g_surname_suf[r]).push_back(std::move(part));
                ++parts;
            } while (res4->NextRow());
        }
    }

    g_loaded = true;
    TC_LOG_INFO("playerbot.v2",
        "[BotNamePool] Loaded in-memory pool: {} generic (m {} f {} u {}), {} curated across {} races, "
        "{} surnames, {} surname parts.",
        g_generic.male.size() + g_generic.female.size() + g_generic.uni.size(),
        g_generic.male.size(), g_generic.female.size(), g_generic.uni.size(),
        curated, g_curated.size(), surnames, parts);
}

// Pops one eligible name out of `b` (the gender-appropriate bucket, then the
// universal one), stamps is_used on its source table and records the meta for
// Release/BindToCharacter. Returns "" when every try bucket is empty.
// Caller must hold g_mutex.
std::string Take_locked(GenderBuckets& b, uint8 gender, uint8 pool, uint8 race_bucket)
{
    // Gender=0 (male) → male → uni. Gender=1 (female) → female → uni.
    // Gender=2 (any) → uni → male → female (any-leftover).
    std::vector<NameEntry>* tries[3] = {nullptr, nullptr, nullptr};
    if (gender == 0)      { tries[0] = &b.male;   tries[1] = &b.uni; }
    else if (gender == 1) { tries[0] = &b.female; tries[1] = &b.uni; }
    else                  { tries[0] = &b.uni;    tries[1] = &b.male; tries[2] = &b.female; }

    for (auto* bucket : tries)
    {
        // Up to 4 pops per bucket: a pool name may already sit on a real
        // (non-bot) character — the curated lists and the 107K generic pool
        // can both contain a name a player took. Rather than fail in Create
        // with "name already in use", consume the row here (it IS unusable
        // forever) and try the next one.
        for (int attempt = 0; attempt < 4 && bucket && !bucket->empty(); ++attempt)
        {
            NameEntry e = PopRandom_locked(*bucket);
            CharacterDatabase.Execute(fmt::format(
                "UPDATE {}.{} SET is_used=1 WHERE name_id={}",
                SharedDb(), NameTable(pool), e.name_id).c_str());
            if (sCharacterCache->GetCharacterCacheByName(e.name))
                continue;
            g_name_to_meta[e.name] = {e.name_id, e.gender, pool, race_bucket};
            return e.name;
        }
    }
    return {};
}

// Collects all surname/part rows valid for `race` (own race + race=0
// universal rows) into `out`. Caller must hold g_mutex.
template <typename T>
void GatherForRace_locked(std::unordered_map<uint8, std::vector<T>> const& m, uint8 race,
                          std::vector<T const*>& out)
{
    for (uint8 r : {race, uint8(0)})
    {
        if (auto it = m.find(r); it != m.end())
            for (T const& e : it->second) out.push_back(&e);
        if (r == 0) break;
    }
}

std::string PickWholeSurname_locked(uint8 race, uint8 gender)
{
    thread_local std::vector<SurnameEntry const*> eligible;
    eligible.clear();
    GatherForRace_locked(g_surnames, race, eligible);
    if (gender != 2)
        eligible.erase(std::remove_if(eligible.begin(), eligible.end(),
            [gender](SurnameEntry const* s) { return s->gender != 2 && s->gender != gender; }),
            eligible.end());
    if (eligible.empty()) return {};
    std::uniform_int_distribution<size_t> dist(0, eligible.size() - 1);
    return eligible[dist(g_rng)]->text;
}

// Prefix + suffix composition ("Hammer"+"fist"). Rejects degenerate results:
// identical halves, triple repeated letters at the seam, odd lengths.
std::string RollCompoundSurname_locked(uint8 race)
{
    thread_local std::vector<std::string const*> pre, suf;
    pre.clear(); suf.clear();
    GatherForRace_locked(g_surname_pre, race, pre);
    GatherForRace_locked(g_surname_suf, race, suf);
    if (pre.empty() || suf.empty()) return {};

    for (int i = 0; i < 6; ++i)
    {
        std::string const& p = *pre[std::uniform_int_distribution<size_t>(0, pre.size() - 1)(g_rng)];
        std::string const& s = *suf[std::uniform_int_distribution<size_t>(0, suf.size() - 1)(g_rng)];
        if (p == s) continue;
        // "Star"+"star" passes the == check but yields Starstar — compare folded.
        if (std::equal(p.begin(), p.end(), s.begin(), s.end(),
                [](char a, char b){ return std::tolower((unsigned char)a) == std::tolower((unsigned char)b); }))
            continue;
        std::string out = p + s;
        if (out.size() < 4 || out.size() > 24) continue;
        bool triple = false;
        for (size_t k = 2; k < out.size(); ++k)
            if (out[k] == out[k-1] && out[k] == out[k-2]) { triple = true; break; }
        if (triple) continue;
        return out;
    }
    return {};
}

} // anonymous

std::string BotNamePool::Acquire(uint8 gender, uint8 race)
{
    std::lock_guard lk(g_mutex);
    if (!g_loaded)
    {
        // Defensive: caller forgot to call ReconcileOnBoot. Self-bootstrap
        // so the pool still works in fallback / test scenarios.
        Load_locked();
    }

    // Tier 1: the curated bucket for this exact race, then the curated
    // any-race (race=0) bucket. Tier 2: the generic all-races pool.
    if (auto it = g_curated.find(race); it != g_curated.end())
        if (std::string n = Take_locked(it->second, gender, POOL_CURATED, race); !n.empty())
            return n;
    if (race != 0)
        if (auto it = g_curated.find(0); it != g_curated.end())
            if (std::string n = Take_locked(it->second, gender, POOL_CURATED, 0); !n.empty())
                return n;
    if (std::string n = Take_locked(g_generic, gender, POOL_GENERIC, 0); !n.empty())
        return n;

    TC_LOG_WARN("playerbot.v2", "[BotNamePool] Acquire: pools exhausted (race {}).", race);
    return {};
}

std::string BotNamePool::AcquireSurname(uint8 race, uint8 gender)
{
    std::lock_guard lk(g_mutex);
    if (!g_loaded)
        Load_locked();

    static float const compoundChance =
        sConfigMgr->GetFloatDefault("Playerbot.Names.SurnameCompoundChance", 0.5f, true);
    std::uniform_real_distribution<float> roll(0.0f, 1.0f);

    for (int attempt = 0; attempt < 12; ++attempt)
    {
        if (roll(g_rng) < compoundChance)
        {
            if (std::string s = RollCompoundSurname_locked(race); !s.empty())
                return s;
        }
        else if (std::string s = PickWholeSurname_locked(race, gender); !s.empty())
            return s;
    }
    // Out of luck or out of content — last resort ignores the gender filter.
    return PickWholeSurname_locked(race, 2);
}

std::string BotNamePool::PreviewName(uint8 gender, uint8 race)
{
    std::lock_guard lk(g_mutex);
    if (!g_loaded)
        Load_locked();

    // Non-destructive peek: gather candidate vectors in the same order
    // Take_locked would try them, then pick uniformly across the union.
    thread_local std::vector<NameEntry const*> pool;
    pool.clear();
    auto collect = [gender](GenderBuckets& b)
    {
        if (gender == 0 || gender == 2)
            for (auto const& e : b.male)   pool.push_back(&e);
        if (gender == 1 || gender == 2)
            for (auto const& e : b.female) pool.push_back(&e);
        for (auto const& e : b.uni) pool.push_back(&e);
    };
    if (auto it = g_curated.find(race); it != g_curated.end()) collect(it->second);
    if (auto it = g_curated.find(0);    it != g_curated.end()) collect(it->second);
    if (pool.empty()) collect(g_generic);
    if (pool.empty()) return {};
    std::uniform_int_distribution<size_t> dist(0, pool.size() - 1);
    return pool[dist(g_rng)]->name;
}

void BotNamePool::BindToCharacter(std::string const& name, uint64 guid_low)
{
    // Pick the source table off the meta when we have one (a hinted name
    // that never went through Acquire isn't in the map — default to the
    // generic table, the historical behaviour).
    uint8 pool = POOL_GENERIC;
    {
        std::lock_guard lk(g_mutex);
        if (auto it = g_name_to_meta.find(name); it != g_name_to_meta.end())
            pool = it->second.pool;
    }
    CharacterDatabase.Execute(fmt::format(
        "UPDATE {}.{} SET used_by_guid={} WHERE name='{}'",
        SharedDb(), NameTable(pool), guid_low, EscapeForSql(name)).c_str());
}

void BotNamePool::Release(std::string const& name)
{
    if (name.empty()) return;
    std::lock_guard lk(g_mutex);
    auto it = g_name_to_meta.find(name);
    if (it == g_name_to_meta.end())
        return;     // not from either pool (syllable-gen fallback) — no-op

    NameMeta const meta = it->second;

    // Re-add to the bucket it was popped from so Acquire can hand it out again.
    NameEntry e{meta.name_id, name, meta.gender, meta.pool, meta.race};
    if (meta.pool == POOL_CURATED)
        PushByGender_locked(g_curated[meta.race], std::move(e));
    else
        PushByGender_locked(g_generic, std::move(e));

    CharacterDatabase.Execute(fmt::format(
        "UPDATE {}.{} SET is_used=0, used_by_guid=NULL WHERE name_id={}",
        SharedDb(), NameTable(meta.pool), meta.name_id).c_str());
}

void BotNamePool::ReconcileOnBoot()
{
    ProbeTables();

    // Clean up DB orphans (is_used=1 but the character doesn't exist).
    // This catches SQL-wipes / mid-create crashes that bypassed Release.
    for (uint8 pool : {POOL_GENERIC, POOL_CURATED})
    {
        if (pool == POOL_CURATED && !g_has_race_names) continue;
        auto orphan_res = CharacterDatabase.Query(fmt::format(
            "SELECT pn.name_id FROM {}.{} pn "
            // Unqualified: the query already runs on the configured characters database, whatever its name
            // (was characters.characters, which fails on a realm whose characters database has another name).
            "LEFT JOIN characters c ON c.guid = pn.used_by_guid "
            "WHERE pn.is_used = 1 AND (pn.used_by_guid IS NULL OR c.guid IS NULL)",
            SharedDb(), NameTable(pool)).c_str());

        uint32 released = 0;
        if (orphan_res)
        {
            do {
                const uint32 name_id = orphan_res->Fetch()[0].GetUInt32();
                CharacterDatabase.Execute(fmt::format(
                    "UPDATE {}.{} SET is_used=0, used_by_guid=NULL WHERE name_id={}",
                    SharedDb(), NameTable(pool), name_id).c_str());
                ++released;
            } while (orphan_res->NextRow());
        }
        if (released)
            TC_LOG_INFO("playerbot.v2",
                "[BotNamePool] ReconcileOnBoot: released {} orphaned {} name(s).",
                released, NameTable(pool));
    }

    // Then load the (post-cleanup) is_used=0 set into memory.
    std::lock_guard lk(g_mutex);
    Load_locked();
}

BotNamePool::PoolStats BotNamePool::GetStats()
{
    std::lock_guard lk(g_mutex);
    PoolStats s{};
    uint32 generic = uint32(g_generic.male.size() + g_generic.female.size() + g_generic.uni.size());
    uint32 curated = 0;
    for (auto const& [race, b] : g_curated)
        curated += uint32(b.male.size() + b.female.size() + b.uni.size());
    s.available = generic + curated;
    s.total     = uint32(g_name_to_meta.size());
    for (auto const& [race, v] : g_surnames)
        s.surnames += uint32(v.size());
    return s;
}

} // namespace Playerbot::V2::Fleet
