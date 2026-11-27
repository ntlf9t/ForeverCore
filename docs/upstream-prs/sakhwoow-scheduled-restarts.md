# Sakhwoow/WoWForever a5c2b04dcb: scheduled restarts (`ServerAutoShutdown.*`)

Sakhwoow/WoWForever `forever` (the Azeroth project's hardcore realm, GPL-2.0), commit a5c2b04dcb by PlayDargoon, 2026-10-20, ported
from their AzerothLegionCore. Reviewed 2026-11-16 against `everlake` 0d9a4b9145. Taken at the user's request (2026-11-16), reworked.

**What it does.** Off by default. Once at startup the world works out the next restart, every N days or on one weekday, at
`ServerAutoShutdown.Time` and an optional `Time2`, server local time, and `PreAnnounce.Seconds` before it starts the normal
restart countdown (`ShutdownServ`, the messages `.server restart` sends). The restarted process works out the next one.

**Changed from theirs.**
- Exit code 2 (`RESTART_EXIT_CODE`, as `.server restart`), not 0. Our containers restart either way, but a 0 reads as a stop.
- Daylight saving: theirs kept today's `tm_isdst` for the planned day, so a restart planned across a clock change landed an hour
  off (03:00 or 05:00 instead of 04:00). Server time is Toronto, which changes its clocks. `tm_isdst = -1` lets `mktime` decide.
- A restart or shutdown already counting down when the countdown would start (a GM's, the GUID alert's) is left alone; theirs
  replaced it with its own timer.
- With two times, only the earlier is planned (one restart per run is all that can happen); a countdown that starts late (a
  stalled world) counts down to the planned time, not a fresh full length.
- The calculation is in `src/server/game/World/AutoRestartSchedule.h` so a test can reach it; config errors are logged and that
  time (or the whole schedule) is not used.

**Test.** `tests/game/AutoRestartSchedule.cpp` (Toronto's rules as a POSIX TZ string, no tz database needed): HH:MM:SS parsing,
daily today/tomorrow, every 3 days, weekday, a process started right at its restart time, a server started inside the countdown,
and the two 2026 clock changes. Built on its own against the real header: 28 checks pass; with theirs (`tm_isdst` kept) the 4
clock change checks fail. CI builds and runs it with the other tests on Linux and macOS.

PTR check: `ServerAutoShutdown.Enabled = 1`, `Time` two minutes after start, `PreAnnounce.Seconds = 60`: the log says
"Scheduled restart in ...", the countdown appears a minute before, the world exits with code 2 and the container brings it back,
and the new process plans the next day.
