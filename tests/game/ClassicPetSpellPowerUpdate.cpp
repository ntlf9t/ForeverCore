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

// advocaite/TrinityCore#266: the Classic 1.60 client has no PetSpellPower in ActivePlayerData. Its changes-mask bit is left out of
// the Classic header (ClassicActivePlayerDataBit), so its value must not be written either: 4 bytes the client does not expect
// shift every later field (client crash when a summon consumed a soul shard).

#include "tc_catch2.h"
#include "ByteBuffer.h"
#include "UpdateFields.h"
#include <initializer_list>
#include <memory>
#include <vector>

namespace
{
    // UpdateFields.h: TransmogCostMinScalingLevel is UpdateField<uint8, 102, 115>, PetSpellPower is UpdateField<int32, 102, 116>
    constexpr uint32 GroupBit = 102;
    constexpr uint32 TransmogCostMinScalingLevelBit = 115;
    constexpr uint32 PetSpellPowerBit = 116;

    std::vector<uint8> WriteActivePlayerUpdate(UF::ActivePlayerData const& fields, std::initializer_list<uint32> bits)
    {
        UF::ActivePlayerData::Mask mask;
        for (uint32 bit : bits)
            mask.Set(bit);

        ByteBuffer buffer;
        fields.WriteUpdate(mask, buffer, nullptr, nullptr, false);
        return std::vector<uint8>(buffer.data(), buffer.data() + buffer.size());
    }
}

TEST_CASE("A changed PetSpellPower adds nothing to a Classic ActivePlayerData update", "[ClassicPetSpellPowerUpdate]")
{
    std::unique_ptr<UF::ActivePlayerData> fields = std::make_unique<UF::ActivePlayerData>();

    SECTION("alone, the update is the same as an empty one")
    {
        CHECK(WriteActivePlayerUpdate(*fields, { GroupBit, PetSpellPowerBit }) == WriteActivePlayerUpdate(*fields, { }));
    }

    SECTION("next to a field of the same group, only that field is written")
    {
        std::vector<uint8> const withPetSpellPower = WriteActivePlayerUpdate(*fields, { GroupBit, TransmogCostMinScalingLevelBit, PetSpellPowerBit });
        std::vector<uint8> const without = WriteActivePlayerUpdate(*fields, { GroupBit, TransmogCostMinScalingLevelBit });
        CHECK(withPetSpellPower.size() == without.size());
        CHECK(withPetSpellPower == without);
    }
}
