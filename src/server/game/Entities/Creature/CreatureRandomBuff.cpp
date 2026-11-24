#include "CreatureRandomBuff.h"
#include "Creature.h"
#include "DatabaseEnv.h"
#include "GameObject.h"
#include "Log.h"
#include "Map.h"
#include "Player.h"
#include "Random.h"
#include "SpellAuras.h"
#include "SpellAuraEffects.h"
#include "SpellInfo.h"
#include "SpellMgr.h"
#include "Timer.h"

#include <algorithm>
#include <atomic>
#include <cctype>
#include <mutex>
#include <string>
#include <unordered_map>
#include <unordered_set>
#include <vector>

namespace
{
    constexpr uint8 MAX_BUFFS = 3;
    constexpr float MAX_LOOT_MULTIPLIER = 16.0f;

    struct BuffRow
    {
        uint32 id = 0;
        std::string name;
        uint8 category = 0;
        uint32 spellId = 0;
        uint32 weight = 0;
        int32 percent = 0;
        bool treasure = false;
    };

    struct State
    {
        uint32 spellIds[MAX_BUFFS] = { 0, 0, 0 };
        CreatureRandomBuff::Info info;
    };

    std::vector<BuffRow> _pool;
    std::unordered_map<ObjectGuid, State> _states;
    std::mutex _stateMutex;
    std::atomic<uint8> _dungeonDifficulty{ 0 };
    std::atomic<uint32> auraFailures{ 0 };

    bool CanHaveBuffs(Creature* creature)
    {
        if (!creature->IsAlive())
            return false;

        // 宠物 / 召唤物 / 图腾 / 触发器 / 小动物不参与
        if (creature->IsPet() || creature->IsSummon() || creature->IsTotem())
            return false;
        if (creature->IsTrigger() || creature->IsCritter())
            return false;

        // 敌对怪全部参与；中立（黄名）怪也参与，但排除商人/训练师/任务 NPC
        if (!creature->IsHostileToPlayers())
        {
            if (!creature->IsNeutralToAll())
                return false;
            if (creature->GetCreatureTemplate()->npcflag)
                return false;
        }

        Map* map = creature->GetMap();
        if (!map || map->IsBattlegroundOrArena())
            return false;

        return true;
    }

    BuffRow const* PickWeighted(std::vector<BuffRow const*>& candidates)
    {
        uint32 totalWeight = 0;
        for (BuffRow const* row : candidates)
            totalWeight += row->weight;

        if (!totalWeight)
            return nullptr;

        uint32 roll = urand(1, totalWeight);
        size_t index = 0;
        for (; index < candidates.size(); ++index)
        {
            if (roll <= candidates[index]->weight)
                break;
            roll -= candidates[index]->weight;
        }

        if (index >= candidates.size())
            index = candidates.size() - 1;

        BuffRow const* row = candidates[index];
        candidates.erase(candidates.begin() + ptrdiff_t(index));
        return row;
    }

    bool HasNearbyPlayer(Creature* creature, float range)
    {
        for (MapReference const& ref : creature->GetMap()->GetPlayers())
            if (Player* player = ref.GetSource())
                if (player->IsInWorld() && player->IsWithinDistInMap(creature, range))
                    return true;

        return false;
    }

    // 一次性扫描：只在 1.60 怪物实际用过的技能里找载体（客户端必然认识），
    // 条件：无任何光环效果、有原生效果槽、且不是玩家可学法术（避免影响职业技能/宠物技能）。
    void ScanCarrierSpells()
    {
        uint32 const started = getMSTime();

        std::unordered_set<uint32> playerSpells;
        auto loadSpells = [&playerSpells](char const* sql)
        {
            if (QueryResult result = WorldDatabase.Query(sql))
                do
                    playerSpells.insert(result->Fetch()[0].GetUInt32());
                while (result->NextRow());
        };
        loadSpells("SELECT Spell FROM playercreateinfo_spell_custom");
        loadSpells("SELECT SpellId FROM trainer_spell");
        loadSpells("SELECT SpellID FROM spell_learn_spell");

        std::unordered_set<uint32> creatureSpells;
        if (QueryResult result = WorldDatabase.Query("SELECT DISTINCT Spell FROM creature_template_spell WHERE Spell <> 0"))
            do
                creatureSpells.insert(result->Fetch()[0].GetUInt32());
            while (result->NextRow());

        // 服务端专用法术客户端不认识，排除
        if (QueryResult result = WorldDatabase.Query("SELECT Id FROM serverside_spell"))
            do
                playerSpells.insert(result->Fetch()[0].GetUInt32());
            while (result->NextRow());

        uint32 matches = 0;
        for (uint32 id = 1; id < 27000 && matches < 400; ++id)
        {
            if (!creatureSpells.contains(id) || playerSpells.contains(id))
                continue;

            SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(id, DIFFICULTY_NONE);
            if (!spellInfo || !spellInfo->SpellName)
                continue;

            char const* rawName = spellInfo->SpellName->Str[LOCALE_enUS];
            if (!rawName || !*rawName)
                continue;

            uint32 effectCount = 0;
            uint32 auraCount = 0;
            std::string effects;
            for (SpellEffectInfo const& effect : spellInfo->GetEffects())
            {
                if (!effect.Effect)
                    continue;

                ++effectCount;
                if (!effects.empty())
                    effects += ',';
                effects += std::to_string(uint32(effect.Effect));
                if (effect.IsUnitOwnedAuraEffect())
                    ++auraCount;
            }

            if (!effectCount || auraCount)
                continue;

            TC_LOG_INFO("server.loading", ">> CARRIER id={} name=[{}] passive={} effects=[{}]",
                id, rawName, spellInfo->IsPassive() ? 1 : 0, effects);
            ++matches;
        }

        TC_LOG_INFO("server.loading", ">> CARRIER scan done: {} matches in {} ms (player: {}, creature: {})",
            matches, GetMSTimeDiffToNow(started), uint32(playerSpells.size()), uint32(creatureSpells.size()));
    }
}

namespace CreatureRandomBuff
{
    void Load()
    {
        _pool.clear();

        {
            std::lock_guard<std::mutex> lock(_stateMutex);
            _states.clear();
        }

        if (QueryResult result = WorldDatabase.Query(
            "SELECT id, name, category, buffSpellId, weight, percent, treasure FROM creature_random_buff WHERE enabled = 1"))
        {
            do
            {
                Field* fields = result->Fetch();

                BuffRow row;
                row.id = fields[0].GetUInt32();
                row.name = fields[1].GetString();
                row.category = fields[2].GetUInt8();
                row.spellId = fields[3].GetUInt32();
                row.weight = fields[4].GetUInt32();
                row.percent = fields[5].GetInt32();
                row.treasure = fields[6].GetUInt8() != 0;

                if (!row.weight)
                    continue;

                _pool.push_back(std::move(row));
            } while (result->NextRow());
        }

        uint8 difficulty = 0;
        if (QueryResult result = WorldDatabase.Query(
            "SELECT value FROM creature_random_buff_config WHERE setting = 'dungeon_difficulty'"))
            difficulty = std::min<uint8>(result->Fetch()[0].GetUInt8(), 2);
        _dungeonDifficulty.store(difficulty);

        ScanCarrierSpells();

        TC_LOG_INFO("server.loading", ">> Loaded {} creature random buffs (dungeon difficulty = {})",
            uint32(_pool.size()), uint32(difficulty));
    }

    void Apply(Creature* creature)
    {
        if (!creature)
            return;

        Remove(creature);

        if (!creature->IsInWorld() || !CanHaveBuffs(creature) || _pool.empty())
            return;

        Map* map = creature->GetMap();
        uint8 count = map->IsDungeon() ? uint8(GetDungeonDifficulty() + 1) : uint8(urand(0, 3));
        if (!count)
            return;

        std::vector<BuffRow const*> candidates;
        candidates.reserve(_pool.size());
        for (BuffRow const& row : _pool)
            candidates.push_back(&row);

        State state;
        std::string pickedNames;
        std::string pickedData;
        bool has80Reduction = false;
        for (uint8 n = 0; n < count && !candidates.empty(); ++n)
        {
            BuffRow const* row = PickWeighted(candidates);
            if (!row)
                break;

            if (row->spellId)
            {
                if (Aura* aura = creature->AddAura(row->spellId, creature))
                {
                    // 这个客户端不显示 duration = -1 的光环（目标框里看不到图标），
                    // 但带正时长的能显示，所以给一个 24 小时超长时长；怪物复活会重新挂。
                    constexpr int32 LONG_DURATION = 24 * 60 * 60 * 1000;
                    aura->SetMaxDuration(LONG_DURATION);
                    aura->SetDuration(LONG_DURATION);
                }
                else if (auraFailures.fetch_add(1) < 5)
                    TC_LOG_ERROR("server.loading", ">> CRB aura failed entry={} spell={}",
                        creature->GetEntry(), row->spellId);
            }

            if (!pickedNames.empty())
                pickedNames += '+';
            pickedNames += row->name;

            if (!pickedData.empty())
                pickedData += '#';
            pickedData += std::to_string(uint32(row->category));
            pickedData += ':';
            pickedData += row->name;

            state.spellIds[n] = row->spellId;
            if (row->category == 3 && row->percent >= 80)
                has80Reduction = true;
            state.info.percentSum += row->percent;
            state.info.treasure = state.info.treasure || row->treasure;
            state.info.count = uint8(n + 1);
        }

        if (!state.info.count)
            return;

        state.info.dangerPercent = state.info.percentSum;
        if (has80Reduction)
            state.info.dangerPercent = std::max(state.info.dangerPercent, 300);

        state.info.lootMultiplier = 1.0f + float(state.info.percentSum) / 100.0f
            + (state.info.treasure ? 9.0f : 0.0f);
        if (state.info.lootMultiplier > MAX_LOOT_MULTIPLIER)
            state.info.lootMultiplier = MAX_LOOT_MULTIPLIER;
        state.info.buffs = pickedNames;
        state.info.buffData = pickedData;

        // 300 以下只微调；300 开始直接跳到 2 倍，方便一眼分辨
        float scale = 1.0f;
        if (state.info.dangerPercent >= 300)
            scale = 2.0f + std::min(state.info.dangerPercent - 300, 600) / 600.0f;
        else if (state.info.dangerPercent >= 200)
            scale = 1.15f;
        else if (state.info.dangerPercent >= 100)
            scale = 1.05f;

        if (scale > 3.0f)
            scale = 3.0f;

        // 宝藏怪也要一眼看出来：至少放大到 135%
        if (state.info.treasure)
            scale = std::max(scale, 1.35f);

        if (scale != 1.0f)
            creature->SetObjectScale(creature->GetNativeObjectScale() * scale);

        // 300 以上：永久寒冰护盾视觉，吸收量设为 0
        if (state.info.dangerPercent >= 300)
        {
            if (Aura* aura = creature->AddAura(11426, creature))
            {
                aura->SetMaxDuration(-1);
                aura->SetDuration(-1);
                for (AuraEffect* effect : aura->GetAuraEffects())
                    if (effect->GetAuraType() == SPELL_AURA_SCHOOL_ABSORB)
                        effect->SetAmount(0.0);
            }
        }

        // 宝藏：金色真言术盾，同样不吸收伤害
        if (state.info.treasure)
        {
            if (Aura* aura = creature->AddAura(17, creature))
            {
                aura->SetMaxDuration(-1);
                aura->SetDuration(-1);
                for (AuraEffect* effect : aura->GetAuraEffects())
                    if (effect->GetAuraType() == SPELL_AURA_SCHOOL_ABSORB)
                        effect->SetAmount(0.0);
            }
        }

        Info info = state.info;
        {
            std::lock_guard<std::mutex> lock(_stateMutex);
            _states[creature->GetGUID()] = state;
        }

        if (map->IsDungeon() || info.treasure || HasNearbyPlayer(creature, 100.0f))
        {
            TC_LOG_INFO("server.loading",
                ">> CRB apply entry={} name={} buffs=[{}] count={} percent={} mult={:.2f} treasure={} visible={}",
                creature->GetEntry(), creature->GetName(), pickedNames, uint32(info.count), info.percentSum,
                info.lootMultiplier, info.treasure ? 1 : 0, uint32(creature->GetVisibleAuras().size()));
        }
    }

    void Remove(Creature* creature)
    {
        if (!creature)
            return;

        State state;
        bool found = false;
        {
            std::lock_guard<std::mutex> lock(_stateMutex);
            auto it = _states.find(creature->GetGUID());
            if (it != _states.end())
            {
                state = it->second;
                _states.erase(it);
                found = true;
            }
        }

        if (!found)
            return;

        for (uint32 spellId : state.spellIds)
            if (spellId)
                creature->RemoveAurasDueToSpell(spellId);

        creature->SetObjectScale(creature->GetNativeObjectScale());
        creature->RemoveAurasDueToSpell(11426);
        creature->RemoveAurasDueToSpell(17);
    }

    float GetLootMultiplier(ObjectGuid guid)
    {
        std::lock_guard<std::mutex> lock(_stateMutex);
        auto it = _states.find(guid);
        return it != _states.end() ? it->second.info.lootMultiplier : 1.0f;
    }

    bool GetInfo(ObjectGuid guid, Info& info)
    {
        std::lock_guard<std::mutex> lock(_stateMutex);
        auto it = _states.find(guid);
        if (it == _states.end())
            return false;

        info = it->second.info;
        return true;
    }

    uint8 GetDungeonDifficulty()
    {
        return _dungeonDifficulty.load();
    }

    void SetDungeonDifficulty(uint8 difficulty)
    {
        if (difficulty > 2)
            difficulty = 2;

        _dungeonDifficulty.store(difficulty);

        std::string sql = "REPLACE INTO creature_random_buff_config (setting, value) VALUES ('dungeon_difficulty', "
            + std::to_string(uint32(difficulty)) + ")";
        WorldDatabase.Execute(sql.c_str());
    }

    char const* GetDungeonDifficultyName(uint8 difficulty)
    {
        switch (difficulty)
        {
            case 1: return "困难";
            case 2: return "史诗";
            default: return "普通";
        }
    }
}
