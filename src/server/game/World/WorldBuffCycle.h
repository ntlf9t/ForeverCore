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

#ifndef TRINITYCORE_WORLD_BUFF_CYCLE_H
#define TRINITYCORE_WORLD_BUFF_CYCLE_H

#include "Define.h"
#include <algorithm>
#include <cstddef>
#include <string>
#include <string_view>
#include <utility>
#include <vector>

// Classic.WorldBuffs.*: the timer that hands out world buffs instead of the raid head turn-ins. One cycle holds every buff;
// each buff fires its own offset after the cycle's start, and the next cycle is rolled once the last one has fired. The cycle
// length is measured between cycle starts, not from the last buff. After Evermore's mod-world-buff-bots (Rockhopper1776).
// Only the timing lives here, so it can be tested; announcing and casting is classic_world_buffs.cpp.
namespace Trinity::WorldBuffs
{
constexpr uint32 MinuteMs = 60 * 1000;

// [min, max] minutes with both at least 1 and min <= max
inline std::pair<uint32, uint32> NormalizeRange(uint32 minMinutes, uint32 maxMinutes)
{
    minMinutes = std::max<uint32>(minMinutes, 1);
    maxMinutes = std::max<uint32>(maxMinutes, 1);
    if (maxMinutes < minMinutes)
        std::swap(minMinutes, maxMinutes);
    return { minMinutes, maxMinutes };
}

// every {token} in text replaced by value
inline std::string FillPlaceholder(std::string text, std::string_view token, std::string_view value)
{
    std::size_t pos = 0;
    while ((pos = text.find(token, pos)) != std::string::npos)
    {
        text.replace(pos, token.size(), value);
        pos += value.size();
    }
    return text;
}

// "1 minute", "10 minutes"
inline std::string FormatMinutes(uint32 minutes)
{
    return std::to_string(minutes) + (minutes == 1 ? " minute" : " minutes");
}

enum class StepType
{
    Warn,   // the heads-up before a buff
    Fire    // the buff itself
};

struct Step
{
    std::size_t Buff = 0;       // index given to the Cycle
    StepType Type = StepType::Fire;
    uint32 RemainingMs = 0;     // Warn: time left until the buff fires
};

class Cycle
{
public:
    // one offset per buff, in milliseconds after the cycle's start
    explicit Cycle(std::vector<uint32> offsetsMs)
    {
        _buffs.reserve(offsetsMs.size());
        for (uint32 offset : offsetsMs)
            _buffs.push_back({ .OffsetMs = offset });
    }

    void SetEnabled(std::size_t buff, bool enabled) { _buffs.at(buff).Enabled = enabled; }
    void SetOffset(std::size_t buff, uint32 offsetMs) { _buffs.at(buff).OffsetMs = offsetMs; }
    // how long before a buff the heads-up goes out; 0 = no heads-up
    void SetWarningLead(uint32 leadMs) { _warningLeadMs = leadMs; }

    bool AnyEnabled() const
    {
        return std::any_of(_buffs.begin(), _buffs.end(), [](Buff const& buff) { return buff.Enabled; });
    }

    // an enabled buff of the current cycle has not fired yet
    bool InFlight() const
    {
        return std::any_of(_buffs.begin(), _buffs.end(), [](Buff const& buff) { return buff.Enabled && buff.Pending; });
    }

    // the largest offset among enabled buffs: how long a cycle runs from its start until its last buff
    uint32 TailMs() const
    {
        uint32 tail = 0;
        for (Buff const& buff : _buffs)
            if (buff.Enabled)
                tail = std::max(tail, buff.OffsetMs);
        return tail;
    }

    // Starts a cycle `delayMs` from now. When it follows a finished cycle (afterCycle), the delay counts from that cycle's
    // start, which was TailMs() ago, so the tail comes off; the start is never less than a minute away.
    void Arm(uint32 delayMs, bool afterCycle)
    {
        uint32 const tail = afterCycle ? TailMs() : 0;
        uint32 const startMs = delayMs > tail + MinuteMs ? delayMs - tail : MinuteMs;
        for (Buff& buff : _buffs)
        {
            buff.TimerMs = startMs + buff.OffsetMs;
            buff.Pending = buff.Enabled;
            buff.Warned = false;
        }
    }

    // time until the buff fires, 0 when it is not pending
    uint32 TimeToFire(std::size_t buff) const
    {
        Buff const& entry = _buffs.at(buff);
        return entry.Pending ? entry.TimerMs : 0;
    }

    // Moves the clock on by diff and returns what is due, in buff order. A buff's heads-up goes out once its time left is at or
    // under the lead; when less than a minute is left by then (a short reroll), it is dropped.
    std::vector<Step> Update(uint32 diff)
    {
        std::vector<Step> steps;
        for (std::size_t i = 0; i < _buffs.size(); ++i)
        {
            Buff& buff = _buffs[i];
            if (!buff.Enabled || !buff.Pending)
                continue;

            if (buff.TimerMs <= diff)
            {
                buff.Pending = false;
                buff.TimerMs = 0;
                steps.push_back({ .Buff = i, .Type = StepType::Fire });
                continue;
            }

            buff.TimerMs -= diff;
            if (!buff.Warned && _warningLeadMs && buff.TimerMs <= _warningLeadMs)
            {
                buff.Warned = true;
                if (buff.TimerMs >= MinuteMs)
                    steps.push_back({ .Buff = i, .Type = StepType::Warn, .RemainingMs = buff.TimerMs });
            }
        }
        return steps;
    }

private:
    struct Buff
    {
        uint32 OffsetMs = 0;
        bool Enabled = true;
        bool Pending = false;
        bool Warned = false;
        uint32 TimerMs = 0;
    };

    std::vector<Buff> _buffs;
    uint32 _warningLeadMs = 0;
};
}

#endif // TRINITYCORE_WORLD_BUFF_CYCLE_H
