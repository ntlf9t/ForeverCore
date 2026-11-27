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

#ifndef TRINITY_NAME_RESERVATION_MGR_H
#define TRINITY_NAME_RESERVATION_MGR_H

#include "Define.h"
#include "NameReservationRules.h"
#include "ObjectGuid.h"
#include <atomic>
#include <functional>
#include <string>
#include <unordered_set>
#include <vector>

// Everlake: a character's full name ("Ora Swiftwind") belongs to one Battle.net account on every realm that shares the
// login database. Only the full name is reserved: another account may still be "Ora Brightleaf". The name is the core's
// normalised form ("Ora"); the surname compares without regard to case, like characters.surname.
//
// auth.name_reservation holds one row per full name: the owning Battle.net account, the realm and character that used it
// last, when it was reserved and when it was freed. auth.name_reservation_character lists every character on every
// realm that uses a full name now.
//
// Character create, rename, customize, faction change, undelete and dump load call Reserve() before the character
// takes the name, then Attach() once it is saved (or Rollback() if it failed). Deleting a character calls Release():
// once no character on any realm uses the name, freed_at is set and other accounts may take it after the grace
// period (NameReservation.GracePeriod). Bots never reserve; see SetYieldHandler and docker/patches/playerbot/.
class TC_GAME_API NameReservationMgr
{
public:
    enum class Result : uint8
    {
        Reserved,   // the name is this account's now (or reservation is off)
        Taken,      // another account holds it: "name in use"
        Error       // the reservation tables are missing or the database failed: refuse, don't guess
    };

    // What Reserve() changed, so Rollback() can put it back
    struct Ticket
    {
        std::string Name;
        std::string Surname;
        uint32 Account = 0;
        NameReservation::Claim Claim = NameReservation::Claim::Taken;
        bool Changed = false;           // Reserve wrote to the row
        bool Skipped = false;           // reservation off, or an exempt (bot) account: nothing to attach
        uint32 PrevOwner = 0;
        time_t PrevFreedAt = 0;
        time_t PrevCreated = 0;
    };

    // True for a game account whose characters never reserve names (the bot module's pool accounts)
    using ExemptAccountCheck = std::function<bool(uint32 gameAccountId)>;
    // Asked when a character on this realm already has a name the player may claim. Returns true when it freed the
    // name on this realm (the bot module renames an offline bot). Without a handler nothing changes (stock behaviour).
    using YieldHandler = std::function<bool(ObjectGuid holder, std::string const& name)>;

    static NameReservationMgr* instance();

    bool IsEnabled() const;                 // NameReservation.Enable
    time_t GetGracePeriod() const;          // NameReservation.GracePeriod, seconds

    // Claims the full name `name` (normalised) + `surname` for `bnetAccountId` before a character takes it. Atomic across
    // realms: the row is written with a compare-and-set on its unique key and read back.
    // `gameAccountId` only decides whether the account is exempt (bots).
    Result Reserve(std::string const& name, std::string const& surname, uint32 gameAccountId, uint32 bnetAccountId, Ticket& ticket);
    // Undoes Reserve() when the character was not saved. Leaves the row alone if a character uses it meanwhile.
    void Rollback(Ticket const& ticket);
    // The character `guid` on this realm now uses the full name `name` + `surname`. A different full name it used before
    // is freed when no other character uses that one.
    void Attach(std::string const& name, std::string const& surname, uint32 gameAccountId, uint32 bnetAccountId, ObjectGuid::LowType guid);
    // The character `guid` on this realm is gone (deleted or unlinked). Its name is freed when no other character on
    // any realm uses it.
    void Release(ObjectGuid::LowType guid);

    // Read only: what Reserve() would answer. bnetAccountId 0 = a bot (only names nobody holds).
    NameReservation::Claim Check(std::string const& name, std::string const& surname, uint32 bnetAccountId);
    // Read only, many names at once (bots at start-up, which have no surname): the ones a bot may not use
    std::unordered_set<std::string> FindHeld(std::vector<std::string> const& names);

    void SetExemptAccountCheck(ExemptAccountCheck check) { _exemptAccountCheck = std::move(check); }
    bool IsExempt(uint32 gameAccountId) const { return _exemptAccountCheck && _exemptAccountCheck(gameAccountId); }
    void SetYieldHandler(YieldHandler handler) { _yieldHandler = std::move(handler); }
    // A character on this realm has the full name `name` + `surname`: if `bnetAccountId` could claim it and the yield
    // handler frees it, true
    bool TryYield(std::string const& name, std::string const& surname, uint32 bnetAccountId);

private:
    NameReservationMgr() = default;

    bool EnsureTables();
    bool ReadRow(std::string const& escapedName, std::string const& escapedSurname, NameReservation::Row& row, time_t& created, time_t& now);

    std::atomic<bool> _tablesChecked = false;
    ExemptAccountCheck _exemptAccountCheck;
    YieldHandler _yieldHandler;
};

#define sNameReservationMgr NameReservationMgr::instance()

// Holds a reservation until the character is saved: rolls it back when it goes out of scope without Commit()
class NameReservationGuard
{
public:
    NameReservationGuard() = default;
    NameReservationGuard(NameReservationGuard const&) = delete;
    NameReservationGuard& operator=(NameReservationGuard const&) = delete;
    ~NameReservationGuard() { if (_active) sNameReservationMgr->Rollback(_ticket); }

    NameReservationMgr::Result Reserve(std::string const& name, std::string const& surname, uint32 gameAccountId, uint32 bnetAccountId)
    {
        NameReservationMgr::Result result = sNameReservationMgr->Reserve(name, surname, gameAccountId, bnetAccountId, _ticket);
        _active = result == NameReservationMgr::Result::Reserved;
        return result;
    }
    void Commit() { _active = false; }
    NameReservationMgr::Ticket const& GetTicket() const { return _ticket; }

private:
    NameReservationMgr::Ticket _ticket;
    bool _active = false;
};

#endif
