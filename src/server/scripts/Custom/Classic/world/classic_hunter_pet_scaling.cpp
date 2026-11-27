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

#include "ScriptMgr.h"
#include "HunterPetForever.h"
#include "Pet.h"
#include "Player.h"
#include "SpellAuraEffects.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "Unit.h"
#include <algorithm>
#include <array>
#include <cmath>

// 415429 - Hunter Pet Scaling. A family passive every hunter pet gets (CreatureFamily skill lines, SkillLineAbility AcquireMethod 2, learned
// in Pet::LearnPetPassives). In the 1.60.1.70862 client all 19 effects are SPELL_EFFECT_APPLY_AURA on the pet with amount 0, except
// effect 15 (+50 maximum focus): the server fills them in. WoW Forever: "Pets now get increased stats based on their Hunter's gear"; the
// amounts below are the Classic Hunter Lodge wiki's (Pet-Stat-Mechanics, see HunterPetForever.h).
//
//  eff  aura                                  misc            carries
//   0   230 SPELL_AURA_MOD_MAX_HEALTH                         2 per hunter Stamina                     (wiki)
//   1    99 SPELL_AURA_MOD_ATTACK_POWER                       10% of the higher of RAP and MAP          (wiki)
//   2    13 SPELL_AURA_MOD_DAMAGE_DONE           126 magic    0: the wiki gives Lightning Breath as rank damage x mods only
//   3-7  22 SPELL_AURA_MOD_RESISTANCE            fire, frost, nature, shadow, arcane   0: the wiki lists no resistance inheritance
//   8   674 armor (handled as SPELL_AURA_MOD_RESISTANCE, physical)   30% of hunter armor             (wiki)
//   9    54 SPELL_AURA_MOD_HIT_CHANCE                         hunter hit, higher of ranged and melee    (wiki: "inherited"; which one is a guess)
//  10    55 SPELL_AURA_MOD_SPELL_HIT_CHANCE                   17/8 of the hunter's ranged hit            (Forever developers, forever-bugs 394)
//  11   319 SPELL_AURA_MOD_MELEE_HASTE_NO_REGEN               0: the wiki lists no haste inheritance     (guess)
//  12    65 SPELL_AURA_MOD_CASTING_SPEED                      0                                         (guess)
//  13    52 SPELL_AURA_MOD_WEAPON_CRIT_PERCENT                100% of the higher of ranged and melee crit (wiki)
//  14    57 SPELL_AURA_MOD_SPELL_CRIT_CHANCE                  the same crit                             (guess: for Lightning Breath)
//  15   418 SPELL_AURA_MOD_MAX_POWER             2 focus      +50, from the client (150 focus, wiki)
//  16-17 593 (no handler)                        4, 2         0: unknown aura
//  18    49 SPELL_AURA_MOD_DODGE_PERCENT                      half of Aspect of the Monkey's dodge with Improved Aspect of the Monkey 19549
//
// The amounts follow the hunter's current stats: effect 0 ticks every second and recalculates the effects whose value changed.
class classic_spell_hun_pet_scaling : public AuraScript
{
    static constexpr int32 RecalculateIntervalMs = 1 * IN_MILLISECONDS;
    static constexpr std::array<SpellEffIndex, 8> ScaledEffects = { EFFECT_0, EFFECT_1, EFFECT_8, EFFECT_9, EFFECT_10, EFFECT_13, EFFECT_14, EFFECT_18 };

    // 19549 - Improved Aspect of the Monkey: "Additionally, your pet gains 50% of the effect of your Aspect of the Monkey ability." The talent
    // holds it in a dummy (effect 1) nothing read. Effect 18 (SPELL_AURA_MOD_DODGE_PERCENT, 0 in the client) carries half of the hunter's
    // current Aspect of the Monkey dodge (the talent's flat bonus included) while the aspect is up; a creature's dodge reads the aura total.
    static constexpr uint32 SPELL_HUN_ASPECT_OF_THE_MONKEY          = 13163;
    static constexpr uint32 SPELL_HUN_IMPROVED_ASPECT_OF_THE_MONKEY = 19549;
    static constexpr float MonkeyPetShare                           = 0.5f;

    bool Validate(SpellInfo const* spellInfo) override
    {
        return ValidateSpellEffect({ { spellInfo->Id, EFFECT_18 } });
    }

    // Pet::GetOwner (the owner pointer the pet is created with), not WorldObject::GetOwner (a lookup by OwnerGUID): a pet being tamed casts its
    // passives before its OwnerGUID is set, and the lookup also fails while the hunter is not on the pet's map.
    static Player const* GetHunter(Unit const* unit)
    {
        Pet const* pet = unit ? unit->ToPet() : nullptr;
        if (!pet || !pet->IsHunterPet())
            return nullptr;

        return pet->GetOwner();
    }

    static HunterPetForever::HunterStats ReadHunter(Player const* hunter)
    {
        // the hunter's own hit, as Unit::MeleeSpellMissChance adds it up: rating plus SPELL_AURA_MOD_HIT_CHANCE (gear and Surefooted)
        float const hitAuras = hunter->GetTotalAuraModifier(SPELL_AURA_MOD_HIT_CHANCE);

        HunterPetForever::HunterStats stats;
        stats.RangedAttackPower = hunter->GetTotalAttackPowerValue(RANGED_ATTACK);
        stats.MeleeAttackPower = hunter->GetTotalAttackPowerValue(BASE_ATTACK);
        stats.Stamina = hunter->GetStat(STAT_STAMINA);
        stats.Armor = float(hunter->GetResistance(SPELL_SCHOOL_NORMAL)); // signed: GetArmor() is unsigned
        stats.RangedCrit = hunter->m_activePlayerData->RangedCritPercentage;
        stats.MeleeCrit = hunter->m_activePlayerData->CritPercentage;
        stats.RangedHit = hunter->m_modRangedHitChance + hitAuras;
        stats.MeleeHit = hunter->m_modMeleeHitChance + hitAuras;
        return stats;
    }

    static float MonkeyDodge(Player const* hunter)
    {
        if (!hunter->HasAura(SPELL_HUN_IMPROVED_ASPECT_OF_THE_MONKEY))
            return 0.0f;
        AuraEffect const* monkey = hunter->GetAuraEffect(SPELL_HUN_ASPECT_OF_THE_MONKEY, EFFECT_0);
        return monkey ? float(monkey->GetAmount()) * MonkeyPetShare : 0.0f;
    }

    static float ScaledAmount(Unit const* pet, uint8 effIndex)
    {
        Player const* hunter = GetHunter(pet);
        if (!hunter)
            return 0.0f;

        if (effIndex == EFFECT_18)
            return MonkeyDodge(hunter);

        HunterPetForever::HunterStats const stats = ReadHunter(hunter);
        switch (effIndex)
        {
            case EFFECT_0:  return std::floor(HunterPetForever::MaxHealth(stats));
            case EFFECT_1:  return std::floor(HunterPetForever::AttackPower(stats));
            case EFFECT_8:  return std::floor(HunterPetForever::Armor(stats));
            case EFFECT_9:  return HunterPetForever::Hit(stats);
            case EFFECT_10: return HunterPetForever::SpellHit(stats);
            case EFFECT_13:
            case EFFECT_14: return HunterPetForever::Crit(stats);
            default:        return 0.0f;
        }
    }

    void CalcAmount(AuraEffect const* aurEff, SpellEffectValue& amount, bool& canBeRecalculated)
    {
        canBeRecalculated = true;
        amount = ScaledAmount(GetUnitOwner(), aurEff->GetEffIndex());
    }

    void CalcRecalculateTimer(AuraEffect const* /*aurEff*/, bool& isPeriodic, int32& amplitude)
    {
        isPeriodic = true;
        amplitude = RecalculateIntervalMs;
    }

    void RecalculateChanged(AuraEffect* /*aurEff*/)
    {
        Unit* pet = GetUnitOwner();
        if (!GetHunter(pet))
            return; // keep the last amounts rather than dropping them all to 0 for a moment

        for (SpellEffIndex effIndex : ScaledEffects)
        {
            AuraEffect* effect = GetEffect(effIndex);
            if (!effect)
                continue;

            SpellEffectValue const oldAmount = effect->GetAmount();
            if (std::abs(oldAmount - ScaledAmount(pet, effIndex)) <= 0.001)
                continue;

            // SPELL_AURA_MOD_INCREASE_HEALTH_2 takes the old amount off with health floored at 1, then heals the whole new amount: a pet with
            // less health than the old bonus came back near full whenever the hunter's Stamina changed. Keep its health, moved by the change.
            int64 const health = pet->GetHealth();
            effect->RecalculateAmount();
            if (effIndex == EFFECT_0 && pet->IsAlive() && health > 0)
            {
                int64 const changed = health + int64(effect->GetAmount() - oldAmount);
                pet->SetHealth(uint64(std::clamp<int64>(changed, 1, int64(pet->GetMaxHealth()))));
            }
        }
    }

    void Register() override
    {
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_0, SPELL_AURA_MOD_MAX_HEALTH);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_1, SPELL_AURA_MOD_ATTACK_POWER);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_8, SPELL_AURA_MOD_RESISTANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_9, SPELL_AURA_MOD_HIT_CHANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_10, SPELL_AURA_MOD_SPELL_HIT_CHANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_13, SPELL_AURA_MOD_WEAPON_CRIT_PERCENT);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_14, SPELL_AURA_MOD_SPELL_CRIT_CHANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_hun_pet_scaling::CalcAmount, EFFECT_18, SPELL_AURA_MOD_DODGE_PERCENT);
        DoEffectCalcPeriodic += AuraEffectCalcPeriodicFn(classic_spell_hun_pet_scaling::CalcRecalculateTimer, EFFECT_0, SPELL_AURA_MOD_MAX_HEALTH);
        OnEffectUpdatePeriodic += AuraEffectUpdatePeriodicFn(classic_spell_hun_pet_scaling::RecalculateChanged, EFFECT_0, SPELL_AURA_MOD_MAX_HEALTH);
    }
};

void AddSC_classic_hunter_pet_scaling()
{
    RegisterSpellScript(classic_spell_hun_pet_scaling);
}
