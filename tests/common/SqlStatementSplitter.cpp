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

// The DB updater runs update files over its own connection, cut into statements by DBUpdaterSql::SplitStatements.
// TrinityCore's files that create a procedure use the mysql client's DELIMITER command, which the server does not know.

#include "tc_catch2.h"
#include "SqlStatementSplitter.h"
#include <algorithm>
#include <string>
#include <vector>

namespace
{
std::string Trim(std::string const& s)
{
    size_t const begin = s.find_first_not_of(" \t\r\n");
    if (begin == std::string::npos)
        return {};
    return s.substr(begin, s.find_last_not_of(" \t\r\n") - begin + 1);
}

std::vector<std::string> Split(std::string const& text)
{
    std::vector<std::string> statements = DBUpdaterSql::SplitStatements(text);
    std::transform(statements.begin(), statements.end(), statements.begin(), Trim);
    return statements;
}
}

TEST_CASE("Statements end at ; outside strings, quoted names and comments", "[SqlStatementSplitter]")
{
    std::vector<std::string> const statements = Split(
        "-- a comment; with a semicolon\n"
        "DELETE FROM `a;b` WHERE `x` = 'it''s; fine';\n"
        "/* block; comment */ INSERT INTO t VALUES (\"q;\");\n"
        "UPDATE t SET x = 1 # trailing; comment\n"
        "WHERE y = 2;\n");
    REQUIRE(statements.size() == 3);
    CHECK(statements[0] == "DELETE FROM `a;b` WHERE `x` = 'it''s; fine';");
    CHECK(statements[1] == "INSERT INTO t VALUES (\"q;\");");
    CHECK(statements[2] == "UPDATE t SET x = 1 \nWHERE y = 2;");
}

TEST_CASE("DELIMITER lines are followed and not sent to the server", "[SqlStatementSplitter]")
{
    // TrinityCore 2026_10_05_00_characters.sql (ebc90650c6 + 511681f7b5), first part
    std::vector<std::string> const statements = Split(
        "DROP PROCEDURE IF EXISTS characters_2026_10_05_00;\n"
        "\n"
        "DELIMITER ;;\n"
        "CREATE PROCEDURE characters_2026_10_05_00() BEGIN\n"
        "  IF EXISTS (SELECT * FROM `information_schema`.`table_constraints` WHERE `constraint_schema`=SCHEMA() AND `constraint_type`='PRIMARY KEY' AND `table_name`='item_loot_items') THEN\n"
        "    ALTER TABLE `item_loot_items` DROP PRIMARY KEY;\n"
        "  END IF;\n"
        "END;;\n"
        "\n"
        "DELIMITER ;\n"
        "CALL characters_2026_10_05_00();\n"
        "\n"
        "DROP PROCEDURE IF EXISTS characters_2026_10_05_00;\n");

    REQUIRE(statements.size() == 4);
    CHECK(statements[0] == "DROP PROCEDURE IF EXISTS characters_2026_10_05_00;");
    CHECK(statements[1] ==
        "CREATE PROCEDURE characters_2026_10_05_00() BEGIN\n"
        "  IF EXISTS (SELECT * FROM `information_schema`.`table_constraints` WHERE `constraint_schema`=SCHEMA() AND `constraint_type`='PRIMARY KEY' AND `table_name`='item_loot_items') THEN\n"
        "    ALTER TABLE `item_loot_items` DROP PRIMARY KEY;\n"
        "  END IF;\n"
        "END;");
    CHECK(statements[2] == "CALL characters_2026_10_05_00();");
    CHECK(statements[3] == "DROP PROCEDURE IF EXISTS characters_2026_10_05_00;");
    for (std::string const& statement : statements)
        CHECK(statement.find("DELIMITER") == std::string::npos);
}

TEST_CASE("Any delimiter, any case, Windows line ends", "[SqlStatementSplitter]")
{
    std::vector<std::string> const statements = Split(
        "delimiter $$\r\n"
        "CREATE TRIGGER t BEFORE INSERT ON x FOR EACH ROW BEGIN SET NEW.a = 1; SET NEW.b = '$$'; END$$\r\n"
        "Delimiter ;\r\n"
        "SELECT 1;\r\n");
    REQUIRE(statements.size() == 2);
    CHECK(statements[0] == "CREATE TRIGGER t BEFORE INSERT ON x FOR EACH ROW BEGIN SET NEW.a = 1; SET NEW.b = '$$'; END;");
    CHECK(statements[1] == "SELECT 1;");
}

TEST_CASE("DELIMITER inside a statement or a string is not a command", "[SqlStatementSplitter]")
{
    std::vector<std::string> const statements = Split(
        "INSERT INTO t (c) VALUES ('DELIMITER ;;');\n"
        "UPDATE t SET c = 1 WHERE d =\n"
        "DELIMITER + 0;\n");
    REQUIRE(statements.size() == 2);
    CHECK(statements[0] == "INSERT INTO t (c) VALUES ('DELIMITER ;;');");
    CHECK(statements[1] == "UPDATE t SET c = 1 WHERE d =\nDELIMITER + 0;");
}
