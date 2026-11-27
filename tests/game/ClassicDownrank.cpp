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
#include "ClassicSpellValue.h"

TEST_CASE("Forever downranking: Blizzard's rank 1 Frostbolt at 60 keeps nothing", "[ClassicDownrank]")
{
    CHECK(ClassicSpellValue::DownrankFactor(60, 4) == 0.0f);
}

TEST_CASE("Forever downranking: no penalty within 16 levels of the rank", "[ClassicDownrank]")
{
    CHECK(ClassicSpellValue::DownrankFactor(60, 56) == 1.0f);
    CHECK(ClassicSpellValue::DownrankFactor(60, 44) == 1.0f);
    CHECK(ClassicSpellValue::DownrankFactor(20, 4) == 1.0f);
}

TEST_CASE("Forever downranking: 5% less per level past 16", "[ClassicDownrank]")
{
    CHECK(ClassicSpellValue::DownrankFactor(60, 43) == Catch::Approx(0.95f));
    CHECK(ClassicSpellValue::DownrankFactor(60, 34) == Catch::Approx(0.5f));
    CHECK(ClassicSpellValue::DownrankFactor(60, 24) == 0.0f);
}

TEST_CASE("Forever downranking: no level data, no penalty", "[ClassicDownrank]")
{
    CHECK(ClassicSpellValue::DownrankFactor(60, 0) == 1.0f);
}
