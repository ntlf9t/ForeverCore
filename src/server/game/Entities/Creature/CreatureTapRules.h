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

#ifndef TRINITY_CREATURE_TAP_RULES_H
#define TRINITY_CREATURE_TAP_RULES_H

#include <cstddef>

// Who may tag a creature (its tap list: loot, kill XP and quest credit). Pure: no game types.
//  classic (Classic.FirstTagOwnsMob = 1, WoW Forever / Classic): the first player to damage the mob, with their group, owns it.
//          Nobody else joins the list and it shows tapped (grey) to everyone outside it at once.
//  retail  (0): every player who damages the mob joins the list until it holds `softCap` tappers; only then is it grey.
namespace CreatureTapRules
{
    // A player tags the mob: does the tag add them (and their group) to the list? Under the classic rule a mob already owned takes
    // no more tags, its owners included (they are on the list already).
    inline bool AcceptsTag(bool classic, std::size_t tappers, std::size_t softCap)
    {
        return classic ? tappers == 0 : tappers < softCap;
    }

    // Is the mob shown tapped to players who are not on its list?
    inline bool ShowsTapped(bool classic, std::size_t tappers, std::size_t softCap)
    {
        return classic ? tappers > 0 : tappers >= softCap;
    }
}

#endif
