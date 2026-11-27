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

#include "WorldSession.h"
#include "BattlePetMgr.h"
#include "BattlePetPackets.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "TemporarySummon.h"

void WorldSession::HandleBattlePetRequestJournal(WorldPackets::BattlePet::BattlePetRequestJournal& /*battlePetRequestJournal*/)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->SendJournal();
}

void WorldSession::HandleBattlePetRequestJournalLock(WorldPackets::BattlePet::BattlePetRequestJournalLock& /*battlePetRequestJournalLock*/)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->SendJournalLockStatus();

    if (GetBattlePetMgr()->HasJournalLock())
        GetBattlePetMgr()->SendJournal();
}

void WorldSession::HandleBattlePetSetBattleSlot(WorldPackets::BattlePet::BattlePetSetBattleSlot& battlePetSetBattleSlot)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    if (BattlePets::BattlePet* pet = GetBattlePetMgr()->GetPet(battlePetSetBattleSlot.PetGuid))
        if (WorldPackets::BattlePet::BattlePetSlot* slot = GetBattlePetMgr()->GetSlot(BattlePets::BattlePetSlot(battlePetSetBattleSlot.Slot)))
            slot->Pet = pet->PacketInfo;
}

void WorldSession::HandleBattlePetModifyName(WorldPackets::BattlePet::BattlePetModifyName& battlePetModifyName)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->ModifyName(battlePetModifyName.PetGuid, battlePetModifyName.Name, std::move(battlePetModifyName.DeclinedNames));
}

void WorldSession::HandleQueryBattlePetName(WorldPackets::BattlePet::QueryBattlePetName& queryBattlePetName)
{
    WorldPackets::BattlePet::QueryBattlePetNameResponse response;
    response.BattlePetID = queryBattlePetName.BattlePetID;

    Creature* summonedBattlePet = ObjectAccessor::GetCreatureOrPetOrVehicle(*_player, queryBattlePetName.UnitGUID);
    if (!summonedBattlePet || !summonedBattlePet->IsSummon())
    {
        SendPacket(response.Write());
        return;
    }

    response.CreatureID = summonedBattlePet->GetEntry();
    response.Timestamp = summonedBattlePet->GetBattlePetCompanionNameTimestamp();

    Unit* petOwner = summonedBattlePet->ToTempSummon()->GetSummonerUnit();
    if (!petOwner->IsPlayer())
    {
        SendPacket(response.Write());
        return;
    }

    BattlePets::BattlePetMgr* ownerBattlePetMgr = petOwner->ToPlayer()->GetSession()->GetBattlePetMgr();
    BattlePets::BattlePet const* battlePet = ownerBattlePetMgr ? ownerBattlePetMgr->GetPet(queryBattlePetName.BattlePetID) : nullptr;
    if (!battlePet)
    {
        SendPacket(response.Write());
        return;
    }

    response.Name = battlePet->PacketInfo.Name;
    if (battlePet->DeclinedName)
    {
        response.HasDeclined = true;
        response.DeclinedNames = *battlePet->DeclinedName;
    }

    response.Allow = !response.Name.empty();

    SendPacket(response.Write());
}

void WorldSession::HandleBattlePetDeletePet(WorldPackets::BattlePet::BattlePetDeletePet& battlePetDeletePet)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->RemovePet(battlePetDeletePet.PetGuid);
}

void WorldSession::HandleBattlePetSetFlags(WorldPackets::BattlePet::BattlePetSetFlags& battlePetSetFlags)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    if (!GetBattlePetMgr()->HasJournalLock())
        return;

    if (BattlePets::BattlePet* pet = GetBattlePetMgr()->GetPet(battlePetSetFlags.PetGuid))
    {
        if (battlePetSetFlags.ControlType == BattlePets::FLAGS_CONTROL_TYPE_APPLY)
            pet->PacketInfo.Flags |= battlePetSetFlags.Flags;
        else // FLAGS_CONTROL_TYPE_REMOVE
            pet->PacketInfo.Flags &= ~battlePetSetFlags.Flags;

        if (pet->SaveInfo != BattlePets::BATTLE_PET_NEW)
            pet->SaveInfo = BattlePets::BATTLE_PET_CHANGED;
    }
}

void WorldSession::HandleBattlePetClearFanfare(WorldPackets::BattlePet::BattlePetClearFanfare& battlePetClearFanfare)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->ClearFanfare(battlePetClearFanfare.PetGuid);
}

void WorldSession::HandleCageBattlePet(WorldPackets::BattlePet::CageBattlePet& cageBattlePet)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->CageBattlePet(cageBattlePet.PetGuid);
}

void WorldSession::HandleBattlePetSummon(WorldPackets::BattlePet::BattlePetSummon& battlePetSummon)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    if (*_player->m_activePlayerData->SummonedBattlePetGUID != battlePetSummon.PetGuid)
        GetBattlePetMgr()->SummonPet(battlePetSummon.PetGuid);
    else
        GetBattlePetMgr()->DismissPet();
}

void WorldSession::HandleBattlePetUpdateNotify(WorldPackets::BattlePet::BattlePetUpdateNotify& battlePetUpdateNotify)
{
    if (!_battlePetMgr) // a bot session has none (DropClientOnlyManagers)
        return;

    GetBattlePetMgr()->UpdateBattlePetData(battlePetUpdateNotify.PetGuid);
}
