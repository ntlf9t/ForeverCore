/*
 * CreatureRandomBuff - 怪物随机附魔（随机 buff）
 *
 * 设计：
 *   - 野外：每只怪 0~3 个 buff（均匀随机）
 *   - 副本：普通 1 / 困难 2 / 史诗 3（全局难度开关 .dungeon）
 *   - 掉落倍率 = 1 + Σ percent/100 + (宝藏 ? 9 : 0)，上限 ×16
 *   - 体型按 Σ percent 分档：<100 1.0 / 100+ 1.2 / 300+ 1.5 / 600+ 2.0
 *
 * 数据表：world.creature_random_buff（buff 池）
 *         world.creature_random_buff_config（全局难度）
 */

#ifndef TRINITYCORE_CREATURERANDOMBUFF_H
#define TRINITYCORE_CREATURERANDOMBUFF_H

#include "Define.h"
#include "ObjectGuid.h"

#include <string>

class Creature;

namespace CreatureRandomBuff
{
    struct Info
    {
        uint8 count = 0;            // 抽到几个 buff
        int32 percentSum = 0;       // 百分比之和
        int32 dangerPercent = 0;    // 危险值：80% 减伤时至少按 300 算
        float lootMultiplier = 1.f; // 掉落/经验/金币倍率
        bool treasure = false;      // 是否带宝藏
        std::string buffs;          // buff 名字（用 + 连接，调试/日志用）
        std::string buffData;       // 给插件的格式：类别:名字|类别:名字
    };

    // 启动时读取 buff 池与难度配置
    void Load();

    // 怪物进世界 / 复活时调用：移除旧 buff，重新抽取并挂上
    void Apply(Creature* creature);

    // 怪物离开世界时调用：移除状态
    void Remove(Creature* creature);

    // 掉落/经验/金币倍率，没有状态时返回 1.0
    float GetLootMultiplier(ObjectGuid guid);

    // 查询某只怪的 buff 信息（脚本日志/提示用）
    bool GetInfo(ObjectGuid guid, Info& info);

    // 0 = 普通, 1 = 困难, 2 = 史诗
    uint8 GetDungeonDifficulty();
    void SetDungeonDifficulty(uint8 difficulty);
    char const* GetDungeonDifficultyName(uint8 difficulty);
}

#endif // TRINITYCORE_CREATURERANDOMBUFF_H
