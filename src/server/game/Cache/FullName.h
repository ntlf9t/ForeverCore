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

#ifndef TRINITYCORE_FULL_NAME_H
#define TRINITYCORE_FULL_NAME_H

#include "Define.h"
#include <cstddef>
#include <string>
#include <string_view>
#include <vector>

// Classic 1.60 characters have a name and a surname ("Bob Smith"). Only the full name is unique: several characters may
// be called Bob. Names and surnames compare without regard to case ("bob smith" is "Bob Smith").
namespace Trinity::FullName
{
struct Parts
{
    std::string Name;       // normalised like the core stores names: "Bob"
    std::string Surname;    // as typed, outer blanks trimmed; empty when none was given
    bool HasSurname = false;
};

// Splits what a player typed ("Bob", "bob smith", " Bob  Smith ") at the first blank. The name is normalised
// (normalizePlayerName); false when it is empty or not a valid name.
TC_GAME_API bool Split(std::string_view text, Parts& parts);

// Readies a player name the client sent for the by-name lookups (ObjectAccessor, CharacterCache), which take full names:
// "bob", "Bob " (the unit menu, no surname), "bob smith", "Bob-Smith" and "Bob Smith-Realm" become "Bob" or "Bob Smith".
// The 1.60 client keeps the surname where retail keeps the realm, so names it builds outside the unit menu (friends list,
// chat links: UnitPopupSharedUtil.GetFullPlayerName) come as "Name-Surname". A suffix after the last '-' is dropped only
// when it names this realm (realmName, spaces ignored, as GetNormalizedRealmName); otherwise "Name-Surname" is read as
// name and surname. The name is normalised, the surname kept: normalizePlayerName keeps only the first word, and a lookup
// by that alone finds another Bob (one with no surname), or nobody when several are online.
// False when it is empty or not a valid name.
TC_GAME_API bool Normalize(std::string& text, std::string_view realmName);

// As above, with this realm's name
TC_GAME_API bool Normalize(std::string& text);

// For packets that carry the surname in a string of its own after the name (1.60 whisper, party invite): "Bob" + "Smith"
// is "Bob Smith", ready for Normalize. The second string is ignored when it is blank or names this realm (where retail
// sends the realm), or when the name already has a surname.
TC_GAME_API std::string WithSurname(std::string_view name, std::string_view surname, std::string_view realmName);

// As above, with this realm's name
TC_GAME_API std::string WithSurname(std::string_view name, std::string_view surname);

// Surnames are equal when they differ only in case (any script, not just ASCII)
TC_GAME_API bool SurnameEquals(std::string_view a, std::string_view b);

// Which of several characters that share the wanted name (their surnames, in any order) the text means:
// - with a surname: the one with that surname;
// - without: the one with no surname ("Bob" is the character called exactly Bob), else the only one;
// npos when none matches, or when a bare name fits several characters (the player has to give the surname).
TC_GAME_API std::size_t Pick(std::vector<std::string_view> const& candidateSurnames, Parts const& wanted);
}

#endif // TRINITYCORE_FULL_NAME_H
