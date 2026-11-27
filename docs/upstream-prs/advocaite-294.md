# advocaite/TrinityCore#294: Weather: rain, snow and sandstorms are sent as the client's particle rows

Karrz1, 2026-11-06, commit 99306b3066. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** The 1.60 client's Weather.db2 still has the legacy rows the server sends (rain 3-5, snow 6-8, sandstorm 22/41/42,
thunder 86), but they have no WeatherXParticulate rows, so the client plays the sound and draws nothing. SMSG_WEATHER
now carries the row of the same kind and strength that has particles.

**Check.** Against the 1.60.1.70862 `Weather` and `WeatherXParticulate` tables (wago.tools):
- Every target row exists, has the same `Type` as the state (1 rain, 2 snow, 3 sandstorm) and 1-3 particulate rows:
  625/579/586 rain (intensity 0.3/0.6/1), 588/589/590 snow (0.5/0.75/1), 592/600/602 sandstorm (0.3/0.5/1),
  584 heavy rain for thunder.
- The legacy rows 4-8, 22, 41, 42, 86 have no particulate rows, as claimed. Row 3 (light rain) does have one, so the
  claim is not quite right for it; mapping it to 625 is still consistent.
- The legacy sandstorm rows were also mislabelled for the client: 22 ("light" on the server) is intensity 1 in the
  client, 41 is 0.5, 42 is 0.75. The new rows follow the server's light/medium/heavy.
- Only the packet changes; states, `game_weather`, scripts and the force-weather aura keep the legacy ids. All senders
  go through `WorldPackets::Misc::Weather::Write`: `Weather::SendWeatherUpdateToPlayer`, the map's zone override,
  `SPELL_AURA_FORCE_WEATHER` and Ossirian's sandstorm. Ids outside the ten pass through.
- Everlake's own weather work: `wow-project-everlake` has nothing about weather on any branch (searched every
  `origin/*` ref). The only weather module we have is Evermore's `wow-mod-weather` for AzerothCore (3.3.5 client,
  `game_weather` zones and fog/thunder rules), which doesn't apply here. No overlap.

**Test.** `tests/game/WeatherPacket.cpp` (`[WeatherPacket]`): writes SMSG_WEATHER for each of the ten states and reads the id
back; fine, fog, drizzle, black rain, black snow and an unknown id go out unchanged. Against the old packet the first
case fails for all ten (it sent the state itself). In-game test for the PTR realm: `.wchange 1 0.9` (rain), `2 0.9`
(snow), `3 0.9` (sandstorm) in a zone with a `game_weather` row. Expected: drops, flakes and sand are drawn, not just
the sound.

**Verdict:** take.
