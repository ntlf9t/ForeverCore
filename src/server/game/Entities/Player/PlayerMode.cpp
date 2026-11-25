#include "PlayerMode.h"
#include "Bag.h"
#include "CalendarMgr.h"
#include "Chat.h"
#include "DB2Stores.h"
#include "DatabaseEnv.h"
#include "Item.h"
#include "Guild.h"
#include "Log.h"
#include "Player.h"
#include "Random.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellMgr.h"
#include "World.h"
#include "WorldSession.h"

#include <algorithm>
#include <vector>

namespace
{
    constexpr uint32 SPELL_GLASS_DAMAGE = 931001;  // aura 79  玻璃大炮：造成伤害 +30%
    constexpr uint32 SPELL_GLASS_TAKEN  = 931002;  // aura 87  玻璃大炮：受到伤害 +30%
    constexpr uint32 SPELL_LONE_DAMAGE  = 931004;  // aura 79  孤勇永久：造成伤害 +X%
    constexpr uint32 SPELL_LONE_TAKEN   = 931005;  // aura 87  孤勇永久：受到伤害 +X%
    constexpr uint32 SPELL_LONE_HEALTH  = 931006;  // aura 133 孤勇永久：最大生命 +X%

    std::unordered_map<ObjectGuid, PlayerMode::Data> _modes;
    std::mutex _modeMutex;

    bool HasAnyInitialInventoryViolation(Player* player, std::string& reason)
    {
        if (player->GetMoney() != 0)
        {
            reason = "金币必须为 0（不能带钱进模式）";
            return true;
        }

        auto checkItem = [&](Item* item) -> bool
        {
            if (!item)
                return false;

            if (item->IsSoulBound() || item->IsBoundAccountWide())
                return false;

            // 出生自带的低装等/低卖价物品（拳斗士胸甲、回血/回蓝药水、食物等）允许；
            // 交易过来的高级装备、材料、金币价值高的物品会被拦下
            ItemTemplate const* proto = item->GetTemplate();
            if (proto->GetBaseItemLevel() <= 10 && proto->GetSellPrice() <= 100)
                return false;

            TC_LOG_INFO("server.loading", ">> MODE reject item entry={} class={} ilvl={} sell={}",
                item->GetEntry(), proto->GetClass(), proto->GetBaseItemLevel(), proto->GetSellPrice());

            reason = "背包/银行里还有未绑定的物品（ID " + std::to_string(item->GetEntry()) + "）";
            return true;
        };

        for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
            if (checkItem(player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot)))
                return true;

        for (uint8 slot = INVENTORY_SLOT_ITEM_START; slot < INVENTORY_SLOT_ITEM_END; ++slot)
            if (checkItem(player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot)))
                return true;

        // 随身包
        for (uint8 bag = INVENTORY_SLOT_BAG_START; bag < INVENTORY_SLOT_BAG_END; ++bag)
        {
            Item* bagItem = player->GetItemByPos(INVENTORY_SLOT_BAG_0, bag);
            if (!bagItem)
                continue;

            if (checkItem(bagItem))
                return true;

            if (bagItem->IsBag())
                for (uint8 i = 0; i < bagItem->ToBag()->GetBagSize(); ++i)
                    if (checkItem(player->GetItemByPos(bag, i)))
                        return true;
        }

        // 银行（银行标签是容器）
        for (uint8 bag = BANK_SLOT_BAG_START; bag < BANK_SLOT_BAG_END; ++bag)
        {
            Item* bagItem = player->GetItemByPos(INVENTORY_SLOT_BAG_0, bag);
            if (!bagItem)
                continue;

            if (checkItem(bagItem))
                return true;

            if (bagItem->IsBag())
                for (uint8 i = 0; i < bagItem->ToBag()->GetBagSize(); ++i)
                    if (checkItem(player->GetItemByPos(bag, i)))
                        return true;
        }

        return false;
    }
}

namespace PlayerMode
{
    void ApplyAuras(Player* player)
    {
        if (!player)
            return;

        player->RemoveAurasDueToSpell(SPELL_GLASS_DAMAGE);
        player->RemoveAurasDueToSpell(SPELL_GLASS_TAKEN);
        player->RemoveAurasDueToSpell(SPELL_LONE_DAMAGE);
        player->RemoveAurasDueToSpell(SPELL_LONE_TAKEN);
        player->RemoveAurasDueToSpell(SPELL_LONE_HEALTH);

        if (!IsLone(player))
            return;

        // 玻璃大炮：只在 1~59 级存在，60 级自动消失
        if (player->GetLevel() < 60)
        {
            if (Aura* aura = player->AddAura(SPELL_GLASS_DAMAGE, player))
                if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
                    effect->ChangeAmount(30.0);

            if (Aura* aura = player->AddAura(SPELL_GLASS_TAKEN, player))
                if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
                    effect->ChangeAmount(30.0);
        }

        // 孤勇永久属性（60 级也保留，靠重生叠加）
        Data data = Get(player);

        if (data.loneDamage > 0)
            if (Aura* aura = player->AddAura(SPELL_LONE_DAMAGE, player))
                if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
                    effect->ChangeAmount(double(data.loneDamage));

        if (data.loneTaken > 0)
            if (Aura* aura = player->AddAura(SPELL_LONE_TAKEN, player))
                if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
                    effect->ChangeAmount(double(data.loneTaken));

        if (data.loneHealth > 0)
            if (Aura* aura = player->AddAura(SPELL_LONE_HEALTH, player))
                if (AuraEffect* effect = aura->GetEffect(EFFECT_0))
                    effect->ChangeAmount(double(data.loneHealth));
    }

    void SyncTalentPoints(Player* player)
    {
        if (!player)
            return;

        uint32 basePoints = player->GetLevel() >= 10 ? uint32(player->GetLevel() - 9) : 0;
        Data data = Get(player);

        uint32 total = basePoints + data.rebirths * 3;
        player->SetDataElementCharacter(9001, int64(total));
    }

    void HandleLoneDeath(Player* player)
    {
        if (!player || !IsLone(player))
            return;

        if (player->GetLevel() >= 60)
            return;

        if (Guild* guild = player->GetGuild())
        {
            std::string const guildName = guild->GetName();
            sCalendarMgr->RemovePlayerGuildEventsAndSignups(player->GetGUID(), guild->GetId());

            CharacterDatabaseTransaction trans(nullptr);
            guild->DeleteMember(trans, player->GetGUID(), false, false);
            ChatHandler(player->GetSession()).PSendSysMessage(
                "孤勇角色死亡，已自动退出公会 <%s>。", guildName.c_str());
        }

        Data data = Get(player);
        if (data.legacyGiven)
            return;

        {
            std::lock_guard<std::mutex> lock(_modeMutex);
            _modes[player->GetGUID()].legacyGiven = true;
        }
        Save(player);

        std::vector<Player*> candidates;
        if (player->GetSession())
        {
            uint32 accountId = player->GetSession()->GetAccountId();
            for (auto const& [guid, session] : sWorld->GetAllSessions())
            {
                if (!session || session->IsBot())
                    continue;

                Player* candidate = session->GetPlayer();
                if (!candidate || candidate == player || !candidate->IsInWorld())
                    continue;
                if (session->GetAccountId() == accountId)
                    continue;

                candidates.push_back(candidate);
            }
        }

        // 随机一件已装备的物品
        std::vector<uint8> equippedSlots;
        for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
        {
            if (slot == EQUIPMENT_SLOT_BODY || slot == EQUIPMENT_SLOT_TABARD)
                continue;
            if (player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
                equippedSlots.push_back(slot);
        }

        uint8 legacySlot = 0;
        uint32 legacyEntry = 0;
        if (!equippedSlots.empty())
        {
            legacySlot = equippedSlots[urand(0, int(equippedSlots.size()) - 1)];
            if (Item* item = player->GetItemByPos(INVENTORY_SLOT_BAG_0, legacySlot))
                legacyEntry = item->GetEntry();
        }

        // 选一个背包放得下的继承人
        std::vector<Player*> eligible;
        for (Player* candidate : candidates)
        {
            if (legacyEntry)
            {
                ItemPosCountVec dest;
                if (candidate->CanStoreNewItem(NULL_BAG, NULL_SLOT, dest, legacyEntry, 1) != EQUIP_ERR_OK)
                    continue;
            }
            eligible.push_back(candidate);
        }

        Player* heir = eligible.empty() ? nullptr : eligible[urand(0, int(eligible.size()) - 1)];

        std::string announcement = "【孤勇陨落】" + player->GetName() + " 已永久死亡";
        if (heir)
            announcement += "，遗产由 " + heir->GetName() + " 继承";
        announcement += "。";
        sWorld->SendGlobalText(announcement.c_str(), nullptr);

        if (!heir)
            return;

        if (legacyEntry && heir->AddItem(legacyEntry, 1))
        {
            player->DestroyItem(INVENTORY_SLOT_BAG_0, legacySlot, true);
            ChatHandler(heir->GetSession()).PSendSysMessage("你继承了 %s 的一件装备。", player->GetName().c_str());
        }

        uint64 gold = player->GetMoney() / 2;
        if (gold > 0)
        {
            player->ModifyMoney(-int64(gold));
            heir->ModifyMoney(int64(gold));
            ChatHandler(heir->GetSession()).PSendSysMessage("你继承了 %s 的 %s 金币。",
                player->GetName().c_str(), std::to_string(gold).c_str());
        }
    }

    void HandleLevelUp(Player* player, uint8 newLevel)
    {
        if (!player || newLevel < 60 || !IsLone(player))
            return;

        {
            std::lock_guard<std::mutex> lock(_modeMutex);
            auto it = _modes.find(player->GetGUID());
            if (it == _modes.end() || it->second.loneRewardGiven)
                return;
            it->second.loneRewardGiven = true;
        }
        Save(player);

        constexpr uint32 LONE_REWARD_GOLD = 10000 * GOLD;
        player->ModifyMoney(LONE_REWARD_GOLD);

        ChatHandler(player->GetSession()).SendSysMessage("孤勇奖励：10000 金已发放。");

        std::string announcement = "【孤勇奖励】" + player->GetName() + " 以孤勇模式达到 60 级，获得 10000 金！";
        sWorld->SendGlobalText(announcement.c_str(), nullptr);
    }

    void Load(Player* player)
    {
        if (!player)
            return;

        Data data;

        std::string sql = "SELECT chosen, lone, lone_damage, lone_health, lone_taken, rebirths, rebirth_active, legacy_given, lone_reward_given "
            "FROM character_modes WHERE guid = " + std::to_string(player->GetGUID().GetCounter());

        if (QueryResult result = CharacterDatabase.Query(sql.c_str()))
        {
            Field* fields = result->Fetch();
            data.chosen = fields[0].GetUInt8() != 0;
            data.lone = fields[1].GetUInt8() != 0;
            data.loneDamage = fields[2].GetUInt32();
            data.loneHealth = fields[3].GetUInt32();
            data.loneTaken = fields[4].GetUInt32();
            data.rebirths = fields[5].GetUInt32();
            data.rebirthActive = fields[6].GetUInt8() != 0;
            data.legacyGiven = fields[7].GetUInt8() != 0;
            data.loneRewardGiven = fields[8].GetUInt8() != 0;
        }

        {
            std::lock_guard<std::mutex> lock(_modeMutex);
            _modes[player->GetGUID()] = data;
        }

        ApplyAuras(player);
        SyncTalentPoints(player);
    }

    void Save(Player* player)
    {
        if (!player)
            return;

        Data data;
        {
            std::lock_guard<std::mutex> lock(_modeMutex);
            auto it = _modes.find(player->GetGUID());
            if (it == _modes.end())
                return;
            data = it->second;
        }

        std::string sql = "REPLACE INTO character_modes "
            "(guid, chosen, lone, lone_damage, lone_health, lone_taken, rebirths, rebirth_active, legacy_given, lone_reward_given) VALUES ("
            + std::to_string(player->GetGUID().GetCounter()) + ","
            + (data.chosen ? "1" : "0") + ","
            + (data.lone ? "1" : "0") + ","
            + std::to_string(data.loneDamage) + ","
            + std::to_string(data.loneHealth) + ","
            + std::to_string(data.loneTaken) + ","
            + std::to_string(data.rebirths) + ","
            + (data.rebirthActive ? "1" : "0") + ","
            + (data.legacyGiven ? "1" : "0") + ","
            + (data.loneRewardGiven ? "1" : "0") + ")";

        CharacterDatabase.Execute(sql.c_str());
    }

    Data Get(Player* player)
    {
        if (!player)
            return Data{};

        std::lock_guard<std::mutex> lock(_modeMutex);
        auto it = _modes.find(player->GetGUID());
        if (it == _modes.end())
            return Data{};

        return it->second;
    }

    Data& GetMutable(Player* player)
    {
        std::lock_guard<std::mutex> lock(_modeMutex);
        return _modes[player->GetGUID()];
    }

    bool IsLone(Player* player)
    {
        return Get(player).lone;
    }

    bool IsRebirthActive(Player* player)
    {
        return Get(player).rebirthActive;
    }

    bool IsDeathLocked(Player* player)
    {
        if (!player || player->GetLevel() >= 60)
            return false;

        Data data = Get(player);
        return data.lone || data.rebirthActive;
    }

    float GetLootRate(Player* player)
    {
        return IsLone(player) ? 3.0f : 1.0f;
    }

    bool CanChooseLone(Player* player, std::string& reason)
    {
        if (!player)
            return false;

        Data data = Get(player);

        if (data.chosen)
        {
            reason = "你已经选择过模式，不能更改";
            return false;
        }

        if (player->GetLevel() != 1)
        {
            reason = "只能在 1 级时选择孤勇模式";
            return false;
        }

        if (HasAnyInitialInventoryViolation(player, reason))
            return false;

        return true;
    }

    bool ChooseLone(Player* player, std::string& reason)
    {
        if (!CanChooseLone(player, reason))
            return false;

        {
            std::lock_guard<std::mutex> lock(_modeMutex);
            Data& data = _modes[player->GetGUID()];
            data.chosen = true;
            data.lone = true;
        }

        // 选择瞬间：强制退队、清除待接受邀请、关闭交易
        if (Group* invite = player->GetGroupInvite())
            invite->RemoveInvite(player);

        if (player->GetGroup())
            player->RemoveFromGroup();

        player->TradeCancel(false);

        Save(player);
        ApplyAuras(player);
        return true;
    }

    bool CanRebirth(Player* player, std::string& reason)
    {
        if (!player)
            return false;

        if (player->GetLevel() < 60)
        {
            reason = "只有 60 级角色才能重生";
            return false;
        }

        if (IsRebirthActive(player))
        {
            reason = "你已经在重生流程中";
            return false;
        }

        if (player->IsInCombat())
        {
            reason = "战斗中不能重生";
            return false;
        }

        for (uint8 slot = EQUIPMENT_SLOT_START; slot < EQUIPMENT_SLOT_END; ++slot)
        {
            if (player->GetItemByPos(INVENTORY_SLOT_BAG_0, slot))
            {
                reason = "重生前必须脱下所有装备（武器、护甲、饰品、戒指等全部卸下）";
                return false;
            }
        }

        return true;
    }

    void SetRebirthActive(Player* player, bool active)
    {
        if (!player)
            return;

        std::lock_guard<std::mutex> lock(_modeMutex);
        _modes[player->GetGUID()].rebirthActive = active;
    }

    void ResetClassSkills(Player* player)
    {
        if (!player)
            return;

        std::vector<uint32> toRemove;
        for (auto const& [spellId, playerSpell] : player->GetSpellMap())
        {
            if (playerSpell.state == PLAYERSPELL_REMOVED)
                continue;

            SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE);
            if (!spellInfo || spellInfo->SpellLevel <= 1)
                continue;

            bool isClassSpell = false;
            auto bounds = sSpellMgr->GetSkillLineAbilityMapBounds(spellId);
            for (auto itr = bounds.first; itr != bounds.second; ++itr)
            {
                SkillLineAbilityEntry const* ability = itr->second;
                if (ability->ClassMask && !(ability->ClassMask & (1 << (player->GetClass() - 1))))
                    continue;

                SkillLineEntry const* skillLine = sSkillLineStore.LookupEntry(ability->SkillLine);
                if (skillLine && skillLine->CategoryID == SKILL_CATEGORY_CLASS)
                {
                    isClassSpell = true;
                    break;
                }
            }

            if (isClassSpell)
                toRemove.push_back(spellId);
        }

        for (uint32 spellId : toRemove)
            player->RemoveSpell(spellId);
    }

    bool DoRebirth(Player* player, std::string& reason)
    {
        if (!CanRebirth(player, reason))
            return false;

        Data data = Get(player);
        std::string rewardText;

        // 孤勇玩家的重生奖励
        if (data.lone)
        {
            uint32 roll = urand(1, 100);

            if (roll <= 80)
            {
                uint32 add = urand(1, 3) * 5;
                uint32 before = data.loneDamage;
                data.loneDamage = std::min<uint32>(500, data.loneDamage + add);
                rewardText = "孤勇伤害 +" + std::to_string(data.loneDamage - before) + "%";
            }
            else if (roll <= 90)
            {
                uint32 add = urand(1, 3);
                uint32 before = data.loneHealth;
                data.loneHealth = std::min<uint32>(100, data.loneHealth + add);
                rewardText = "孤勇生命 +" + std::to_string(data.loneHealth - before) + "%";
            }
            else
            {
                uint32 add = urand(1, 3);
                uint32 before = data.loneTaken;
                data.loneTaken = std::min<uint32>(50, data.loneTaken + add);
                rewardText = "孤勇承伤 +" + std::to_string(data.loneTaken - before) + "%";
            }
        }

        // C 方案：清天赋、降回 1 级，职业高阶技能由核心自动遗忘，专业/坐骑/种族技能保留
        player->ResetTalents(true);
        player->GiveLevel(1);
        player->SetXP(0);
        player->SetHealth(player->GetMaxHealth());
        player->SetPower(player->GetPowerType(), player->GetMaxPower(player->GetPowerType()));

        {
            std::lock_guard<std::mutex> lock(_modeMutex);
            Data& stored = _modes[player->GetGUID()];
            stored = data;
            stored.chosen = true;
            stored.rebirths = data.rebirths + 1;
            stored.rebirthActive = true;
        }

        Save(player);
        ApplyAuras(player);
        SyncTalentPoints(player);

        // 每次重生额外奖励 10000 金，普通/孤勇都有
        player->ModifyMoney(int64(10000) * GOLD);

        reason = "重生完成：等级已回到 1 级，装备/背包/专业保留。";
        reason += " 本次奖励：10000金";
        if (!rewardText.empty())
            reason += " + " + rewardText;
        return true;
    }
}
