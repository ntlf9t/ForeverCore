/*
 * ItemScoreAffix - 装备随机词条（评分系统）
 *
 * 规则来源：3.3.5 项目的 mod-creature-affix（ScoreBudget / ScoreAffixCount / RollScoreEnchant），
 * 参数按本服（Forever 1.60）调整：
 *   白 1 条×5.0 / 绿 2 条×2.8 / 蓝 3 条×2.2 / 紫 4 条×1.8 / 暗金 4 条×1.8 / 橙 5 条×1.8
 *
 * 数据表 world.item_score_enchant：ench（附魔ID）、level（档位=数值×单价）、weight（权重）、
 * mask（甲种掩码）、kind（属性种类，用于避免同属性重复）
 */

#ifndef TRINITYCORE_ITEMSCOREAFFIX_H
#define TRINITYCORE_ITEMSCOREAFFIX_H

#include "Define.h"

class Item;
class Player;

namespace ItemScoreAffix
{
    // 启动时从 world.item_score_enchant 读取词条池
    void Load();

    // 物品被创建时调用：按装等/品质/部位算评分，随机挂上词条附魔
    void Apply(Player* owner, Item* item);

    // 旧版可见槽迁移到隐藏槽（登录时对已有物品执行一次）
    void Migrate(Player* owner, Item* item);
    void MigrateAll(Player* owner);

    // 洗练：重抽评分与词条（不检查是否已有附魔）
    void Reroll(Player* owner, Item* item, bool maxScore = false);

    // 单条洗练：index = 0..3，对应四个词条槽
    void RerollLine(Player* owner, Item* item, uint32 index);

    // 乱穿洗：总分重新随机分配，可跨流派
    bool RerollChaos(Player* owner, Item* item);

    // 风格洗：锁定每条预算和流派，只换属性
    bool RerollStyle(Player* owner, Item* item);

    // 当前评分（0 = 没有评分行）
    uint32 GetScore(Item const* item);

    // 评分上限
    uint32 GetBudget(Player* owner, Item const* item);
}

#endif // TRINITYCORE_ITEMSCOREAFFIX_H
