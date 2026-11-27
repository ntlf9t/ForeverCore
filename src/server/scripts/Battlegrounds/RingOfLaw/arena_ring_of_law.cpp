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

#include "Battleground.h"
#include "BattlegroundScript.h"
#include "GameObject.h"
#include "Map.h"
#include "ScriptMgr.h"

// Classic 1.60 (Forever): 2v2 / 3v3 arena in the Ring of Law of Blackrock Depths. Map 3200 is an arena copy of the
// Blackrock Depths map (230): same terrain and buildings, its own map id, no dungeon spawns. Each team waits in a tunnel
// behind one of the ring's gates; both gates open when the match starts. The other two gates (the dungeon entrance and
// exit) stay shut, so the ring is closed all round. The gates are the Blackrock Depths ones, at their dungeon spots.
namespace RingOfLaw
{
    static constexpr uint32 MapId = 3200;

    namespace GameObjects
    {
        static constexpr uint32 GateSouth = 161525; // team 1 (Alliance side) start tunnel
        static constexpr uint32 GateEast  = 161522; // team 2 (Horde side) start tunnel
        static constexpr uint32 GateNorth = 161524; // stays shut
        static constexpr uint32 GateWest  = 161523; // stays shut (the dungeon entrance)
    }
}

struct arena_ring_of_law : ArenaScript
{
    explicit arena_ring_of_law(BattlegroundMap* map) : ArenaScript(map) { }

    void OnInit() override
    {
        using namespace RingOfLaw::GameObjects;
        // Spots and rotations of the Blackrock Depths spawns (world gameobject rows of map 230).
        if (GameObject const* go = CreateObject(GateSouth, 607.668f, -229.653f, -52.8988f, 1.8326f, 0.f, 0.f, 0.793354f, 0.608761f, GO_STATE_READY))
            _startGates.push_back(go->GetGUID());
        if (GameObject const* go = CreateObject(GateEast, 637.64f, -177.801f, -52.8988f, 0.261799f, 0.f, 0.f, 0.130526f, 0.991445f, GO_STATE_READY))
            _startGates.push_back(go->GetGUID());
        CreateObject(GateNorth, 585.739f, -147.762f, -52.8988f, 1.8326f, 0.f, 0.f, 0.793354f, 0.608761f, GO_STATE_READY);
        CreateObject(GateWest, 555.751f, -199.744f, -52.908f, 0.261799f, 0.f, 0.f, 0.130526f, 0.991445f, GO_STATE_READY);
    }

    void OnStart() override
    {
        for (ObjectGuid const& guid : _startGates)
            if (GameObject* gate = battlegroundMap->GetGameObject(guid))
                gate->SetGoState(GO_STATE_ACTIVE);
    }

private:
    GuidVector _startGates;
};

void AddSC_arena_ring_of_law()
{
    RegisterBattlegroundMapScript(arena_ring_of_law, RingOfLaw::MapId);
}
