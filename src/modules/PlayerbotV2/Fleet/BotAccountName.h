// BotAccountName - the names of the bot pool accounts ("PBV2_0001", ...).
//
// The names live in the login database, which every realm on one login server shares, while each realm numbers
// its own pool from its own characters database (playerbot_v2_account). Two realms with bots and the same prefix
// both start at 0001 and take each other's names. Playerbot.AccountPrefix gives each realm its own prefix
// (default "PBV2_", the name every existing pool already has).
//
// Header-only and free of the server's globals, so the unit tests can include it.

#pragma once

#include <cctype>
#include <cstdint>
#include <string>
#include <string_view>

#include <fmt/format.h>

namespace Playerbot::V2::AccountName {

inline constexpr std::string_view kDefaultPrefix = "PBV2_";

// A prefix leaves room for the index: account names stay within MAX_ACCOUNT_STR (16) up to index 999999.
inline constexpr std::size_t kMaxPrefixLength = 10;

// Letters, digits and '_' only, 1 to kMaxPrefixLength characters.
inline bool IsValidPrefix(std::string_view prefix)
{
    if (prefix.empty() || prefix.size() > kMaxPrefixLength)
        return false;
    for (char c : prefix)
        if (!std::isalnum(static_cast<unsigned char>(c)) && c != '_')
            return false;
    return true;
}

// The configured prefix when it is valid, else the default.
inline std::string_view PrefixOrDefault(std::string_view configured)
{
    return IsValidPrefix(configured) ? configured : kDefaultPrefix;
}

// "<prefix><index>", the index zero-padded to 4 digits ("PBV2_0001"; 5 digits and more from 10000).
inline std::string Make(std::string_view prefix, uint32_t index)
{
    return fmt::format("{}{:04}", prefix, index);
}

} // namespace Playerbot::V2::AccountName
