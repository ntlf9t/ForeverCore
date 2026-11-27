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

#include "../../src/server/game/Spells/ClassicLegacyPerks.h"

using ClassicLegacyPerks::IsBossCelebrationBuff;

TEST_CASE("Legacy perks: boss celebration buffs", "[ClassicLegacyPerks]")
{
    // Rend's buff for each faction, the client's dummy and both copies
    CHECK(IsBossCelebrationBuff(16609));
    CHECK(IsBossCelebrationBuff(460939));
    CHECK(IsBossCelebrationBuff(460940));
    CHECK(IsBossCelebrationBuff(1304678));
    CHECK(IsBossCelebrationBuff(22888));
    CHECK(IsBossCelebrationBuff(24425));

    // other world buffs are not boss celebrations
    CHECK_FALSE(IsBossCelebrationBuff(15366));  // Songflower Serenade
    CHECK_FALSE(IsBossCelebrationBuff(22818));  // Mol'dar's Moxie
    CHECK_FALSE(IsBossCelebrationBuff(0));
}
