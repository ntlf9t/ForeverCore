/*
 * ItemScoreAffix - 装备随机词条（评分系统），实现见头文件说明。
 */

#include "ItemScoreAffix.h"
#include "Bag.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "ItemTemplate.h"
#include "Log.h"
#include "Player.h"
#include "Random.h"

#include <algorithm>
#include <iterator>
#include <limits>
#include <map>
#include <vector>

namespace
{
    // 0/1 是玩家永久/临时附魔槽；评分放隐藏槽 9，3 条词条放原生可见的 5/7/8。
    constexpr EnchantmentSlot SCORE_ENCHANTMENT_SLOT = PROP_ENCHANTMENT_SLOT_1;
    constexpr EnchantmentSlot AFFIX_SLOTS[3] =
    {
        BONUS_ENCHANTMENT_SLOT,
        USE_ENCHANTMENT_SLOT,
        PROP_ENCHANTMENT_SLOT_0
    };
    constexpr uint32 AffixSlotCount = 3;

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
            case ITEM_QUALITY_EPIC:      return 3;
            case ITEM_QUALITY_ARTIFACT:  return 3;
            case ITEM_QUALITY_LEGENDARY: return 3;
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
            case ITEM_QUALITY_EPIC:      qualityNum = 24; break;   // ×2.4（4 条→3 条，保持总预算）
            case ITEM_QUALITY_ARTIFACT:  qualityNum = 24; break;   // ×2.4
            case ITEM_QUALITY_LEGENDARY: qualityNum = 31; break;   // ×3.1（4 条→3 条，保持总预算）
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

namespace
{
    // 15 流派：与 3.3.5 洗练表对应
    uint32 StyleOfKind(uint32 kind)
    {
        switch (kind)
        {
            case 1: case 7: case 46: case 209:                 return 1;
            case 4: case 207:                                  return 2;
            case 3: case 208:                                  return 3;
            case 0: case 5: case 210:                          return 4;
            case 6: case 211:                                  return 5;
            case 38: case 212:                                 return 6;
            case 39: case 213:                                 return 7;
            case 201: case 214: case 216: case 219: case 221:  return 8;
            case 42: case 45: case 202: case 215:              return 9;
            case 43: case 217:                                 return 10;
            case 41: case 203:                                 return 11;
            case 12: case 48: case 100: case 204:              return 12;
            case 101: case 102: case 103: case 104: case 105:
            case 106: case 205: case 222:                      return 13;
            case 206: case 218: case 220:                      return 15;
            default:                                           return 0;
        }
    }

    ScoreAffixEntry const* FindEntry(uint32 ench)
    {
        for (ScoreAffixEntry const& entry : _pool)
            if (entry.Ench == ench)
                return &entry;
        return nullptr;
    }

    ScoreAffixEntry const* PickAffix(uint32 mask, uint32 style, uint32 budget, bool allowOverBudget)
    {
        std::vector<ScoreAffixEntry const*> candidates;
        uint32 bestLevel = 0;

        for (ScoreAffixEntry const& entry : _pool)
        {
            if (!(entry.Mask & mask) || StyleOfKind(entry.Kind) != style)
                continue;

            if (entry.Level <= budget)
            {
                if (entry.Level > bestLevel)
                {
                    bestLevel = entry.Level;
                    candidates.clear();
                }
                if (entry.Level == bestLevel)
                    candidates.push_back(&entry);
            }
        }

        if (candidates.empty() && allowOverBudget)
        {
            uint32 lowest = std::numeric_limits<uint32>::max();
            for (ScoreAffixEntry const& entry : _pool)
            {
                if (!(entry.Mask & mask) || StyleOfKind(entry.Kind) != style)
                    continue;
                if (entry.Level < lowest)
                {
                    lowest = entry.Level;
                    candidates.clear();
                }
                if (entry.Level == lowest)
                    candidates.push_back(&entry);
            }
        }

        if (candidates.empty())
            return nullptr;

        return candidates[urand(0, int(candidates.size()) - 1)];
    }

    uint32 LoadStoredBudget(ObjectGuid::LowType itemGuid, uint32 index)
    {
        if (!itemGuid)
            return 0;

        std::string sql = "SELECT budget FROM characters.item_score_affix_budget WHERE item_guid = "
            + std::to_string(itemGuid) + " AND slot = " + std::to_string(index);
        QueryResult result = CharacterDatabase.Query(sql.c_str());
        return result ? result->Fetch()[0].GetUInt32() : 0;
    }

    void StoreBudget(ObjectGuid::LowType itemGuid, uint32 index, uint32 budget)
    {
        if (!itemGuid)
            return;

        std::string sql = "REPLACE INTO characters.item_score_affix_budget (item_guid, slot, budget) VALUES ("
            + std::to_string(itemGuid) + "," + std::to_string(index) + "," + std::to_string(budget) + ")";
        CharacterDatabase.Execute(sql.c_str());
    }

    void DeleteBudget(ObjectGuid::LowType itemGuid, uint32 index)
    {
        if (!itemGuid)
            return;

        std::string sql = "DELETE FROM characters.item_score_affix_budget WHERE item_guid = "
            + std::to_string(itemGuid) + " AND slot = " + std::to_string(index);
        CharacterDatabase.Execute(sql.c_str());
    }

    // 旧版 4 条布局的 slot3 合并到 slot2，保持总预算
    void MergeLegacyBudgetRows(ObjectGuid::LowType itemGuid)
    {
        uint32 const slot3 = LoadStoredBudget(itemGuid, 3);
        if (!slot3)
            return;

        uint32 const slot2 = LoadStoredBudget(itemGuid, 2);
        StoreBudget(itemGuid, 2, slot2 + slot3);
        DeleteBudget(itemGuid, 3);
    }

    uint32 ResolveLineBudget(Item* item, uint32 index, uint32 score)
    {
        uint32 const budget = ItemScoreAffix::GetLineBudget(item, index);
        return budget ? budget : score;
    }

    std::vector<uint32> SplitBudget(uint32 total, uint32 count)
    {
        std::vector<uint32> budgets(count, 1);
        uint32 remaining = total > count ? total - count : 0;

        for (uint32 i = 0; i + 1 < count; ++i)
        {
            uint32 maxPick = remaining - (count - 1 - i);
            uint32 pick = maxPick > 0 ? urand(1, maxPick) : 0;
            budgets[i] += pick;
            remaining -= pick;
        }
        budgets[count - 1] += remaining;
        return budgets;
    }
}

bool ItemScoreAffix::RerollChaos(Player* owner, Item* item)
{
    if (!owner || !item)
        return false;

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto || (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR))
        return false;

    uint32 const score = GetScore(item);
    uint32 const count = CountForQuality(proto->GetQuality());
    if (!score || !count)
        return false;

    uint32 const total = score * count;
    std::vector<uint32> budgets = SplitBudget(total, count);
    uint32 const mask = MaskForItem(proto);

    for (uint32 i = 0; i < AffixSlotCount; ++i)
    {
        SetLineBudget(item, i, 0);
        item->SetEnchantment(AFFIX_SLOTS[i], 0, 0, 0);
    }

    static constexpr uint32 styles[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15 };
    for (uint32 index = 0; index < count && index < AffixSlotCount; ++index)
    {
        ScoreAffixEntry const* chosen = nullptr;
        uint32 start = urand(0, uint32(std::size(styles)) - 1);
        for (uint32 n = 0; n < std::size(styles) && !chosen; ++n)
        {
            uint32 style = styles[(start + n) % std::size(styles)];
            chosen = PickAffix(mask, style, budgets[index], false);
            if (!chosen)
                chosen = PickAffix(mask, style, budgets[index], true);
        }

        if (!chosen)
            break;

        item->SetEnchantment(AFFIX_SLOTS[index], chosen->Ench, 0, 0);
        SetLineBudget(item, index, budgets[index]);
    }

    item->SetState(ITEM_CHANGED, owner);
    return true;
}

bool ItemScoreAffix::RerollStyle(Player* owner, Item* item)
{
    if (!owner || !item)
        return false;

    ItemTemplate const* proto = item->GetTemplate();
    if (!proto || (proto->GetClass() != ITEM_CLASS_WEAPON && proto->GetClass() != ITEM_CLASS_ARMOR))
        return false;

    uint32 const score = GetScore(item);
    uint32 const count = CountForQuality(proto->GetQuality());
    if (!score || !count)
        return false;

    uint32 const mask = MaskForItem(proto);
    static constexpr uint32 styles[] = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 15 };
    bool changed = false;

    // 风格洗：只锁每条分到的预算，属性从全部流派大池子里随机
    for (uint32 index = 0; index < count && index < AffixSlotCount; ++index)
    {
        uint32 const budget = ResolveLineBudget(item, index, score);
        ScoreAffixEntry const* chosen = nullptr;
        uint32 start = urand(0, uint32(std::size(styles)) - 1);

        for (uint32 n = 0; n < std::size(styles) && !chosen; ++n)
        {
            uint32 style = styles[(start + n) % std::size(styles)];
            chosen = PickAffix(mask, style, budget, false);
            if (!chosen)
                chosen = PickAffix(mask, style, budget, true);
        }

        if (!chosen)
            continue;

        item->SetEnchantment(AFFIX_SLOTS[index], chosen->Ench, 0, 0);
        SetLineBudget(item, index, budget);
        changed = true;
    }

    item->SetState(ITEM_CHANGED, owner);
    return changed;
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

    // 已经有评分或永久附魔的物品不再处理（避免重复叠加）
    if (item->GetEnchantmentId(SCORE_ENCHANTMENT_SLOT) != 0
        || item->GetEnchantmentId(PERM_ENCHANTMENT_SLOT) >= SCORE_ENCHANT_BASE)
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

    // 评分放 BONUS 槽：和玩家的永久附魔槽分开
    item->SetEnchantment(SCORE_ENCHANTMENT_SLOT, SCORE_ENCHANT_BASE + shown, 0, 0);
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

    // 0/1 是玩家附魔槽，不能用；5/7/8 是旧版随机槽，清掉避免重复显示
    for (uint32 i = 0; i < AffixSlotCount; ++i)
    {
        SetLineBudget(item, i, 0);
        item->SetEnchantment(AFFIX_SLOTS[i], 0, 0, 0);
    }
    item->SetEnchantment(USE_ENCHANTMENT_SLOT, 0, 0, 0);
    item->SetEnchantment(PROP_ENCHANTMENT_SLOT_0, 0, 0, 0);

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

        item->SetEnchantment(AFFIX_SLOTS[index], chosen->Ench, 0, 0);
        SetLineBudget(item, index, shown);
    }
}

void ItemScoreAffix::Migrate(Player* owner, Item* item)
{
    if (!item)
        return;

    // 旧数据迁移：把 charges/duration 里的预算移到独立表，并清掉客户端显示的“次数”
    for (uint32 i = 0; i < AffixSlotCount; ++i)
        if (item->GetEnchantmentId(AFFIX_SLOTS[i]))
            GetLineBudget(item, i);

    // 旧版可见槽：5/7/8；新槽是 6（评分）+ 9/10/11/12（词条）
    uint32 score = 0;
    static constexpr EnchantmentSlot scoreSlots[] =
    {
        SCORE_ENCHANTMENT_SLOT, BONUS_ENCHANTMENT_SLOT, PERM_ENCHANTMENT_SLOT
    };
    for (EnchantmentSlot slot : scoreSlots)
    {
        uint32 const ench = item->GetEnchantmentId(slot);
        if (ench >= SCORE_ENCHANT_BASE && ench <= SCORE_ENCHANT_BASE + SCORE_MAX)
        {
            score = ench;
            break;
        }
    }

    if (!score)
        return;

    bool needsMigration = item->GetEnchantmentId(SCORE_ENCHANTMENT_SLOT) != score;

    if (!needsMigration)
        return;

    TC_LOG_INFO("server.loading", ">> ItemScoreAffix migrate item={} score={}", item->GetEntry(), score);

    std::vector<uint32> affixes;
    std::vector<uint32> legacyBudgets;
    static constexpr EnchantmentSlot oldSlots[] =
    {
        TEMP_ENCHANTMENT_SLOT, BONUS_ENCHANTMENT_SLOT, PRISMATIC_ENCHANTMENT_SLOT,
        USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0, PROP_ENCHANTMENT_SLOT_1,
        PROP_ENCHANTMENT_SLOT_2, PROP_ENCHANTMENT_SLOT_3, PROP_ENCHANTMENT_SLOT_4
    };

    for (EnchantmentSlot slot : oldSlots)
    {
        uint32 const ench = item->GetEnchantmentId(slot);
        if (ench >= 200000 && ench < SCORE_ENCHANT_BASE)
        {
            if (std::find(affixes.begin(), affixes.end(), ench) == affixes.end())
            {
                affixes.push_back(ench);
                uint32 const budget = item->GetEnchantmentCharges(slot)
                    ? item->GetEnchantmentCharges(slot)
                    : item->GetEnchantmentDuration(slot);
                legacyBudgets.push_back(budget);
            }
        }
    }

    // 旧版预算可能在 DB 的 0..3，也可能还在 charges/duration 里
    ObjectGuid::LowType const itemGuid = item->GetGUID().GetCounter();
    uint32 stored[4] =
    {
        LoadStoredBudget(itemGuid, 0), LoadStoredBudget(itemGuid, 1),
        LoadStoredBudget(itemGuid, 2), LoadStoredBudget(itemGuid, 3)
    };
    bool hasStored = stored[0] || stored[1] || stored[2] || stored[3];

    // 清掉旧可见槽和旧词条槽，玩家 0/1 附魔槽不动
    for (EnchantmentSlot slot : { BONUS_ENCHANTMENT_SLOT, USE_ENCHANTMENT_SLOT, PROP_ENCHANTMENT_SLOT_0,
             PROP_ENCHANTMENT_SLOT_1, PROP_ENCHANTMENT_SLOT_2, PROP_ENCHANTMENT_SLOT_3, PROP_ENCHANTMENT_SLOT_4 })
        item->SetEnchantmentRaw(slot, 0);

    item->SetEnchantmentRaw(SCORE_ENCHANTMENT_SLOT, score);
    for (uint32 i = 0; i < affixes.size() && i < AffixSlotCount; ++i)
        item->SetEnchantmentRaw(AFFIX_SLOTS[i], affixes[i]);

    // 旧版 4 条的第 4 条预算合并到第 3 条，不能让总预算凭空消失
    for (uint32 i = 0; i < AffixSlotCount; ++i)
    {
        uint32 budget = hasStored ? stored[i] : (i < legacyBudgets.size() ? legacyBudgets[i] : 0);
        if (i == 2)
        {
            if (hasStored)
                budget += stored[3];
            else if (legacyBudgets.size() > 3)
                budget += legacyBudgets[3];
        }

        if (budget)
            SetLineBudget(item, i, budget);
    }
    DeleteBudget(itemGuid, 3);

    if (owner)
        item->SetState(ITEM_CHANGED, owner);
}

void ItemScoreAffix::MigrateAll(Player* owner)
{
    if (!owner)
        return;

    for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
        if (Item* item = owner->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
            Migrate(owner, item);

    for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
        if (Item* item = owner->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
            Migrate(owner, item);

    for (uint8 bagSlot = INVENTORY_SLOT_BAG_START; bagSlot < INVENTORY_SLOT_BAG_END; ++bagSlot)
    {
        Item* bag = owner->GetItemByPos(INVENTORY_SLOT_BAG_0, bagSlot);
        if (!bag || !bag->IsBag())
            continue;

        for (uint8 slot = 0; slot < bag->ToBag()->GetBagSize(); ++slot)
            if (Item* item = owner->GetItemByPos(bagSlot, slot))
                Migrate(owner, item);
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

    item->SetEnchantment(SCORE_ENCHANTMENT_SLOT, SCORE_ENCHANT_BASE + shown, 0, 0);

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

    // 先清空四条词条槽，避免旧的残留；不动玩家的 0/1 附魔槽
    for (uint32 i = 0; i < AffixSlotCount; ++i)
    {
        SetLineBudget(item, i, 0);
        item->SetEnchantment(AFFIX_SLOTS[i], 0, 0, 0);
    }
    item->SetEnchantment(USE_ENCHANTMENT_SLOT, 0, 0, 0);
    item->SetEnchantment(PROP_ENCHANTMENT_SLOT_0, 0, 0, 0);

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
        item->SetEnchantment(AFFIX_SLOTS[index], chosen->Ench, 0, 0);
        SetLineBudget(item, index, shown);
    }

    item->SetState(ITEM_CHANGED, owner);
}
uint32 ItemScoreAffix::GetScore(Item const* item)
{
    if (!item)
        return 0;

    uint32 const ench = item->GetEnchantmentId(SCORE_ENCHANTMENT_SLOT);
    if (ench >= SCORE_ENCHANT_BASE)
        return ench - SCORE_ENCHANT_BASE;

    // 兼容旧物品：评分曾经放在 BONUS 槽 5 或永久附魔槽 0
    uint32 const bonus = item->GetEnchantmentId(BONUS_ENCHANTMENT_SLOT);
    if (bonus >= SCORE_ENCHANT_BASE)
        return bonus - SCORE_ENCHANT_BASE;

    uint32 const legacy = item->GetEnchantmentId(PERM_ENCHANTMENT_SLOT);
    if (legacy >= SCORE_ENCHANT_BASE)
        return legacy - SCORE_ENCHANT_BASE;

    return 0;
}

uint32 ItemScoreAffix::GetLineBudget(Item* item, uint32 index)
{
    if (!item || index >= AffixSlotCount)
        return 0;

    ObjectGuid::LowType const itemGuid = item->GetGUID().GetCounter();
    MergeLegacyBudgetRows(itemGuid);
    uint32 const stored = LoadStoredBudget(itemGuid, index);
    if (stored)
        return stored;

    // 兼容旧数据：预算曾经存在 charges 或 duration 里
    uint32 const legacy = item->GetEnchantmentCharges(AFFIX_SLOTS[index])
        ? item->GetEnchantmentCharges(AFFIX_SLOTS[index])
        : item->GetEnchantmentDuration(AFFIX_SLOTS[index]);
    if (legacy)
    {
        StoreBudget(itemGuid, index, legacy);
        item->SetEnchantment(AFFIX_SLOTS[index],
            item->GetEnchantmentId(AFFIX_SLOTS[index]), 0, 0);
        return legacy;
    }

    return 0;
}

void ItemScoreAffix::SetLineBudget(Item* item, uint32 index, uint32 budget)
{
    if (!item || index >= AffixSlotCount)
        return;

    ObjectGuid::LowType const itemGuid = item->GetGUID().GetCounter();
    if (!budget)
        DeleteBudget(itemGuid, index);
    else
        StoreBudget(itemGuid, index, budget);

    // 预算不再写进 duration/charges，避免客户端显示“次数”或被装备时清掉
    item->SetEnchantment(AFFIX_SLOTS[index],
        item->GetEnchantmentId(AFFIX_SLOTS[index]), 0, 0);
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

    uint32 const budget = ResolveLineBudget(item, index, shown);
    uint32 const mask = MaskForItem(proto);

    std::vector<ScoreAffixEntry const*> candidates;
    candidates.reserve(_pool.size());
    for (ScoreAffixEntry const& entry : _pool)
        if ((entry.Mask & mask) && entry.Level <= budget)
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

    // 避开其它槽已经用掉的词条种类
    std::vector<uint32> usedKinds;
    for (uint32 i = 0; i < AffixSlotCount; ++i)
    {
        if (i == index)
            continue;

        uint32 const ench = item->GetEnchantmentId(AFFIX_SLOTS[i]);
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

    item->SetEnchantment(AFFIX_SLOTS[index], chosen->Ench, 0, 0);
    SetLineBudget(item, index, budget);
    item->SetState(ITEM_CHANGED, owner);
}