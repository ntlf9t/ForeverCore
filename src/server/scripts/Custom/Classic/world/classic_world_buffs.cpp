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

// Everlake: timed world buffs (Classic.WorldBuffs.*). Everlake does not offer the raid head turn-ins, so Rallying Cry of the
// Dragonslayer (Onyxia's head) and Spirit of Zandalar (Hakkar's heart) go out on a random timer instead, the way Evermore's
// mod-world-buff-bots (Rockhopper1776) does it. Each cycle a made-up player "turns in" Onyxia's head in Stormwind and in
// Orgrimmar at the same moment, and Spirit of Zandalar follows in Stranglethorn Vale. A heads-up goes out first, naming the
// realm time the buff drops. Rend's head (Warchief's Blessing, Might of Stormwind) is left to players: Upper Blackrock Spire
// is a dungeon and stays open. The timing is Trinity::WorldBuffs::Cycle (WorldBuffCycle.h); it is not saved, so a restart
// rolls a new first cycle. Buff lengths are the client's: 2 hours each.

#include "ScriptMgr.h"
#include "Config.h"
#include "GameTime.h"
#include "Log.h"
#include "Player.h"
#include "Random.h"
#include "Util.h"
#include "World.h"
#include "WorldBuffCycle.h"
#include "WorldSession.h"
#include <algorithm>
#include <array>
#include <ctime>
#include <string>

namespace
{
    using namespace Trinity::WorldBuffs;

    constexpr uint32 SpellRallyingCryOfTheDragonslayer = 22888;
    constexpr uint32 SpellSpiritOfZandalar = 24425;

    constexpr uint32 ZoneStranglethornVale = 33;
    constexpr uint32 ZoneStormwindCity = 1519;
    constexpr uint32 ZoneOrgrimmar = 1637;

    enum class BuffTeam
    {
        Alliance,
        Horde,
        Both
    };

    struct WorldBuff
    {
        char const* ConfigKey;      // Classic.WorldBuffs.<key>.Enable
        char const* Name;
        uint32 SpellId;
        uint32 ZoneId;
        BuffTeam Team;              // who hears about it and who gets it
        char const* Warning;        // {player}, {buff}, {time}, {duration}
        char const* Announcement;   // {player}, {buff}
    };

    // Cycle indexes: both heads at the cycle's start, Zandalar Classic.WorldBuffs.Zandalar.OffsetMinutes later
    enum WorldBuffIndex : std::size_t
    {
        BUFF_RALLYING_CRY_STORMWIND,
        BUFF_RALLYING_CRY_ORGRIMMAR,
        BUFF_SPIRIT_OF_ZANDALAR,
        MAX_WORLD_BUFFS
    };

    std::array<WorldBuff, MAX_WORLD_BUFFS> constexpr WorldBuffs =
    { {
        { "RallyingCry", "Rallying Cry of the Dragonslayer", SpellRallyingCryOfTheDragonslayer, ZoneStormwindCity, BuffTeam::Alliance,
            "{player} is carrying the head of Onyxia to Stormwind. {buff} drops at {time} realm time, in {duration}!",
            "{player} has returned the head of Onyxia! {buff} echoes through Stormwind." },
        { "RallyingCry", "Rallying Cry of the Dragonslayer", SpellRallyingCryOfTheDragonslayer, ZoneOrgrimmar, BuffTeam::Horde,
            "{player} is carrying the head of Onyxia to Orgrimmar. {buff} drops at {time} realm time, in {duration}!",
            "{player} has returned the head of Onyxia! {buff} echoes through Orgrimmar." },
        { "Zandalar", "Spirit of Zandalar", SpellSpiritOfZandalar, ZoneStranglethornVale, BuffTeam::Both,
            "{player} is carrying the Heart of Hakkar to Yojamba Isle. {buff} drops at {time} realm time, in {duration}!",
            "{player} has returned the Heart of Hakkar! {buff} fills Stranglethorn Vale." },
    } };

    std::array<char const*, 24> constexpr AllianceNames =
    { {
        "Aldren", "Aricel", "Baelric", "Brennar", "Caldrin", "Corwyn", "Darien", "Edrin", "Elowen", "Fenric", "Garran", "Halwen",
        "Isendra", "Jorren", "Kaelyn", "Liora", "Merric", "Norwyn", "Odelia", "Perrin", "Roswyn", "Selric", "Tarian", "Vaelora"
    } };

    std::array<char const*, 24> constexpr HordeNames =
    { {
        "Azgora", "Brakka", "Dorgash", "Gorvak", "Gralnok", "Hargun", "Krazka", "Lokgar", "Malkor", "Mogra", "Narvok", "Rethka",
        "Rogash", "Shagra", "Surnak", "Thokran", "Torgha", "Urgash", "Varkesh", "Varzok", "Zagrim", "Zoraka", "Drezka", "Kazra"
    } };

    template <std::size_t N>
    std::string PickName(std::array<char const*, N> const& names)
    {
        return names[urand(0, uint32(N - 1))];
    }

    std::string PickAnnouncer(BuffTeam team)
    {
        switch (team)
        {
            case BuffTeam::Alliance: return PickName(AllianceNames);
            case BuffTeam::Horde: return PickName(HordeNames);
            default: return urand(0, 1) ? PickName(AllianceNames) : PickName(HordeNames);
        }
    }

    bool IsOnTeam(Player const* player, BuffTeam team)
    {
        switch (team)
        {
            case BuffTeam::Alliance: return player->GetTeam() == ALLIANCE;
            case BuffTeam::Horde: return player->GetTeam() == HORDE;
            default: return true;
        }
    }

    // the clock time fromNowMs ahead, in the server's local time
    std::string RealmClock(uint32 fromNowMs)
    {
        time_t const at = GameTime::GetGameTime() + time_t(fromNowMs / IN_MILLISECONDS);
        tm local;
        localtime_r(&at, &local);
        char text[16];
        if (!std::strftime(text, sizeof(text), "%H:%M", &local))
            return {};
        return text;
    }

    // at most a week, so minutes in milliseconds stay inside uint32
    uint32 ReadMinutes(char const* name, int32 def)
    {
        return uint32(std::clamp(sConfigMgr->GetIntDefault(name, def), 0, 7 * 24 * 60));
    }
}

class classic_world_buffs : public WorldScript
{
public:
    classic_world_buffs() : WorldScript("classic_world_buffs"), _cycle({ 0, 0, 0 }) { }

    // runs once at start-up (after the scripts load) and again on every .reload config. A reload keeps a cycle players were
    // already told about; new times and switches count from the next cycle.
    void OnConfigLoad(bool reload) override
    {
        bool const wasEnabled = _enabled;
        _enabled = sConfigMgr->GetBoolDefault("Classic.WorldBuffs.Enable", true);
        _range = NormalizeRange(ReadMinutes("Classic.WorldBuffs.MinMinutes", 30), ReadMinutes("Classic.WorldBuffs.MaxMinutes", 150));
        _firstRange = NormalizeRange(ReadMinutes("Classic.WorldBuffs.FirstMinMinutes", 30),
            ReadMinutes("Classic.WorldBuffs.FirstMaxMinutes", 150));
        _cycle.SetWarningLead(ReadMinutes("Classic.WorldBuffs.WarningMinutes", 10) * MinuteMs);
        _cycle.SetOffset(BUFF_SPIRIT_OF_ZANDALAR, ReadMinutes("Classic.WorldBuffs.Zandalar.OffsetMinutes", 10) * MinuteMs);
        for (std::size_t i = 0; i < MAX_WORLD_BUFFS; ++i)
            _cycle.SetEnabled(i, sConfigMgr->GetBoolDefault(std::string("Classic.WorldBuffs.") + WorldBuffs[i].ConfigKey + ".Enable", true));

        if (reload && (!wasEnabled || !_cycle.InFlight()))
            ArmFirstCycle();
    }

    void OnStartup() override
    {
        ArmFirstCycle();
    }

    // before the maps update, so no map thread touches the players while they are buffed
    void OnBeforeMapsUpdate(uint32 diff) override
    {
        if (!_enabled)
            return;

        for (Step const& step : _cycle.Update(diff))
        {
            if (step.Type == StepType::Warn)
                Warn(step.Buff, step.RemainingMs);
            else
                Fire(step.Buff);
        }

        if (!_cycle.InFlight() && _cycle.AnyEnabled())
            ArmCycle(_range, true);
    }

private:
    void ArmFirstCycle()
    {
        if (!_enabled)
            return;

        uint32 const tailMinutes = _cycle.TailMs() / MinuteMs;
        if (tailMinutes && _range.first <= tailMinutes)
            TC_LOG_WARN("server.loading", "Classic.WorldBuffs: MinMinutes ({}) is not above Zandalar.OffsetMinutes ({}), so short cycles "
                "start a minute after the last one ends", _range.first, tailMinutes);

        ArmCycle(_firstRange, false);
    }

    void ArmCycle(std::pair<uint32, uint32> range, bool afterCycle)
    {
        _cycle.Arm(urand(range.first, range.second) * MinuteMs, afterCycle);
        for (std::size_t i = 0; i < MAX_WORLD_BUFFS; ++i)
            _announcers[i] = PickAnnouncer(WorldBuffs[i].Team);

        for (std::size_t i = 0; i < MAX_WORLD_BUFFS; ++i)
            if (uint32 const inMs = _cycle.TimeToFire(i))
                TC_LOG_INFO("server.worldserver", "Classic.WorldBuffs: next {} in {} min", WorldBuffs[i].Name, inMs / MinuteMs);
    }

    std::string Fill(std::size_t index, char const* text) const
    {
        return FillPlaceholder(FillPlaceholder(text, "{player}", _announcers[index]), "{buff}", WorldBuffs[index].Name);
    }

    void Warn(std::size_t index, uint32 remainingMs)
    {
        uint32 const minutes = (remainingMs + MinuteMs - 1) / MinuteMs;
        std::string message = Fill(index, WorldBuffs[index].Warning);
        message = FillPlaceholder(std::move(message), "{time}", RealmClock(remainingMs));
        message = FillPlaceholder(std::move(message), "{duration}", FormatMinutes(minutes));
        Tell(WorldBuffs[index].Team, message);
    }

    void Fire(std::size_t index)
    {
        WorldBuff const& buff = WorldBuffs[index];
        Tell(buff.Team, Fill(index, buff.Announcement));

        uint32 buffed = 0;
        for (auto const& [accountId, session] : sWorld->GetAllSessions())
        {
            Player* player = session->GetPlayer();
            if (!player || !player->IsInWorld() || !player->IsAlive() || player->IsGameMaster())
                continue;
            if (player->GetZoneId() != buff.ZoneId || !IsOnTeam(player, buff.Team))
                continue;

            // the aura alone: the spells also reach nearby allies, which would catch GMs and buff a crowd once per player
            if (player->AddAura(buff.SpellId, player))
                ++buffed;
        }

        TC_LOG_INFO("server.worldserver", "Classic.WorldBuffs: {} in zone {} for {} ({} players)", buff.Name, buff.ZoneId, _announcers[index], buffed);
    }

    // a system message to every player of the team; bots do not read chat
    static void Tell(BuffTeam team, std::string const& message)
    {
        for (auto const& [accountId, session] : sWorld->GetAllSessions())
        {
            Player* player = session->GetPlayer();
            if (session->IsBot() || !player || !player->IsInWorld() || !IsOnTeam(player, team))
                continue;

            sWorld->SendServerMessage(SERVER_MSG_STRING, message, player);
        }
    }

    Cycle _cycle;
    std::array<std::string, MAX_WORLD_BUFFS> _announcers;
    std::pair<uint32, uint32> _range = { 30, 150 };
    std::pair<uint32, uint32> _firstRange = { 30, 150 };
    bool _enabled = true;
};

void AddSC_classic_world_buffs()
{
    new classic_world_buffs();
}
