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

#include "Pet.h"
#include "PetScaling.h"
#include "CharmInfo.h"
#include "Chat.h"
#include "Common.h"
#include "DatabaseEnv.h"
#include "DB2Stores.h"
#include "Group.h"
#include "HunterPetForever.h"
#include "InstanceScript.h"
#include "Log.h"
#include "Map.h"
#include "ObjectMgr.h"
#include "PetFollowPosition.h"
#include "PetPackets.h"
#include "PhasingHandler.h"
#include "Player.h"
#include "QueryHolder.h"
#include "Spell.h"
#include "SpellAuraEffects.h"
#include "SpellAuras.h"
#include "SpellHistory.h"
#include "SpellMgr.h"
#include "SpellPackets.h"
#include "Unit.h"
#include "Util.h"
#include "WarlockPetForever.h"
#include "World.h"
#include "WorldSession.h"
#include <algorithm>
#include <limits>
#include <sstream>
#include <unordered_set>


Pet::Pet(Player* owner, PetType type) :
    Guardian(nullptr, owner, true), m_removed(false),
    m_petType(type), m_duration(0), m_loading(false), m_groupUpdateMask(0),
    m_petSpecialization(0)
{
    ASSERT(GetOwner());

    m_unitTypeMask |= UNIT_MASK_PET;
    if (type == HUNTER_PET)
    {
        m_unitTypeMask |= UNIT_MASK_HUNTER_PET;
        // Classic 1.60 (WoW Forever): no spell crit of its own either (Lightning Breath); Unit::GetUnitCriticalChanceDone has the melee side
        m_baseSpellCritChance = 0.0f;
    }

    if (!(m_unitTypeMask & UNIT_MASK_CONTROLABLE_GUARDIAN))
    {
        m_unitTypeMask |= UNIT_MASK_CONTROLABLE_GUARDIAN;
        InitCharmInfo();
    }

    m_name = "Pet";
    m_focusRegenTimer = PET_FOCUS_REGEN_INTERVAL;
}

Pet::~Pet() = default;

void Pet::AddToWorld()
{
    ///- Register the pet for guid lookup
    if (!IsInWorld())
    {
        ///- Register the pet for guid lookup
        GetMap()->GetObjectsStore().Insert<Pet>(this);
        Unit::AddToWorld();
        AIM_Initialize();
        if (ZoneScript* zoneScript = GetZoneScript() ? GetZoneScript() : GetInstanceScript())
            zoneScript->OnCreatureCreate(this);
    }

    // Prevent stuck pets when zoning. Pets default to "follow" when added to world
    // so we'll reset flags and let the AI handle things
    if (GetCharmInfo() && GetCharmInfo()->HasCommandState(COMMAND_FOLLOW))
    {
        GetCharmInfo()->SetIsCommandAttack(false);
        GetCharmInfo()->SetIsCommandFollow(false);
        GetCharmInfo()->SetIsAtStay(false);
        GetCharmInfo()->SetIsFollowing(false);
        GetCharmInfo()->SetIsReturning(false);
    }
}

void Pet::RemoveFromWorld()
{
    ///- Remove the pet from the accessor
    if (IsInWorld())
    {
        ///- Don't call the function for Creature, normal mobs + totems go in a different storage
        Unit::RemoveFromWorld();
        GetMap()->GetObjectsStore().Remove<Pet>(this);
    }
}

std::pair<PetStable::PetInfo const*, PetSaveMode> Pet::GetLoadPetInfo(PetStable const& stable, uint32 petEntry, uint32 petnumber, Optional<PetSaveMode> slot)
{
    if (petnumber)
    {
        // Known petnumber entry
        for (std::size_t activeSlot = 0; activeSlot < stable.ActivePets.size(); ++activeSlot)
            if (stable.ActivePets[activeSlot] && stable.ActivePets[activeSlot]->PetNumber == petnumber)
                return { &stable.ActivePets[activeSlot].value(), PetSaveMode(PET_SAVE_FIRST_ACTIVE_SLOT + activeSlot) };

        for (std::size_t stableSlot = 0; stableSlot < stable.StabledPets.size(); ++stableSlot)
            if (stable.StabledPets[stableSlot] && stable.StabledPets[stableSlot]->PetNumber == petnumber)
                return { &stable.StabledPets[stableSlot].value(), PetSaveMode(PET_SAVE_FIRST_STABLE_SLOT + stableSlot) };

        for (PetStable::PetInfo const& pet : stable.UnslottedPets)
            if (pet.PetNumber == petnumber)
                return { &pet, PET_SAVE_NOT_IN_SLOT };
    }
    else if (slot)
    {
        // Current pet
        if (slot == PET_SAVE_AS_CURRENT)
            if (stable.GetCurrentActivePetIndex() && stable.ActivePets[*stable.GetCurrentActivePetIndex()])
                return { &stable.ActivePets[*stable.GetCurrentActivePetIndex()].value(), PetSaveMode(*stable.GetCurrentActivePetIndex()) };

        if (slot >= PET_SAVE_FIRST_ACTIVE_SLOT && slot < PET_SAVE_LAST_ACTIVE_SLOT)
            if (stable.ActivePets[*slot])
                return { &stable.ActivePets[*slot].value(), *slot };

        if (slot >= PET_SAVE_FIRST_STABLE_SLOT && slot < PET_SAVE_LAST_STABLE_SLOT)
            if (stable.StabledPets[*slot])
                return { &stable.StabledPets[*slot].value(), *slot };
    }
    else if (petEntry)
    {
        // known petEntry entry (unique for summoned pet, but non unique for hunter pet (only from current or not stabled pets)
        // A character can hold more than one unslotted pet of the same entry (an older warlock demon left behind when a load
        // failed once). Take the one saved last, so the demon that learned its grimoire spells comes back after a restart
        // instead of the older copy the database happens to return first.
        PetStable::PetInfo const* newest = nullptr;
        for (PetStable::PetInfo const& pet : stable.UnslottedPets)
            if (pet.CreatureId == petEntry)
                if (!newest || pet.LastSaveTime > newest->LastSaveTime
                    || (pet.LastSaveTime == newest->LastSaveTime && pet.PetNumber > newest->PetNumber))
                    newest = &pet;

        if (newest)
            return { newest, PET_SAVE_NOT_IN_SLOT };
    }
    else
    {
        // Any current or other non-stabled pet (for hunter "call pet")
        if (stable.ActivePets[0])
            return { &stable.ActivePets[0].value(), PET_SAVE_FIRST_ACTIVE_SLOT };

        if (!stable.UnslottedPets.empty())
            return { &stable.UnslottedPets.front(), PET_SAVE_NOT_IN_SLOT };
    }

    return { nullptr, PET_SAVE_AS_DELETED };
}

class PetLoadQueryHolder : public CharacterDatabaseQueryHolder
{
public:
    enum
    {
        DECLINED_NAMES,
        AURAS,
        AURA_EFFECTS,
        SPELLS,
        COOLDOWNS,
        CHARGES,

        MAX
    };

    PetLoadQueryHolder(ObjectGuid::LowType ownerGuid, uint32 petNumber)
    {
        SetSize(MAX);

        CharacterDatabasePreparedStatement* stmt;

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_PET_DECLINED_NAME);
        stmt->setUInt64(0, ownerGuid);
        stmt->setUInt32(1, petNumber);
        SetPreparedQuery(DECLINED_NAMES, stmt);

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_PET_AURA);
        stmt->setUInt32(0, petNumber);
        SetPreparedQuery(AURAS, stmt);

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_PET_AURA_EFFECT);
        stmt->setUInt32(0, petNumber);
        SetPreparedQuery(AURA_EFFECTS, stmt);

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_PET_SPELL);
        stmt->setUInt32(0, petNumber);
        SetPreparedQuery(SPELLS, stmt);

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_PET_SPELL_COOLDOWN);
        stmt->setUInt32(0, petNumber);
        SetPreparedQuery(COOLDOWNS, stmt);

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_SEL_PET_SPELL_CHARGES);
        stmt->setUInt32(0, petNumber);
        SetPreparedQuery(CHARGES, stmt);
    }
};

bool Pet::LoadPetFromDB(Player* owner, uint32 petEntry, uint32 petnumber, bool current, Optional<PetSaveMode> forcedSlot /*= {}*/)
{
    m_loading = true;

    PetStable* petStable = ASSERT_NOTNULL(owner->GetPetStable());

    ObjectGuid::LowType ownerid = owner->GetGUID().GetCounter();
    std::pair<PetStable::PetInfo const*, PetSaveMode> info = GetLoadPetInfo(*petStable, petEntry, petnumber, forcedSlot);
    PetStable::PetInfo const* petInfo = info.first;
    PetSaveMode slot = info.second;
    if (!petInfo || (slot >= PET_SAVE_FIRST_STABLE_SLOT && slot < PET_SAVE_LAST_STABLE_SLOT))
    {
        m_loading = false;
        return false;
    }

    // Don't try to reload the current pet
    if (petStable->GetCurrentPet() && owner->GetPet() && petStable->GetCurrentPet()->PetNumber == petInfo->PetNumber)
        return false;

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(petInfo->CreatedBySpellId, owner->GetMap()->GetDifficultyID());

    bool isTemporarySummon = spellInfo && spellInfo->GetDuration() > 0;
    if (current && isTemporarySummon)
        return false;

    if (petInfo->Type == HUNTER_PET)
    {
        CreatureTemplate const* creatureInfo = sObjectMgr->GetCreatureTemplate(petInfo->CreatureId);
        if (!creatureInfo)
            return false;

        CreatureDifficulty const* creatureDifficulty = creatureInfo->GetDifficulty(DIFFICULTY_NONE);
        if (!creatureDifficulty || !creatureInfo->IsTameable(owner->CanTameExoticPets(), creatureDifficulty))
            return false;
    }

    if (current && owner->IsPetNeedBeTemporaryUnsummoned())
    {
        owner->SetTemporaryUnsummonedPetNumber(petInfo->PetNumber);
        return false;
    }

    owner->SetTemporaryUnsummonedPetNumber(0);

    Map* map = owner->GetMap();
    ObjectGuid::LowType guid = map->GenerateLowGuid<HighGuid::Pet>();

    if (!Create(guid, map, petInfo->CreatureId, petInfo->PetNumber))
        return false;

    PhasingHandler::InheritPhaseShift(this, owner);

    setPetType(petInfo->Type);
    SetFaction(owner->GetFaction());
    SetCreatedBySpell(petInfo->CreatedBySpellId);

    if (IsCritter())
    {
        float px, py, pz;
        owner->GetClosePoint(px, py, pz, GetCombatReach(), PET_FOLLOW_DIST, GetFollowAngle());
        Relocate(px, py, pz, owner->GetOrientation());

        if (!IsPositionValid())
        {
            TC_LOG_ERROR("entities.pet", "Pet{} not loaded. Suggested coordinates isn't valid (X: {} Y: {})",
                GetGUID().ToString(), GetPositionX(), GetPositionY());
            return false;
        }

        map->AddToMap(ToCreature());
        return true;
    }

    m_charmInfo->SetPetNumber(petInfo->PetNumber, IsPermanentPetFor(owner));

    SetDisplayId(petInfo->DisplayId, true);
    uint8 petlevel = petInfo->Level;
    ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
    ReplaceAllNpcFlags2(UNIT_NPC_FLAG_2_NONE);
    SetName(petInfo->Name);

    switch (getPetType())
    {
        case SUMMON_PET:
            petlevel = owner->GetLevel();
            ReplaceAllUnitFlags(UNIT_FLAG_PLAYER_CONTROLLED); // this enables popup window (pet dismiss, cancel)
            break;
        case HUNTER_PET:
            SetClass(CLASS_WARRIOR);
            SetGender(GENDER_NONE);
            SetSheath(SHEATH_STATE_MELEE);
            ReplaceAllPetFlags(petInfo->WasRenamed ? UNIT_PET_FLAG_CAN_BE_ABANDONED : (UNIT_PET_FLAG_CAN_BE_RENAMED | UNIT_PET_FLAG_CAN_BE_ABANDONED));
            ReplaceAllUnitFlags(UNIT_FLAG_PLAYER_CONTROLLED); // this enables popup window (pet abandon, cancel)
            break;
        default:
            if (!IsPetGhoul())
                TC_LOG_ERROR("entities.pet", "Pet have incorrect type ({}) for pet loading.", getPetType());
            break;
    }

    SetPetNameTimestamp(uint32(GameTime::GetGameTime()));
    SetCreatorGUID(owner->GetGUID());

    InitStatsForLevel(petlevel);
    SetPetExperience(petInfo->Experience);
    if (HasLoyalty())
        InitLoyalty(petInfo->LoyaltyLevel, petInfo->LoyaltyPoints, petInfo->LoyaltySeconds);

    SynchronizeLevelWithOwner();

    // Set pet's position after setting level, its size depends on it
    float px, py, pz;
    owner->GetClosePoint(px, py, pz, GetCombatReach(), PET_FOLLOW_DIST, GetFollowAngle());
    Relocate(px, py, pz, owner->GetOrientation());
    if (!IsPositionValid())
    {
        TC_LOG_ERROR("entities.pet", "Pet {} not loaded. Suggested coordinates isn't valid (X: {} Y: {})",
            GetGUID().ToString(), GetPositionX(), GetPositionY());
        return false;
    }

    SetReactState(petInfo->ReactState);
    SetCanModifyStats(true);

    if (getPetType() == SUMMON_PET && !current)              //all (?) summon pets come with full health when called, but not when they are current
        SetFullPower(POWER_MANA);
    else
    {
        uint32 savedhealth = petInfo->Health;
        uint32 savedmana = petInfo->Mana;
        // Classic 1.60: hunter pets have no mana; their curmana column keeps the happiness (pets saved before: content).
        // A dead pet gets it too: loaded without it (its corpse had gone, a relog, a mount or a teleport), Revive Pet brought
        // it back at 0 happiness, it lost loyalty every tick and a new pet ran away for good soon after (player report, 5 Nov).
        if (HasHappiness())
        {
            SetMaxPower(POWER_HAPPINESS, HAPPINESS_MAX);
            SetPower(POWER_HAPPINESS, savedmana ? std::min<int32>(savedmana, HAPPINESS_MAX) : HAPPINESS_MAX / 2);
        }

        if (!savedhealth && getPetType() == HUNTER_PET)
            setDeathState(JUST_DIED);
        else
        {
            SetHealth(savedhealth);
            if (!HasHappiness())
                SetPower(POWER_MANA, savedmana);
        }
    }

    // set current pet as current
    // 0-4=current
    // PET_SAVE_NOT_IN_SLOT(-1) = not stable slot (summoning))
    if (slot == PET_SAVE_NOT_IN_SLOT)
    {
        uint32 petInfoNumber = petInfo->PetNumber;
        if (petStable->CurrentPetIndex)
            owner->RemovePet(nullptr, PET_SAVE_NOT_IN_SLOT);

        auto unslottedPetItr = std::find_if(petStable->UnslottedPets.begin(), petStable->UnslottedPets.end(), [&](PetStable::PetInfo const& unslottedPet)
        {
            return unslottedPet.PetNumber == petInfoNumber;
        });
        ASSERT(!petStable->CurrentPetIndex);
        ASSERT(unslottedPetItr != petStable->UnslottedPets.end());

        petStable->SetCurrentUnslottedPetIndex(std::distance(petStable->UnslottedPets.begin(), unslottedPetItr));
    }
    else if (PET_SAVE_FIRST_ACTIVE_SLOT <= slot && slot <= PET_SAVE_LAST_ACTIVE_SLOT)
    {
        auto activePetItr = std::find_if(petStable->ActivePets.begin(), petStable->ActivePets.end(), [&](Optional<PetStable::PetInfo> const& pet)
        {
            return pet && pet->PetNumber == petInfo->PetNumber;
        });
        ASSERT(activePetItr != petStable->ActivePets.end());

        uint32 newPetIndex = std::distance(petStable->ActivePets.begin(), activePetItr);

        petStable->SetCurrentActivePetIndex(newPetIndex);
    }

    owner->SetMinion(this, true);

    if (!isTemporarySummon)
        m_charmInfo->LoadPetActionBar(petInfo->ActionBar);

    map->AddToMap(ToCreature());

    //set last used pet number (for use in BG's)
    if (owner->GetTypeId() == TYPEID_PLAYER && isControlled() && !isTemporarySummoned() && (getPetType() == SUMMON_PET || getPetType() == HUNTER_PET))
        owner->ToPlayer()->SetLastPetNumber(petInfo->PetNumber);

    owner->GetSession()->AddQueryHolderCallback(CharacterDatabase.DelayQueryHolder(std::make_shared<PetLoadQueryHolder>(ownerid, petInfo->PetNumber)))
        .AfterComplete([this, owner, session = owner->GetSession(), isTemporarySummon, current, lastSaveTime = petInfo->LastSaveTime, specializationId = petInfo->SpecializationId, savedHealth = petInfo->Health](SQLQueryHolderBase const& holder)
    {
        if (session->GetPlayer() != owner || owner->GetPet() != this)
            return;

        // passing previous checks ensure that 'this' is still valid
        if (m_removed)
            return;

        // damage or healing the pet took since it was added to the map, before this query came back (kept by the health restore below)
        int64 const healthChangeWhileLoading = int64(GetHealth()) - int64(std::min<uint64>(savedHealth, GetMaxHealth()));

        uint32 timediff = uint32(GameTime::GetGameTime() - lastSaveTime);
        _LoadAuras(holder.GetPreparedResult(PetLoadQueryHolder::AURAS), holder.GetPreparedResult(PetLoadQueryHolder::AURA_EFFECTS), timediff);

        // load action bar, if data broken will fill later by default spells.
        if (!isTemporarySummon)
        {
            _LoadSpells(holder.GetPreparedResult(PetLoadQueryHolder::SPELLS));
            GetSpellHistory()->LoadFromDB<Pet>(holder.GetPreparedResult(PetLoadQueryHolder::COOLDOWNS), holder.GetPreparedResult(PetLoadQueryHolder::CHARGES));
            LearnPetPassives();
            InitLevelupSpellsForLevel();
            // Classic 1.60: a beast tamed before it kept its wild abilities has none (auto attack only); give them now
            if (getPetType() == HUNTER_PET && !KnowsActiveSpell())
                LearnTameSpells();
            // and its attack speed passive, for a pet tamed before the beast had one or since it changed
            SyncTameAttackSpeed();
            if (GetMap()->IsBattleArena())
                RemoveArenaAuras();

            CastPetAuras(current);

            // The saved health was capped to the maximum without the auras (passives are not saved), and an aura that raises maximum
            // health (Hunter Pet Scaling, Warlock Pet Scaling, Great Stamina) heals its whole amount when applied: put back what the pet had
            // when it was saved, moved by what happened to it while loading. A demon summoned anew (not current) comes at full health.
            if ((getPetType() == HUNTER_PET || (getPetType() == SUMMON_PET && current)) && IsAlive() && savedHealth)
                SetHealth(uint64(std::clamp<int64>(int64(savedHealth) + healthChangeWhileLoading, 1, int64(GetMaxHealth()))));
        }

        TC_LOG_DEBUG("entities.pet", "New Pet has {}", GetGUID().ToString());

        uint16 specId = specializationId;
        if (ChrSpecializationEntry const* petSpec = sChrSpecializationStore.LookupEntry(specId))
            specId = sDB2Manager.GetChrSpecializationByIndex(owner->HasAuraType(SPELL_AURA_OVERRIDE_PET_SPECS) ? PET_SPEC_OVERRIDE_CLASS_INDEX : 0, petSpec->OrderIndex)->ID;

        SetSpecialization(specId);

        // The SetSpecialization function will run these functions if the pet's spec is not 0
        if (!GetSpecialization())
        {
            CleanupActionBar();                                     // remove unknown spells from action bar after load

            owner->PetSpellInitialize();
        }

        SetGroupUpdateFlag(GROUP_UPDATE_PET_FULL);

        TC_LOG_INFO("entities.pet", "Pet loaded for {}: number {} entry {} type {} level {} display {} scale {} spells {} specialization {}", owner->GetName(),
            GetCharmInfo() ? GetCharmInfo()->GetPetNumber() : 0, GetEntry(), uint32(getPetType()), uint32(GetLevel()), GetDisplayId(), GetObjectScale(),
            m_spells.size(), GetSpecialization());

        if (getPetType() == HUNTER_PET)
        {
            if (PreparedQueryResult result = holder.GetPreparedResult(PetLoadQueryHolder::DECLINED_NAMES))
            {
                m_declinedname = std::make_unique<DeclinedName>();
                Field* fields = result->Fetch();
                for (uint8 i = 0; i < MAX_DECLINED_NAME_CASES; ++i)
                    m_declinedname->name[i] = fields[i].GetString();
            }
        }

        if (owner->IsMounted())
            owner->DisablePetControlsOnMount(REACT_PASSIVE, COMMAND_FOLLOW);

        // must be after SetMinion (owner guid check)
        LoadTemplateImmunities(0);
        m_loading = false;
    });

    return true;
}

void Pet::SavePetToDB(PetSaveMode mode)
{
    if (!GetEntry())
        return;

    // save only fully controlled creature
    if (!isControlled())
        return;

    // not save not player pets
    if (!GetOwnerGUID().IsPlayer())
        return;

    Player* owner = GetOwner();

    // not save pet as current if another pet temporary unsummoned
    if (mode == PET_SAVE_AS_CURRENT && owner->GetTemporaryUnsummonedPetNumber() &&
        owner->GetTemporaryUnsummonedPetNumber() != m_charmInfo->GetPetNumber())
    {
        // pet will lost anyway at restore temporary unsummoned
        if (getPetType() == HUNTER_PET)
            return;

        // for warlock case
        mode = PET_SAVE_NOT_IN_SLOT;
    }

    uint32 curhealth = GetHealth();
    uint32 curmana = GetPower(HasHappiness() ? POWER_HAPPINESS : POWER_MANA);    // Classic 1.60: hunter pets save happiness

    CharacterDatabaseTransaction trans = CharacterDatabase.BeginTransaction();
    // save auras before possibly removing them
    _SaveAuras(trans);

    if (mode == PET_SAVE_AS_CURRENT)
        if (Optional<uint32> activeSlot = owner->GetPetStable()->GetCurrentActivePetIndex())
            mode = PetSaveMode(*activeSlot);

    // stable and not in slot saves
    if (mode < PET_SAVE_FIRST_ACTIVE_SLOT || mode >= PET_SAVE_LAST_ACTIVE_SLOT)
        RemoveAllAuras();

    _SaveSpells(trans);
    GetSpellHistory()->SaveToDB<Pet>(trans);
    CharacterDatabase.CommitTransaction(trans);

    // current/stable/not_in_slot
    if (mode != PET_SAVE_AS_DELETED)
    {
        ObjectGuid::LowType ownerLowGUID = GetOwnerGUID().GetCounter();
        trans = CharacterDatabase.BeginTransaction();
        // remove current data

        CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_CHAR_PET_BY_ID);
        stmt->setUInt32(0, m_charmInfo->GetPetNumber());
        trans->Append(stmt);

        // save pet
        std::string actionBar = GenerateActionBarData();

        ASSERT(owner->GetPetStable()->GetCurrentPet() && owner->GetPetStable()->GetCurrentPet()->PetNumber == m_charmInfo->GetPetNumber());
        FillPetInfo(owner->GetPetStable()->GetCurrentPet(), owner->GetTemporaryPetReactState());

        stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_PET);
        stmt->setUInt32(0, m_charmInfo->GetPetNumber());
        stmt->setUInt32(1, GetEntry());
        stmt->setUInt64(2, ownerLowGUID);
        stmt->setUInt32(3, GetNativeDisplayId());
        stmt->setUInt8(4, GetLevel());
        stmt->setUInt32(5, m_unitData->PetExperience);
        stmt->setUInt8(6, owner->GetTemporaryPetReactState().value_or(GetReactState()));
        stmt->setInt16(7, owner->GetPetStable()->GetCurrentActivePetIndex().value_or(PET_SAVE_NOT_IN_SLOT));
        stmt->setString(8, m_name);
        stmt->setUInt8(9, HasPetFlag(UNIT_PET_FLAG_CAN_BE_RENAMED) ? 0 : 1);
        stmt->setUInt32(10, curhealth);
        stmt->setUInt32(11, curmana);
        stmt->setString(12, actionBar);
        stmt->setUInt32(13, GameTime::GetGameTime());
        stmt->setUInt32(14, m_unitData->CreatedBySpell);
        stmt->setUInt8(15, getPetType());
        stmt->setUInt16(16, GetSpecialization());
        trans->Append(stmt);

        // Classic 1.60: hunter pet loyalty (sql/custom/characters 2026_10_12_20, loyalty_time 2026_11_13_81)
        if (HasLoyalty())
            trans->PAppend("REPLACE INTO character_pet_loyalty (id, loyalty, loyalty_points, loyalty_time) VALUES ({}, {}, {}, {})",
                m_charmInfo->GetPetNumber(), uint32(m_loyaltyLevel), m_loyaltyPoints, m_loyaltySeconds);

        CharacterDatabase.CommitTransaction(trans);
    }
    // delete
    else
    {
        RemoveAllAuras();
        DeleteFromDB(m_charmInfo->GetPetNumber());
    }
}

void Pet::FillPetInfo(PetStable::PetInfo* petInfo, Optional<ReactStates> forcedReactState /*= {}*/) const
{
    petInfo->PetNumber = m_charmInfo->GetPetNumber();
    petInfo->CreatureId = GetEntry();
    petInfo->DisplayId = GetNativeDisplayId();
    petInfo->Level = GetLevel();
    petInfo->Experience = m_unitData->PetExperience;
    petInfo->ReactState = forcedReactState.value_or(GetReactState());
    petInfo->Name = GetName();
    petInfo->WasRenamed = !HasPetFlag(UNIT_PET_FLAG_CAN_BE_RENAMED);
    petInfo->Health = GetHealth();
    petInfo->Mana = GetPower(HasHappiness() ? POWER_HAPPINESS : POWER_MANA);
    petInfo->ActionBar = GenerateActionBarData();
    petInfo->LastSaveTime = GameTime::GetGameTime();
    petInfo->CreatedBySpellId = m_unitData->CreatedBySpell;
    petInfo->Type = getPetType();
    petInfo->SpecializationId = GetSpecialization();
    petInfo->LoyaltyLevel = m_loyaltyLevel;
    petInfo->LoyaltyPoints = m_loyaltyPoints;
    petInfo->LoyaltySeconds = m_loyaltySeconds;
}

void Pet::DeleteFromDB(uint32 petNumber)
{
    CharacterDatabaseTransaction trans = CharacterDatabase.BeginTransaction();

    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_CHAR_PET_BY_ID);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_CHAR_PET_DECLINEDNAME);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_AURA_EFFECTS);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_AURAS);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_SPELLS);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_SPELL_COOLDOWNS);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_SPELL_CHARGES);
    stmt->setUInt32(0, petNumber);
    trans->Append(stmt);

    trans->PAppend("DELETE FROM character_pet_loyalty WHERE id = {}", petNumber);   // Classic 1.60 hunter pet loyalty

    CharacterDatabase.CommitTransaction(trans);
}

void Pet::setDeathState(DeathState s)                       // overwrite virtual Creature::setDeathState and Unit::setDeathState
{
    Creature::setDeathState(s);
    if (getDeathState() == CORPSE)
    {
        if (getPetType() == HUNTER_PET)
        {
            // pet corpse non lootable and non skinnable
            ReplaceAllDynamicFlags(UNIT_DYNFLAG_NONE);
            RemoveUnitFlag(UNIT_FLAG_SKINNABLE);

            //SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_STUNNED);
        }

        // Classic 1.60: a pet that dies outside PvP loses one whole happiness level
        // (VMaNGOS Pet::SetDeathState). Battlegrounds and arenas are exempt, and because loyalty only
        // reacts to the happiness *level* on its 12 s tick, an exempt death costs no loyalty either.
        // `IsInWorld()` keeps the penalty off the load path: LoadFromDB revives a pet that was saved
        // dead by going through JUST_DIED -> CORPSE, which is not a death that just happened.
        if (HasHappiness() && IsInWorld() && !GetMap()->IsBattlegroundOrArena())
            ModifyPower(POWER_HAPPINESS, -HAPPINESS_MAX / 3);
    }
    else if (getDeathState() == ALIVE)
    {
        //RemoveFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_STUNNED);
        CastPetAuras(true);
    }
}

void Pet::Update(uint32 diff)
{
    if (m_removed)                                           // pet already removed, just wait in remove queue, no updates
        return;

    if (m_loading)
        return;

    switch (m_deathState)
    {
        case CORPSE:
        {
            if (getPetType() != HUNTER_PET || m_corpseRemoveTime <= GameTime::GetGameTime())
            {
                Remove(PET_SAVE_NOT_IN_SLOT);               //hunters' pets never get removed because of death, NEVER!
                return;
            }
            break;
        }
        case ALIVE:
        {
            // unsummon pet that lost owner
            Player* owner = GetOwner();
            bool const outOfSight = !IsWithinDistInMap(owner, GetMap()->GetVisibilityRange()) && !isPossessed();
            if (outOfSight && isControlled() && owner->GetPetGUID() == GetGUID() && CatchUpWithOwner())
                break;
            // The owner went where the pet could not follow (a boat or zeppelin, a taxi, a teleport): the pet was dismissed for good and
            // a warlock found the Imp gone after the trip (player report, 3 Nov). Put it away like a mount-up does; it comes back once the
            // owner stands on the ground again.
            if (outOfSight && isControlled() && owner->GetPetGUID() == GetGUID() && ParkForOwnerTravel())
                return;
            if (outOfSight || (isControlled() && !owner->GetPetGUID()))
            //if (!owner || (!IsWithinDistInMap(owner, GetMap()->GetVisibilityDistance()) && (owner->GetCharmGUID() && (owner->GetCharmGUID() != GetGUID()))) || (isControlled() && !owner->GetPetGUID()))
            {
                TC_LOG_INFO("entities.pet", "Pet {} ({}) of {} dismissed: {}", GetName(), GetEntry(), owner->GetName(),
                    outOfSight ? "out of its owner's sight" : "owner has no pet");
                Remove(PET_SAVE_NOT_IN_SLOT, true);
                return;
            }

            if (isControlled())
            {
                if (owner->GetPetGUID() != GetGUID())
                {
                    // An owner points at one pet at a time; this one is not it. Remove() below puts it away cleanly, so log it rather
                    // than take the whole server down for a hunter pet (Karrz1/ForeverCore crashed here on 26 Nov after a change to
                    // how pets load; our load path does not do that, but any other way to strand a pet should not crash either).
                    TC_LOG_ERROR("entities.pet", "Pet {} ({}) of {} is not its owner's pet ({}), removed; {}", GetEntry(),
                        getPetType() == HUNTER_PET ? "hunter pet" : "summon", GetOwner()->GetName(), owner->GetPetGUID().ToString(),
                        owner->GetSession()->GetPlayerInfo());
                    Remove(PET_SAVE_NOT_IN_SLOT);
                    return;
                }
            }

            // Forever: a following pet left behind (e.g. Undercity elevator) catches up to its owner instead of getting stuck
            if (!isPossessed() && !IsInCombat() && GetCharmInfo() && GetCharmInfo()->HasCommandState(COMMAND_FOLLOW)
                && !GetTransport() && !owner->GetTransport() && !owner->IsInFlight() && !owner->IsFalling()
                && GetExactDist(owner) > 40.0f)
                NearTeleportTo(owner->GetPosition());

            if (m_duration > 0)
            {
                if (uint32(m_duration) > diff)
                    m_duration -= diff;
                else
                {
                    Remove(getPetType() != SUMMON_PET ? PET_SAVE_AS_DELETED : PET_SAVE_NOT_IN_SLOT);
                    return;
                }
            }

            // Classic 1.60: hunter pets slowly lose happiness, 1.5 times as fast in combat (VMaNGOS Pet::LooseHappiness)
            if (HasHappiness())
            {
                // A bot hunter has no client to feed its pet: the pet of a bot stays content.
                if (Player const* owner = GetOwner(); owner && owner->GetSession() && owner->GetSession()->IsBot())
                    SetPower(POWER_HAPPINESS, HAPPINESS_MAX);
                else if (m_happinessTimer > diff)
                    m_happinessTimer -= diff;
                else
                {
                    m_happinessTimer = HAPPINESS_LOSS_INTERVAL;
                    int32 loss = int32(HAPPINESS_LOSS * (IsInCombat() ? 1.5f : 1.0f) * sWorld->getRate(RATE_PET_HAPPINESS_DECAY));
                    ModifyPower(POWER_HAPPINESS, -loss);
                }
            }

            // Classic 1.60 (WoW Forever): loyalty counts the time the pet is out, alive (vanilla: points every 12 s by happiness, lost while
            // unhappy, and a Rebellious pet ran away; the Forever rule has no loss)
            if (HasLoyalty())
            {
                if (m_loyaltyTimer > diff)
                    m_loyaltyTimer -= diff;
                else
                {
                    m_loyaltyTimer = LOYALTY_TICK_INTERVAL;
                    AddLoyaltyProgress(0, LOYALTY_TICK_INTERVAL / IN_MILLISECONDS);
                }
            }

            //regenerate focus for hunter pets or energy for deathknight's ghoul
            if (m_focusRegenTimer)
            {
                if (m_focusRegenTimer > diff)
                    m_focusRegenTimer -= diff;
                else
                {
                    switch (GetPowerType())
                    {
                        case POWER_FOCUS:
                        {
                            // Classic 1.60: one tick a second, so a world update longer than that (lag) gets the ticks it covered, up to 5
                            uint32 const overdue = diff - m_focusRegenTimer;
                            uint32 const ticks = std::min<uint32>(1 + overdue / PET_FOCUS_REGEN_INTERVAL, 5);
                            for (uint32 i = 0; i < ticks; ++i)
                                Regenerate(POWER_FOCUS);
                            m_focusRegenTimer = PET_FOCUS_REGEN_INTERVAL - overdue % PET_FOCUS_REGEN_INTERVAL;
                            break;
                        }

                        // in creature::update
                        //case POWER_ENERGY:
                        //    Regenerate(POWER_ENERGY);
                        //    m_regenTimer += CREATURE_REGEN_INTERVAL - diff;
                        //    if (!m_regenTimer) ++m_regenTimer;
                        //    break;
                        default:
                            m_focusRegenTimer = 0;
                            break;
                    }
                }
            }
            break;
        }
        default:
            break;
    }
    Creature::Update(diff);
}

bool Pet::CatchUpWithOwner()
{
    Player* owner = GetOwner();
    if (!owner || !owner->IsInWorld() || !owner->IsAlive() || !IsInWorld() || !IsAlive() || m_removed || isPossessed())
        return false;
    if (owner->GetMap() != GetMap() || !InSamePhase(owner) || owner->GetTransport() != GetTransport())
        return false;
    if (owner->IsInFlight() || owner->IsBeingTeleported() || owner->IsPetNeedBeTemporaryUnsummoned())
        return false;
    if (GetCharmInfo() && GetCharmInfo()->HasStayCommand())
        return false;                                       // told to stay there: dismissed as before

    // A fight it was left at stays behind, or the pet would run straight back to it and drop out of sight again.
    CombatStop(true);
    StopMoving();
    float x, y, z;
    owner->GetClosePoint(x, y, z, GetCombatReach(), PET_FOLLOW_DIST, GetFollowAngle());
    NearTeleportTo(x, y, z, owner->GetOrientation());
    TC_LOG_INFO("entities.pet", "Pet {} ({}) of {} fell out of sight, set down next to its owner at ({:.0f},{:.0f},{:.0f})",
        GetName(), GetEntry(), owner->GetName(), x, y, z);
    return true;
}

bool Pet::ParkForOwnerTravel()
{
    Player* owner = GetOwner();
    if (!owner || !owner->IsInWorld() || !owner->IsAlive() || !IsInWorld() || !IsAlive() || m_removed || isPossessed() || isTemporarySummoned())
        return false;
    if (GetCharmInfo() && GetCharmInfo()->HasStayCommand())
        return false;                                       // told to stay there: dismissed as before
    if (owner->GetMap() != GetMap())
        return false;

    TC_LOG_INFO("entities.pet", "Pet {} ({}) of {} could not follow its owner (transport, flight or teleport), put away until the owner is back on the ground",
        GetName(), GetEntry(), owner->GetName());
    owner->ParkPetForTravel();
    return true;
}

void Pet::Remove(PetSaveMode mode, bool returnreagent)
{
    GetOwner()->RemovePet(this, mode, returnreagent);
}

void Pet::GivePetXP(uint32 xp)
{
    if (getPetType() != HUNTER_PET)
        return;

    if (xp < 1)
        return;

    if (!IsAlive())
        return;

    // Classic 1.60 (WoW Forever): the kill XP also counts toward the next loyalty rank, a pet at the hunter's level included
    if (HasLoyalty())
        AddLoyaltyProgress(xp, 0);

    uint8 maxlevel = std::min((uint8)sWorld->getIntConfig(CONFIG_MAX_PLAYER_LEVEL), GetOwner()->GetLevel());
    uint8 petlevel = GetLevel();

    // If pet is detected to be at, or above(?) the players level, don't hand out XP
    if (petlevel >= maxlevel)
       return;

    uint32 nextLvlXP = m_unitData->PetNextLevelExperience;
    uint32 curXP = m_unitData->PetExperience;
    uint32 newXP = curXP + xp;

    // Check how much XP the pet should receive, and hand off have any left from previous levelups
    while (newXP >= nextLvlXP && petlevel < maxlevel)
    {
        // Subtract newXP from amount needed for nextlevel, and give pet the level
        newXP -= nextLvlXP;
        ++petlevel;

        GivePetLevel(petlevel);

        nextLvlXP = m_unitData->PetNextLevelExperience;
    }
    // Not affected by special conditions - give it new XP
    SetPetExperience(petlevel < maxlevel ? newXP : 0);

}

// Classic 1.60 (WoW Forever): 20% of the hunter's XP for the level (Classic Hunter Lodge wiki, Pet-Fundamentals); vanilla was 5%
uint32 Pet::GetHunterPetNextLevelExperience(uint8 level)
{
    return HunterPetForever::NextLevelXp(sObjectMgr->GetXPForLevel(level));
}

void Pet::GivePetLevel(uint8 level)
{
    if (!level || level == GetLevel())
        return;

    if (getPetType() == HUNTER_PET)
    {
        SetPetExperience(0);
        SetPetNextLevelExperience(GetHunterPetNextLevelExperience(level));
    }

    InitStatsForLevel(level);
    InitLevelupSpellsForLevel();
}

bool Pet::CreateBaseAtCreature(Creature* creature)
{
    ASSERT(creature);

    if (!CreateBaseAtTamed(creature->GetCreatureTemplate(), creature->GetMap()))
        return false;

    Relocate(creature->GetPositionX(), creature->GetPositionY(), creature->GetPositionZ(), creature->GetOrientation());

    if (!IsPositionValid())
    {
        TC_LOG_ERROR("entities.pet", "Pet {} not created base at creature. Suggested coordinates isn't valid (X: {} Y: {})",
            GetGUID().ToString(), GetPositionX(), GetPositionY());
        return false;
    }

    CreatureTemplate const* cinfo = GetCreatureTemplate();
    if (!cinfo)
    {
        TC_LOG_ERROR("entities.pet", "CreateBaseAtCreature() failed, creatureInfo is missing!");
        return false;
    }

    SetDisplayId(creature->GetDisplayId());

    if (CreatureFamilyEntry const* cFamily = sCreatureFamilyStore.LookupEntry(cinfo->family))
    {
        WorldSession const* osess = GetOwner() ? GetOwner()->GetSession() : nullptr;
        LocaleConstant loc = osess ? osess->GetSessionDbcLocale() : DEFAULT_LOCALE;
        SetName(cFamily->Name[loc]);
    }
    else
        SetName(creature->GetNameForLocaleIdx(sObjectMgr->GetDBCLocaleIndex()));

    return true;
}

bool Pet::CreateBaseAtCreatureInfo(CreatureTemplate const* cinfo, Unit* owner)
{
    if (!CreateBaseAtTamed(cinfo, owner->GetMap()))
        return false;

    if (CreatureFamilyEntry const* cFamily = sCreatureFamilyStore.LookupEntry(cinfo->family))
        SetName(cFamily->Name[GetOwner()->GetSession()->GetSessionDbcLocale()]);

    Relocate(owner->GetPositionX(), owner->GetPositionY(), owner->GetPositionZ(), owner->GetOrientation());

    return true;
}

Pet::HappinessState Pet::GetHappinessState() const
{
    int32 happiness = GetPower(POWER_HAPPINESS);
    if (happiness < HAPPINESS_MAX / 3)
        return UNHAPPY;
    if (happiness >= 2 * HAPPINESS_MAX / 3)
        return HAPPY;
    return CONTENT;
}

float Pet::GetHappinessDamageMod() const
{
    if (!HasHappiness())
        return 1.0f;

    switch (GetHappinessState())
    {
        case UNHAPPY: return 0.75f;
        case HAPPY:   return 1.25f;
        default:      return 1.0f;
    }
}

int32 Pet::GetFoodBenefit(uint8 petLevel, uint32 foodLevel)
{
    if (petLevel <= foodLevel + 5)
        return 35000;
    if (petLevel <= foodLevel + 10)
        return 17000;
    if (petLevel <= foodLevel + 14)
        return 8000;
    return 0;
}

void Pet::InitLoyalty(uint8 loyaltyLevel, int32 loyaltyPoints, uint32 loyaltySeconds /*= 0*/)
{
    m_loyaltyLevel = std::clamp<uint8>(loyaltyLevel, REBELLIOUS, BEST_FRIEND);
    m_loyaltyPoints = std::max<int32>(loyaltyPoints, 0);
    m_loyaltySeconds = loyaltySeconds;
    m_loyaltyTimer = LOYALTY_TICK_INTERVAL;
}

// Classic 1.60 (WoW Forever, Classic Hunter Lodge wiki, Pet-Fundamentals): a loyalty rank needs 5% of the hunter's XP for the pet's level,
// earned since the last rank, and 0, 30, 45, 60 or 90 minutes out for ranks 2 to 6. Each rank adds the pet's level in training points.
void Pet::AddLoyaltyProgress(uint32 xp, uint32 seconds)
{
    if (!HasLoyalty() || m_loyaltyLevel >= BEST_FRIEND)
        return;

    // capped well above any requirement, so a long stay out cannot overflow the counters
    m_loyaltyPoints = int32(std::min<uint64>(uint64(m_loyaltyPoints) + xp, uint64(std::numeric_limits<int32>::max() / 2)));
    m_loyaltySeconds = uint32(std::min<uint64>(uint64(m_loyaltySeconds) + seconds, 24 * HOUR));

    if (!HunterPetForever::CanRankUp(m_loyaltyLevel, uint32(m_loyaltyPoints), m_loyaltySeconds, sObjectMgr->GetXPForLevel(GetLevel())))
        return;

    ++m_loyaltyLevel;
    m_loyaltyPoints = 0;
    m_loyaltySeconds = 0;
    UpdateTrainingPoints();

    TC_LOG_DEBUG("entities.pet", "Pet {} ({}) reached loyalty level {}", GetName(), GetGUID().ToString(), uint32(m_loyaltyLevel));

    // the client reads loyalty only from the stable pet values
    if (Player* owner = GetOwner())
        owner->UpdateStablePetLoyalty(m_charmInfo->GetPetNumber(), m_loyaltyLevel, m_loyaltyPoints, m_loyaltySeconds);
}

uint32 Pet::GetSpellTrainingPoints(uint32 spellId)
{
    static std::unordered_map<uint32, uint32> const costs = []
    {
        std::unordered_map<uint32, uint32> result;
        if (QueryResult query = WorldDatabase.Query("SELECT SpellId, Points FROM classic_pet_spell_training_points"))
        {
            do
            {
                Field* fields = query->Fetch();
                result[fields[0].GetUInt32()] = fields[1].GetUInt16();
            } while (query->NextRow());
        }
        TC_LOG_INFO("server.loading", ">> Loaded {} Classic pet spell training point costs", result.size());
        return result;
    }();

    auto itr = costs.find(spellId);
    return itr != costs.end() ? itr->second : 0;
}

uint32 Pet::GetTrainingPointsTotal() const
{
    // vanilla: (loyalty level - 1) per pet level, i.e. every pet level gives loyalty - 1 and every loyalty level gives the pet level
    return GetLevel() * (m_loyaltyLevel - 1);
}

uint32 Pet::GetTrainingPointsUsed() const
{
    // a rank costs its full price minus what the lower rank cost, so a chain costs the price of its highest known rank
    std::unordered_map<uint32, uint32> chainCost;
    for (auto const& [spellId, petSpell] : m_spells)
    {
        if (petSpell.state == PETSPELL_REMOVED)
            continue;

        if (uint32 points = GetSpellTrainingPoints(spellId))
        {
            uint32& cost = chainCost[sSpellMgr->GetFirstSpellInChain(spellId)];
            cost = std::max(cost, points);
        }
    }

    uint32 used = 0;
    for (auto const& [chain, cost] : chainCost)
        used += cost;
    return used;
}

void Pet::UpdateTrainingPoints()
{
    if (!HasLoyalty())
        return;

    auto unitData = m_values.ModifyValue(&Unit::m_unitData);
    SetUpdateFieldValue(unitData.ModifyValue(&UF::UnitData::ClassicTrainingPointsUsed), uint16(std::min<uint32>(GetTrainingPointsUsed(), 0xFFFF)));
    SetUpdateFieldValue(unitData.ModifyValue(&UF::UnitData::ClassicTrainingPointsTotal), uint16(std::min<uint32>(GetTrainingPointsTotal(), 0xFFFF)));
}

uint32 Pet::GetTrainerTaughtPetSpell(uint32 trainerSpellId)
{
    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(trainerSpellId, DIFFICULTY_NONE);
    if (!spellInfo)
        return 0;

    for (SpellEffectInfo const& effect : spellInfo->GetEffects())
        if (effect.IsEffect(SPELL_EFFECT_LEARN_SPELL) && effect.TriggerSpell && effect.TargetA.GetTarget() == TARGET_UNIT_PET)
            return effect.TriggerSpell;
    return 0;
}

bool Pet::IsTrainerTaughtPetSpell(uint32 petSpellId)
{
    static std::unordered_set<uint32> const taught = []
    {
        std::unordered_set<uint32> result;
        sSpellMgr->ForEachSpellInfo([&](SpellInfo const* spellInfo)
        {
            if (uint32 petSpell = GetTrainerTaughtPetSpell(spellInfo->Id))
                result.insert(petSpell);
        });
        return result;
    }();
    return taught.contains(petSpellId);
}

// "I wish to untrain my pet." on the pet trainer menus: GossipOptionID 96000000 + MenuID (sql/custom/world 2026_10_28_20)
bool Pet::IsPetUntrainGossipOption(int32 gossipOptionId)
{
    return gossipOptionId >= 96000000 && gossipOptionId < 97000000;
}

bool Pet::KnowsSpellOrHigherRank(uint32 spellId) const
{
    if (HasSpell(spellId))
        return true;

    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE);
    if (!spellInfo || !spellInfo->IsRanked())
        return false;

    for (auto const& [knownId, petSpell] : m_spells)
    {
        if (petSpell.state == PETSPELL_REMOVED)
            continue;
        if (SpellInfo const* known = sSpellMgr->GetSpellInfo(knownId, DIFFICULTY_NONE))
            if (known->IsDifferentRankOf(spellInfo) && known->IsHighRankOf(spellInfo))
                return true;
    }
    return false;
}

uint32 Pet::UntrainTrainerSpells()
{
    std::vector<uint32> spells;
    for (auto const& [spellId, petSpell] : m_spells)
        if (petSpell.state != PETSPELL_REMOVED && IsTrainerTaughtPetSpell(spellId))
            spells.push_back(spellId);

    if (spells.empty())
        return 0;

    unlearnSpells(spells, false, true);
    InitLevelupSpellsForLevel();                            // gives back the family spells its level grants (Growl) if a trained rank replaced them
    if (Player* owner = GetOwner())
        owner->PetSpellInitialize();
    return uint32(spells.size());
}

std::vector<uint32> const* Pet::GetTameSpells(uint32 creatureEntry)
{
    static std::unordered_map<uint32, std::vector<uint32>> const spells = []
    {
        std::unordered_map<uint32, std::vector<uint32>> result;
        if (QueryResult query = WorldDatabase.Query("SELECT CreatureEntry, SpellId FROM classic_pet_tame_spell ORDER BY CreatureEntry, SpellId"))
        {
            do
            {
                Field* fields = query->Fetch();
                uint32 spellId = fields[1].GetUInt32();
                if (!sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE))
                {
                    TC_LOG_ERROR("sql.sql", "Table `classic_pet_tame_spell` has unknown spell {} for creature {}, skipped.", spellId, fields[0].GetUInt32());
                    continue;
                }
                result[fields[0].GetUInt32()].push_back(spellId);
            } while (query->NextRow());
        }
        TC_LOG_INFO("server.loading", ">> Loaded the abilities of {} Classic tameable beasts", result.size());
        return result;
    }();

    auto itr = spells.find(creatureEntry);
    return itr != spells.end() ? &itr->second : nullptr;
}

uint32 Pet::GetBeastTrainingTeachSpell(uint32 petSpellId)
{
    // the hunter's Beast Training ranks (skill line 261, e.g. 17254 Bite Rank 1) each have a Learn Spell effect on the pet
    static constexpr uint32 SKILL_LINE_BEAST_TRAINING = 261;
    static std::unordered_map<uint32, uint32> const teachSpells = []
    {
        std::unordered_map<uint32, uint32> result;
        sSpellMgr->ForEachSpellInfo([&](SpellInfo const* spellInfo)
        {
            if (spellInfo->Difficulty != DIFFICULTY_NONE)
                return;
            if (uint32 petSpell = GetTrainerTaughtPetSpell(spellInfo->Id))
                if (IsPartOfSkillLine(SKILL_LINE_BEAST_TRAINING, spellInfo->Id))
                    result.emplace(petSpell, spellInfo->Id);
        });
        return result;
    }();

    auto itr = teachSpells.find(petSpellId);
    return itr != teachSpells.end() ? itr->second : 0;
}

void Pet::LearnTameSpells()
{
    if (getPetType() != HUNTER_PET)
        return;

    std::vector<uint32> const* spells = GetTameSpells(GetEntry());
    if (!spells)
        return;

    for (uint32 spellId : *spells)
        if (!KnowsSpellOrHigherRank(spellId))
            learnSpell(spellId);                            // replaces a lower rank of it
}

void Pet::SyncTameAttackSpeed()
{
    if (getPetType() != HUNTER_PET)
        return;

    uint32 ownPassive = 0;
    if (std::vector<uint32> const* spells = GetTameSpells(GetEntry()))
        for (uint32 spellId : *spells)
            if (HunterPetForever::IsAttackSpeedPassive(spellId))
                ownPassive = spellId;

    // one speed at a time: a passive that is not this beast's own goes (the beast's row changed, or it never had one)
    for (uint32 spellId : HunterPetForever::AttackSpeedPassives)
        if (spellId != ownPassive && HasSpell(spellId))
            unlearnSpell(spellId, false, false);

    if (ownPassive && !HasSpell(ownPassive))
        learnSpell(ownPassive);
}

int32 Pet::GetAttackSpeedPassivePercent() const
{
    for (uint32 spellId : HunterPetForever::AttackSpeedPassives)
    {
        if (!HasSpell(spellId))
            continue;

        if (SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE))
            for (SpellEffectInfo const& effect : spellInfo->GetEffects())
                if (effect.IsAura(SPELL_AURA_MOD_ATTACKSPEED))
                    return effect.CalcValueAsInt(this);
    }
    return 0;
}

bool Pet::KnowsActiveSpell() const
{
    for (auto const& [spellId, petSpell] : m_spells)
    {
        if (petSpell.state == PETSPELL_REMOVED)
            continue;
        if (SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE))
            if (!spellInfo->IsPassive())
                return true;
    }
    return false;
}

void Pet::CheckLearning(uint32 spellId)
{
    if (getPetType() != HUNTER_PET)
        return;

    Player* owner = GetOwner();
    if (!owner)
        return;

    // only what the beast knew in the wild teaches its hunter; ranks the hunter taught it are known already
    std::vector<uint32> const* tameSpells = GetTameSpells(GetEntry());
    if (!tameSpells || std::find(tameSpells->begin(), tameSpells->end(), spellId) == tameSpells->end())
        return;

    uint32 teachSpell = GetBeastTrainingTeachSpell(spellId);
    if (!teachSpell || owner->HasSpell(teachSpell))
        return;

    if (!roll_chance(10))
        return;

    owner->LearnSpell(teachSpell, false);
    TC_LOG_DEBUG("entities.pet", "Pet::CheckLearning: {} learned Beast Training spell {} from its pet {} (entry {}) using spell {}",
        owner->GetName(), teachSpell, GetGUID().ToString(), GetEntry(), spellId);
}

bool Pet::CreateBaseAtTamed(CreatureTemplate const* cinfo, Map* map)
{
    TC_LOG_DEBUG("entities.pet", "Pet::CreateBaseForTamed");
    if (!Create(map->GenerateLowGuid<HighGuid::Pet>(), map, cinfo->Entry, sObjectMgr->GeneratePetNumber()))
        return false;

    SetPetNameTimestamp(0);
    SetPetExperience(0);
    SetPetNextLevelExperience(GetHunterPetNextLevelExperience(GetLevel() + 1));
    ReplaceAllNpcFlags(UNIT_NPC_FLAG_NONE);
    ReplaceAllNpcFlags2(UNIT_NPC_FLAG_2_NONE);

    if (cinfo->type == CREATURE_TYPE_BEAST)
    {
        SetClass(CLASS_WARRIOR);
        SetGender(GENDER_NONE);
        SetPowerType(POWER_FOCUS);
        SetSheath(SHEATH_STATE_MELEE);
        ReplaceAllPetFlags(UNIT_PET_FLAG_CAN_BE_RENAMED | UNIT_PET_FLAG_CAN_BE_ABANDONED);
        // Classic 1.60: a freshly tamed beast is Rebellious
        InitLoyalty(REBELLIOUS, 0, 0);
    }

    return true;
}

void Pet::SendNewlyTamed(bool playPingFx /*= true*/) const
{
    WorldPackets::Pet::PetNewlyTamed petNewlyTamed;
    petNewlyTamed.UnitGUID = GetGUID();
    petNewlyTamed.PlayPingFX = playPingFx;
    SendMessageToSet(petNewlyTamed.Write(), true);
}

/// @todo Move stat mods code to pet passive auras
bool Guardian::InitStatsForLevel(uint8 petlevel)
{
    CreatureTemplate const* cinfo = GetCreatureTemplate();
    ASSERT(cinfo);

    SetLevel(petlevel);

    //Determine pet type
    PetType petType = MAX_PET_TYPE;
    if (IsPet() && GetOwner()->GetTypeId() == TYPEID_PLAYER)
    {
        if (GetOwner()->GetClass() == CLASS_WARLOCK
            || GetOwner()->GetClass() == CLASS_SHAMAN        // Fire Elemental
            || GetOwner()->GetClass() == CLASS_DEATH_KNIGHT) // Risen Ghoul
        {
            petType = SUMMON_PET;
        }
        else if (GetOwner()->GetClass() == CLASS_HUNTER)
        {
            petType = HUNTER_PET;
            m_unitTypeMask |= UNIT_MASK_HUNTER_PET;
        }
        else
        {
            TC_LOG_ERROR("entities.pet", "Unknown type pet {} is summoned by player class {}",
                           GetEntry(), GetOwner()->GetClass());
        }
    }

    uint32 creature_ID = (petType == HUNTER_PET) ? 1 : cinfo->Entry;

    SetMeleeDamageSchool(SpellSchools(cinfo->dmgschool));

    SetStatFlatModifier(UNIT_MOD_ARMOR, BASE_VALUE, float(petlevel * 50));

    // Classic 1.60 (WoW Forever): every hunter pet swings once in 2.0 sec, whatever the beast did in the wild, and a faster or
    // slower beast knows a Faster Attack or Slower Attack passive that changes it (classic_pet_tame_spell, SyncTameAttackSpeed).
    // Other pets keep their creature's attack speed; retail forced 2.0 sec on all of them.
    uint32 attackTime = cinfo->BaseAttackTime ? cinfo->BaseAttackTime : BASE_ATTACK_TIME;
    if (petType == HUNTER_PET)
        attackTime = HunterPetForever::BaseAttackTimeMs;
    SetBaseAttackTime(BASE_ATTACK, attackTime);
    SetBaseAttackTime(OFF_ATTACK, attackTime);
    SetBaseAttackTime(RANGED_ATTACK, cinfo->RangeAttackTime ? cinfo->RangeAttackTime : BASE_ATTACK_TIME);

    //scale
    SetObjectScale(GetNativeObjectScale());

    // Resistance
    // Hunters pet should not inherit resistances from creature_template, they have separate auras for that
    if (!IsHunterPet())
        for (uint8 i = SPELL_SCHOOL_HOLY; i < MAX_SPELL_SCHOOL; ++i)
            SetStatFlatModifier(UnitMods(UNIT_MOD_RESISTANCE_START + i), BASE_VALUE, float(cinfo->resistance[i]));

    Powers powerType = CalculateDisplayPowerType();

    // Health, Mana or Power, Armor
    PetLevelInfo const* pInfo = sObjectMgr->GetPetLevelInfo(creature_ID, petlevel);
    if (pInfo)                                      // exist in DB
    {
        SetCreateHealth(pInfo->health);
        SetCreateMana(pInfo->mana);

        SetStatPctModifier(UnitMods(UNIT_MOD_POWER_START + AsUnderlyingType(powerType)), BASE_PCT, 1.0f);

        if (pInfo->armor > 0)
            SetStatFlatModifier(UNIT_MOD_ARMOR, BASE_VALUE, float(pInfo->armor));

        for (uint8 stat = 0; stat < MAX_STATS; ++stat)
            SetCreateStat(Stats(stat), float(pInfo->stats[stat]));
    }
    else                                            // not exist in DB, use some default fake data
    {
        // remove elite bonuses included in DB values
        CreatureBaseStats const* stats = sObjectMgr->GetCreatureBaseStats(petlevel, cinfo->unit_class);
        if (!m_Properties) // pet loaded from DB
            ApplyLevelScaling(GetOwner()->m_unitData->ContentTuningID, GetOwner()->m_unitData->ScalingLevelDelta);

        CreatureDifficulty const* creatureDifficulty = GetCreatureDifficulty();
        SetCreateHealth(std::max(sDB2Manager.EvaluateExpectedStat(ExpectedStatType::CreatureHealth, petlevel, creatureDifficulty->GetHealthScalingExpansion(), m_unitData->ContentTuningID, Classes(cinfo->unit_class), 0) * creatureDifficulty->HealthModifier * GetHealthMod(cinfo->Classification), 1.0f));
        SetCreateMana(stats->BaseMana);
        SetCreateStat(STAT_STRENGTH, 22);
        SetCreateStat(STAT_AGILITY, 22);
        SetCreateStat(STAT_STAMINA, 25);
        SetCreateStat(STAT_INTELLECT, 28);
    }

    // Power
    SetPowerType(powerType, true, true);

    // Damage
    SetBonusDamage(0);
    switch (petType)
    {
        case SUMMON_PET:
        {
            // No bonus damage here: the warlock's share reaches a demon through 416189 Warlock Pet Scaling (classic_warlock_pet_scaling.cpp)
            float minDamage = float(petlevel - (petlevel / 4));
            float maxDamage = float(petlevel + (petlevel / 4));

            // WoW Forever: the Sayaad's and Voidwalker's weapons are shares of the creature dps for their level (wowsims/forever EV-0075,
            // EV-0076). The Voidwalker's melee is then halved in Guardian::UpdateDamagePhysical.
            if (WarlockPetForever::SwingModel const* swing = WarlockPetForever::DemonSwing(GetEntry()))
            {
                float const creatureDps = sDB2Manager.EvaluateExpectedStat(ExpectedStatType::CreatureAutoAttackDps, petlevel, -2, 0, CLASS_NONE, 0);
                minDamage = WarlockPetForever::MinDamage(*swing, creatureDps);
                maxDamage = WarlockPetForever::MaxDamage(*swing, creatureDps);
            }

            SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, minDamage);
            SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, maxDamage);

            //SetStatFlatModifier(UNIT_MOD_ATTACK_POWER, BASE_VALUE, float(cinfo->attackpower));
            break;
        }
        case HUNTER_PET:
        {
            ToPet()->SetPetNextLevelExperience(Pet::GetHunterPetNextLevelExperience(petlevel));
            // Classic 1.60 (WoW Forever): the swing is the creature auto attack dps of the pet's level less the pet's own attack power,
            // over 2.0 s, 20% either side (HunterPetForever::SwingAverage, EV-0071); attack power adds on top. Retail TrinityCore used
            // level -/+ level / 4.
            float const creatureDps = sDB2Manager.EvaluateExpectedStat(ExpectedStatType::CreatureAutoAttackDps, petlevel, -2, 0, CLASS_NONE, 0);
            SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, HunterPetForever::SwingMin(creatureDps));
            SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, HunterPetForever::SwingMax(creatureDps));
            break;
        }
        default:
        {
            switch (GetEntry())
            {
                case 510: // mage Water Elemental
                {
                    SetBonusDamage(int32(GetOwner()->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_FROST) * 0.33f));
                    break;
                }
                case 1964: //force of nature
                {
                    if (!pInfo)
                        SetCreateHealth(30 + 30*petlevel);
                    float bonusDmg = GetOwner()->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_NATURE) * 0.15f;
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float(petlevel * 2.5f - (petlevel / 2) + bonusDmg));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float(petlevel * 2.5f + (petlevel / 2) + bonusDmg));
                    break;
                }
                case 15352: //earth elemental 36213
                {
                    if (!pInfo)
                        SetCreateHealth(100 + 120*petlevel);
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float(petlevel - (petlevel / 4)));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float(petlevel + (petlevel / 4)));
                    break;
                }
                case 15438: //fire elemental
                {
                    if (!pInfo)
                    {
                        SetCreateHealth(40*petlevel);
                        SetCreateMana(28 + 10*petlevel);
                    }
                    SetBonusDamage(int32(GetOwner()->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_FIRE) * 0.5f));
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float(petlevel * 4 - petlevel));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float(petlevel * 4 + petlevel));
                    break;
                }
                case 19668: // Shadowfiend
                {
                    if (!pInfo)
                    {
                        SetCreateMana(28 + 10*petlevel);
                        SetCreateHealth(28 + 30*petlevel);
                    }
                    int32 bonus_dmg = int32(GetOwner()->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_SHADOW)* 0.3f);
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float((petlevel * 4 - petlevel) + bonus_dmg));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float((petlevel * 4 + petlevel) + bonus_dmg));

                    break;
                }
                case 19833: //Snake Trap - Venomous Snake
                {
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float((petlevel / 2) - 25));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float((petlevel / 2) - 18));
                    break;
                }
                case 19921: //Snake Trap - Viper
                {
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float(petlevel / 2 - 10));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float(petlevel / 2));
                    break;
                }
                case 29264: // Feral Spirit
                {
                    if (!pInfo)
                        SetCreateHealth(30*petlevel);

                    // wolf attack speed is 1.5s
                    SetBaseAttackTime(BASE_ATTACK, cinfo->BaseAttackTime);

                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float((petlevel * 4 - petlevel)));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float((petlevel * 4 + petlevel)));

                    SetStatFlatModifier(UNIT_MOD_ARMOR, BASE_VALUE, float(GetOwner()->GetArmor()) * 0.35f);  // Bonus Armor (35% of player armor)
                    SetStatFlatModifier(UNIT_MOD_STAT_STAMINA, BASE_VALUE, float(GetOwner()->GetStat(STAT_STAMINA)) * 0.3f);  // Bonus Stamina (30% of player stamina)
                    if (!HasAura(58877))//prevent apply twice for the 2 wolves
                        AddAura(58877, this);//Spirit Hunt, passive, Spirit Wolves' attacks heal them and their master for 150% of damage done.
                    break;
                }
                case 31216: // Mirror Image
                {
                    SetBonusDamage(int32(GetOwner()->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_FROST) * 0.33f));
                    SetDisplayId(GetOwner()->GetDisplayId());
                    if (!pInfo)
                    {
                        SetCreateMana(28 + 30*petlevel);
                        SetCreateHealth(28 + 10*petlevel);
                    }
                    break;
                }
                case 27829: // Ebon Gargoyle
                {
                    if (!pInfo)
                    {
                        SetCreateMana(28 + 10*petlevel);
                        SetCreateHealth(28 + 30*petlevel);
                    }
                    SetBonusDamage(int32(GetOwner()->GetTotalAttackPowerValue(BASE_ATTACK) * 0.5f));
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float(petlevel - (petlevel / 4)));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float(petlevel + (petlevel / 4)));
                    break;
                }
                case 28017: // Bloodworms
                {
                    SetCreateHealth(4 * petlevel);
                    SetBonusDamage(int32(GetOwner()->GetTotalAttackPowerValue(BASE_ATTACK) * 0.006f));
                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, float(petlevel - 30 - (petlevel / 4)));
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, float(petlevel - 30 + (petlevel / 4)));
                    break;
                }
                default:
                {
                    /* ToDo: Check what 5f5d2028 broke/fixed and how much of Creature::UpdateLevelDependantStats()
                     * should be copied here (or moved to another method or if that function should be called here
                     * or not just for this default case)
                     */
                    float basedamage = GetBaseDamageForLevel(petlevel);

                    float weaponBaseMinDamage = basedamage;
                    float weaponBaseMaxDamage = basedamage * 1.5f;

                    SetBaseWeaponDamage(BASE_ATTACK, MINDAMAGE, weaponBaseMinDamage);
                    SetBaseWeaponDamage(BASE_ATTACK, MAXDAMAGE, weaponBaseMaxDamage);
                    break;
                }
            }
            break;
        }
    }

    // Classic 1.60 (vanilla): a creature's own pet or guardian has the stats of a vanilla creature of its level, class level stats times its own
    // multipliers (VMaNGOS Pet::InitStatsForLevel), not the client's damage per second up to 1.5 times over; health, mana and armor of a
    // pet_levelstats row win. Its health is the create health alone (no flat health left from the level it was created at).
    if (!IsPet() && !GetOwner()->IsCharmedOwnedByPlayerOrPlayer() && sObjectMgr->GetCreatureClassicStats(cinfo->Entry)
        && sObjectMgr->GetCreatureClassicClassLevelStats(petlevel, cinfo->unit_class))
    {
        UpdateLevelDependantStats();
        SetStatFlatModifier(UNIT_MOD_HEALTH, BASE_VALUE, 0.0f);
        if (pInfo)
        {
            SetCreateHealth(std::max(1u, uint32(pInfo->health * GetHealthMod(cinfo->Classification))));
            SetCreateMana(pInfo->mana);
            if (pInfo->armor > 0)
                SetStatFlatModifier(UNIT_MOD_ARMOR, BASE_VALUE, float(pInfo->armor));
        }
    }

    // 猎人 / 术士宠物：继承主人基础属性、攻强和法强，血量 x1.5，仇恨 x5
    if (Player* owner = GetOwner() ? GetOwner()->ToPlayer() : nullptr)
    {
        if (owner->GetClass() == CLASS_HUNTER || owner->GetClass() == CLASS_WARLOCK)
        {
            for (uint8 stat = 0; stat < MAX_STATS; ++stat)
                SetStatFlatModifier(UnitMods(UNIT_MOD_STAT_STRENGTH + stat), BASE_VALUE,
                    owner->GetCreateStat(Stats(stat)));

            SetBonusDamage(owner->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_MAGIC));

            SetCreateHealth(uint32(GetCreateHealth() * 1.5f));
            GetThreatManager().SetGeneratedThreatMultiplier(5.0f);
        }
    }

    UpdateAllStats();

    SetFullHealth();
    SetFullPower(POWER_MANA);
    return true;
}

bool Pet::HaveInDiet(ItemTemplate const* item) const
{
    if (!item->FoodType || item->FoodType > 32)   // one bit of CreatureFamily.PetFoodMask per type
        return false;

    CreatureTemplate const* cInfo = GetCreatureTemplate();
    if (!cInfo)
        return false;

    CreatureFamilyEntry const* cFamily = sCreatureFamilyStore.LookupEntry(cInfo->family);
    if (!cFamily)
        return false;

    return HunterPetForever::EatsFoodType(uint32(cFamily->PetFoodMask), item->FoodType);
}

void Pet::_LoadSpells(PreparedQueryResult result)
{
    if (result)
    {
        do
        {
            Field* fields = result->Fetch();

            addSpell(fields[0].GetUInt32(), ActiveStates(fields[1].GetUInt8()), PETSPELL_UNCHANGED);
        }
        while (result->NextRow());
    }
}

void Pet::_SaveSpells(CharacterDatabaseTransaction trans)
{
    for (PetSpellMap::iterator itr = m_spells.begin(), next = m_spells.begin(); itr != m_spells.end(); itr = next)
    {
        ++next;

        // prevent saving family passives to DB
        if (itr->second.type == PETSPELL_FAMILY)
            continue;

        CharacterDatabasePreparedStatement* stmt;

        switch (itr->second.state)
        {
            case PETSPELL_REMOVED:
                stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_SPELL_BY_SPELL);
                stmt->setUInt32(0, m_charmInfo->GetPetNumber());
                stmt->setUInt32(1, itr->first);
                trans->Append(stmt);

                m_spells.erase(itr);
                continue;
            case PETSPELL_CHANGED:
                stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_SPELL_BY_SPELL);
                stmt->setUInt32(0, m_charmInfo->GetPetNumber());
                stmt->setUInt32(1, itr->first);
                trans->Append(stmt);

                stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_PET_SPELL);
                stmt->setUInt32(0, m_charmInfo->GetPetNumber());
                stmt->setUInt32(1, itr->first);
                stmt->setUInt8(2, itr->second.active);
                trans->Append(stmt);

                break;
            case PETSPELL_NEW:
                stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_PET_SPELL);
                stmt->setUInt32(0, m_charmInfo->GetPetNumber());
                stmt->setUInt32(1, itr->first);
                stmt->setUInt8(2, itr->second.active);
                trans->Append(stmt);
                break;
            case PETSPELL_UNCHANGED:
                continue;
        }
        itr->second.state = PETSPELL_UNCHANGED;
    }
}

void Pet::_LoadAuras(PreparedQueryResult auraResult, PreparedQueryResult effectResult, uint32 timediff)
{
    TC_LOG_DEBUG("entities.pet", "Loading auras for pet {}", GetGUID().ToString());

    ObjectGuid casterGuid, itemGuid;
    std::map<AuraKey, AuraLoadEffectInfo> effectInfo;

    /*
                    0      1           2            3       4           5
    SELECT casterGuid, spell, effectMask, effectIndex, amount, baseAmount FROM pet_aura_effect WHERE guid = ?
    */
    if (effectResult)
    {
        do
        {
            Field* fields = effectResult->Fetch();
            uint32 effectIndex = fields[3].GetUInt8();
            if (effectIndex < MAX_SPELL_EFFECTS)
            {
                std::span<uint8 const> rawGuidBytes = fields[0].GetBinaryView();
                if (rawGuidBytes.size() != ObjectGuid::BytesSize)
                    continue;

                casterGuid.SetRawValue(rawGuidBytes);
                if (casterGuid.IsEmpty())
                    casterGuid = GetGUID();

                AuraKey key{ casterGuid, itemGuid, fields[1].GetUInt32(), fields[2].GetUInt32() };
                AuraLoadEffectInfo& info = effectInfo[key];
                info.Amounts[effectIndex] = fields[4].GetDouble();
                info.BaseAmounts[effectIndex] = fields[5].GetDouble();
            }
        } while (effectResult->NextRow());
    }

    /*
                    0      1           2                3           4           5            6           7              8
    SELECT casterGuid, spell, effectMask, recalculateMask, difficulty, stackCount, maxDuration, remainTime, remainCharges,
                          9            10            11            12            13
           dstLocationMapId, dstLocationX, dstLocationY, dstLocationZ, dstLocationO FROM pet_aura WHERE guid = ?
    */
    if (auraResult)
    {
        do
        {
            Field* fields = auraResult->Fetch();
            // NULL guid stored - pet is the caster of the spell - see Pet::_SaveAuras
            std::span<uint8 const> rawGuidBytes = fields[0].GetBinaryView();
            if (rawGuidBytes.size() != ObjectGuid::BytesSize)
                continue;

            casterGuid.SetRawValue(rawGuidBytes);
            if (casterGuid.IsEmpty())
                casterGuid = GetGUID();

            AuraKey key{ casterGuid, itemGuid, fields[1].GetUInt32(), fields[2].GetUInt32() };
            uint32 recalculateMask = fields[3].GetUInt32();
            Difficulty difficulty = Difficulty(fields[4].GetUInt8());
            uint8 stackCount = fields[5].GetUInt8();
            int32 maxDuration = fields[6].GetInt32();
            int32 remainTime = fields[7].GetInt32();
            uint8 remainCharges = fields[8].GetUInt8();
            WorldLocation dst(fields[9].GetInt32(), fields[10].GetFloat(), fields[11].GetFloat(), fields[12].GetFloat(), fields[13].GetFloat());

            SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(key.SpellId, difficulty);
            if (!spellInfo)
            {
                TC_LOG_ERROR("entities.pet", "Pet::_LoadAuras: Unknown aura (spellid {}), ignore.", key.SpellId);
                continue;
            }

            if (difficulty != DIFFICULTY_NONE && !sDifficultyStore.LookupEntry(difficulty))
            {
                TC_LOG_ERROR("entities.pet", "Pet::_LoadAuras: Unknown difficulty {} (spellid {}), ignore.", uint32(difficulty), key.SpellId);
                continue;
            }

            // negative effects should continue counting down after logout
            if (remainTime != -1 && (!spellInfo->IsPositive() || spellInfo->HasAttribute(SPELL_ATTR4_AURA_EXPIRES_OFFLINE)))
            {
                if (remainTime/IN_MILLISECONDS <= int32(timediff))
                    continue;

                remainTime -= timediff*IN_MILLISECONDS;
            }

            // prevent wrong values of remainCharges
            if (spellInfo->ProcCharges)
            {
                // we have no control over the order of applying auras and modifiers allow auras
                // to have more charges than value in SpellInfo
                if (remainCharges <= 0/* || remainCharges > spellproto->procCharges*/)
                    remainCharges = spellInfo->ProcCharges;
            }
            else
                remainCharges = 0;

            if ((dst.GetMapId() != MAPID_INVALID && !sMapStore.HasRecord(dst.GetMapId()))
                || !Trinity::IsValidMapCoord(dst.GetPositionX(), dst.GetPositionY(), dst.GetPositionZ(), dst.GetOrientation()))
                dst = WorldLocation();

            AuraLoadEffectInfo& info = effectInfo[key];
            ObjectGuid castId = ObjectGuid::Create<HighGuid::Cast>(SPELL_CAST_SOURCE_NORMAL, GetMapId(), spellInfo->Id, GetMap()->GenerateLowGuid<HighGuid::Cast>());
            AuraCreateInfo createInfo(castId, spellInfo, difficulty, key.EffectMask, this);
            createInfo
                .SetCasterGUID(casterGuid)
                .SetBaseAmount(info.BaseAmounts.data())
                .SetStackAmount(stackCount)
                .SetDst(&dst);

            if (Aura* aura = Aura::TryCreate(createInfo))
            {
                if (!aura->CanBeSaved())
                {
                    aura->Remove();
                    continue;
                }

                aura->SetLoadedState(maxDuration, remainTime, remainCharges, recalculateMask, info.Amounts.data());
                aura->ApplyForTargets();
                TC_LOG_DEBUG("entities.pet", "Added aura spellid {}, effectmask {}", spellInfo->Id, key.EffectMask);
            }
        }
        while (auraResult->NextRow());
    }
}

void Pet::_SaveAuras(CharacterDatabaseTransaction trans)
{
    CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_AURA_EFFECTS);
    stmt->setUInt32(0, m_charmInfo->GetPetNumber());
    trans->Append(stmt);

    stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_PET_AURAS);
    stmt->setUInt32(0, m_charmInfo->GetPetNumber());
    trans->Append(stmt);

    uint8 index;
    for (AuraMap::const_iterator itr = m_ownedAuras.begin(); itr != m_ownedAuras.end(); ++itr)
    {
        // check if the aura has to be saved
        if (!itr->second->CanBeSaved() || IsPetAura(itr->second))
            continue;

        Aura* aura = itr->second;
        uint32 recalculateMask = 0;
        AuraKey key = aura->GenerateKey(recalculateMask);

        // don't save guid of caster in case we are caster of the spell - guid for pet is generated every pet load, so it won't match saved guid anyways
        if (key.Caster == GetGUID())
            key.Caster.Clear();

        index = 0;
        stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_PET_AURA);
        stmt->setUInt32(index++, m_charmInfo->GetPetNumber());
        stmt->setBinary(index++, key.Caster.GetRawValue());
        stmt->setUInt32(index++, key.SpellId);
        stmt->setUInt32(index++, key.EffectMask);
        stmt->setUInt32(index++, recalculateMask);
        stmt->setUInt8(index++, aura->GetCastDifficulty());
        stmt->setUInt8(index++, aura->GetStackAmount());
        stmt->setInt32(index++, aura->GetMaxDuration());
        stmt->setInt32(index++, aura->GetDuration());
        stmt->setUInt8(index++, aura->GetCharges());
        stmt->setInt32(index++, aura->GetDst().GetMapId());
        stmt->setFloat(index++, aura->GetDst().GetPositionX());
        stmt->setFloat(index++, aura->GetDst().GetPositionY());
        stmt->setFloat(index++, aura->GetDst().GetPositionZ());
        stmt->setFloat(index++, aura->GetDst().GetOrientation());
        trans->Append(stmt);

        for (AuraEffect const* effect : aura->GetAuraEffects())
        {
            index = 0;
            stmt = CharacterDatabase.GetPreparedStatement(CHAR_INS_PET_AURA_EFFECT);
            stmt->setUInt32(index++, m_charmInfo->GetPetNumber());
            stmt->setBinary(index++, key.Caster.GetRawValue());
            stmt->setUInt32(index++, key.SpellId);
            stmt->setUInt32(index++, key.EffectMask);
            stmt->setUInt8(index++, effect->GetEffIndex());
            stmt->setDouble(index++, effect->GetAmount());
            stmt->setDouble(index++, effect->GetBaseAmount());
            trans->Append(stmt);
        }
    }
}

bool Pet::addSpell(uint32 spellId, ActiveStates active /*= ACT_DECIDE*/, PetSpellState state /*= PETSPELL_NEW*/, PetSpellType type /*= PETSPELL_NORMAL*/)
{
    SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE);
    if (!spellInfo)
    {
        // do pet spell book cleanup
        if (state == PETSPELL_UNCHANGED)                    // spell load case
        {
            TC_LOG_ERROR("entities.pet", "Pet::addSpell: Non-existed in SpellStore spell #{} request, deleting for all pets in `pet_spell`.", spellId);

            CharacterDatabasePreparedStatement* stmt = CharacterDatabase.GetPreparedStatement(CHAR_DEL_INVALID_PET_SPELL);

            stmt->setUInt32(0, spellId);

            CharacterDatabase.Execute(stmt);
        }
        else
            TC_LOG_ERROR("entities.pet", "Pet::addSpell: Non-existed in SpellStore spell #{} request.", spellId);

        return false;
    }

    PetSpellMap::iterator itr = m_spells.find(spellId);
    if (itr != m_spells.end())
    {
        if (itr->second.state == PETSPELL_REMOVED)
            state = PETSPELL_CHANGED;
        else
        {
            if (state == PETSPELL_UNCHANGED && itr->second.state != PETSPELL_UNCHANGED)
            {
                // can be in case spell loading but learned at some previous spell loading
                itr->second.state = PETSPELL_UNCHANGED;

                if (active == ACT_ENABLED)
                    ToggleAutocast(spellInfo, true);
                else if (active == ACT_DISABLED)
                    ToggleAutocast(spellInfo, false);
            }

            return false;
        }
    }

    PetSpell newspell;
    newspell.state = state;
    newspell.type = type;

    if (active == ACT_DECIDE)                               // active was not used before, so we save it's autocast/passive state here
    {
        if (!spellInfo->IsAutocastable())
            newspell.active = ACT_PASSIVE;
        else if (spellInfo->IsAutocastEnabledByDefault())
            newspell.active = ACT_ENABLED;
        else
            newspell.active = ACT_DISABLED;
    }
    else
        newspell.active = active;

    // talent: unlearn all other talent ranks (high and low)
    if (spellInfo->IsRanked())
    {
        for (PetSpellMap::const_iterator itr2 = m_spells.begin(); itr2 != m_spells.end(); ++itr2)
        {
            if (itr2->second.state == PETSPELL_REMOVED)
                continue;

            SpellInfo const* oldRankSpellInfo = sSpellMgr->GetSpellInfo(itr2->first, DIFFICULTY_NONE);

            if (!oldRankSpellInfo)
                continue;

            if (spellInfo->IsDifferentRankOf(oldRankSpellInfo))
            {
                // replace by new high rank
                if (spellInfo->IsHighRankOf(oldRankSpellInfo))
                {
                    newspell.active = itr2->second.active;

                    if (newspell.active == ACT_ENABLED)
                        ToggleAutocast(oldRankSpellInfo, false);

                    unlearnSpell(itr2->first, false, false);
                    break;
                }
                // ignore new lesser rank
                else
                    return false;
            }
        }
    }

    m_spells[spellId] = newspell;

    if (spellInfo->IsPassive() && (!spellInfo->CasterAuraState || HasAuraState(AuraStateType(spellInfo->CasterAuraState))))
        CastSpell(this, spellId, true);
    else
        m_charmInfo->AddSpellToActionBar(spellInfo);

    if (newspell.active == ACT_ENABLED)
        ToggleAutocast(spellInfo, true);

    return true;
}

bool Pet::learnSpell(uint32 spell_id)
{
    // prevent duplicated entires in spell book
    if (!addSpell(spell_id))
        return false;

    if (!m_loading)
    {
        WorldPackets::Pet::PetLearnedSpells packet;
        packet.Spells.push_back(spell_id);
        GetOwner()->SendDirectMessage(packet.Write());
        GetOwner()->PetSpellInitialize();
        UpdateTrainingPoints();
    }
    return true;
}

void Pet::learnSpells(std::vector<uint32> const& spellIds)
{
    WorldPackets::Pet::PetLearnedSpells packet;

    for (uint32 spell : spellIds)
    {
        if (!addSpell(spell))
            continue;

        packet.Spells.push_back(spell);
    }

    if (!m_loading)
        if (Player* o = GetOwner())
            if (WorldSession* sess = o->GetSession())
                sess->SendPacket(packet.Write());
}

void Pet::InitLevelupSpellsForLevel()
{
    uint8 level = GetLevel();

    if (PetLevelupSpellSet const* levelupSpells = GetCreatureTemplate()->family ? sSpellMgr->GetPetLevelupSpellList(GetCreatureTemplate()->family) : nullptr)
    {
        // PetLevelupSpellSet ordered by levels, process in reversed order
        for (PetLevelupSpellSet::const_reverse_iterator itr = levelupSpells->rbegin(); itr != levelupSpells->rend(); ++itr)
        {
            // will called first if level down
            if (itr->first > level)
                unlearnSpell(itr->second, true);                 // will learn prev rank if any
            // will called if level up
            else
                learnSpell(itr->second);                        // will unlearn prev rank if any
        }
    }

    // default spells (can be not learned if pet level (as owner level decrease result for example) less first possible in normal game)
    if (PetDefaultSpellsEntry const* defSpells = sSpellMgr->GetPetDefaultSpellsEntry(int32(GetEntry())))
    {
        for (uint32 spellId : defSpells->spellid)
        {
            SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(spellId, DIFFICULTY_NONE);
            if (!spellInfo)
                continue;

            // will called first if level down
            if (spellInfo->SpellLevel > level)
                unlearnSpell(spellInfo->Id, true);
            // will called if level up
            else
                learnSpell(spellInfo->Id);
        }
    }

    // Classic 1.60: training points follow the pet level and its known abilities
    UpdateTrainingPoints();
}

bool Pet::unlearnSpell(uint32 spell_id, bool learn_prev, bool clear_ab)
{
    if (removeSpell(spell_id, learn_prev, clear_ab))
    {
        if (!m_loading)
        {
            WorldPackets::Pet::PetUnlearnedSpells packet;
            packet.Spells.push_back(spell_id);
            GetOwner()->SendDirectMessage(packet.Write());
            UpdateTrainingPoints();
        }
        return true;
    }
    return false;
}

void Pet::unlearnSpells(std::vector<uint32> const& spellIds, bool learn_prev, bool clear_ab)
{
    WorldPackets::Pet::PetUnlearnedSpells packet;

    for (uint32 spell : spellIds)
    {
        if (!removeSpell(spell, learn_prev, clear_ab))
            continue;

        packet.Spells.push_back(spell);
    }

    if (!m_loading)
    {
        if (Player* o = GetOwner())
            if (WorldSession* sess = o->GetSession())
                sess->SendPacket(packet.Write());

        UpdateTrainingPoints();
    }
}

bool Pet::removeSpell(uint32 spell_id, bool learn_prev, bool clear_ab)
{
    PetSpellMap::iterator itr = m_spells.find(spell_id);
    if (itr == m_spells.end())
        return false;

    if (itr->second.state == PETSPELL_REMOVED)
        return false;

    if (itr->second.state == PETSPELL_NEW)
        m_spells.erase(itr);
    else
        itr->second.state = PETSPELL_REMOVED;

    RemoveAurasDueToSpell(spell_id);

    if (learn_prev)
    {
        if (uint32 prev_id = sSpellMgr->GetPrevSpellInChain (spell_id))
            learnSpell(prev_id);
        else
            learn_prev = false;
    }

    // if remove last rank or non-ranked then update action bar at server and client if need
    if (clear_ab && !learn_prev && m_charmInfo->RemoveSpellFromActionBar(spell_id))
    {
        if (!m_loading)
            GetOwner()->PetSpellInitialize(); // need update action bar for last removed rank
    }

    return true;
}

void Pet::CleanupActionBar()
{
    for (uint8 i = 0; i < MAX_UNIT_ACTION_BAR_INDEX; ++i)
        if (UnitActionBarEntry const* ab = m_charmInfo->GetActionBarEntry(i))
            if (ab->GetAction() && ab->IsActionBarForSpell())
            {
                if (!HasSpell(ab->GetAction()))
                    m_charmInfo->SetActionBar(i, 0, ACT_PASSIVE);
                else if (ab->GetType() == ACT_ENABLED)
                {
                    if (SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(ab->GetAction(), DIFFICULTY_NONE))
                        ToggleAutocast(spellInfo, true);
                }
            }
}

void Pet::InitPetCreateSpells()
{
    m_charmInfo->InitPetActionBar();
    m_spells.clear();

    LearnPetPassives();
    InitLevelupSpellsForLevel();

    CastPetAuras(false);
}

void Pet::ToggleAutocast(SpellInfo const* spellInfo, bool apply)
{
    ASSERT(spellInfo);

    if (!spellInfo->IsAutocastable())
        return;

    PetSpellMap::iterator itr = m_spells.find(spellInfo->Id);
    if (itr == m_spells.end())
        return;

    auto autospellItr = std::find(m_autospells.begin(), m_autospells.end(), spellInfo->Id);

    if (apply)
    {
        if (autospellItr == m_autospells.end())
        {
            m_autospells.push_back(spellInfo->Id);

            if (itr->second.active != ACT_ENABLED)
            {
                itr->second.active = ACT_ENABLED;
                if (itr->second.state != PETSPELL_NEW)
                    itr->second.state = PETSPELL_CHANGED;
            }
        }
    }
    else
    {
        if (autospellItr != m_autospells.end())
        {
            m_autospells.erase(autospellItr);

            if (itr->second.active != ACT_DISABLED)
            {
                itr->second.active = ACT_DISABLED;
                if (itr->second.state != PETSPELL_NEW)
                    itr->second.state = PETSPELL_CHANGED;
            }
        }
    }
}

bool Pet::IsPermanentPetFor(Player* owner) const
{
    switch (getPetType())
    {
        case SUMMON_PET:
            switch (owner->GetClass())
            {
                case CLASS_WARLOCK:
                    return GetCreatureTemplate()->type == CREATURE_TYPE_DEMON;
                case CLASS_DEATH_KNIGHT:
                    return GetCreatureTemplate()->type == CREATURE_TYPE_UNDEAD;
                case CLASS_MAGE:
                    return GetCreatureTemplate()->type == CREATURE_TYPE_ELEMENTAL;
                default:
                    return false;
            }
        case HUNTER_PET:
            return true;
        default:
            return false;
    }
}

bool Pet::Create(ObjectGuid::LowType guidlow, Map* map, uint32 Entry, uint32 /*petId*/)
{
    ASSERT(map);
    SetMap(map);

    // TODO: counter should be constructed as (summon_count << 32) | petNumber
    _Create(ObjectGuid::Create<HighGuid::Pet>(map->GetId(), Entry, guidlow));

    m_originalEntry = Entry;

    if (!InitEntry(Entry))
        return false;

    // Force regen flag for player pets, just like we do for players themselves
    SetUnitFlag2(UNIT_FLAG2_REGENERATE_POWER);
    SetSheath(SHEATH_STATE_MELEE);

    GetThreatManager().Initialize();

    return true;
}

bool Pet::HasSpell(uint32 spell) const
{
    PetSpellMap::const_iterator itr = m_spells.find(spell);
    return itr != m_spells.end() && itr->second.state != PETSPELL_REMOVED;
}

// Get all passive spells in our skill line
void Pet::LearnPetPassives()
{
    CreatureTemplate const* cInfo = GetCreatureTemplate();
    if (!cInfo)
        return;

    CreatureFamilyEntry const* cFamily = sCreatureFamilyStore.LookupEntry(cInfo->family);
    if (!cFamily)
        return;

    PetFamilySpellsStore::const_iterator petStore = sPetFamilySpellsStore.find(cInfo->family);
    if (petStore != sPetFamilySpellsStore.end())
    {
        // For general hunter pets skill 270
        // Passive 01~10, Passive 00 (20782, not used), Ferocious Inspiration (34457)
        // Scale 01~03 (34902~34904, bonus from owner, not used)
        for (uint32 spellId : petStore->second)
            addSpell(spellId, ACT_DECIDE, PETSPELL_NEW, PETSPELL_FAMILY);
    }
}

void Pet::CastPetAuras(bool current)
{
    Player* owner = GetOwner();

    if (!IsPermanentPetFor(owner))
        return;

    for (auto itr = owner->m_petAuras.begin(); itr != owner->m_petAuras.end();)
    {
        PetAura const* pa = *itr;
        ++itr;

        if (!current && pa->IsRemovedOnChangePet())
            owner->RemovePetAura(pa);
        else
            CastPetAura(pa);
    }
}

void Pet::CastPetAura(PetAura const* aura)
{
    uint32 auraId = aura->GetAura(GetEntry());
    if (!auraId)
        return;

    CastSpellExtraArgs args;
    args.TriggerFlags = TRIGGERED_FULL_MASK;

    if (auraId == 35696)                                      // Demonic Knowledge
        args.AddSpellMod(SPELLVALUE_BASE_POINT0, CalculatePct(aura->GetDamage(), GetStat(STAT_STAMINA) + GetStat(STAT_INTELLECT)));

    CastSpell(this, auraId, args);
}

bool Pet::IsPetAura(Aura const* aura)
{
    Player* owner = GetOwner();

    // if the owner has that pet aura, return true
    for (PetAura const* petAura : owner->m_petAuras)
        if (petAura->GetAura(GetEntry()) == aura->GetId())
            return true;

    return false;
}

void Pet::learnSpellHighRank(uint32 spellid)
{
    learnSpell(spellid);

    if (uint32 next = sSpellMgr->GetNextSpellInChain(spellid))
        learnSpellHighRank(next);
}

void Pet::SynchronizeLevelWithOwner()
{
    Player* owner = GetOwner();

    switch (getPetType())
    {
        // always same level
        case SUMMON_PET:
        case HUNTER_PET:
            GivePetLevel(owner->GetLevel());
            break;
        default:
            break;
    }
}

Player* Pet::GetOwner() const
{
    return Minion::GetOwner()->ToPlayer();
}

float Pet::GetFollowAngle() const
{
    return PetFollowPosition::FollowAngle(getPetType(), Guardian::GetFollowAngle());
}

float Pet::GetNativeObjectScale() const
{
    CreatureFamilyEntry const* creatureFamily = sCreatureFamilyStore.LookupEntry(GetCreatureTemplate()->family);
    // both ends must be set: a family with MinScale but MaxScale 0 would give its pets ObjectScale 0 (invisible, client asserts)
    if (creatureFamily && creatureFamily->MinScale > 0.0f && creatureFamily->MaxScale > 0.0f && getPetType() == HUNTER_PET)
        return PetScaling::FamilyScale(*creatureFamily, GetLevel());

    // a template without a scale would give the pet ObjectScale 0, which the client asserts on ("scale > FLT_EPSILON") when it draws the pet
    float const scale = Guardian::GetNativeObjectScale();
    if (!(scale > 0.01f))
    {
        TC_LOG_ERROR("entities.pet", "Pet::GetNativeObjectScale: creature {} has scale {}, using 1", GetEntry(), scale);
        return 1.0f;
    }

    return scale;
}

void Pet::SetDisplayId(uint32 modelId, bool setNative /*= false*/)
{
    Guardian::SetDisplayId(modelId, setNative);

    if (!isControlled())
        return;

    SetGroupUpdateFlag(GROUP_UPDATE_FLAG_PET_MODEL_ID);
}

void Pet::SetGroupUpdateFlag(uint32 flag)
{
    if (GetOwner()->GetGroup())
    {
        m_groupUpdateMask |= flag;
        GetOwner()->SetGroupUpdateFlag(GROUP_UPDATE_FLAG_PET);
    }
}

void Pet::ResetGroupUpdateFlag()
{
    m_groupUpdateMask = GROUP_UPDATE_FLAG_PET_NONE;
    if (GetOwner()->GetGroup())
        GetOwner()->RemoveGroupUpdateFlag(GROUP_UPDATE_FLAG_PET);
}

void Pet::LearnSpecializationSpells()
{
    std::vector<uint32> learnedSpells;

    if (std::vector<SpecializationSpellsEntry const*> const* specSpells = sDB2Manager.GetSpecializationSpells(m_petSpecialization))
    {
        for (size_t j = 0; j < specSpells->size(); ++j)
        {
            SpecializationSpellsEntry const* specSpell = specSpells->at(j);
            SpellInfo const* spellInfo = sSpellMgr->GetSpellInfo(specSpell->SpellID, DIFFICULTY_NONE);
            if (!spellInfo || spellInfo->SpellLevel > GetLevel())
                continue;

            learnedSpells.push_back(specSpell->SpellID);
        }
    }

    learnSpells(learnedSpells);
}

void Pet::RemoveSpecializationSpells(bool clearActionBar)
{
    std::vector<uint32> unlearnedSpells;

    for (uint32 i = 0; i < MAX_SPECIALIZATIONS; ++i)
    {
        if (ChrSpecializationEntry const* specialization = sDB2Manager.GetChrSpecializationByIndex(0, i))
        {
            if (std::vector<SpecializationSpellsEntry const*> const* specSpells = sDB2Manager.GetSpecializationSpells(specialization->ID))
            {
                for (size_t j = 0; j < specSpells->size(); ++j)
                {
                    SpecializationSpellsEntry const* specSpell = specSpells->at(j);
                    unlearnedSpells.push_back(specSpell->SpellID);
                }
            }
        }

        if (ChrSpecializationEntry const* specialization = sDB2Manager.GetChrSpecializationByIndex(PET_SPEC_OVERRIDE_CLASS_INDEX, i))
        {
            if (std::vector<SpecializationSpellsEntry const*> const* specSpells = sDB2Manager.GetSpecializationSpells(specialization->ID))
            {
                for (size_t j = 0; j < specSpells->size(); ++j)
                {
                    SpecializationSpellsEntry const* specSpell = specSpells->at(j);
                    unlearnedSpells.push_back(specSpell->SpellID);
                }
            }
        }
    }

    unlearnSpells(unlearnedSpells, true, clearActionBar);
}

void Pet::SetSpecialization(uint16 spec)
{
    if (m_petSpecialization == spec)
        return;

    // remove all the old spec's specalization spells, set the new spec, then add the new spec's spells
    // clearActionBars is false because we'll be updating the pet actionbar later so we don't have to do it now
    RemoveSpecializationSpells(false);
    if (!sChrSpecializationStore.LookupEntry(spec))
    {
        m_petSpecialization = 0;
        return;
    }

    m_petSpecialization = spec;
    LearnSpecializationSpells();

    // resend SMSG_PET_SPELLS_MESSAGE to remove old specialization spells from the pet action bar
    CleanupActionBar();
    GetOwner()->PetSpellInitialize();

    WorldPackets::Pet::SetPetSpecialization setPetSpecialization;
    setPetSpecialization.SpecID = m_petSpecialization;
    if (Player* o = GetOwner())
        if (WorldSession* sess = o->GetSession())
            sess->SendPacket(setPetSpecialization.Write());
}

std::string Pet::GenerateActionBarData() const
{
    std::ostringstream ss;

    for (uint32 i = ACTION_BAR_INDEX_START; i < ACTION_BAR_INDEX_END; ++i)
    {
        ss << uint32(m_charmInfo->GetActionBarEntry(i)->GetType()) << ' '
           << uint32(m_charmInfo->GetActionBarEntry(i)->GetAction()) << ' ';
    }

    return ss.str();
}

std::string Pet::GetDebugInfo() const
{
    std::stringstream sstr;
    sstr << Guardian::GetDebugInfo() << "\n"
        << std::boolalpha
        << "PetType: " << std::to_string(getPetType()) << " "
        << "PetNumber: " << m_charmInfo->GetPetNumber();
    return sstr.str();
}
