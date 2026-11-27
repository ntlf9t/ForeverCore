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
#include "Creature.h"
#include <memory>

// Everlake: WorldObject::~WorldObject() asks IsStoredInWorldObjectGridContainer(). By then ~Creature has already run,
// so the answer must come from WorldObject state alone. When it read Creature::m_isTempWorldObject instead, the UBSan
// build (vptr check) reported a member access within an object that is no longer a Creature, for every Creature deleted.

TEST_CASE("Deleting a creature reads no Creature state in the WorldObject destructor", "[WorldObjectGridContainer]")
{
    for (bool tempWorldObject : { false, true })
    {
        INFO("Temporary world object: " << tempWorldObject);
        auto creature = std::make_unique<Creature>();
        creature->m_isTempWorldObject = tempWorldObject;
        CHECK(creature->IsStoredInWorldObjectGridContainer() == tempWorldObject);
        creature.reset();
    }

    auto worldObjectCreature = std::make_unique<Creature>(true);
    CHECK(worldObjectCreature->IsAlwaysStoredInWorldObjectGridContainer());
    CHECK(worldObjectCreature->IsStoredInWorldObjectGridContainer());
    worldObjectCreature.reset();
}

TEST_CASE("The temporary world object flag is WorldObject state", "[WorldObjectGridContainer]")
{
    // The flag has to live in the WorldObject part of the object, so the WorldObject destructor can still read it.
    Creature creature;
    WorldObject& worldObject = creature;
    CHECK_FALSE(worldObject.IsStoredInWorldObjectGridContainer());
    worldObject.m_isTempWorldObject = true;
    CHECK(worldObject.IsStoredInWorldObjectGridContainer());
    worldObject.m_isTempWorldObject = false;
    CHECK_FALSE(worldObject.IsStoredInWorldObjectGridContainer());
}
