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
#include "ClassicRage.h"

// WoW Forever rage, against the tenths read off Forever combat logs (magey/forever-warrior#3, wowsims/forever EV-0053).
TEST_CASE("Forever swing rage", "[ClassicRage]")
{
    using Catch::Approx;
    // one-handers: 3.46 x speed (1.6 dagger 55.4, 2.1 sword 72.8, 2.7 mace 93.4 tenths)
    REQUIRE(ClassicRage::SwingRage(1.6f, false, false, false) * 10.0f == Approx(55.4f).margin(0.1f));
    REQUIRE(ClassicRage::SwingRage(2.1f, false, false, false) * 10.0f == Approx(72.8f).margin(0.2f));
    REQUIRE(ClassicRage::SwingRage(2.7f, false, false, false) * 10.0f == Approx(93.4f).margin(0.1f));
    // two-handers: 4.5 x speed (3.2 sword 143.8, 3.0 sword 134.8 tenths)
    REQUIRE(ClassicRage::SwingRage(3.2f, false, true, false) * 10.0f == Approx(144.0f).margin(0.3f));
    REQUIRE(ClassicRage::SwingRage(3.0f, false, true, false) * 10.0f == Approx(135.0f).margin(0.3f));
    // off-hand: half the one-hand rate (1.9 sword 32.9, 1.6 27.7 tenths)
    REQUIRE(ClassicRage::SwingRage(1.9f, true, false, false) * 10.0f == Approx(32.9f).margin(0.1f));
    REQUIRE(ClassicRage::SwingRage(1.6f, true, false, false) * 10.0f == Approx(27.7f).margin(0.1f));
    // a crit doubles the whole swing, the two-hand factor and the off-hand halving included
    REQUIRE(ClassicRage::SwingRage(2.6f, false, false, true) == Approx(2.0f * ClassicRage::SwingRage(2.6f, false, false, false)));
    REQUIRE(ClassicRage::SwingRage(3.3f, false, true, true) == Approx(2.0f * ClassicRage::SwingRage(3.3f, false, true, false)));
    REQUIRE(ClassicRage::SwingRage(1.6f, true, false, true) * 10.0f == Approx(55.4f).margin(0.1f));
    // Dual Wield Specialization raises only the off-hand
    REQUIRE(ClassicRage::SwingRage(1.6f, true, false, false, 50.0f) == Approx(1.5f * ClassicRage::SwingRage(1.6f, true, false, false)));
    REQUIRE(ClassicRage::SwingRage(1.6f, false, false, false, 50.0f) == Approx(ClassicRage::SwingRage(1.6f, false, false, false)));
}

TEST_CASE("Forever rage from damage taken", "[ClassicRage]")
{
    using Catch::Approx;
    REQUIRE(ClassicRage::Conversion(60.0f) == Approx(230.6f).margin(0.1f));
    // the assumed armor follows the attacker's level: flat low, rising from 42, about 38% at 50-60
    REQUIRE(ClassicRage::AssumedArmorReduction(20.0f) == Approx(0.218f));
    REQUIRE(ClassicRage::AssumedArmorReduction(44.0f) == Approx(0.31f));
    REQUIRE(ClassicRage::AssumedArmorReduction(45.0f) == Approx(0.335f));
    REQUIRE(ClassicRage::AssumedArmorReduction(60.0f) == Approx(0.385f));
    REQUIRE(ClassicRage::AssumedArmorReduction(70.0f) == Approx(0.40f));
    // k = 2.5 x (1 - A): 1.955 at levels 19-38 (measured 1.960 over 3,702 swings)
    float const k = ClassicRage::RageFromDamageTaken(100.0f, 30.0f) * ClassicRage::Conversion(30.0f) / 100.0f;
    REQUIRE(k == Approx(1.955f).margin(0.001f));
    // spells / ticks / specials x2, mana and energy attackers x0.5
    REQUIRE(ClassicRage::RageFromDamageTaken(100.0f, 30.0f, ClassicRage::NonSwingTakenMultiplier) == Approx(2.0f * ClassicRage::RageFromDamageTaken(100.0f, 30.0f)));
    REQUIRE(ClassicRage::RageFromDamageTaken(100.0f, 30.0f, ClassicRage::NonRageAttackerMultiplier) == Approx(0.5f * ClassicRage::RageFromDamageTaken(100.0f, 30.0f)));
}
