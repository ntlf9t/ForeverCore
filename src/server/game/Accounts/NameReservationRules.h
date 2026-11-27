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

#ifndef TRINITY_NAME_RESERVATION_RULES_H
#define TRINITY_NAME_RESERVATION_RULES_H

#include "Define.h"
#include <ctime>

// Everlake: who may use a character name, across every realm that shares the login database.
// The rules alone, without the database, so they can be unit tested (tests/game/NameReservationRules.cpp).
// NameReservationMgr reads a row of auth.name_reservation, asks Evaluate() and writes the answer back.
namespace NameReservation
{
    // One name's row in auth.name_reservation, as the rules need it
    struct Row
    {
        bool Exists = false;
        uint32 Owner = 0;       // Battle.net account id that holds the name
        time_t FreedAt = 0;     // when the last character with the name went away; 0 = in use (or being created)
        uint32 Users = 0;       // characters on any realm that use the name now
    };

    enum class Claim : uint8
    {
        Free,       // nobody holds the name: a new row
        Own,        // the requester holds it already (in use, or still within its grace period)
        Expired,    // another account held it, its characters are gone and the grace period is over: taken over
        Taken       // another account holds it: refused with the stock "name in use"
    };

    // A name freed at `freedAt` (0 = not freed) may go to another account from freedAt + grace on
    constexpr bool IsGraceOver(time_t freedAt, time_t now, time_t grace)
    {
        return freedAt != 0 && now >= freedAt + grace;
    }

    // requester = Battle.net account id; 0 = no player account (a bot), which may use only a name nobody holds
    constexpr Claim Evaluate(Row const& row, uint32 requester, time_t now, time_t grace)
    {
        if (!row.Exists)
            return Claim::Free;
        if (requester != 0 && row.Owner == requester)
            return Claim::Own;
        if (row.Users == 0 && IsGraceOver(row.FreedAt, now, grace))
            return Claim::Expired;
        return Claim::Taken;
    }

    constexpr bool CanUse(Claim claim) { return claim != Claim::Taken; }
}

#endif
