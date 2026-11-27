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

#include "FullName.h"
#include "ObjectMgr.h"
#include "RealmList.h"
#include "Util.h"

namespace
{
    // the blanks normalizePlayerName trims (the unit menu sends "Name " for a character with no surname)
    bool IsBlank(wchar_t c)
    {
        switch (c)
        {
            case L' ': case L'\t': case L' ': case L'​': case L'‌': case L'‍': case L'‎':
            case L'‏': case L'﻿':
                return true;
            default:
                return false;
        }
    }

    std::wstring Trimmed(std::wstring const& text)
    {
        std::size_t first = 0;
        while (first < text.size() && IsBlank(text[first]))
            ++first;
        std::size_t last = text.size();
        while (last > first && IsBlank(text[last - 1]))
            --last;
        return text.substr(first, last - first);
    }

    bool Folded(std::string_view text, std::wstring& folded)
    {
        if (!Utf8toWStr(text, folded))
            return false;
        folded = Trimmed(folded);
        wstrToLower(folded);
        return true;
    }

    // true when text names the realm: case and blanks ignored, as the client's GetNormalizedRealmName drops the spaces
    bool IsRealmName(std::string_view text, std::string_view realmName)
    {
        std::wstring a, b;
        if (realmName.empty() || !Folded(text, a) || !Folded(realmName, b))
            return false;
        std::erase_if(a, IsBlank);
        std::erase_if(b, IsBlank);
        return !a.empty() && a == b;
    }

    std::string CurrentRealmName()
    {
        if (std::shared_ptr<Realm const> realm = sRealmList->GetCurrentRealm())
            return realm->NormalizedName;
        return {};
    }
}

bool Trinity::FullName::Split(std::string_view text, Parts& parts)
{
    parts = Parts();

    std::wstring wide;
    if (!Utf8toWStr(text, wide))
        return false;
    wide = Trimmed(wide);

    std::size_t blank = 0;
    while (blank < wide.size() && !IsBlank(wide[blank]))
        ++blank;

    std::wstring surname = blank < wide.size() ? Trimmed(wide.substr(blank)) : std::wstring();
    if (!WStrToUtf8(wide.substr(0, blank), parts.Name) || !WStrToUtf8(surname, parts.Surname))
        return false;

    parts.HasSurname = !parts.Surname.empty();
    return normalizePlayerName(parts.Name);
}

bool Trinity::FullName::Normalize(std::string& text, std::string_view realmName)
{
    std::string_view full(text);

    // "Name-Realm" / "Name Surname-Realm": the realm goes after the last '-' (realm names have none). Cross-realm lookups
    // aren't supported, so it is dropped.
    if (std::size_t const dash = full.rfind('-'); dash != std::string_view::npos && IsRealmName(full.substr(dash + 1), realmName))
        full = full.substr(0, dash);

    std::string joined(full);

    // "Name-Surname" (the 1.60 client's realm slot holds the surname): names are letters only, so the first '-' of a text
    // with no blank ends the name. "Name Surname-Jones" (a blank first) is a surname with a '-' in it.
    std::size_t const start = joined.find_first_not_of(" \t");
    std::size_t const firstDash = joined.find('-');
    if (firstDash != std::string::npos && joined.find_first_of(" \t", start) > firstDash)
    {
        if (firstDash == start)
            return false;   // "-Surname": no name
        joined[firstDash] = ' ';
    }

    Parts parts;
    if (!Split(joined, parts))
        return false;

    text = parts.HasSurname ? parts.Name + ' ' + parts.Surname : parts.Name;
    return true;
}

bool Trinity::FullName::Normalize(std::string& text)
{
    return Normalize(text, CurrentRealmName());
}

std::string Trinity::FullName::WithSurname(std::string_view name, std::string_view surname, std::string_view realmName)
{
    std::wstring wide;
    if (!Utf8toWStr(surname, wide) || Trimmed(wide).empty() || IsRealmName(surname, realmName))
        return std::string(name);

    std::wstring wideName;
    if (!Utf8toWStr(name, wideName))
        return std::string(name);
    wideName = Trimmed(wideName);
    if (wideName.find_first_of(L" \t-") != std::wstring::npos)
        return std::string(name);   // already "Name Surname" or "Name-Surname"

    return std::string(name) + ' ' + std::string(surname);
}

std::string Trinity::FullName::WithSurname(std::string_view name, std::string_view surname)
{
    return WithSurname(name, surname, CurrentRealmName());
}

bool Trinity::FullName::SurnameEquals(std::string_view a, std::string_view b)
{
    std::wstring foldedA, foldedB;
    if (!Folded(a, foldedA) || !Folded(b, foldedB))
        return false;
    return foldedA == foldedB;
}

std::size_t Trinity::FullName::Pick(std::vector<std::string_view> const& candidateSurnames, Parts const& wanted)
{
    constexpr std::size_t none = std::size_t(-1);

    if (wanted.HasSurname)
    {
        for (std::size_t i = 0; i < candidateSurnames.size(); ++i)
            if (SurnameEquals(candidateSurnames[i], wanted.Surname))
                return i;
        return none;
    }

    for (std::size_t i = 0; i < candidateSurnames.size(); ++i)
        if (candidateSurnames[i].empty())
            return i;

    return candidateSurnames.size() == 1 ? 0 : none;
}
