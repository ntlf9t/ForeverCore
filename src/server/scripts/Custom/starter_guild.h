/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

#ifndef FOREVERCORE_STARTER_GUILD_H
#define FOREVERCORE_STARTER_GUILD_H

#include <cstdint>
#include <string>
#include <string_view>

namespace StarterGuild
{
constexpr std::uint32_t MemberLimit = 1000;

constexpr bool HasCapacity(std::uint32_t memberCount)
{
    return memberCount < MemberLimit;
}

constexpr bool EligibleOnFirstLogin(std::uint32_t level, std::uint32_t requiredLevel)
{
    return requiredLevel == 0 || level >= requiredLevel;
}

constexpr bool EligibleOnLevelChange(std::uint32_t oldLevel, std::uint32_t newLevel, std::uint32_t requiredLevel)
{
    return requiredLevel != 0 && oldLevel < requiredLevel && newLevel >= requiredLevel;
}

inline std::string FormatWelcome(std::string_view text, std::string_view guild, std::string_view player)
{
    std::string result;
    for (std::size_t pos = 0; pos < text.size();)
    {
        if (text.substr(pos, 7) == "{GUILD}")
        {
            result.append(guild);
            pos += 7;
        }
        else if (text.substr(pos, 8) == "{PLAYER}")
        {
            result.append(player);
            pos += 8;
        }
        else
            result.push_back(text[pos++]);
    }
    return result;
}
}

#endif
