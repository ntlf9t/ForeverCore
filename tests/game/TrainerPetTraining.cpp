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
#include "DB2Structure.h"
#include "SpellInfo.h"
#include "Trainer.h"
#include <unordered_set>

// advocaite/TrinityCore#113: a trainer casts a LEARN_SPELL spell on the player, except a pet training spell, which the hunter
// learns. Rows below are the Forever client's (build 70862, SpellEffect.db2).
namespace
{
    SpellEffectEntry Effect(int32 index, SpellEffects effect, int32 triggerSpell)
    {
        SpellEffectEntry entry{};
        entry.EffectIndex = index;
        entry.Effect = effect;
        entry.EffectTriggerSpell = triggerSpell;
        return entry;
    }

    // 4187 Great Stamina, 2649 Growl, 17253 Bite and 2947 Fire Shield are on pet family skill lines (270, 208..., 188)
    std::unordered_set<uint32> const PetAbilities = { 4187, 2649, 17253, 2947 };
    auto const IsPetAbility = [](uint32 spellId) { return PetAbilities.contains(spellId); };
}

TEST_CASE("A pet training spell sold by a pet trainer is learned, not cast", "[TrainerPetTraining]")
{
    SpellNameEntry name{};

    // 4195 Great Stamina: LEARN_SPELL 4187 at the pet. Cast on the spot it trained the summoned pet once and never entered the
    // hunter's spellbook, so the trainer kept offering it and no other pet could be trained.
    SpellInfo greatStamina(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_LEARN_SPELL, 4187) });
    CHECK(Trainer::IsPetTrainingSpell(greatStamina, IsPetAbility));
    CHECK_FALSE(Trainer::IsCastToTeach(greatStamina, IsPetAbility));

    // 1853 Growl and 17254 Bite are the same shape
    SpellInfo growl(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_LEARN_SPELL, 2649) });
    CHECK_FALSE(Trainer::IsCastToTeach(growl, IsPetAbility));

    // 2949 Fire Shield (a warlock grimoire): LEARN_PET_SPELL; it was never cast (no LEARN_SPELL), and still is not
    SpellInfo grimoire(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_LEARN_PET_SPELL, 2947) });
    CHECK(Trainer::IsPetTrainingSpell(grimoire, IsPetAbility));
    CHECK_FALSE(Trainer::IsCastToTeach(grimoire, IsPetAbility));
}

TEST_CASE("Other LEARN_SPELL trainer spells are still cast", "[TrainerPetTraining]")
{
    SpellNameEntry name{};

    // a profession rank or class spell that teaches a player spell
    SpellInfo professionRank(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_LEARN_SPELL, 2575) });
    CHECK_FALSE(Trainer::IsPetTrainingSpell(professionRank, IsPetAbility));
    CHECK(Trainer::IsCastToTeach(professionRank, IsPetAbility));

    // a pet ability as the trigger of some other effect does not make a training spell
    SpellInfo triggers(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_LEARN_SPELL, 2575), Effect(1, SPELL_EFFECT_TRIGGER_SPELL, 4187) });
    CHECK_FALSE(Trainer::IsPetTrainingSpell(triggers, IsPetAbility));
    CHECK(Trainer::IsCastToTeach(triggers, IsPetAbility));

    // a plain spell (no LEARN_SPELL) is learned, as before
    SpellInfo plain(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_SCHOOL_DAMAGE, 0) });
    CHECK_FALSE(Trainer::IsPetTrainingSpell(plain, IsPetAbility));
    CHECK_FALSE(Trainer::IsCastToTeach(plain, IsPetAbility));

    // LEARN_SPELL with no trigger
    SpellInfo empty(&name, DIFFICULTY_NONE, { Effect(0, SPELL_EFFECT_LEARN_SPELL, 0) });
    CHECK_FALSE(Trainer::IsPetTrainingSpell(empty, IsPetAbility));
    CHECK(Trainer::IsCastToTeach(empty, IsPetAbility));
}
