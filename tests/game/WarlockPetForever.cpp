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
#include "WarlockPetForever.h"

TEST_CASE("Demon spell damage and attack power come from the warlock's better school", "[WarlockPetForever]")
{
    WarlockPetForever::WarlockStats warlock;
    warlock.ShadowDamage = 500.0f;
    warlock.FireDamage = 300.0f;
    CHECK(WarlockPetForever::SpellDamage(warlock) == Catch::Approx(50.0f));   // 10% of 500
    CHECK(WarlockPetForever::AttackPower(warlock) == Catch::Approx(85.0f));   // 17% of 500

    warlock.FireDamage = 700.0f;                                               // a fire set makes Fire the source
    CHECK(WarlockPetForever::SpellDamage(warlock) == Catch::Approx(70.0f));

    warlock.ShadowDamage = -20.0f;
    warlock.FireDamage = -10.0f;                                               // never below 0
    CHECK(WarlockPetForever::SpellDamage(warlock) == Catch::Approx(0.0f));
    CHECK(WarlockPetForever::AttackPower(warlock) == Catch::Approx(0.0f));
}

TEST_CASE("Demon health, armor, regen and hit from the warlock", "[WarlockPetForever]")
{
    WarlockPetForever::WarlockStats warlock;
    warlock.Stamina = 250.0f;
    warlock.Intellect = 200.0f;
    warlock.Armor = 1000.0f;
    warlock.SpellHit = 8.5f;

    CHECK(WarlockPetForever::MaxHealth(warlock) == Catch::Approx(500.0f));
    CHECK(WarlockPetForever::Armor(warlock) == Catch::Approx(350.0f));
    CHECK(WarlockPetForever::ManaPer5(warlock, true) == Catch::Approx(60.0f));  // Imp: 30%
    CHECK(WarlockPetForever::ManaPer5(warlock, false) == Catch::Approx(20.0f)); // the others: 10%
    CHECK(WarlockPetForever::SpellHit(warlock) == Catch::Approx(8.5f));
    CHECK(WarlockPetForever::MeleeHit(warlock) == Catch::Approx(4.0f));         // 8/17 of it

    warlock.Armor = -50.0f;                                                       // stacked armor debuffs
    CHECK(WarlockPetForever::Armor(warlock) == Catch::Approx(0.0f));
}

TEST_CASE("Demon weapons and attack power follow the creature values", "[WarlockPetForever]")
{
    // EV-0075: a level 30 Sayaad (creature dps 24.69) swings about 27 to 42 before attack power
    CHECK(WarlockPetForever::MinDamage(WarlockPetForever::SayaadSwing, 24.69f) == Catch::Approx(27.06f).margin(0.05f));
    CHECK(WarlockPetForever::MaxDamage(WarlockPetForever::SayaadSwing, 24.69f) == Catch::Approx(41.88f).margin(0.05f));

    // EV-0076: a level 30 Voidwalker averages about 24.4 a swing before attack power and the halving
    float const average = (WarlockPetForever::MinDamage(WarlockPetForever::VoidwalkerSwing, 24.69f)
        + WarlockPetForever::MaxDamage(WarlockPetForever::VoidwalkerSwing, 24.69f)) / 2.0f;
    CHECK(average == Catch::Approx(24.39f).margin(0.05f));

    CHECK(WarlockPetForever::DemonSwing(WarlockPetForever::SayaadEntry) == &WarlockPetForever::SayaadSwing);
    CHECK(WarlockPetForever::DemonSwing(416) == nullptr);                 // the Imp keeps the old range

    CHECK(WarlockPetForever::DemonAttackPower(20) == Catch::Approx(66.0f));
    CHECK(WarlockPetForever::DemonAttackPower(30) == Catch::Approx(96.0f));
}
