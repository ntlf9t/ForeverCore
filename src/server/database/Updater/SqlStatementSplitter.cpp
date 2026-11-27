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

#include "SqlStatementSplitter.h"
#include <cctype>
#include <string_view>

// splits SQL text at the `;` that end statements, skipping strings, quoted names and comments; whole statements only
std::vector<std::string> DBUpdaterSql::SplitStatements(std::string const& text)
{
    std::vector<std::string> statements;
    std::string current;
    std::string delimiter = ";";
    size_t i = 0;
    size_t const n = text.size();
    auto flush = [&]()
    {
        if (current.find_first_not_of(" \t\r\n") != std::string::npos)
            statements.push_back(current);
        current.clear();
    };
    auto isSpace = [](char c) { return c == ' ' || c == '\t' || c == '\r' || c == '\n'; };
    auto isBlank = [&]() { return current.find_first_not_of(" \t\r\n") == std::string::npos; };
    // the mysql command line client's DELIMITER command, at the start of a statement: `DELIMITER ;;` ... `END;;` ... `DELIMITER ;`
    static constexpr std::string_view delimiterKeyword = "DELIMITER";
    auto isDelimiterCommand = [&](size_t at)
    {
        size_t const length = delimiterKeyword.size();
        if (at + length >= n || !isSpace(text[at + length]) || text[at + length] == '\n')
            return false;
        for (size_t k = 0; k < length; ++k)
            if (std::toupper(static_cast<unsigned char>(text[at + k])) != delimiterKeyword[k])
                return false;
        return true;
    };
    while (i < n)
    {
        char const c = text[i];
        if (isBlank() && isDelimiterCommand(i))
        {
            size_t lineEnd = text.find('\n', i);
            if (lineEnd == std::string::npos)
                lineEnd = n;
            std::string_view argument(text.data() + i + delimiterKeyword.size(), lineEnd - i - delimiterKeyword.size());
            while (!argument.empty() && isSpace(argument.front()))
                argument.remove_prefix(1);
            while (!argument.empty() && isSpace(argument.back()))
                argument.remove_suffix(1);
            if (!argument.empty())
                delimiter.assign(argument);
            current.clear();
            i = lineEnd;
            continue;
        }
        // comments: `-- ` (or `--` at the end of the text), `#`, `/* */` (`/*!` version comments are kept as code)
        if (c == '-' && i + 1 < n && text[i + 1] == '-' && (i + 2 >= n || isSpace(text[i + 2])))
        {
            while (i < n && text[i] != '\n')
                ++i;
            continue;
        }
        if (c == '#')
        {
            while (i < n && text[i] != '\n')
                ++i;
            continue;
        }
        if (c == '/' && i + 1 < n && text[i + 1] == '*' && !(i + 2 < n && text[i + 2] == '!'))
        {
            i += 2;
            while (i + 1 < n && !(text[i] == '*' && text[i + 1] == '/'))
                ++i;
            i += 2;
            continue;
        }
        if (c == '\'' || c == '"' || c == '`')
        {
            char const quote = c;
            current += c;
            ++i;
            while (i < n)
            {
                char const d = text[i];
                current += d;
                ++i;
                if (d == '\\' && quote != '`' && i < n)
                {
                    current += text[i];
                    ++i;
                    continue;
                }
                if (d == quote)
                {
                    if (i < n && text[i] == quote)      // doubled quote inside the string
                    {
                        current += text[i];
                        ++i;
                        continue;
                    }
                    break;
                }
            }
            continue;
        }
        current += c;
        ++i;
        if (current.size() >= delimiter.size() && current.compare(current.size() - delimiter.size(), delimiter.size(), delimiter) == 0)
        {
            // the server knows only `;`: a statement written with another delimiter is sent with `;`
            if (delimiter != ";")
                current.replace(current.size() - delimiter.size(), delimiter.size(), ";");
            flush();
        }
    }
    flush();
    return statements;
}
