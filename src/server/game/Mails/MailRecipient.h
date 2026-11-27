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

#ifndef TRINITYCORE_MAIL_RECIPIENT_H
#define TRINITYCORE_MAIL_RECIPIENT_H

#include "Util.h"
#include <string>
#include <string_view>

namespace Trinity::Mail
{
    struct RecipientName
    {
        std::string Name;
        std::string Surname;
    };

    /// Splits what the client typed in the mail To box. Classic 1.60 clients send "Name" or "Name Surname"; the 70790 client
    /// asks for a full name and sends "Name-Realm" or "Name Surname-Realm". A "-Realm" suffix naming `realmName` (spaces and
    /// case ignored) is dropped; a suffix naming another realm is kept, so that recipient is not found, as before.
    inline RecipientName SplitRecipient(std::string_view target, std::string_view realmName)
    {
        RecipientName recipient;
        recipient.Name = target;

        if (size_t dashPos = recipient.Name.rfind('-'); dashPos != std::string::npos)
        {
            std::string suffix = recipient.Name.substr(dashPos + 1);
            std::string realm(realmName);
            std::erase(suffix, ' ');
            std::erase(realm, ' ');
            if (!suffix.empty() && StringEqualI(suffix, realm))
                recipient.Name.erase(dashPos);
        }

        if (size_t spacePos = recipient.Name.find(' '); spacePos != std::string::npos)
        {
            recipient.Surname = recipient.Name.substr(spacePos + 1);
            recipient.Name.erase(spacePos);
            // tolerate repeated/trailing whitespace
            recipient.Surname.erase(0, recipient.Surname.find_first_not_of(' '));
            recipient.Surname.erase(recipient.Surname.find_last_not_of(' ') + 1);
        }

        return recipient;
    }
}

#endif // TRINITYCORE_MAIL_RECIPIENT_H
