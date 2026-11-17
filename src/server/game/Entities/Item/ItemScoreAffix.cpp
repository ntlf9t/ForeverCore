/*
 * ItemScoreAffix - 装备随机词条（评分系统），实现见头文件说明。
 */

#include "ItemScoreAffix.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "ItemTemplate.h"
#include "Log.h"
#include "Player.h"
#include "Random.h"

#include <algorithm>
#include <map>
#include <vector>

namespace
{
    struct ScoreAffixEntry
    {
        uint32 Ench   = 0;
        uint32 Level  = 0;   // 档位 = 数值 × 单价
        uint32 Weight = 0;
        uint32 Mask   = 0;   // 甲种掩码
        uint32 Kind   = 0;   // 属性种类（避免同属性重复）
    };

    std::vector<ScoreAffixEntry> _pool;

    // 与 3.3.5 一致：装等超过 92 后按 0.4 压缩
    // 评分显示附魔：ID = SCORE_ENCHANT_BASE + 评分（1..SCORE_MAX）
    constexpr uint32 SCORE_ENCHANT_BASE = 210000;
    constexpr uint32 SCORE_MAX          = 1000;

    constexpr uint32 SCORE_MAX_ITEM_LEVEL = 92;
    constexpr uint32 SCORE_BUDGET_CAP     = 12000;

    enum AffixMask : uint32
    {
        MASK_CLOTH   = 1,
        MASK_LEATHER = 2,
        MASK_MAIL    = 4,
        MASK_PLATE   = 8,
        MASK_WEAPON  = 16,
        MASK_SHIELD  = 32,
        MASK_MISC    = 64,
        MASK_ALL     = 127
    };

    uint32 CountForQuality(uint32 quality)
    {
        switch (quality)
        {
            case ITEM_QUALITY_NORMAL:    return 1;
            case ITEM_QUALITY_UNCOMMON:  return 2;
            case ITEM_QUALITY_RARE:      return 3;
            case ITEM_QUALITY_EPIC:      return 4;
            case ITEM_QUALITY_ARTIFACT:  return 4;
            case ITEM_QUALITY_LEGENDARY: return 4;
            default:                     return 0;
        }
    }

    uint32 Budget(uint32 itemLevel, uint32 quality, InventoryType inventoryType)
    {
        if (itemLevel > SCORE_MAX_ITEM_LEVEL)
            itemLevel = SCORE_MAX_ITEM_LEVEL + uint32(float(itemLevel - SCORE_MAX_ITEM_LEVEL) * 0.4f);

        uint32 qualityNum = 0;
        switch (quality)
        {
            case ITEM_QUALITY_NORMAL:    qualityNum = 50; break;   // ×5.0
            case ITEM_QUALITY_UNCOMMON:  qualityNum = 28; break;   // ×2.8
            case ITEM_QUALITY_RARE:      qualityNum = 22; break;   // ×2.2
            case ITEM_QUALITY_EPIC:      qualityNum = 18; break;   // ×1.8
            case ITEM_QUALITY_ARTIFACT:  qualityNum = 18; break;   // ×1.8
            case ITEM_QUALITY_LEGENDARY: qualityNum = 23; break;   // ×2.3（本服：橙 4 条，靠系数拉高总量）
            default:                     return 0;
        }

        uint32 slotNum = 1;
        uint32 slotDen = 1;
        switch (inventoryType)
        {
            case INVTYPE_WEAPON:
            case INVTYPE_WEAPONMAINHAND:
            case INVTYPE_WEAPONOFFHAND:
                slotNum = 3;
                slotDen = 4;
                break;
            case INVTYPE_2HWEAPON:
                slotNum = 9;
                slotDen = 5;
                break;
            case INVTYPE_NON_EQUIP:
            case INVTYPE_BODY:
            case INVTYPE_BAG:
            case INVTYPE_TABARD:
            case INVTYPE_AMMO:
            case INVTYPE_QUIVER:
                return 0;
            default:
                break;
        }

        return itemLevel * qualityNum * slotNum / (10 * slotDen);
    }

    uint32 MaskForItem(ItemTemplate const* proto)
    {
        if (proto->GetClass() == ITEM_CLASS_WEAPON)
            return MASK_WEAPON;

        switch (proto->GetSubClass())
        {
            case ITEM_SUBCLASS_ARMOR_CLOTH:   return MASK_CLOTH;
            case ITEM_SUBCLASS_ARMOR_LEATHER: return MASK_LEATHER;
            case ITEM_SUBCLASS_ARMOR_MAIL:    return MASK_MAIL;
            case ITEM_SUBCLASS_ARMOR_PLATE:   return MASK_PLATE;
            case ITEM_SUBCLASS_ARMOR_SHIELD:  return MASK_SHIELD;
            default:                          return MASK_MISC;
        }
    }
}

void ItemScoreAffix::Load()
{
    _pool.clear();

    QueryResult result = WorldDatabase.Query("SELECT ench, level, weight, mask, kind FROM item_score_enchant");
    if (!result)
    {
        TC_LOG_INFO("server.loading", ">> Loaded 0 item score affixes. Table `item_score_enchant` is empty.");
        return;
    }

    do
    {
        Field* fields = result->Fetch();
        ScoreAffixEntry entry;
        entry.Ench   = fields[0].GetUInt32();
        entry.Level  = fields[1].GetUInt32();
        entry.Weight = fields[2].GetUInt32();
        entry.Mask   = fields[3].GetUInt32();
        entry.Kind   = fields[4].GetUInt32();
        _pool.push_back(entry);
    } while (result->NextRow());

    TC_LOG_INFO("server.loading", ">> Loaded {} item score affixes", uint32(_pool.size()));
}

void ItemScoreAffix::Apply(Player* owner, Item* item)
{
    if (!owner || !item)
        return;

    if (!sConfigMgr->GetBoolDefault("ItemScore.Enable", true))
        return;

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto)
        return;

    // 只处理武器与护甲
    if (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR)
        return;

    // 已经有附魔的物品不再处理（避免重复叠加）
    if (item->GetEnchantmentId(PERM_ENCHANTMENT_SLOT) != 0)
        return;

    uint32 const count = CountForQuality(proto->GetQuality());
    if (!count)
        return;

    uint32 const budget = Budget(item->GetItemLevel(owner), proto->GetQuality(), proto->GetInventoryType());
    if (!budget || budget > SCORE_BUDGET_CAP)
    {
        if (!budget)
            return;
    }

    uint32 const shown = std::min(urand(1, std::min(budget, SCORE_BUDGET_CAP)), SCORE_MAX);

    // 槽位 0 放「评分 N」：玩家从 tooltip 就能看到这件装备的评分上限参考
    item->SetEnchantment(PERM_ENCHANTMENT_SLOT, SCORE_ENCHANT_BASE + shown, 0, 0);
    uint32 const mask = MaskForItem(proto);

    std::vector<ScoreAffixEntry const*> candidates;
    candidates.reserve(_pool.size());
    for (ScoreAffixEntry const& entry : _pool)
        if ((entry.Mask & mask) && entry.Level <= shown)
            candidates.push_back(&entry);

    // 同一属性只保留「评分买得起的最高档」：数值 = 评分 / 单价
    {
        std::map<uint32, ScoreAffixEntry const*> bestPerKind;
        for (ScoreAffixEntry const* entry : candidates)
        {
            auto it = bestPerKind.find(entry->Kind);
            if (it == bestPerKind.end() || entry->Level > it->second->Level)
                bestPerKind[entry->Kind] = entry;
        }

        candidates.clear();
        for (auto const& pair : bestPerKind)
            candidates.push_back(pair.second);
    }

    if (candidates.empty())
        return;

    // 白装：只取能达到的最高档（与 3.3.5 一致）
    if (proto->GetQuality() == ITEM_QUALITY_NORMAL)
    {
        uint32 bestLevel = 0;
        for (ScoreAffixEntry const* entry : candidates)
            bestLevel = std::max(bestLevel, entry->Level);

        candidates.erase(std::remove_if(candidates.begin(), candidates.end(),
            [bestLevel](ScoreAffixEntry const* entry) { return entry->Level < bestLevel; }), candidates.end());
    }

    // 实测只有这四个槽位的词条会显示在 tooltip 上（槽 0 留给评分）
    // 槽 6（棱彩）与 9-12 的属性会生效但客户端不显示；槽 2/3/4 是宝石孔，没孔会被拒绝
    static constexpr EnchantmentSlot AffixSlots[] =
    {
        TEMP_ENCHANTMENT_SLOT,      // 槽 1，显示
        BONUS_ENCHANTMENT_SLOT,     // 槽 5，显示
        USE_ENCHANTMENT_SLOT,       // 槽 7，显示
        PROP_ENCHANTMENT_SLOT_0     // 槽 8，显示
    };
    static constexpr uint32 AffixSlotCount = sizeof(AffixSlots) / sizeof(AffixSlots[0]);

    std::vector<uint32> usedKinds;
    usedKinds.reserve(count);

    for (uint32 index = 0; index < count; ++index)
    {
        uint32 total = 0;
        for (ScoreAffixEntry const* entry : candidates)
            if (std::find(usedKinds.begin(), usedKinds.end(), entry->Kind) == usedKinds.end())
                total += entry->Weight;

        if (!total)
            break;

        uint32 roll = urand(1, total);
        uint32 cursor = 0;
        ScoreAffixEntry const* chosen = nullptr;
        for (ScoreAffixEntry const* entry : candidates)
        {
            if (std::find(usedKinds.begin(), usedKinds.end(), entry->Kind) != usedKinds.end())
                continue;

            cursor += entry->Weight;
            if (roll <= cursor)
            {
                chosen = entry;
                break;
            }
        }

        if (!chosen)
            break;

        usedKinds.push_back(chosen->Kind);
        if (index >= AffixSlotCount)
            break;

        item->SetEnchantment(AffixSlots[index], chosen->Ench, 0, 0);
    }
}

void ItemScoreAffix::Reroll(Player* owner, Item* item, bool maxScore)
{
    if (!owner || !item)
        return;

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto)
        return;

    if (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR)
        return;

    uint32 const count = CountForQuality(proto->GetQuality());
    if (!count)
        return;

    uint32 budget = Budget(item->GetItemLevel(owner), proto->GetQuality(), proto->GetInventoryType());
    if (!budget)
        return;

    if (budget > SCORE_BUDGET_CAP)
        budget = SCORE_BUDGET_CAP;

    uint32 const shown = maxScore ? std::min(budget, SCORE_MAX) : std::min(urand(1, budget), SCORE_MAX);

    item->SetEnchantment(PERM_ENCHANTMENT_SLOT, SCORE_ENCHANT_BASE + shown, 0, 0);

    uint32 const mask = MaskForItem(proto);
    std::vector<ScoreAffixEntry const*> candidates;
    candidates.reserve(_pool.size());
    for (ScoreAffixEntry const& entry : _pool)
        if ((entry.Mask & mask) && entry.Level <= shown)
            candidates.push_back(&entry);

    // 同一属性只保留「评分买得起的最高档」：数值 = 评分 / 单价
    {
        std::map<uint32, ScoreAffixEntry const*> bestPerKind;
        for (ScoreAffixEntry const* entry : candidates)
        {
            auto it = bestPerKind.find(entry->Kind);
            if (it == bestPerKind.end() || entry->Level > it->second->Level)
                bestPerKind[entry->Kind] = entry;
        }

        candidates.clear();
        for (auto const& pair : bestPerKind)
            candidates.push_back(pair.second);
    }

    if (candidates.empty())
        return;

    if (proto->GetQuality() == ITEM_QUALITY_NORMAL)
    {
        uint32 bestLevel = 0;
        for (ScoreAffixEntry const* entry : candidates)
            bestLevel = std::max(bestLevel, entry->Level);

        candidates.erase(std::remove_if(candidates.begin(), candidates.end(),
            [bestLevel](ScoreAffixEntry const* entry) { return entry->Level < bestLevel; }), candidates.end());
    }

    static constexpr EnchantmentSlot AffixSlots[] =
    {
        TEMP_ENCHANTMENT_SLOT, BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
    };
    static constexpr uint32 AffixSlotCount = sizeof(AffixSlots) / sizeof(AffixSlots[0]);

    // 先清空四条词条槽，避免旧的残留
    for (uint32 i = 0; i < AffixSlotCount; ++i)
        item->SetEnchantment(AffixSlots[i], 0, 0, 0);

    std::vector<uint32> usedKinds;
    usedKinds.reserve(count);

    for (uint32 index = 0; index < count && index < AffixSlotCount; ++index)
    {
        uint32 total = 0;
        for (ScoreAffixEntry const* entry : candidates)
            if (std::find(usedKinds.begin(), usedKinds.end(), entry->Kind) == usedKinds.end())
                total += entry->Weight;

        if (!total)
            break;

        uint32 roll = urand(1, total);
        uint32 cursor = 0;
        ScoreAffixEntry const* chosen = nullptr;
        for (ScoreAffixEntry const* entry : candidates)
        {
            if (std::find(usedKinds.begin(), usedKinds.end(), entry->Kind) != usedKinds.end())
                continue;

            cursor += entry->Weight;
            if (roll <= cursor)
            {
                chosen = entry;
                break;
            }
        }

        if (!chosen)
            break;

        usedKinds.push_back(chosen->Kind);
        item->SetEnchantment(AffixSlots[index], chosen->Ench, 0, 0);
    }

    item->SetState(ITEM_CHANGED, owner);
}
uint32 ItemScoreAffix::GetScore(Item const* item)
{
    if (!item)
        return 0;

    uint32 const ench = item->GetEnchantmentId(PERM_ENCHANTMENT_SLOT);
    if (ench < SCORE_ENCHANT_BASE)
        return 0;

    return ench - SCORE_ENCHANT_BASE;
}

uint32 ItemScoreAffix::GetBudget(Player* owner, Item const* item)
{
    if (!item)
        return 0;

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto)
        return 0;

    uint32 budget = Budget(item->GetItemLevel(owner), proto->GetQuality(), proto->GetInventoryType());
    return std::min(budget, SCORE_BUDGET_CAP);
}

void ItemScoreAffix::RerollLine(Player* owner, Item* item, uint32 index)
{
    if (!owner || !item || index >= 4)
        return;

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto)
        return;

    if (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR)
        return;

    uint32 const shown = GetScore(item);
    if (!shown)
        return;

    uint32 const mask = MaskForItem(proto);

    std::vector<ScoreAffixEntry const*> candidates;
    candidates.reserve(_pool.size());
    for (ScoreAffixEntry const& entry : _pool)
        if ((entry.Mask & mask) && entry.Level <= shown)
            candidates.push_back(&entry);

    // 同一属性只保留「评分买得起的最高档」：数值 = 评分 / 单价
    {
        std::map<uint32, ScoreAffixEntry const*> bestPerKind;
        for (ScoreAffixEntry const* entry : candidates)
        {
            auto it = bestPerKind.find(entry->Kind);
            if (it == bestPerKind.end() || entry->Level > it->second->Level)
                bestPerKind[entry->Kind] = entry;
        }

        candidates.clear();
        for (auto const& pair : bestPerKind)
            candidates.push_back(pair.second);
    }

    if (candidates.empty())
        return;

    static constexpr EnchantmentSlot AffixSlots[] =
    {
        TEMP_ENCHANTMENT_SLOT, BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0
    };

    // 避开其它槽已经用掉的词条种类
    std::vector<uint32> usedKinds;
    for (uint32 i = 0; i < 4; ++i)
    {
        if (i == index)
            continue;

        uint32 const ench = item->GetEnchantmentId(AffixSlots[i]);
        if (!ench)
            continue;

        for (ScoreAffixEntry const& entry : _pool)
            if (entry.Ench == ench)
            {
                usedKinds.push_back(entry.Kind);
                break;
            }
    }

    uint32 total = 0;
    for (ScoreAffixEntry const* entry : candidates)
        if (std::find(usedKinds.begin(), usedKinds.end(), entry->Kind) == usedKinds.end())
            total += entry->Weight;

    if (!total)
        return;

    uint32 roll = urand(1, total);
    uint32 cursor = 0;
    ScoreAffixEntry const* chosen = nullptr;
    for (ScoreAffixEntry const* entry : candidates)
    {
        if (std::find(usedKinds.begin(), usedKinds.end(), entry->Kind) != usedKinds.end())
            continue;

        cursor += entry->Weight;
        if (roll <= cursor)
        {
            chosen = entry;
            break;
        }
    }

    if (!chosen)
        return;

    item->SetEnchantment(AffixSlots[index], chosen->Ench, 0, 0);
    item->SetState(ITEM_CHANGED, owner);
}