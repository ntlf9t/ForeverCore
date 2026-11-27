#include "tc_catch2.h"
#include "../../src/modules/PlayerbotV2/Fleet/BotSurnames.h"
#include <set>

using namespace Playerbot::V2::Fleet;

TEST_CASE("Bot surnames cover playable cultures with valid distinct candidates", "[BotSurnames]")
{
    for (unsigned race : {1,2,3,4,5,6,7,8,9,10,11,22,24,25,26,27,28,29,30,31,32,34,35,36,37,52,70,84,85,86,91,95,96,255})
    {
        auto candidates = BotSurnames::Candidates(race);
        REQUIRE(candidates.size() == 144);
        std::set<std::string> unique(candidates.begin(), candidates.end());
        REQUIRE(unique.size() == candidates.size());
        for (auto const& name : candidates)
        {
            REQUIRE(name.size() <= 48);
            REQUIRE(name.front() >= 'A');
            REQUIRE(name.front() <= 'Z');
            REQUIRE(name.find_first_not_of("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ") == std::string::npos);
        }
    }
    REQUIRE(BotSurnames::Candidates(3) != BotSurnames::Candidates(4));
    REQUIRE(BotSurnames::Candidates(95) == BotSurnames::Candidates(96));
}

TEST_CASE("Bot surname selection skips held full names and exhausts safely", "[BotSurnames]")
{
    std::mt19937 random(42);
    std::set<std::string> visited;
    auto candidates = BotSurnames::Candidates(3);
    std::string const free = candidates.back();
    auto chosen = BotSurnames::Pick(3, random, [&](std::string const& surname)
    {
        REQUIRE(visited.insert(surname).second);
        return surname == free; // all other combinations occupied locally or reserved by players
    });
    REQUIRE(chosen == free);
    visited.clear();
    REQUIRE(BotSurnames::Pick(3, random, [&](std::string const& surname)
    {
        REQUIRE(visited.insert(surname).second);
        return false; // includes reservation lookup failures: never accept an unchecked name
    }).empty());
    REQUIRE(visited.size() == 144);
}

TEST_CASE("A bot keeps its first name while receiving many distinct full names", "[BotSurnames]")
{
    std::mt19937 random(9);
    std::set<std::string> occupied;
    for (unsigned i = 0; i < 144; ++i)
    {
        auto surname = BotSurnames::Pick(4, random, [&](std::string const& value) { return !occupied.count(value); });
        REQUIRE(!surname.empty());
        REQUIRE(occupied.insert(surname).second);
    }
    REQUIRE(BotSurnames::Pick(4, random, [&](std::string const& value) { return !occupied.count(value); }).empty());
}
