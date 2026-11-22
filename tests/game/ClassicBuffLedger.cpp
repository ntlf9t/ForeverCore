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

#include "../../src/modules/PlayerbotV2/Bot/ClassicBuffLedger.h"

using namespace Playerbot::Classic;

namespace
{
constexpr uint64_t kGreaterKey = (1ull << 48) | 0x0301;   // Greater Blessing, class 1
constexpr uint64_t kSingleKey  = (2ull << 48) | 7;        // a single blessing on one member
constexpr uint64_t kGroupKey   = (3ull << 48) | 5;        // a group class buff
constexpr uint32_t kMin        = 60u * 1000u;
}

TEST_CASE("A Greater Blessing the bot cast is trusted for six minutes, not recast every 30 seconds", "[ClassicBuffLedger]")
{
    // MC Magmadar 2026-10-10: Greater Blessing of Wisdom 39 times and Salvation 37 times in one fight.
    CHECK(BuffCastTrusted(kGreaterKey, 100000, 100000 + 30 * 1000));
    CHECK(BuffCastTrusted(kGreaterKey, 100000, 100000 + 5 * kMin));
    CHECK_FALSE(BuffCastTrusted(kGreaterKey, 100000, 100000 + 6 * kMin));
}

TEST_CASE("A single blessing is trusted for three minutes, a group class buff for six", "[ClassicBuffLedger]")
{
    CHECK(BuffCastTrusted(kSingleKey, 5000, 5000 + 2 * kMin));
    CHECK_FALSE(BuffCastTrusted(kSingleKey, 5000, 5000 + 3 * kMin));
    CHECK(BuffCastTrusted(kGroupKey, 5000, 5000 + 5 * kMin));
    CHECK_FALSE(BuffCastTrusted(kGroupKey, 5000, 5000 + 6 * kMin));
}

TEST_CASE("A buff never cast, or a key of another kind, is not trusted", "[ClassicBuffLedger]")
{
    CHECK_FALSE(BuffCastTrusted(kGreaterKey, 0, 1000));
    CHECK_FALSE(BuffCastTrusted((9ull << 48) | 1, 1000, 2000));
    CHECK(BuffTrustMs(0) == 0);
}

TEST_CASE("The clock wrapping around does not make a fresh cast stale", "[ClassicBuffLedger]")
{
    uint32_t const cast = 0xFFFFFFFFu - 1000u;
    CHECK(BuffCastTrusted(kGreaterKey, cast, cast + 5000u));
}

TEST_CASE("A caster-centred class buff is trusted only for the snapshot's lag", "[ClassicBuffLedger]")
{
    uint64_t const areaKey = (6ull << 48) | 4;
    CHECK(BuffTrustMs(areaKey) == kAreaBuffTrustMs);
    CHECK(BuffCastTrusted(areaKey, 1000, 1000 + kAreaBuffTrustMs - 1));
    CHECK_FALSE(BuffCastTrusted(areaKey, 1000, 1000 + kAreaBuffTrustMs));
}

TEST_CASE("A cast the core refused right after the bot sent it is not trusted", "[ClassicBuffLedger]")
{
    // Naxx Razuvious r2 af54: Blessing of Wisdom on one member refused NOT_READY 2 s after it was sent; trusted for 3 minutes, the raid
    // waited 83 s on it.
    CHECK(CastRefusedAfter(100000, 100000));
    CHECK(CastRefusedAfter(100000, 102000));
    CHECK(CastRefusedAfter(100000, 109999));
    CHECK_FALSE(CastRefusedAfter(100000, 110000));    // a refusal 10 s later belongs to a later cast
    CHECK_FALSE(CastRefusedAfter(100000, 99000));     // a refusal before the cast was sent is an older cast's
    CHECK_FALSE(CastRefusedAfter(0, 100000));         // never cast
    CHECK_FALSE(CastRefusedAfter(100000, 0));         // never refused
    CHECK(CastRefusedAfter(0xFFFFF000u, 0x00000400u)); // across the game clock's wrap
}
