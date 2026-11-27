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

// TrinityCore 7b7de79d54 finds Auto Shot by its class flags (hunter family, mask 0x1, auto repeat) instead of id 75.
// In the 1.60.1.70862 client two spells match: Auto Shot 75 and Auto Shot 413446; the wand's Shoot (5019, auto repeat,
// no class family) must not, or it would stop breaking on other casts like Auto Shot does.

#include "tc_catch2.h"
#include "DB2Structure.h"
#include "SpellInfo.h"

namespace
{
struct TestSpell
{
    SpellNameEntry Name{};
    SpellInfo Info;

    TestSpell(uint32 family, uint32 mask0, bool autoRepeat) : Info(&Name, DIFFICULTY_NONE, std::vector<SpellEffectEntry>{ SpellEffectEntry{} })
    {
        Info.SpellFamilyName = family;
        Info.SpellFamilyFlags = flag128(mask0, 0, 0, 0);
        if (autoRepeat)
            Info.AttributesEx2 |= SPELL_ATTR2_AUTO_REPEAT;
    }
};
}

TEST_CASE("Auto Shot is the hunter auto repeat spell with class flag 0x1", "[AutoShotSpell]")
{
    // 75 and 413446 "Auto Shot" in 70862: SpellClassSet 9, SpellClassMask_0 0x1, Attributes_2 has 0x20
    TestSpell autoShot(SPELLFAMILY_HUNTER, 0x1, true);
    CHECK(autoShot.Info.IsAutoShot());
}

TEST_CASE("Wand Shoot and other auto repeat spells are not Auto Shot", "[AutoShotSpell]")
{
    // 5019 "Shoot" in 70862: no class family, auto repeat
    TestSpell wand(SPELLFAMILY_GENERIC, 0, true);
    CHECK_FALSE(wand.Info.IsAutoShot());

    TestSpell otherHunterAutoRepeat(SPELLFAMILY_HUNTER, 0x2, true);
    CHECK_FALSE(otherHunterAutoRepeat.Info.IsAutoShot());
}

TEST_CASE("A hunter spell with class flag 0x1 that does not repeat is not Auto Shot", "[AutoShotSpell]")
{
    TestSpell notRepeating(SPELLFAMILY_HUNTER, 0x1, false);
    CHECK_FALSE(notRepeating.Info.IsAutoShot());
}
