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

/*
 * WoW Forever: Darkspear Islands (map 2997, BattlemasterList 1157), 15v15, levels 30-60.
 *
 * From the client data: four capture points (gameobject type 42, assault -> 60 s -> captured; the core's capture point code
 * clicks, times and announces them), the Darkspear Islands Flag in the centre (type 36, pickup spell 1284560, dropped flag
 * 633862 that resets after 10 s, respawn 20 s after a capture), the score widget 7467 (world states 1776/1777, max 1780),
 * the base status widget 7860 (per base and team: 1 assaulted, 2 captured; flag taken 51172/51173), the scoreboard
 * columns 1026-1028 and the 2,000 points to win.
 *
 * Not in the client data, chosen by the realm owner (2026-11-26): Eye of the Storm scoring (a tick every 2 s worth
 * 1/2/5/10 for 1-4 bases, the flag worth 75/85/100/500 by the bases its team holds), the flag scored at a base the
 * carrier's team holds, +10 reputation (Theramore Expeditionary Force 2799 / Darkspear Raiders 2798) per 200 resources.
 * Graveyards and spirit guides (start areas plus each captured base) are world data: graveyard conditions and spawn
 * group conditions on the capture point world states 30837-30840.
 *
 * Quest credit at the end: kill credit 275188 ("Win in Darkspear Islands") for the winners, and the game event
 * EVENT_WIN_THREE_BASES for winners whose team holds 3 or more bases (server criteria trees 233754/233756).
 */

#include "BattlegroundScript.h"
#include "Battleground.h"
#include "BattlegroundMgr.h"
#include "BattlegroundPackets.h"
#include "DBCEnums.h"
#include "GameObject.h"
#include "Map.h"
#include "ObjectAccessor.h"
#include "Player.h"
#include "ScriptMgr.h"
#include "Timer.h"

namespace DarkspearIslands
{
    static constexpr uint32 MapId = 2997;
    static constexpr uint32 MaxTeamScore = 2000;
    static constexpr Milliseconds PointsTickTime = 2s;
    static constexpr Milliseconds FlagCheckTime = 250ms;
    static constexpr float FlagCaptureRadius = 10.0f;
    static constexpr uint8 BasesCount = 4;
    static constexpr std::array<uint32, BasesCount> TickPoints = { 1, 2, 5, 10 };
    static constexpr std::array<uint32, BasesCount> FlagPoints = { 75, 85, 100, 500 };
    static constexpr uint32 HonorTicksNormal = 260;
    static constexpr uint32 HonorTicksWeekend = 160;
    static constexpr uint32 ReputationTicks = 200;
    static constexpr uint32 ReputationPerTick = 10;
    static constexpr uint8 BasesForConquestQuests = 3;

    enum Factions : uint32
    {
        FACTION_DARKSPEAR_RAIDERS               = 2798,     // Horde
        FACTION_THERAMORE_EXPEDITIONARY_FORCE   = 2799      // Alliance
    };

    enum GameObjects : uint32
    {
        GO_DARKSPEAR_ISLANDS_FLAG               = 633863,
        GO_CAPTURE_POINT_CAMP                   = 637673,
        GO_CAPTURE_POINT_RUINS                  = 637674,
        GO_CAPTURE_POINT_ABANDONED_TOWER        = 637675,
        GO_CAPTURE_POINT_SHIPWRECK_COVE         = 637677,
        GO_DOOR_HORDE                           = 661004,
        GO_DOOR_ALLIANCE                        = 661005
    };

    enum Spells : uint32
    {
        SPELL_DARKSPEAR_ISLANDS_FLAG            = 1284560
    };

    enum Creatures : uint32
    {
        NPC_WIN_CREDIT                          = 275188    // "Win in Darkspear Islands" (quests 98903-98908)
    };

    enum Events : uint32
    {
        EVENT_WIN_THREE_BASES                   = 299701    // server only, criteria 233754/233756 (quests 98918/98919)
    };

    enum WorldStates : int32
    {
        WS_RESOURCES_ALLIANCE                   = 1776,
        WS_RESOURCES_HORDE                      = 1777,
        WS_RESOURCES_MAX                        = 1780,
        WS_FLAG_STATE                           = 31175,    // the flag's worldState1
        WS_FLAG_TAKEN_ALLIANCE                  = 51172,    // widget 7860 "Alliance has taken the flag"
        WS_FLAG_TAKEN_HORDE                     = 51173     // widget 7860 "Horde has taken the flag"
    };

    enum PvpStats : uint32
    {
        PVP_STAT_FLAG_CAPTURES                  = 1026,
        PVP_STAT_BASES_ASSAULTED                = 1027,
        PVP_STAT_BASES_DEFENDED                 = 1028
    };

    enum Texts : uint32
    {
        TEXT_TAKEN_FLAG                         = 18359,    // "$n has taken the flag!"
        TEXT_FLAG_DROPPED                       = 18361,    // "The flag has been dropped!"
        TEXT_FLAG_RESET                         = 18364,    // "The flag has been reset."
        TEXT_ALLIANCE_CAPTURED_FLAG             = 18375,    // "$n has captured the flag!"
        TEXT_HORDE_CAPTURED_FLAG                = 18384
    };

    enum Sounds : uint32
    {
        SOUND_FLAG_PICKED_UP_ALLIANCE           = 8212,
        SOUND_FLAG_CAPTURED_HORDE               = 8213,
        SOUND_FLAG_PICKED_UP_HORDE              = 8174,
        SOUND_FLAG_CAPTURED_ALLIANCE            = 8173,
        SOUND_FLAG_RESET                        = 8192,
        SOUND_NODE_ASSAULTED_ALLIANCE           = 8212,
        SOUND_NODE_ASSAULTED_HORDE              = 8174,
        SOUND_NODE_CAPTURED_ALLIANCE            = 8173,
        SOUND_NODE_CAPTURED_HORDE               = 8213
    };

    // base status widget 7860: per team, 1 = assaulted, 2 = captured
    struct BaseInfo
    {
        uint32 CapturePointEntry;
        int32 WidgetAlliance;
        int32 WidgetHorde;
    };

    static constexpr std::array<BaseInfo, BasesCount> Bases =
    { {
        { GO_CAPTURE_POINT_SHIPWRECK_COVE,  30852, 30851 }, // north island, west (capture point world state 30840)
        { GO_CAPTURE_POINT_ABANDONED_TOWER, 30857, 30858 }, // north island, east (30839)
        { GO_CAPTURE_POINT_CAMP,            30854, 30853 }, // south island, west (30837)
        { GO_CAPTURE_POINT_RUINS,           30855, 30856 }  // south island, east (30838)
    } };
}

using namespace DarkspearIslands;
using WorldPackets::Battleground::BattlegroundCapturePointState;

struct battleground_darkspear_islands : BattlegroundScript
{
    explicit battleground_darkspear_islands(BattlegroundMap* map) : BattlegroundScript(map)
    {
        _honorTicks = sBattlegroundMgr->IsBGWeekend(battleground->GetTypeID()) ? HonorTicksWeekend : HonorTicksNormal;
        _honorScoreTicks = { 0, 0 };
        _reputationScoreTicks = { 0, 0 };
        _pointsTimer.Reset(PointsTickTime);
        _flagCheckTimer.Reset(FlagCheckTime);
    }

    void OnInit() override
    {
        BattlegroundScript::OnInit();
        UpdateWorldState(WS_RESOURCES_MAX, MaxTeamScore);
        UpdateWorldState(WS_RESOURCES_ALLIANCE, 0);
        UpdateWorldState(WS_RESOURCES_HORDE, 0);
    }

    void OnStart() override
    {
        for (ObjectGuid const& guid : _doors)
        {
            if (GameObject* door = battlegroundMap->GetGameObject(guid))
            {
                door->UseDoorOrButton();
                door->DespawnOrUnsummon(3s);
            }
        }
    }

    void OnUpdate(uint32 diff) override
    {
        if (battleground->GetStatus() != STATUS_IN_PROGRESS)
            return;

        _pointsTimer.Update(diff);
        if (_pointsTimer.Passed())
        {
            _pointsTimer.Reset(PointsTickTime);
            for (TeamId teamId : { TEAM_ALLIANCE, TEAM_HORDE })
            {
                if (battleground->GetStatus() != STATUS_IN_PROGRESS)
                    break;                                  // the first team's tick ended the battle
                if (uint8 bases = GetControlledBaseCount(teamId))
                    AddPoints(teamId, TickPoints[bases - 1]);
            }
        }

        if (battleground->GetStatus() != STATUS_IN_PROGRESS)
            return;

        _flagCheckTimer.Update(diff);
        if (_flagCheckTimer.Passed())
        {
            _flagCheckTimer.Reset(FlagCheckTime);
            CheckFlagCapture();
        }
    }

    void OnGameObjectCreate(GameObject* gameObject) override
    {
        if (gameObject->GetGoType() == GAMEOBJECT_TYPE_CAPTURE_POINT)
            _capturePoints.push_back(gameObject->GetGUID());

        switch (gameObject->GetEntry())
        {
            case GO_DARKSPEAR_ISLANDS_FLAG:
                _flagGUID = gameObject->GetGUID();
                break;
            case GO_DOOR_ALLIANCE:
            case GO_DOOR_HORDE:
                _doors.push_back(gameObject->GetGUID());
                break;
            default:
                break;
        }
    }

    static BaseInfo const* GetBaseInfo(uint32 capturePointEntry)
    {
        for (BaseInfo const& base : Bases)
            if (base.CapturePointEntry == capturePointEntry)
                return &base;
        return nullptr;
    }

    static BattlegroundCapturePointState CapturedState(TeamId teamId)
    {
        return teamId == TEAM_ALLIANCE ? BattlegroundCapturePointState::AllianceCaptured : BattlegroundCapturePointState::HordeCaptured;
    }

    BattlegroundCapturePointState GetCapturePointState(GameObject const* capturePoint) const
    {
        return BattlegroundCapturePointState(battlegroundMap->GetWorldStateValue(capturePoint->GetGOInfo()->capturePoint.worldState1));
    }

    uint8 GetControlledBaseCount(TeamId teamId) const
    {
        uint8 count = 0;
        for (ObjectGuid const& guid : _capturePoints)
            if (GameObject const* capturePoint = battlegroundMap->GetGameObject(guid))
                if (GetCapturePointState(capturePoint) == CapturedState(teamId))
                    ++count;
        return count;
    }

    void AddPoints(TeamId teamId, uint32 points)
    {
        if (battleground->GetStatus() != STATUS_IN_PROGRESS)
            return;

        Team const team = teamId == TEAM_ALLIANCE ? ALLIANCE : HORDE;
        battleground->AddPoint(team, points);

        _honorScoreTicks[teamId] += points;
        while (_honorScoreTicks[teamId] >= _honorTicks)
        {
            battleground->RewardHonorToTeam(battleground->GetBonusHonorFromKill(1), team);
            _honorScoreTicks[teamId] -= _honorTicks;
        }

        _reputationScoreTicks[teamId] += points;
        while (_reputationScoreTicks[teamId] >= ReputationTicks)
        {
            battleground->RewardReputationToTeam(teamId == TEAM_ALLIANCE ? FACTION_THERAMORE_EXPEDITIONARY_FORCE : FACTION_DARKSPEAR_RAIDERS, ReputationPerTick, team);
            _reputationScoreTicks[teamId] -= ReputationTicks;
        }

        uint32 score = battleground->GetTeamScore(teamId);
        if (score >= MaxTeamScore)
        {
            score = MaxTeamScore;
            battleground->SetTeamPoint(team, MaxTeamScore);
        }

        UpdateWorldState(teamId == TEAM_ALLIANCE ? WS_RESOURCES_ALLIANCE : WS_RESOURCES_HORDE, score);

        if (score >= MaxTeamScore)
            battleground->EndBattleground(team);
    }

    // The flag scores at any base the carrier's team holds (Darkspear Islands has no capture area triggers in the client data)
    void CheckFlagCapture()
    {
        GameObject* flag = battlegroundMap->GetGameObject(_flagGUID);
        if (!flag || flag->GetFlagState() != FlagState::Taken)
            return;

        Player* carrier = ObjectAccessor::GetPlayer(*flag, flag->GetFlagCarrierGUID());
        if (!carrier || !carrier->IsAlive() || !carrier->HasAura(SPELL_DARKSPEAR_ISLANDS_FLAG))
            return;

        TeamId const teamId = Battleground::GetTeamIndexByTeamId(battleground->GetPlayerTeam(carrier->GetGUID()));
        if (teamId != TEAM_ALLIANCE && teamId != TEAM_HORDE)
            return;

        for (ObjectGuid const& guid : _capturePoints)
        {
            GameObject const* capturePoint = battlegroundMap->GetGameObject(guid);
            if (!capturePoint || GetCapturePointState(capturePoint) != CapturedState(teamId))
                continue;

            if (carrier->GetExactDist2d(capturePoint) > FlagCaptureRadius || std::abs(carrier->GetPositionZ() - capturePoint->GetPositionZ()) > FlagCaptureRadius)
                continue;

            CaptureFlag(flag, carrier, teamId);
            return;
        }
    }

    void CaptureFlag(GameObject* flag, Player* carrier, TeamId teamId)
    {
        uint8 const bases = GetControlledBaseCount(teamId);

        // Respawning first: removing the carrier's aura then does not drop the flag
        flag->HandleCustomTypeCommand(GameObjectType::SetNewFlagState(FlagState::Respawning, carrier));
        carrier->RemoveAurasDueToSpell(SPELL_DARKSPEAR_ISLANDS_FLAG);
        carrier->RemoveAurasWithInterruptFlags(SpellAuraInterruptFlags::PvPActive);

        if (teamId == TEAM_ALLIANCE)
        {
            battleground->SendBroadcastText(TEXT_ALLIANCE_CAPTURED_FLAG, CHAT_MSG_BG_SYSTEM_ALLIANCE, carrier);
            battleground->PlaySoundToAll(SOUND_FLAG_CAPTURED_ALLIANCE);
        }
        else
        {
            battleground->SendBroadcastText(TEXT_HORDE_CAPTURED_FLAG, CHAT_MSG_BG_SYSTEM_HORDE, carrier);
            battleground->PlaySoundToAll(SOUND_FLAG_CAPTURED_HORDE);
        }

        battleground->UpdatePvpStat(carrier, PVP_STAT_FLAG_CAPTURES, 1);

        if (bases > 0)
            AddPoints(teamId, FlagPoints[bases - 1]);
    }

    void OnFlagStateChange(GameObject* /*flagInBase*/, FlagState /*oldValue*/, FlagState newValue, Player* player) override
    {
        UpdateWorldState(WS_FLAG_STATE, AsUnderlyingType(newValue));
        UpdateWorldState(WS_FLAG_TAKEN_ALLIANCE, 0);
        UpdateWorldState(WS_FLAG_TAKEN_HORDE, 0);

        switch (newValue)
        {
            case FlagState::Taken:
            {
                if (!player)
                    break;

                if (battleground->GetPlayerTeam(player->GetGUID()) == ALLIANCE)
                {
                    UpdateWorldState(WS_FLAG_TAKEN_ALLIANCE, 1);
                    battleground->PlaySoundToAll(SOUND_FLAG_PICKED_UP_ALLIANCE);
                    battleground->SendBroadcastText(TEXT_TAKEN_FLAG, CHAT_MSG_BG_SYSTEM_ALLIANCE, player);
                }
                else
                {
                    UpdateWorldState(WS_FLAG_TAKEN_HORDE, 1);
                    battleground->PlaySoundToAll(SOUND_FLAG_PICKED_UP_HORDE);
                    battleground->SendBroadcastText(TEXT_TAKEN_FLAG, CHAT_MSG_BG_SYSTEM_HORDE, player);
                }

                player->RemoveAurasWithInterruptFlags(SpellAuraInterruptFlags::PvPActive);
                break;
            }
            case FlagState::Dropped:
                // live Forever: no Recently Dropped Flag here, the carrier can pick it straight back up
                if (player)
                    battleground->SendBroadcastText(TEXT_FLAG_DROPPED, battleground->GetPlayerTeam(player->GetGUID()) == ALLIANCE ? CHAT_MSG_BG_SYSTEM_ALLIANCE : CHAT_MSG_BG_SYSTEM_HORDE);
                break;
            case FlagState::InBase:
                // back from the ground (expired dropped flag) or after the respawn time
                battleground->SendBroadcastText(TEXT_FLAG_RESET, CHAT_MSG_BG_SYSTEM_NEUTRAL);
                battleground->PlaySoundToAll(SOUND_FLAG_RESET);
                break;
            default:
                break;
        }
    }

    void ProcessEvent(WorldObject* source, uint32 eventId, WorldObject* invoker) override
    {
        BattlegroundScript::ProcessEvent(source, eventId, invoker);

        GameObject* capturePoint = nullptr;
        for (WorldObject* object : { source, invoker })
            if (GameObject* gameObject = object ? object->ToGameObject() : nullptr)
                if (gameObject->GetGoType() == GAMEOBJECT_TYPE_CAPTURE_POINT)
                    capturePoint = gameObject;

        if (!capturePoint)
            return;

        BaseInfo const* base = GetBaseInfo(capturePoint->GetEntry());
        if (!base)
            return;

        auto const& info = capturePoint->GetGOInfo()->capturePoint;
        Player* player = nullptr;
        for (WorldObject* object : { source, invoker })
            if (Player* objectPlayer = object ? object->ToPlayer() : nullptr)
                player = objectPlayer;

        // the timed capture fires its event before the capture point writes its new state, so the state comes from the event
        BattlegroundCapturePointState state = GetCapturePointState(capturePoint);
        if (eventId == info.ContestedEventAlliance || eventId == info.ContestedEventHorde)
        {
            battleground->PlaySoundToAll(eventId == info.ContestedEventAlliance ? SOUND_NODE_ASSAULTED_ALLIANCE : SOUND_NODE_ASSAULTED_HORDE);
            if (player)
                battleground->UpdatePvpStat(player, PVP_STAT_BASES_ASSAULTED, 1);
        }
        else if (eventId == info.DefendedEventAlliance || eventId == info.DefendedEventHorde)
        {
            battleground->PlaySoundToAll(eventId == info.DefendedEventAlliance ? SOUND_NODE_CAPTURED_ALLIANCE : SOUND_NODE_CAPTURED_HORDE);
            if (player)
                battleground->UpdatePvpStat(player, PVP_STAT_BASES_DEFENDED, 1);
        }
        else if (eventId == info.CaptureEventAlliance || eventId == info.CaptureEventHorde)
        {
            battleground->PlaySoundToAll(eventId == info.CaptureEventAlliance ? SOUND_NODE_CAPTURED_ALLIANCE : SOUND_NODE_CAPTURED_HORDE);
            state = CapturedState(eventId == info.CaptureEventAlliance ? TEAM_ALLIANCE : TEAM_HORDE);
        }
        else
            return;

        UpdateBaseWidget(*base, state);
    }

    void UpdateBaseWidget(BaseInfo const& base, BattlegroundCapturePointState state) const
    {
        int32 alliance = 0, horde = 0;
        switch (state)
        {
            case BattlegroundCapturePointState::ContestedAlliance: alliance = 1; break;
            case BattlegroundCapturePointState::AllianceCaptured:  alliance = 2; break;
            case BattlegroundCapturePointState::ContestedHorde:    horde = 1;    break;
            case BattlegroundCapturePointState::HordeCaptured:     horde = 2;    break;
            default: break;
        }

        UpdateWorldState(base.WidgetAlliance, alliance);
        UpdateWorldState(base.WidgetHorde, horde);
    }

    Team GetPrematureWinner() override
    {
        if (battleground->GetTeamScore(TEAM_ALLIANCE) > battleground->GetTeamScore(TEAM_HORDE))
            return ALLIANCE;
        if (battleground->GetTeamScore(TEAM_HORDE) > battleground->GetTeamScore(TEAM_ALLIANCE))
            return HORDE;
        return BattlegroundScript::GetPrematureWinner();
    }

    void OnEnd(Team winner) override
    {
        BattlegroundScript::OnEnd(winner);

        // Eye of the Storm end rewards: bonus honor for the win and for the completed battle
        if (winner == ALLIANCE || winner == HORDE)
            battleground->RewardHonorToTeam(battleground->GetBonusHonorFromKill(1), winner);
        battleground->RewardHonorToTeam(battleground->GetBonusHonorFromKill(1), ALLIANCE);
        battleground->RewardHonorToTeam(battleground->GetBonusHonorFromKill(1), HORDE);

        if (winner != ALLIANCE && winner != HORDE)
            return;

        bool const heldThreeBases = GetControlledBaseCount(Battleground::GetTeamIndexByTeamId(winner)) >= BasesForConquestQuests;
        for (auto const& [guid, bgPlayer] : battleground->GetPlayers())
        {
            if (bgPlayer.Team != winner)
                continue;

            Player* player = ObjectAccessor::FindPlayer(guid);
            if (!player)
                continue;

            player->KilledMonsterCredit(NPC_WIN_CREDIT);
            if (heldThreeBases)
                player->UpdateCriteria(CriteriaType::PlayerTriggerGameEvent, EVENT_WIN_THREE_BASES);
        }
    }

private:
    TimeTracker _pointsTimer;
    TimeTracker _flagCheckTimer;
    uint32 _honorTicks;
    std::array<uint32, PVP_TEAMS_COUNT> _honorScoreTicks;
    std::array<uint32, PVP_TEAMS_COUNT> _reputationScoreTicks;

    GuidVector _capturePoints;
    GuidVector _doors;
    ObjectGuid _flagGUID;
};

void AddSC_battleground_darkspear_islands()
{
    RegisterBattlegroundMapScript(battleground_darkspear_islands, MapId);
}
