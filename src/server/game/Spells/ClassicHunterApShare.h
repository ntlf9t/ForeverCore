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

#ifndef TRINITY_CLASSIC_HUNTER_AP_SHARE_H
#define TRINITY_CLASSIC_HUNTER_AP_SHARE_H

#include <cstdint>

// WoW Forever gave these hunter spells a share of ranged attack power that the client rows do not carry (their
// BonusCoefficientFromAP is 0), so the server has to add it. Blizzard's Forever notes say fire traps scale with attack power; the
// amounts come from players' logs:
// - Arcane Shot 15% and Serpent Sting 5% a tick (25% over the sting): Blizzard's note of build 70755 (3 November 2026), "Attack Power
//   coefficient raised from 0.1 to 0.15" and "Attack Power coefficient per tick increased to 5% from 3%". wowsims/forever EV-0068 (combat
//   logs, levels 34 and 36) found the same; the forever-hunter wiki's 10% and 3% a tick are the old values the note names.
// - Explosive Trap: 10% on the initial hit, none on the ticks (EV-0068).
// - Immolation Trap: 10% over its five ticks, 2% a tick (forever-hunter wiki, "verified"; wowsims takes the same).
// Each tick reads the hunter's attack power when it lands (the core recalculates ticks), as on live.
namespace ClassicHunterApShare
{
    inline float For(uint32_t spellId, bool periodic)
    {
        switch (spellId)
        {
            // Arcane Shot ranks 1-8
            case 3044: case 14281: case 14282: case 14283: case 14284: case 14285: case 14286: case 14287:
                return periodic ? 0.0f : 0.15f;
            // Explosive Trap Effect ranks 1-3: the initial hit only
            case 13812: case 14314: case 14315:
                return periodic ? 0.0f : 0.10f;
            // Serpent Sting ranks 1-9
            case 1978: case 13549: case 13550: case 13551: case 13552: case 13553: case 13554: case 13555: case 25295:
                return periodic ? 0.05f : 0.0f;
            // Immolation Trap Effect ranks 1-5
            case 13797: case 14298: case 14299: case 14300: case 14301:
                return periodic ? 0.02f : 0.0f;
            default:
                return 0.0f;
        }
    }
}

#endif
