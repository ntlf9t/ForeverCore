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
#include "CharacterCache.h"
#include "FullName.h"
#include "ObjectGuid.h"
#include "ObjectMgr.h"
#include <string>
#include <vector>

// Everlake: character names are unique by full name (name + surname), without regard to case. Several characters may
// be called Bob; "Bob Smith", "bob smith" and "BOB SMITH" are one full name.
using namespace Trinity::FullName;

namespace
{
    constexpr std::size_t None = std::size_t(-1);

    Parts SplitOf(std::string_view text)
    {
        Parts parts;
        REQUIRE(Split(text, parts));
        return parts;
    }
}

TEST_CASE("A typed full name splits into a normalised name and a trimmed surname", "[FullName]")
{
    Parts parts = SplitOf("bob smith");
    CHECK(parts.Name == "Bob");
    CHECK(parts.Surname == "smith");
    CHECK(parts.HasSurname);

    parts = SplitOf("  BOB   Smith  ");
    CHECK(parts.Name == "Bob");
    CHECK(parts.Surname == "Smith");

    // a surname may have more than one word: everything after the first blank
    parts = SplitOf("Ora of the Glade");
    CHECK(parts.Name == "Ora");
    CHECK(parts.Surname == "of the Glade");

    // the unit menu sends "Name " for a character with no surname
    parts = SplitOf("Bob ");
    CHECK(parts.Name == "Bob");
    CHECK(parts.Surname.empty());
    CHECK_FALSE(parts.HasSurname);

    Parts empty;
    CHECK_FALSE(Split("", empty));
    CHECK_FALSE(Split("   ", empty));
}

TEST_CASE("Surnames compare without regard to case, in any script", "[FullName]")
{
    CHECK(SurnameEquals("Smith", "smith"));
    CHECK(SurnameEquals("Smith", "SMITH"));
    CHECK(SurnameEquals("Élan", "élan"));
    CHECK(SurnameEquals("Иванов", "иванов"));
    CHECK(SurnameEquals(" Smith ", "Smith"));
    CHECK(SurnameEquals("", ""));
    CHECK_FALSE(SurnameEquals("Smith", "Jones"));
    CHECK_FALSE(SurnameEquals("Smith", ""));
}

TEST_CASE("A full name picks exactly the character with that surname", "[FullName]")
{
    std::vector<std::string_view> bobs = { "Smith", "Jones", "" };
    CHECK(Pick(bobs, SplitOf("bob smith")) == 0);
    CHECK(Pick(bobs, SplitOf("BOB JONES")) == 1);
    CHECK(Pick(bobs, SplitOf("Bob Brown")) == None);
}

TEST_CASE("A bare name picks the character with no surname, else the only one, else none", "[FullName]")
{
    // "Bob" is the character called exactly Bob, even with other Bobs around
    CHECK(Pick({ "Smith", "", "Jones" }, SplitOf("bob")) == 1);
    // only one Bob: it is the one meant
    CHECK(Pick({ "Smith" }, SplitOf("Bob")) == 0);
    // several Bobs, none without a surname: the player has to say which
    CHECK(Pick({ "Smith", "Jones" }, SplitOf("Bob")) == None);
    CHECK(Pick({}, SplitOf("Bob")) == None);
}

TEST_CASE("The character cache finds every Bob by full name, in any capitals", "[FullName]")
{
    ObjectGuid const smith = ObjectGuid::Create<HighGuid::Player>(UI64LIT(900001));
    ObjectGuid const jones = ObjectGuid::Create<HighGuid::Player>(UI64LIT(900002));
    ObjectGuid const plain = ObjectGuid::Create<HighGuid::Player>(UI64LIT(900003));

    sCharacterCache->AddCharacterCacheEntry(smith, 1, "Bob", 0, 1, 1, 10, false);
    sCharacterCache->UpdateCharacterSurname(smith, "Smith");
    sCharacterCache->AddCharacterCacheEntry(jones, 2, "Bob", 0, 1, 1, 10, false);
    sCharacterCache->UpdateCharacterSurname(jones, "Jones");

    CHECK(sCharacterCache->GetCharacterGuidByName("Bob Smith") == smith);
    CHECK(sCharacterCache->GetCharacterGuidByName("bob smith") == smith);
    CHECK(sCharacterCache->GetCharacterGuidByName("BOB JONES") == jones);
    CHECK(sCharacterCache->GetCharacterCacheByFullName("Bob", "sMiTh") == sCharacterCache->GetCharacterCacheByGuid(smith));
    CHECK(sCharacterCache->GetCharacterCacheByFullName("Bob", "") == nullptr);

    // two Bobs, neither without a surname: a bare "Bob" is not enough
    CHECK(sCharacterCache->GetCharacterGuidByName("Bob").IsEmpty());

    // a Bob with no surname is the one "Bob" means
    sCharacterCache->AddCharacterCacheEntry(plain, 3, "Bob", 0, 1, 1, 10, false);
    CHECK(sCharacterCache->GetCharacterGuidByName("bob") == plain);

    // removing one Bob leaves the others findable
    sCharacterCache->DeleteCharacterCacheEntry(plain, "Bob");
    sCharacterCache->DeleteCharacterCacheEntry(jones, "Bob");
    CHECK(sCharacterCache->GetCharacterGuidByName("Bob Smith") == smith);
    CHECK(sCharacterCache->GetCharacterGuidByName("Bob") == smith);   // the only Bob left
    CHECK(sCharacterCache->GetCharacterGuidByName("Bob Jones").IsEmpty());

    sCharacterCache->DeleteCharacterCacheEntry(smith, "Bob");
    CHECK(sCharacterCache->GetCharacterGuidByName("Bob").IsEmpty());
}

namespace
{
    std::string Normalized(std::string text, std::string_view realmName = "Everlake")
    {
        REQUIRE(Normalize(text, realmName));
        return text;
    }

    bool Normalizes(std::string text, std::string_view realmName = "Everlake")
    {
        return Normalize(text, realmName);
    }
}

TEST_CASE("A name the client sent keeps its surname for the lookups", "[FullName]")
{
    // typed names and the unit menu send "Name Surname" (or "Name " with no surname); normalizePlayerName alone kept only
    // "Bob", so a lookup found another Bob or nobody
    CHECK(Normalized("Bob Smith") == "Bob Smith");
    CHECK(Normalized("bob smith") == "Bob smith");      // the surname compares without regard to case later (Pick)
    CHECK(Normalized("  BOB   Smith  ") == "Bob Smith");
    CHECK(Normalized("Ora of the Glade") == "Ora of the Glade");
    CHECK(Normalized("Bob ") == "Bob");
    CHECK(Normalized("bob") == "Bob");

    // this realm after the last '-' is dropped, in any case and with or without its spaces
    CHECK(Normalized("Bob-Everlake") == "Bob");
    CHECK(Normalized("Bob-everlake") == "Bob");
    CHECK(Normalized("Bob Smith-Everlake") == "Bob Smith");
    CHECK(Normalized("Bob Smith-Jones-Everlake") == "Bob Smith-Jones");
    CHECK(Normalized("Bob-EverlakeTwo", "Everlake Two") == "Bob");

    CHECK_FALSE(Normalizes(""));
    CHECK_FALSE(Normalizes("   "));
    CHECK_FALSE(Normalizes("-Everlake"));
}

TEST_CASE("Name-Surname from the friends list and chat links is a name and surname", "[FullName]")
{
    // the 1.60 client keeps the surname in retail's realm slot, so outside the unit menu it builds "Name-Surname"
    CHECK(Normalized("Ora-Brightleaf") == "Ora Brightleaf");
    CHECK(Normalized("ora-brightleaf") == "Ora brightleaf");
    CHECK(Normalized("Ora-Brightleaf-Everlake") == "Ora Brightleaf");
    CHECK(Normalized(" Ora-Brightleaf ") == "Ora Brightleaf");
    // a '-' after the first blank belongs to the surname
    CHECK(Normalized("Bob Smith-Jones") == "Bob Smith-Jones");
    // with no realm known, every suffix is a surname
    CHECK(Normalized("Ora-Brightleaf", "") == "Ora Brightleaf");

    CHECK_FALSE(Normalizes("-Brightleaf"));
    CHECK_FALSE(Normalizes("-Brightleaf", ""));
}

TEST_CASE("A surname sent apart from the name joins it", "[FullName]")
{
    // whisper and party invite carry the surname in a 9 bit string of its own, where retail carries the realm
    CHECK(WithSurname("Ora", "Brightleaf", "Everlake") == "Ora Brightleaf");
    CHECK(WithSurname("Ora", "", "Everlake") == "Ora");
    CHECK(WithSurname("Ora", "  ", "Everlake") == "Ora");
    // the realm in that slot is no surname
    CHECK(WithSurname("Ora", "Everlake", "Everlake") == "Ora");
    CHECK(WithSurname("Ora", "everlake two", "Everlake Two") == "Ora");
    // a name that already has its surname keeps it
    CHECK(WithSurname("Ora Brightleaf", "Brightleaf", "Everlake") == "Ora Brightleaf");
    CHECK(WithSurname("Ora-Brightleaf", "Everlake", "Everlake") == "Ora-Brightleaf");

    CHECK(Normalized(WithSurname("ora", "Brightleaf", "Everlake")) == "Ora Brightleaf");
}

TEST_CASE("A whispered full name finds that character, not another with the same name", "[FullName]")
{
    ObjectGuid const brightleaf = ObjectGuid::Create<HighGuid::Player>(UI64LIT(900011));
    ObjectGuid const bot = ObjectGuid::Create<HighGuid::Player>(UI64LIT(900012));

    // a player friend "Ora Brightleaf" and a bot called just "Ora"
    sCharacterCache->AddCharacterCacheEntry(brightleaf, 1, "Ora", 0, 1, 1, 10, false);
    sCharacterCache->UpdateCharacterSurname(brightleaf, "Brightleaf");
    sCharacterCache->AddCharacterCacheEntry(bot, 2, "Ora", 0, 1, 1, 10, false);

    std::string target = "Ora Brightleaf ";
    REQUIRE(Normalize(target, "Everlake"));
    CHECK(sCharacterCache->GetCharacterGuidByName(target) == brightleaf);

    // the friends list whisper: "Ora-Brightleaf", which reaches the server as "Ora" + surname "Brightleaf"
    std::string fromFriendsList = WithSurname("Ora", "Brightleaf", "Everlake");
    REQUIRE(Normalize(fromFriendsList, "Everlake"));
    CHECK(sCharacterCache->GetCharacterGuidByName(fromFriendsList) == brightleaf);

    std::string dashed = "Ora-Brightleaf";
    REQUIRE(Normalize(dashed, "Everlake"));
    CHECK(sCharacterCache->GetCharacterGuidByName(dashed) == brightleaf);

    // before: the surname was cut off and the lookup took the Ora with no surname
    std::string firstWordOnly = "Ora Brightleaf ";
    REQUIRE(normalizePlayerName(firstWordOnly));
    CHECK(firstWordOnly == "Ora");
    CHECK(sCharacterCache->GetCharacterGuidByName(firstWordOnly) == bot);

    sCharacterCache->DeleteCharacterCacheEntry(bot, "Ora");
    sCharacterCache->DeleteCharacterCacheEntry(brightleaf, "Ora");
}
