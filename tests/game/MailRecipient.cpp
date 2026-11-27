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

#include "tc_catch2.h"
#include "MailRecipient.h"

using Trinity::Mail::SplitRecipient;

// advocaite/TrinityCore#275: the To box of the mail window. Before, the whole text was looked up as a character name.

TEST_CASE("A plain name is the name", "[MailRecipient]")
{
    auto recipient = SplitRecipient("Karrz", "Everlake");
    CHECK(recipient.Name == "Karrz");
    CHECK(recipient.Surname.empty());
}

TEST_CASE("Name Surname is split at the first space", "[MailRecipient]")
{
    auto recipient = SplitRecipient("Berle Youngfield", "Everlake");
    CHECK(recipient.Name == "Berle");
    CHECK(recipient.Surname == "Youngfield");

    recipient = SplitRecipient("Berle   Youngfield  ", "Everlake");
    CHECK(recipient.Name == "Berle");
    CHECK(recipient.Surname == "Youngfield");
}

TEST_CASE("This realm's -Realm suffix is dropped, spaces and case ignored", "[MailRecipient]")
{
    auto recipient = SplitRecipient("Karrz-Everlake", "Everlake");
    CHECK(recipient.Name == "Karrz");
    CHECK(recipient.Surname.empty());

    recipient = SplitRecipient("Berle Youngfield-EverlakeTwo", "Everlake Two");
    CHECK(recipient.Name == "Berle");
    CHECK(recipient.Surname == "Youngfield");

    recipient = SplitRecipient("Karrz-everlake", "Everlake");
    CHECK(recipient.Name == "Karrz");
}

TEST_CASE("Another realm's suffix is kept, so that recipient is not found", "[MailRecipient]")
{
    auto recipient = SplitRecipient("Karrz-Stormrage", "Everlake");
    CHECK(recipient.Name == "Karrz-Stormrage");
    CHECK(recipient.Surname.empty());

    // a hyphen inside a surname is not a realm suffix
    recipient = SplitRecipient("Berle Smith-Jones", "Everlake");
    CHECK(recipient.Name == "Berle");
    CHECK(recipient.Surname == "Smith-Jones");

    // no realm known: nothing is dropped
    recipient = SplitRecipient("Karrz-Everlake", "");
    CHECK(recipient.Name == "Karrz-Everlake");
}
