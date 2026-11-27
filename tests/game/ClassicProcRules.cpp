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

// advocaite/TrinityCore#325 and our filters on top. Spell ids, enchantments and SpellClassOptions masks are the 1.60.1.70862
// client's (wago.tools DB2 export of that build).

#include "tc_catch2.h"
#include "ClassicProcRules.h"

using ClassicProcRules::ProcEvent;
using ClassicProcRules::TalentProcMatches;

namespace
{
    ProcEvent SpellHit(uint32 family, flag128 flags, uint32 schoolMask = SPELL_SCHOOL_MASK_NORMAL)
    {
        ProcEvent event;
        event.SpellFamily = family;
        event.SpellFamilyFlags = flags;
        event.SchoolMask = schoolMask;
        event.Damage = true;
        return event;
    }

    ProcEvent MeleeSwingTaken(bool blocked, bool critical)
    {
        ProcEvent event;
        event.SchoolMask = SPELL_SCHOOL_MASK_NORMAL;
        event.Blocked = blocked;
        event.Critical = critical;
        event.Damage = true;
        return event;
    }
}

TEST_CASE("Flametongue Weapon: every rank's enchantment names its proc spell", "[ClassicProcRules]")
{
    CHECK(ClassicProcRules::FlametongueRankSpell(5) == 8026);
    CHECK(ClassicProcRules::FlametongueRankSpell(4) == 8028);
    CHECK(ClassicProcRules::FlametongueRankSpell(3) == 8029);
    CHECK(ClassicProcRules::FlametongueRankSpell(523) == 10445);
    CHECK(ClassicProcRules::FlametongueRankSpell(1665) == 16343);
    CHECK(ClassicProcRules::FlametongueRankSpell(1666) == 16344);
    CHECK(ClassicProcRules::FlametongueRankSpell(7567) == 16344);
    CHECK(ClassicProcRules::FlametongueRankSpell(283) == 0);    // a Windfury enchantment
}

TEST_CASE("Flametongue Weapon: damage is the rank's points / 100 per second of weapon speed", "[ClassicProcRules]")
{
    // tooltip of 8024 at rank 1 (8026: 326): $8026m1/77 to $8026m1/25, i.e. 1.3 s to 4.0 s weapons
    CHECK(ClassicProcRules::FlametongueDamage(326.0f, 1300) == 4);
    CHECK(ClassicProcRules::FlametongueDamage(326.0f, 4000) == 13);
    // at level 16 the points are 326 + 6 * 19 = 440
    CHECK(ClassicProcRules::FlametongueDamage(440.0f, 2600) == 11);
    CHECK(ClassicProcRules::FlametongueDamage(0.0f, 1300) == 1);
}

TEST_CASE("Windfury Weapon: every rank's enchantment names its attack spell", "[ClassicProcRules]")
{
    CHECK(ClassicProcRules::WindfuryRankSpell(283) == 8233);
    CHECK(ClassicProcRules::WindfuryRankSpell(284) == 8236);
    CHECK(ClassicProcRules::WindfuryRankSpell(525) == 10484);
    CHECK(ClassicProcRules::WindfuryRankSpell(1669) == 16361);
    CHECK(ClassicProcRules::WindfuryRankSpell(7569) == 16361);
    CHECK(ClassicProcRules::WindfuryRankSpell(5) == 0);         // a Flametongue enchantment
}

TEST_CASE("Talent chance: the effect the tooltip reads", "[ClassicProcRules]")
{
    CHECK(ClassicProcRules::TalentChanceEffect(13754) == EFFECT_0);    // Improved Kick: $m1
    CHECK(ClassicProcRules::TalentChanceEffect(11213) == EFFECT_0);    // Arcane Concentration: $m1
    CHECK(ClassicProcRules::TalentChanceEffect(11180) == EFFECT_1);    // Winter's Chill: $m2
    CHECK(ClassicProcRules::TalentChanceEffect(12298) == EFFECT_1);    // Shield Specialization: $m2
    CHECK(ClassicProcRules::TalentChanceEffect(1224716) == EFFECT_1);  // Puncturing Wounds: $m2
}

TEST_CASE("Talents that name one spell proc only from it", "[ClassicProcRules]")
{
    flag128 const kick(0x10), sinisterStrike(0x800002), backstab(0x800004), ambush(0x800200);
    CHECK(TalentProcMatches(13754, SpellHit(SPELLFAMILY_ROGUE, kick)));              // Improved Kick
    CHECK_FALSE(TalentProcMatches(13754, SpellHit(SPELLFAMILY_ROGUE, sinisterStrike)));
    CHECK(TalentProcMatches(1224716, SpellHit(SPELLFAMILY_ROGUE, backstab)));        // Puncturing Wounds
    CHECK_FALSE(TalentProcMatches(1224716, SpellHit(SPELLFAMILY_ROGUE, ambush)));
    CHECK(TalentProcMatches(13976, SpellHit(SPELLFAMILY_ROGUE, ambush)));            // Initiative
    CHECK_FALSE(TalentProcMatches(13976, SpellHit(SPELLFAMILY_ROGUE, sinisterStrike)));

    CHECK(TalentProcMatches(12311, SpellHit(SPELLFAMILY_WARRIOR, flag128(0x800))));  // Improved Shield Bash: Shield Bash
    CHECK_FALSE(TalentProcMatches(12311, SpellHit(SPELLFAMILY_WARRIOR, flag128(0x40))));  // Heroic Strike
    CHECK(TalentProcMatches(12289, SpellHit(SPELLFAMILY_WARRIOR, flag128(0x2))));    // Improved Hamstring: Hamstring
    CHECK_FALSE(TalentProcMatches(12289, SpellHit(SPELLFAMILY_WARRIOR, flag128(0x40))));

    CHECK(TalentProcMatches(19407, SpellHit(SPELLFAMILY_HUNTER, flag128(0x200))));   // Improved Concussive Shot
    CHECK_FALSE(TalentProcMatches(19407, SpellHit(SPELLFAMILY_HUNTER, flag128(0x800))));  // Arcane Shot
    CHECK(TalentProcMatches(19228, SpellHit(SPELLFAMILY_HUNTER, flag128(0x40))));    // Improved Wing Clip
    CHECK_FALSE(TalentProcMatches(19228, SpellHit(SPELLFAMILY_HUNTER, flag128(0x800))));

    CHECK(TalentProcMatches(16850, SpellHit(SPELLFAMILY_DRUID, flag128(0x4), SPELL_SCHOOL_MASK_ARCANE)));   // Improved Starfire
    CHECK_FALSE(TalentProcMatches(16850, SpellHit(SPELLFAMILY_DRUID, flag128(0x1), SPELL_SCHOOL_MASK_NATURE)));  // Wrath
    CHECK(TalentProcMatches(18119, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x200, 0x800000), SPELL_SCHOOL_MASK_FIRE)));  // Aftermath: Conflagrate
    CHECK_FALSE(TalentProcMatches(18119, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x4), SPELL_SCHOOL_MASK_FIRE)));        // Immolate
    CHECK(TalentProcMatches(11180, SpellHit(SPELLFAMILY_MAGE, flag128(0x40180020), SPELL_SCHOOL_MASK_FROST)));  // Winter's Chill: Frostbolt
    CHECK_FALSE(TalentProcMatches(11180, SpellHit(SPELLFAMILY_MAGE, flag128(0x180200), SPELL_SCHOOL_MASK_FROST)));  // Cone of Cold

    // a spell of another class with the same bits does not count
    CHECK_FALSE(TalentProcMatches(13754, SpellHit(SPELLFAMILY_WARRIOR, kick)));
    // nor a melee swing
    CHECK_FALSE(TalentProcMatches(13754, MeleeSwingTaken(false, false)));
}

TEST_CASE("Nightfall: Corruption, Drain Life, Drain Soul and Wrack, not Shadow Bolt", "[ClassicProcRules]")
{
    CHECK(TalentProcMatches(18094, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x2), SPELL_SCHOOL_MASK_SHADOW)));        // Corruption
    CHECK(TalentProcMatches(18094, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x8), SPELL_SCHOOL_MASK_SHADOW)));        // Drain Life
    CHECK(TalentProcMatches(18094, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x4000), SPELL_SCHOOL_MASK_SHADOW)));     // Drain Soul
    CHECK(TalentProcMatches(18094, SpellHit(SPELLFAMILY_WARLOCK, flag128(0, 0x40000), SPELL_SCHOOL_MASK_SHADOW))); // Wrack
    CHECK_FALSE(TalentProcMatches(18094, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x1), SPELL_SCHOOL_MASK_SHADOW)));  // Shadow Bolt
    CHECK_FALSE(TalentProcMatches(18094, SpellHit(SPELLFAMILY_WARLOCK, flag128(0x4), SPELL_SCHOOL_MASK_FIRE)));    // Immolate
}

TEST_CASE("Talents that name a hit result or a school", "[ClassicProcRules]")
{
    // Shield Specialization (warrior 12298, paladin 20150): a block, not any hit taken
    CHECK(TalentProcMatches(12298, MeleeSwingTaken(true, false)));
    CHECK_FALSE(TalentProcMatches(12298, MeleeSwingTaken(false, false)));
    CHECK(TalentProcMatches(20150, MeleeSwingTaken(true, false)));
    CHECK_FALSE(TalentProcMatches(20150, MeleeSwingTaken(false, true)));

    // Martyrdom: a critical strike taken
    CHECK(TalentProcMatches(14531, MeleeSwingTaken(false, true)));
    CHECK_FALSE(TalentProcMatches(14531, MeleeSwingTaken(false, false)));

    // Illumination: a critical Flash of Light / Holy Light / Holy Shock / Light's Vigil heal
    ProcEvent flashOfLight = SpellHit(SPELLFAMILY_PALADIN, flag128(0x40002000), SPELL_SCHOOL_MASK_HOLY);
    CHECK_FALSE(TalentProcMatches(20210, flashOfLight));
    flashOfLight.Critical = true;
    CHECK(TalentProcMatches(20210, flashOfLight));
    ProcEvent lightsVigil = SpellHit(SPELLFAMILY_PALADIN, flag128(0, 0, 0, 0x4000000), SPELL_SCHOOL_MASK_HOLY);
    lightsVigil.Critical = true;
    CHECK(TalentProcMatches(20210, lightsVigil));

    // Shadow Weaving and Blackout: Shadow damage spells; Impact: Fire spells
    CHECK(TalentProcMatches(15257, SpellHit(SPELLFAMILY_PRIEST, flag128(0x2000), SPELL_SCHOOL_MASK_SHADOW)));    // Mind Blast
    CHECK_FALSE(TalentProcMatches(15326, SpellHit(SPELLFAMILY_PRIEST, flag128(0x80), SPELL_SCHOOL_MASK_HOLY)));  // Smite
    CHECK(TalentProcMatches(11103, SpellHit(SPELLFAMILY_MAGE, flag128(0x40000001), SPELL_SCHOOL_MASK_FIRE)));    // Fireball
    CHECK_FALSE(TalentProcMatches(11103, SpellHit(SPELLFAMILY_MAGE, flag128(0x40180020), SPELL_SCHOOL_MASK_FROST)));

    // Elemental Focus: Fire, Frost or Nature damage spells of the shaman
    CHECK(TalentProcMatches(16164, SpellHit(SPELLFAMILY_SHAMAN, flag128(0x1), SPELL_SCHOOL_MASK_NATURE)));       // Lightning Bolt
    CHECK_FALSE(TalentProcMatches(16164, SpellHit(SPELLFAMILY_SHAMAN, flag128(0x1), SPELL_SCHOOL_MASK_NORMAL)));

    // Searing Light: Holy Fire's periodic damage, not its direct hit
    ProcEvent holyFire = SpellHit(SPELLFAMILY_PRIEST, flag128(0x100000), SPELL_SCHOOL_MASK_HOLY);
    CHECK_FALSE(TalentProcMatches(14909, holyFire));
    holyFire.Periodic = true;
    CHECK(TalentProcMatches(14909, holyFire));

    // Ruthlessness: finishing moves
    ProcEvent eviscerate = SpellHit(SPELLFAMILY_ROGUE, flag128(0x820000));
    CHECK_FALSE(TalentProcMatches(14156, eviscerate));
    eviscerate.FinishingMove = true;
    CHECK(TalentProcMatches(14156, eviscerate));

    // Frostbite: Chill effects
    ProcEvent coneOfCold = SpellHit(SPELLFAMILY_MAGE, flag128(0x180200), SPELL_SCHOOL_MASK_FROST);
    CHECK_FALSE(TalentProcMatches(11071, coneOfCold));
    coneOfCold.Chill = true;
    CHECK(TalentProcMatches(11071, coneOfCold));
}

TEST_CASE("Talents without a spell in their tooltip keep every event of their proc flags", "[ClassicProcRules]")
{
    CHECK(TalentProcMatches(12322, MeleeSwingTaken(false, false)));   // Unbridled Wrath (proc flags: melee swings)
    CHECK(TalentProcMatches(15270, ProcEvent()));                     // Spirit Tap (proc flags: kills)
}

TEST_CASE("Missile Barrage: Arcane Blast full chance, four spells half, the rest none", "[ClassicProcRules]")
{
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_MAGE, flag128(0x60000000), 40.0f) == 40.0f);               // Arcane Blast
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_MAGE, flag128(0x40000000, 0x8000), 40.0f) == 20.0f);       // Arcane Wrath
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_MAGE, flag128(0x40000001), 40.0f) == 20.0f);               // Fireball
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_MAGE, flag128(0x40180020), 40.0f) == 20.0f);               // Frostbolt
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_MAGE, flag128(0x40100000, 0x1000, 0x8), 40.0f) == 20.0f);  // Frostfire Bolt
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_MAGE, flag128(0x40800), 40.0f) == 0.0f);                   // Arcane Missiles
    CHECK(ClassicProcRules::MissileBarrageChance(SPELLFAMILY_WARLOCK, flag128(0x40000001), 40.0f) == 0.0f);
}

TEST_CASE("Reckoning: a block once per 1.5 s, a critical hit taken at 2.5 times the chance", "[ClassicProcRules]")
{
    bool fromBlock = false;
    CHECK(ClassicProcRules::ReckoningChance(MeleeSwingTaken(true, false), 10000, 0, 4.0f, fromBlock) == 4.0f);
    CHECK(fromBlock);
    CHECK(ClassicProcRules::ReckoningChance(MeleeSwingTaken(true, false), 11000, 10000, 4.0f, fromBlock) == 0.0f);
    CHECK(ClassicProcRules::ReckoningChance(MeleeSwingTaken(true, false), 11500, 10000, 4.0f, fromBlock) == 4.0f);

    // the block cooldown does not hold back a critical hit
    CHECK(ClassicProcRules::ReckoningChance(MeleeSwingTaken(false, true), 10500, 10000, 4.0f, fromBlock) == 10.0f);
    CHECK_FALSE(fromBlock);
    CHECK(ClassicProcRules::ReckoningChance(MeleeSwingTaken(false, false), 10500, 0, 4.0f, fromBlock) == 0.0f);
}
