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

#include "../../src/modules/PlayerbotV2/Fleet/BotAccountName.h"

using namespace Playerbot::V2;

TEST_CASE("Bot pool accounts keep their old names by default", "[BotAccountName]")
{
    REQUIRE(AccountName::Make(AccountName::kDefaultPrefix, 1) == "PBV2_0001");
    REQUIRE(AccountName::Make(AccountName::kDefaultPrefix, 9999) == "PBV2_9999");
    REQUIRE(AccountName::Make(AccountName::kDefaultPrefix, 10000) == "PBV2_10000");
}

TEST_CASE("Two realms with their own prefixes never make the same account name", "[BotAccountName]")
{
    for (uint32_t index : { 1u, 42u, 9999u, 123456u })
        REQUIRE(AccountName::Make("PBV2_", index) != AccountName::Make("PBPTR_", index));
    REQUIRE(AccountName::Make("PBPTR_", 1) == "PBPTR_0001");
}

TEST_CASE("Account names stay within the 16 characters an account name may have", "[BotAccountName]")
{
    std::string const longest(AccountName::kMaxPrefixLength, 'P');
    REQUIRE(AccountName::IsValidPrefix(longest));
    REQUIRE(AccountName::Make(longest, 999999).size() <= 16);
}

TEST_CASE("A prefix that is empty, too long or has other characters falls back to the default", "[BotAccountName]")
{
    REQUIRE(AccountName::PrefixOrDefault("PBPTR_") == "PBPTR_");
    REQUIRE(AccountName::PrefixOrDefault("") == AccountName::kDefaultPrefix);
    REQUIRE(AccountName::PrefixOrDefault("ABCDEFGHIJK") == AccountName::kDefaultPrefix);   // 11 characters
    REQUIRE(AccountName::PrefixOrDefault("PB PTR") == AccountName::kDefaultPrefix);
    REQUIRE(AccountName::PrefixOrDefault("PB-PTR") == AccountName::kDefaultPrefix);
    REQUIRE(AccountName::PrefixOrDefault("PB'PTR") == AccountName::kDefaultPrefix);
}
