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

#include "Battleground.h"
#include "DB2Structure.h"

// Playtest 2026-11-24: a warlock queued for Warsong Gulch or Alterac Valley was shown as a tank. The server sent a hard role 0, which the
// client reads as the tank role, on the entry popup and the scoreboard.
TEST_CASE("Battleground role: the player's specialization role is sent, not tank", "[battleground][role]")
{
    ChrSpecializationEntry spec{};

    // Classic 1.60 ChrSpecialization.db2: every class has one specialization with the damage role (warlock 1490)
    spec.ID = 1490;
    spec.ClassID = 9;
    spec.Role = int8(ChrSpecializationRole::Dps);
    CHECK(Battleground::GetLfgRole(&spec) == uint8(ChrSpecializationRole::Dps));

    // the role of the specialization is passed through as it is
    spec.Role = int8(ChrSpecializationRole::Healer);
    CHECK(Battleground::GetLfgRole(&spec) == uint8(ChrSpecializationRole::Healer));
    spec.Role = int8(ChrSpecializationRole::Tank);
    CHECK(Battleground::GetLfgRole(&spec) == uint8(ChrSpecializationRole::Tank));

    // no specialization: damage, never tank
    CHECK(Battleground::GetLfgRole(nullptr) == uint8(ChrSpecializationRole::Dps));
}
