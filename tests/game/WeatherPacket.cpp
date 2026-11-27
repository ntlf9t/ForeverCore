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
#include "MiscPackets.h"
#include "Weather.h"
#include <utility>

// advocaite/TrinityCore#294: SMSG_WEATHER carries the 1.60 client's Weather.db2 row of the same kind and strength that has
// WeatherXParticulate rows (checked against 1.60.1.70862: each target row has 1-3 particulate rows and the same Type),
// not the legacy row the server keeps internally.
namespace
{
    uint32 SentWeatherId(WeatherState state)
    {
        WorldPackets::Misc::Weather weather(state, 0.5f);
        WorldPacket const* packet = weather.Write();
        return packet->read<uint32>(0);
    }
}

TEST_CASE("Rain, snow, sandstorm and thunder are sent as the client's particle rows", "[WeatherPacket]")
{
    for (auto [state, clientId] : {
        std::pair{ WEATHER_STATE_LIGHT_RAIN, 625u }, { WEATHER_STATE_MEDIUM_RAIN, 579u }, { WEATHER_STATE_HEAVY_RAIN, 586u },
        { WEATHER_STATE_LIGHT_SNOW, 588u }, { WEATHER_STATE_MEDIUM_SNOW, 589u }, { WEATHER_STATE_HEAVY_SNOW, 590u },
        { WEATHER_STATE_LIGHT_SANDSTORM, 592u }, { WEATHER_STATE_MEDIUM_SANDSTORM, 600u }, { WEATHER_STATE_HEAVY_SANDSTORM, 602u },
        { WEATHER_STATE_THUNDERS, 584u } })
    {
        CAPTURE(uint32(state));
        CHECK(SentWeatherId(state) == clientId);   // the old packet sent uint32(state)
    }
}

TEST_CASE("Other weather ids are sent unchanged", "[WeatherPacket]")
{
    for (WeatherState state : { WEATHER_STATE_FINE, WEATHER_STATE_FOG, WEATHER_STATE_DRIZZLE, WEATHER_STATE_BLACKRAIN,
        WEATHER_STATE_BLACKSNOW, WeatherState(625) })
    {
        CAPTURE(uint32(state));
        CHECK(SentWeatherId(state) == uint32(state));
    }
}
