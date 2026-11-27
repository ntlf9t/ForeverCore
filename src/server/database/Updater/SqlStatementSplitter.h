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

#ifndef TRINITY_SQL_STATEMENT_SPLITTER_H
#define TRINITY_SQL_STATEMENT_SPLITTER_H

#include "Define.h"
#include <string>
#include <vector>

namespace DBUpdaterSql
{
    // Classic 1.60 fork: the files are run over our own MySQL connection (multi statements), not through the mysql command
    // line client. The client silently stopped reading some files (quotes in `--` comments) and, started from the
    // worldserver, sometimes ran nothing at all while exiting with success (2026-10-05). The file is cut into chunks at
    // statement ends (outside strings and comments).
    // Splits SQL text at the `;` that end statements, skipping strings, quoted names and comments; whole statements only.
    // `DELIMITER x` lines (the mysql command line client's command, used by TrinityCore files that create a procedure) are
    // followed and dropped: until the next one, statements end at x, and each is returned ending in `;`.
    TC_DATABASE_API std::vector<std::string> SplitStatements(std::string const& text);
}

#endif // TRINITY_SQL_STATEMENT_SPLITTER_H
