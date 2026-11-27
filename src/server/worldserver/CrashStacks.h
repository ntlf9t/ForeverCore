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


#ifndef TRINITY_CRASHSTACKS_H
#define TRINITY_CRASHSTACKS_H

// Stack traces for Linux crashes. Without them a segfault or an ABORT left only the kernel's one-line "segfault at ..."
// (no core dumps in the container), so the calling code had to be guessed from the faulting function alone.
namespace CrashStacks
{
    // Print the crashing thread's stack to stderr on SIGSEGV, SIGBUS, SIGFPE and SIGILL, then let the crash go on as before
    // (the handler resets itself and returns, the fault repeats and the kernel still logs it). Call once, early in main.
    void Install();

    // Call from the world thread before the world loop: the freeze detector can then ask it for its stack.
    void RegisterWorldThread();

    // Called by the freeze detector before it forces a crash: the world thread prints its own stack (where it is stuck).
    // Waits up to waitMs for it. Does nothing when no world thread was registered.
    void DumpWorldThreadStack(unsigned waitMs);
}

#endif // TRINITY_CRASHSTACKS_H
