/*
 * This file is part of the TrinityCore Project. See AUTHORS file for Copyright information
 *
 * This program is free software; you can redistribute it and/or modify it
 * under the terms of the GNU General Public License as published by the
 * Free Software Foundation; either version 2 of the License, or (at your
 * option) any later version.
 */

#include "tc_catch2.h"
#include "../../src/server/scripts/Custom/starter_guild.h"

TEST_CASE("StarterGuild: first login and level threshold", "[starterguild]")
{
    CHECK(StarterGuild::EligibleOnFirstLogin(1, 0));
    CHECK_FALSE(StarterGuild::EligibleOnFirstLogin(9, 10));
    CHECK(StarterGuild::EligibleOnFirstLogin(10, 10));
    CHECK(StarterGuild::EligibleOnFirstLogin(11, 10));

    CHECK_FALSE(StarterGuild::EligibleOnLevelChange(1, 2, 0));
    CHECK_FALSE(StarterGuild::EligibleOnLevelChange(8, 9, 10));
    CHECK(StarterGuild::EligibleOnLevelChange(9, 10, 10));
    CHECK(StarterGuild::EligibleOnLevelChange(9, 12, 10));
    CHECK_FALSE(StarterGuild::EligibleOnLevelChange(10, 11, 10));
    CHECK_FALSE(StarterGuild::EligibleOnLevelChange(11, 10, 10));
}

TEST_CASE("StarterGuild: member limit", "[starterguild]")
{
    CHECK(StarterGuild::HasCapacity(999));
    CHECK_FALSE(StarterGuild::HasCapacity(1000));
    CHECK_FALSE(StarterGuild::HasCapacity(1001));
}

TEST_CASE("StarterGuild: welcome placeholders are literal and nonrecursive", "[starterguild]")
{
    CHECK(StarterGuild::FormatWelcome("", "Guild", "Player").empty());
    CHECK(StarterGuild::FormatWelcome("{PLAYER} / {GUILD} / {PLAYER}", "Guild", "Player") ==
        "Player / Guild / Player");
    CHECK(StarterGuild::FormatWelcome("{GUILD} {unknown}", "{PLAYER}", "Alice") == "{PLAYER} {unknown}");
    CHECK(StarterGuild::FormatWelcome("{GUILD", "Guild", "Player") == "{GUILD");
}
