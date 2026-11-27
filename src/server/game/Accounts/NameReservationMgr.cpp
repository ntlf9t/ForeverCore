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

#include "NameReservationMgr.h"
#include "CharacterCache.h"
#include "Config.h"
#include "DatabaseEnv.h"
#include "FullName.h"
#include "Log.h"
#include "RealmList.h"
#include "StringFormat.h"
#include <algorithm>

namespace
{
    std::string Escaped(std::string const& value)
    {
        std::string escaped = value;
        LoginDatabase.EscapeString(escaped);
        return escaped;
    }

    uint32 CurrentRealm()
    {
        return sRealmList->GetCurrentRealmId().Realm;
    }

    // The full name a reservation is for: name (normalised, compared byte for byte) + surname (compared without regard to
    // case by its column's collation, as characters.surname is)
    std::string FullNameWhere(char const* table, std::string const& escapedName, std::string const& escapedSurname)
    {
        return Trinity::StringFormat("{0}.`name` = '{1}' AND {0}.`surname` = '{2}'", table, escapedName, escapedSurname);
    }

    // a character row uses reservation r
    constexpr char const* UsedBy = "EXISTS (SELECT 1 FROM `name_reservation_character` c WHERE c.`name` = r.`name` AND c.`surname` = r.`surname`)";

    // Frees a full name (sets freed_at) when no character on any realm uses it any more
    void AppendFreeIfUnused(LoginDatabaseTransaction& trans, std::string const& escapedName, std::string const& escapedSurname)
    {
        trans->PAppend("UPDATE `name_reservation` r SET r.`freed_at` = NOW() WHERE {} AND r.`freed_at` IS NULL AND NOT {}",
            FullNameWhere("r", escapedName, escapedSurname), UsedBy);
    }
}

NameReservationMgr* NameReservationMgr::instance()
{
    static NameReservationMgr instance;
    return &instance;
}

bool NameReservationMgr::IsEnabled() const
{
    return sConfigMgr->GetBoolDefault("NameReservation.Enable", true);
}

time_t NameReservationMgr::GetGracePeriod() const
{
    return time_t(std::max(0, sConfigMgr->GetIntDefault("NameReservation.GracePeriod", 90 * 24 * 3600)));
}

bool NameReservationMgr::EnsureTables()
{
    if (_tablesChecked)
        return true;

    QueryResult result = LoginDatabase.Query("SELECT COUNT(*) FROM information_schema.TABLES WHERE TABLE_SCHEMA = DATABASE() "
        "AND TABLE_NAME IN ('name_reservation', 'name_reservation_character')");
    if (result && (*result)[0].GetUInt64() == 2)
    {
        _tablesChecked = true;
        return true;
    }

    TC_LOG_ERROR("server.loading", "NameReservation.Enable = 1 but the login database has no name_reservation tables: "
        "character names are refused until sql/everlake/2026_11_07_09_auth_name_reservation.sql is applied "
        "(or NameReservation.Enable = 0).");
    return false;
}

bool NameReservationMgr::ReadRow(std::string const& escapedName, std::string const& escapedSurname, NameReservation::Row& row, time_t& created, time_t& now)
{
    QueryResult result = LoginDatabase.PQuery("SELECT r.`battlenet_account`, IFNULL(UNIX_TIMESTAMP(r.`freed_at`), 0), "
        "UNIX_TIMESTAMP(r.`created`), (SELECT COUNT(*) FROM `name_reservation_character` c WHERE c.`name` = r.`name` AND c.`surname` = r.`surname`), "
        "UNIX_TIMESTAMP() FROM `name_reservation` r WHERE {}", FullNameWhere("r", escapedName, escapedSurname));

    row = NameReservation::Row();
    created = 0;
    now = 0;
    if (!result)
        return false;

    Field* fields = result->Fetch();
    row.Exists = true;
    row.Owner = fields[0].GetUInt32();
    row.FreedAt = time_t(fields[1].GetUInt64());
    created = time_t(fields[2].GetUInt64());
    row.Users = uint32(fields[3].GetUInt64());
    now = time_t(fields[4].GetUInt64());
    return true;
}

NameReservationMgr::Result NameReservationMgr::Reserve(std::string const& name, std::string const& surname, uint32 gameAccountId, uint32 bnetAccountId, Ticket& ticket)
{
    ticket = Ticket();
    ticket.Name = name;
    ticket.Surname = surname;
    ticket.Account = bnetAccountId;

    if (!IsEnabled() || IsExempt(gameAccountId))
    {
        ticket.Skipped = true;
        return Result::Reserved;
    }

    // every player account belongs to a Battle.net account; one without has no identity to reserve for
    if (!bnetAccountId)
    {
        TC_LOG_ERROR("entities.player.character", "NameReservation: no Battle.net account for a character named {} {}: refused", name, surname);
        return Result::Error;
    }

    if (!EnsureTables())
        return Result::Error;

    std::string escapedName = Escaped(name);
    std::string escapedSurname = Escaped(surname);
    NameReservation::Row row;
    time_t created = 0, now = 0;
    ReadRow(escapedName, escapedSurname, row, created, now);

    ticket.Claim = NameReservation::Evaluate(row, bnetAccountId, now, GetGracePeriod());
    ticket.PrevOwner = row.Owner;
    ticket.PrevFreedAt = row.FreedAt;
    ticket.PrevCreated = created;

    switch (ticket.Claim)
    {
        case NameReservation::Claim::Free:
            // the primary key decides between two realms inserting at once: the loser's insert is ignored
            LoginDatabase.DirectPExecute("INSERT IGNORE INTO `name_reservation` (`name`, `surname`, `battlenet_account`, `created`) VALUES ('{}', '{}', {}, NOW())",
                escapedName, escapedSurname, bnetAccountId);
            ticket.Changed = true;
            break;
        case NameReservation::Claim::Own:
            if (row.FreedAt)
            {
                LoginDatabase.DirectPExecute("UPDATE `name_reservation` r SET r.`freed_at` = NULL WHERE {} AND r.`battlenet_account` = {}",
                    FullNameWhere("r", escapedName, escapedSurname), bnetAccountId);
                ticket.Changed = true;
            }
            break;
        case NameReservation::Claim::Expired:
            // compare-and-set on the row as read: only one realm's takeover matches
            LoginDatabase.DirectPExecute("UPDATE `name_reservation` r SET r.`battlenet_account` = {}, r.`created` = NOW(), r.`freed_at` = NULL "
                "WHERE {} AND r.`battlenet_account` = {} AND UNIX_TIMESTAMP(r.`freed_at`) = {}",
                bnetAccountId, FullNameWhere("r", escapedName, escapedSurname), row.Owner, uint64(row.FreedAt));
            ticket.Changed = true;
            break;
        case NameReservation::Claim::Taken:
            return Result::Taken;
    }

    // read back: whoever's write landed owns the row
    NameReservation::Row after;
    if (!ReadRow(escapedName, escapedSurname, after, created, now))
    {
        TC_LOG_ERROR("entities.player.character", "NameReservation: the row for {} {} is missing after reserving it: refused", name, surname);
        ticket.Changed = false;
        return Result::Error;
    }

    if (after.Owner != bnetAccountId || after.FreedAt != 0)
    {
        ticket.Changed = false;     // another realm won the race; our write did not apply
        return Result::Taken;
    }

    return Result::Reserved;
}

void NameReservationMgr::Rollback(Ticket const& ticket)
{
    if (!ticket.Changed || !IsEnabled())
        return;

    std::string const fullName = FullNameWhere("r", Escaped(ticket.Name), Escaped(ticket.Surname));
    std::string const unused = Trinity::StringFormat("NOT {}", UsedBy);
    switch (ticket.Claim)
    {
        case NameReservation::Claim::Free:
            LoginDatabase.DirectPExecute("DELETE r FROM `name_reservation` r WHERE {} AND r.`battlenet_account` = {} "
                "AND r.`freed_at` IS NULL AND {}", fullName, ticket.Account, unused);
            break;
        case NameReservation::Claim::Own:
            LoginDatabase.DirectPExecute("UPDATE `name_reservation` r SET r.`freed_at` = FROM_UNIXTIME({}) WHERE {} "
                "AND r.`battlenet_account` = {} AND r.`freed_at` IS NULL AND {}", uint64(ticket.PrevFreedAt), fullName, ticket.Account, unused);
            break;
        case NameReservation::Claim::Expired:
            LoginDatabase.DirectPExecute("UPDATE `name_reservation` r SET r.`battlenet_account` = {}, r.`created` = FROM_UNIXTIME({}), "
                "r.`freed_at` = FROM_UNIXTIME({}) WHERE {} AND r.`battlenet_account` = {} AND r.`freed_at` IS NULL AND {}",
                ticket.PrevOwner, uint64(ticket.PrevCreated), uint64(ticket.PrevFreedAt), fullName, ticket.Account, unused);
            break;
        default:
            break;
    }

    TC_LOG_INFO("entities.player.character", "NameReservation: {} {} released again (the character was not saved)", ticket.Name, ticket.Surname);
}

void NameReservationMgr::Attach(std::string const& name, std::string const& surname, uint32 gameAccountId, uint32 bnetAccountId, ObjectGuid::LowType guid)
{
    if (!IsEnabled() || !bnetAccountId || IsExempt(gameAccountId) || !EnsureTables())
        return;

    uint32 realm = CurrentRealm();
    std::string escapedName = Escaped(name);
    std::string escapedSurname = Escaped(surname);

    bool hadPrevious = false;
    std::string previousName, previousSurname;
    if (QueryResult result = LoginDatabase.PQuery("SELECT `name`, `surname` FROM `name_reservation_character` WHERE `realm_id` = {} AND `character_guid` = {}",
        realm, guid))
    {
        hadPrevious = true;
        previousName = (*result)[0].GetString();
        previousSurname = (*result)[1].GetString();
    }

    LoginDatabaseTransaction trans = LoginDatabase.BeginTransaction();
    // the row exists (Reserve); the insert only covers a rollback by a concurrent failed create of the same account.
    // Columns change only while the row is this account's.
    trans->PAppend("INSERT INTO `name_reservation` (`name`, `surname`, `battlenet_account`, `realm_id`, `character_guid`, `created`) "
        "VALUES ('{0}', '{1}', {2}, {3}, {4}, NOW()) ON DUPLICATE KEY UPDATE "
        "`realm_id` = IF(`battlenet_account` = {2}, VALUES(`realm_id`), `realm_id`), "
        "`character_guid` = IF(`battlenet_account` = {2}, VALUES(`character_guid`), `character_guid`), "
        "`freed_at` = IF(`battlenet_account` = {2}, NULL, `freed_at`)",
        escapedName, escapedSurname, bnetAccountId, realm, guid);
    trans->PAppend("REPLACE INTO `name_reservation_character` (`realm_id`, `character_guid`, `name`, `surname`) VALUES ({}, {}, '{}', '{}')",
        realm, guid, escapedName, escapedSurname);
    // a new full name (a rename, or a new surname) frees the old one once no character uses it
    if (hadPrevious && (previousName != name || !Trinity::FullName::SurnameEquals(previousSurname, surname)))
        AppendFreeIfUnused(trans, Escaped(previousName), Escaped(previousSurname));
    LoginDatabase.CommitTransaction(trans);
}

void NameReservationMgr::Release(ObjectGuid::LowType guid)
{
    if (!IsEnabled() || !EnsureTables())
        return;

    uint32 realm = CurrentRealm();
    QueryResult result = LoginDatabase.PQuery("SELECT `name`, `surname` FROM `name_reservation_character` WHERE `realm_id` = {} AND `character_guid` = {}",
        realm, guid);
    if (!result)
        return;     // not reserved: a bot, or a character from before reservations (run the back-fill)

    std::string escapedName = Escaped((*result)[0].GetString());
    std::string escapedSurname = Escaped((*result)[1].GetString());
    LoginDatabaseTransaction trans = LoginDatabase.BeginTransaction();
    trans->PAppend("DELETE FROM `name_reservation_character` WHERE `realm_id` = {} AND `character_guid` = {}", realm, guid);
    AppendFreeIfUnused(trans, escapedName, escapedSurname);
    LoginDatabase.CommitTransaction(trans);
}

NameReservation::Claim NameReservationMgr::Check(std::string const& name, std::string const& surname, uint32 bnetAccountId)
{
    if (!IsEnabled())
        return NameReservation::Claim::Free;
    if (!EnsureTables())
        return NameReservation::Claim::Taken;

    // Always return one row, even for an unreserved name. A failed query must not look like a free name.
    QueryResult result = LoginDatabase.PQuery(
        "SELECT r.`battlenet_account`, IFNULL(UNIX_TIMESTAMP(r.`freed_at`), 0), "
        "(SELECT COUNT(*) FROM `name_reservation_character` c WHERE c.`name` = r.`name` AND c.`surname` = r.`surname`), "
        "clock.`now` FROM (SELECT UNIX_TIMESTAMP() AS `now`) clock LEFT JOIN `name_reservation` r ON {}",
        FullNameWhere("r", Escaped(name), Escaped(surname)));
    if (!result)
        return NameReservation::Claim::Taken;
    Field* fields = result->Fetch();
    NameReservation::Row row;
    row.Exists = !fields[0].IsNull();
    if (row.Exists)
    {
        row.Owner = fields[0].GetUInt32();
        row.FreedAt = time_t(fields[1].GetUInt64());
        row.Users = fields[2].GetUInt32();
    }
    return NameReservation::Evaluate(row, bnetAccountId, time_t(fields[3].GetUInt64()), GetGracePeriod());
}

std::unordered_set<std::string> NameReservationMgr::FindHeld(std::vector<std::string> const& names)
{
    std::unordered_set<std::string> held;
    if (!IsEnabled() || names.empty())
        return held;
    if (!EnsureTables())
        return { names.begin(), names.end() };

    time_t grace = GetGracePeriod();
    std::size_t constexpr batch = 500;
    for (std::size_t start = 0; start < names.size(); start += batch)
    {
        std::string list;
        for (std::size_t i = start; i < std::min(names.size(), start + batch); ++i)
        {
            if (!list.empty())
                list += ',';
            list += '\'' + Escaped(names[i]) + '\'';
        }

        // bots have no surname: the full names asked about are these names with an empty surname
        QueryResult result = LoginDatabase.PQuery("SELECT r.`name`, r.`battlenet_account`, IFNULL(UNIX_TIMESTAMP(r.`freed_at`), 0), "
            "(SELECT COUNT(*) FROM `name_reservation_character` c WHERE c.`name` = r.`name` AND c.`surname` = r.`surname`), UNIX_TIMESTAMP() "
            "FROM `name_reservation` r WHERE r.`name` IN ({}) AND r.`surname` = ''", list);
        if (!result)
            continue;

        do
        {
            Field* fields = result->Fetch();
            NameReservation::Row row;
            row.Exists = true;
            row.Owner = fields[1].GetUInt32();
            row.FreedAt = time_t(fields[2].GetUInt64());
            row.Users = uint32(fields[3].GetUInt64());
            if (!NameReservation::CanUse(NameReservation::Evaluate(row, 0, time_t(fields[4].GetUInt64()), grace)))
                held.insert(fields[0].GetString());
        } while (result->NextRow());
    }
    return held;
}

bool NameReservationMgr::TryYield(std::string const& name, std::string const& surname, uint32 bnetAccountId)
{
    if (!_yieldHandler)
        return false;

    // The character with exactly this full name; bot surnames participate in the same lookup.
    CharacterCacheEntry const* holderEntry = sCharacterCache->GetCharacterCacheByFullName(name, surname);
    if (!holderEntry)
        return false;
    ObjectGuid holder = holderEntry->Guid;

    // only for a player who could have the name: never rename a bot for someone who is refused anyway
    if (!NameReservation::CanUse(Check(name, surname, bnetAccountId)))
        return false;

    return _yieldHandler(holder, name);
}
