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


#include "CrashStacks.h"
#include "Define.h"

#if TRINITY_PLATFORM == TRINITY_PLATFORM_UNIX

#include <atomic>
#include <chrono>
#include <csignal>
#include <cstdio>
#include <thread>
#include <execinfo.h>
#include <pthread.h>
#include <unistd.h>

// start of the executable's image (linker symbol): frame address - image base = address in the binary (llvm-nm, objdump)
extern "C" char __executable_start;

namespace
{
    constexpr int WorldStackSignal = SIGUSR2;

    pthread_t WorldThread;
    std::atomic<bool> WorldThreadRegistered{ false };
    std::atomic<bool> WorldStackWritten{ false };

    // Only async-signal-safe calls (write, backtrace_symbols_fd; backtrace once libgcc is loaded, see Install).
    void WriteStack(char const* title)
    {
        char header[192];
        int length = std::snprintf(header, sizeof(header), "\n==== %s: thread %ld, image base %p ====\n", title,
            long(gettid()), static_cast<void*>(&__executable_start));
        if (length > 0)
        {
            [[maybe_unused]] ssize_t written = write(STDERR_FILENO, header, size_t(length));
        }

        void* frames[64];
        int count = backtrace(frames, 64);
        backtrace_symbols_fd(frames, count, STDERR_FILENO);

        static char const footer[] = "==== end of stack ====\n";
        [[maybe_unused]] ssize_t written = write(STDERR_FILENO, footer, sizeof(footer) - 1);
    }

    void FatalSignalHandler(int signalNumber)
    {
        char const* title = "Crash stack";
        switch (signalNumber)
        {
            case SIGSEGV: title = "Crash stack (SIGSEGV)"; break;
            case SIGBUS:  title = "Crash stack (SIGBUS)"; break;
            case SIGFPE:  title = "Crash stack (SIGFPE)"; break;
            case SIGILL:  title = "Crash stack (SIGILL)"; break;
            default: break;
        }
        WriteStack(title);
        // SA_RESETHAND put the default action back: returning repeats the faulting instruction, which now ends the process
        // the usual way (and the kernel logs it).
    }

    void WorldStackHandler(int /*signalNumber*/)
    {
        WriteStack("World thread stack (freeze detector)");
        WorldStackWritten.store(true);
    }
}

void CrashStacks::Install()
{
    // The first backtrace() loads libgcc_s (malloc + dlopen): do it now, never for the first time in a signal handler.
    void* warmUp[1];
    backtrace(warmUp, 1);

    struct sigaction fatal = {};
    fatal.sa_handler = &FatalSignalHandler;
    sigemptyset(&fatal.sa_mask);
    fatal.sa_flags = SA_RESETHAND | SA_NODEFER;
    for (int signalNumber : { SIGSEGV, SIGBUS, SIGFPE, SIGILL })
        sigaction(signalNumber, &fatal, nullptr);

    struct sigaction world = {};
    world.sa_handler = &WorldStackHandler;
    sigemptyset(&world.sa_mask);
    world.sa_flags = SA_RESTART;
    sigaction(WorldStackSignal, &world, nullptr);
}

void CrashStacks::RegisterWorldThread()
{
    WorldThread = pthread_self();
    WorldThreadRegistered.store(true);
}

void CrashStacks::DumpWorldThreadStack(unsigned waitMs)
{
    if (!WorldThreadRegistered.load())
        return;

    WorldStackWritten.store(false);
    if (pthread_kill(WorldThread, WorldStackSignal) != 0)
        return;

    for (unsigned waited = 0; waited < waitMs && !WorldStackWritten.load(); waited += 50)
        std::this_thread::sleep_for(std::chrono::milliseconds(50));
}

#else

void CrashStacks::Install() { }               // Windows: WheatyExceptionReport writes crash reports; macOS: not done
void CrashStacks::RegisterWorldThread() { }
void CrashStacks::DumpWorldThreadStack(unsigned /*waitMs*/) { }

#endif
