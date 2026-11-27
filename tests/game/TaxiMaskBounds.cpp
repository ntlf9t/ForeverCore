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
#include "DB2Stores.h"
#include "DummyData.h"
#include "PlayerTaxi.h"
#include <limits>

namespace
{
    // TaxiNodes rows up to id 100: the mask is sized from the row count, rounded up to whole uint64s, so it holds nodes
    // 1-128 (16 bytes). The rows live as long as the test binary, like the store they stand in for.
    void LoadTaxiNodes()
    {
        static UnitTestDataLoader::DB2<TaxiNodesEntry, &TaxiNodesEntry::ID> nodes{sTaxiNodesStore};
        static bool loaded = false;
        if (loaded)
            return;

        loaded = true;
        auto loader = nodes.Loader();
        for (uint32 id : { 1u, 2u, 100u })
            loader.Add().ID = id;
    }
}

TEST_CASE("Taxi mask nodes inside the mask can be learned and are known", "[TaxiMaskBounds]")
{
    LoadTaxiNodes();
    PlayerTaxi taxi;
    REQUIRE(taxi.GetTaxiMask().size() == 16);

    for (uint32 node : { 1u, 2u, 8u, 9u, 100u, 128u })
    {
        CAPTURE(node);
        CHECK_FALSE(taxi.IsTaximaskNodeKnown(node));
        CHECK(taxi.SetTaximaskNode(node));
        CHECK(taxi.IsTaximaskNodeKnown(node));
        CHECK_FALSE(taxi.SetTaximaskNode(node));   // already known
    }
}

TEST_CASE("Taxi mask refuses node 0 and nodes past its end", "[TaxiMaskBounds]")
{
    LoadTaxiNodes();
    PlayerTaxi taxi;
    REQUIRE(taxi.GetTaxiMask().size() == 16);

    // 129 is the first node past the 16-byte mask; 0 used to wrap round to field 536870911
    for (uint32 node : { 0u, 129u, 136u, 100000u, std::numeric_limits<uint32>::max() })
    {
        CAPTURE(node);
        REQUIRE_FALSE(taxi.SetTaximaskNode(node));
        REQUIRE_FALSE(taxi.IsTaximaskNodeKnown(node));
    }

    // and nothing inside the mask was touched by the refused writes
    TaxiMask const& mask = taxi.GetTaxiMask();
    for (size_t i = 0; i < mask.size(); ++i)
        CHECK(mask[i] == 0);
}
