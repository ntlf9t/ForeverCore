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

#ifndef TRINITYCORE_FALL_OUT_OF_WORLD_H
#define TRINITYCORE_FALL_OUT_OF_WORLD_H

// What happens to an alive player who falls below the map (battlegrounds handle their own first).
namespace Trinity::FallOutOfWorld
{
enum class Outcome
{
    ReturnToGraveyard,  // back at the nearest graveyard, alive (advocaite #285): falling through a hole is not the player's fault
    Die                 // killed, as before #285
};

// Alive at the graveyard only out of combat in the open world. In combat, or inside a dungeon, raid or other instance,
// the player dies as before, so a deliberate fall is no free way out of a fight or out of an instance.
inline Outcome For(bool inCombat, bool inInstance)
{
    return (inCombat || inInstance) ? Outcome::Die : Outcome::ReturnToGraveyard;
}
}

#endif // TRINITYCORE_FALL_OUT_OF_WORLD_H
