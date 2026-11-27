# v1ptyoz macOS runtime fixes: thread stacks and memory figures

**Source:** v1ptyoz/Karrz-playerbots-wow-forever `main` (`af4b52b`), commit `eaa7549` ("macOS support: build, install and
server menu scripts; libc++/macOS fixes in the bot module"), 2026-11-02. GPL-2.0 (`COPYING`), the same as this tree.
That repository is an overlay of Karrz's bot module over advocaite's `forever` core, 35 commits ahead of
Karrz1/Karrz-playerbots-wow-forever.

## Taken

| What | Files | Why |
|---|---|---|
| `Trinity::LargeStackThread`: a `std::thread` stand-in that starts through pthread with an 8 MB stack on macOS and is a plain `std::thread` everywhere else | `src/common/Threading/LargeStackThread.h`, `MapUpdater.h`, bot `AiWorkerPool.h`, `SnapshotBuildPool.h`, `FleetThread.h/.cpp` | macOS gives every `std::thread` 512 KB of stack (checked on macOS 26: `pthread_get_stacksize_np` reads 512 KB), Linux 8 MB. Map update threads and the bot pools run deep call chains (bot AI, path finding, spells), so a macOS server can overflow where Linux does not. Linux and Windows builds are unchanged. |
| Process memory on macOS for the bot spawner: resident size from `MACH_TASK_BASIC_INFO`, private memory from `TASK_VM_INFO` `phys_footprint` | `src/modules/PlayerbotV2/Fleet/WorldBotSpawner.cpp` | macOS has no `/proc/self/statm`, so the RSS read 0: the `[mem]` and spawner reports showed 0 MB and the world bot RSS budget never held bots back. |

Test: `tests/common/LargeStackThread.cpp` (function with arguments, member function, move, and the 8 MB stack on macOS).

## Already here

- `Util/AtomicSharedPtr.h` and the Apple ld64 link list for the bot module (#91, our version differs in detail but does the same).
- SpellDuration.db2 with `DurationPerLevel` (layout `0x4FDF0951`): `78258603b3` for 70790; the same layout as their 70707 change.

## Left out

- Log text in `WorldBotSpawner.cpp` that points at their `macos/install.sh` script: we don't ship it.
- Their macOS install, menu, uninstall and packaging scripts and the macOS release workflow: they build and run a home server
  from their overlay, not our tree.
- The macOS client key-setter (`macos/forever_client.py`, `macos/forever_inject.c`): client side, reviewed against our launcher
  separately.
