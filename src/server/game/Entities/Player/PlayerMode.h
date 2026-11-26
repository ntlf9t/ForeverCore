/*
 * 角色模式（孤勇 / 重生）
 *
 * 数据表：characters.character_modes
 * 当前阶段只做状态与选择校验；限制、Buff、重生流程在后续阶段接入。
 */

#ifndef TRINITYCORE_PLAYERMODE_H
#define TRINITYCORE_PLAYERMODE_H

#include "Define.h"
#include "ObjectGuid.h"

#include <mutex>
#include <string>
#include <unordered_map>

class Player;

namespace PlayerMode
{
    struct Data
    {
        bool chosen = false;        // 是否已选择过模式
        bool lone = false;          // 孤勇
        bool loneExited = false;    // 已退出孤勇，保留固定的 +30% 伤害/生命
        uint32 loneDamage = 0;      // 孤勇增伤 %
        uint32 loneHealth = 0;      // 孤勇生命 %
        uint32 loneTaken = 0;       // 孤勇承伤 %（负面）
        uint32 rebirths = 0;        // 重生次数
        bool rebirthActive = false; // 当前重生流程中
        bool legacyGiven = false;   // 孤勇永久死亡遗产是否已发放
        bool loneRewardGiven = false; // 孤勇 60 级奖励是否已发放
    };

    // 登录时读取，登出/变更时保存
    void Load(Player* player);
    void Save(Player* player);

    Data Get(Player* player);
    Data& GetMutable(Player* player);

    // 登录 / 选择孤勇 / 重生奖励变化后调用：挂上或刷新孤勇 Buff
    void ApplyAuras(Player* player);

    bool IsLone(Player* player);
    bool IsRebirthActive(Player* player);

    // 60 级前死亡无法复活（孤勇 / 重生流程中）
    bool IsDeathLocked(Player* player);

    // 孤勇 60 级前永久死亡：退出公会、全服公告 + 随机遗产
    void HandleLoneDeath(Player* player);

    // 等级变化：孤勇首次到 60 级发奖励（36 格包 + 1 万金）
    void HandleLevelUp(Player* player, uint8 newLevel);

    // 孤勇掉落倍率（物品/金币 ×3，经验不变）
    float GetLootRate(Player* player);

    // 选择孤勇：校验等级/金币/银行/物品绑定
    bool CanChooseLone(Player* player, std::string& reason);
    bool ChooseLone(Player* player, std::string& reason);

    // 60 级退出孤勇：解除组队/交易等限制，保留固定 +30% 伤害和 +30% 生命
    bool CanExitLone(Player* player, std::string& reason);
    bool ExitLone(Player* player, std::string& reason);

    // 重生（后续阶段实现）
    bool CanRebirth(Player* player, std::string& reason);
    bool DoRebirth(Player* player, std::string& reason);
    void SetRebirthActive(Player* player, bool active);

    // 遗忘所有职业高阶技能（保留 1 级技能、专业、种族、坐骑）
    void ResetClassSkills(Player* player);

    // 同步天赋点：等级基础点 + 重生次数 ×3
    void SyncTalentPoints(Player* player);
}

#endif // TRINITYCORE_PLAYERMODE_H
