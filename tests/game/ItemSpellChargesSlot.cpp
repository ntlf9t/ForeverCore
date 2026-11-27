/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but WITHOUT
 * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
 * FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for
 * more details.
 *
 * You should have received a copy of the GNU General Public License along
 * with this program. If not, see <http://www.gnu.org/licenses/>.
 */

#include "tc_catch2.h"
#include "DB2Structure.h"
#include "Item.h"
#include <initializer_list>
#include <vector>

// advocaite/TrinityCore#301: the client reads an item effect's charges from SpellCharges[LegacySlotIndex]. The effect rows
// below are the 1.60.1.70862 ItemEffect rows (ItemXItemEffect links them to the items).
namespace
{
    ItemEffectEntry Effect(uint32 id, uint8 legacySlot, int16 charges)
    {
        ItemEffectEntry effect{};
        effect.ID = id;
        effect.LegacySlotIndex = legacySlot;
        effect.Charges = charges;
        return effect;
    }

    BonusData WithEffects(std::vector<ItemEffectEntry> const& effects)
    {
        BonusData bonusData{};
        for (ItemEffectEntry const& effect : effects)
            bonusData.Effects[bonusData.EffectCount++] = &effect;
        return bonusData;
    }
}

TEST_CASE("Healthstones and mana gems keep their charge in slot 1", "[ItemSpellChargesSlot]")
{
    // 5512 Minor Healthstone: effect 97875, slot 1, -1 charge; 5514 Mana Agate: effect 97664, slot 1, -1 charge
    for (uint32 effectId : { 97875u, 97664u })
    {
        CAPTURE(effectId);
        std::vector<ItemEffectEntry> effects = { Effect(effectId, 1, -1) };
        BonusData bonusData = WithEffects(effects);
        CHECK(GetSpellChargesSlotForEffect(bonusData, 0) == 1);   // the old rule (slot = effect index) gave 0
    }
}

TEST_CASE("Effects in slots 0 and 1 keep their own slots", "[ItemSpellChargesSlot]")
{
    std::vector<ItemEffectEntry> effects = { Effect(1, 0, 0), Effect(2, 1, -1) };
    BonusData bonusData = WithEffects(effects);
    CHECK(GetSpellChargesSlotForEffect(bonusData, 0) == 0);
    CHECK(GetSpellChargesSlotForEffect(bonusData, 1) == 1);
}

TEST_CASE("Two effects naming the same slot get different slots", "[ItemSpellChargesSlot]")
{
    // 239695: effect 208251 (slot 1, -1 charge, on use) and 227869 (slot 1, 0 charges). The first keeps slot 1, the second
    // takes the lowest free slot, so its 0 can't overwrite the first one's charge
    std::vector<ItemEffectEntry> effects = { Effect(208251, 1, -1), Effect(227869, 1, 0) };
    BonusData bonusData = WithEffects(effects);
    CHECK(GetSpellChargesSlotForEffect(bonusData, 0) == 1);
    CHECK(GetSpellChargesSlotForEffect(bonusData, 1) == 0);
}

TEST_CASE("Every effect of an item gets a different slot", "[ItemSpellChargesSlot]")
{
    // slots 3, 3, 0, past the end (9), 1: the slot past the end and the second 3 take the free slots 2 and 4
    std::vector<ItemEffectEntry> effects = { Effect(1, 3, 0), Effect(2, 3, 0), Effect(3, 0, 0), Effect(4, 9, 0), Effect(5, 1, 0) };
    BonusData bonusData = WithEffects(effects);
    std::vector<uint32> slots;
    for (uint32 i = 0; i < effects.size(); ++i)
        slots.push_back(GetSpellChargesSlotForEffect(bonusData, i));

    CHECK(slots == std::vector<uint32>{ 3, 2, 0, 4, 1 });
}

TEST_CASE("Effect indexes past the charge slots pass through", "[ItemSpellChargesSlot]")
{
    std::vector<ItemEffectEntry> effects = { Effect(1, 1, -1) };
    BonusData bonusData = WithEffects(effects);
    CHECK(GetSpellChargesSlotForEffect(bonusData, 5) == 5);   // 5 = SpellCharges size: callers check slot < size
    CHECK(GetSpellChargesSlotForEffect(bonusData, 3) == 3);   // inside the slots but past EffectCount
}
