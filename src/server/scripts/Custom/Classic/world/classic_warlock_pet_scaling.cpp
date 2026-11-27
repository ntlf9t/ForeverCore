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
#include "Pet.h"
#include "Player.h"
#include "SpellAuraEffects.h"
#include "SpellInfo.h"
#include "SpellScript.h"
#include "Unit.h"
#include "WarlockPetForever.h"
#include <algorithm>
#include <array>
#include <cmath>

// 416189 - Warlock Pet Scaling. A family passive of the Imp, Voidwalker, Succubus, Felhunter, Infernal and Doomguard (CreatureFamily skill
// lines 188, 204, 205, 189, 206, 207; SkillLineAbility AcquireMethod 2, learned in Pet::LearnPetPassives). In the 1.60 client all 20
// effects are SPELL_EFFECT_APPLY_AURA on the pet with amount 0: the server fills them in. The shares are in WarlockPetForever.h.
//
//  eff  aura                                  misc            carries
//   0   230 SPELL_AURA_MOD_MAX_HEALTH                         2 per warlock Stamina
//   1    99 SPELL_AURA_MOD_ATTACK_POWER                       17% of the warlock's spell damage
//   2    13 SPELL_AURA_MOD_DAMAGE_DONE           126 magic    10% of the warlock's spell damage
//   3-7  22 SPELL_AURA_MOD_RESISTANCE            fire, frost, nature, shadow, arcane   0: no share known
//   8   674 armor (handled as SPELL_AURA_MOD_RESISTANCE, physical)   35% of warlock armor, fixed at the summon
//   9    54 SPELL_AURA_MOD_HIT_CHANCE                         8/17 of the warlock's spell hit
//  10    55 SPELL_AURA_MOD_SPELL_HIT_CHANCE                   the warlock's spell hit
//  11   319 SPELL_AURA_MOD_MELEE_HASTE_NO_REGEN               0: no share known
//  12    65 SPELL_AURA_MOD_CASTING_SPEED                      0: no share known
//  13    52 SPELL_AURA_MOD_WEAPON_CRIT_PERCENT                0: a demon keeps its own crit in game (EV-0081)
//  14    57 SPELL_AURA_MOD_SPELL_CRIT_CHANCE                  0: the same
//  15    29 SPELL_AURA_MOD_STAT                  3 Intellect  0: no share known
//  16    85 SPELL_AURA_MOD_POWER_REGEN           0 mana       MP5: Imp 30%, the others 10% of the warlock's Intellect
//  17-18 593 (no handler)                        4, 2         0: unknown aura
//  19   135 SPELL_AURA_MOD_HEALING_DONE          126          0
//
// The amounts follow the warlock's current stats, but for armor: effect 0 ticks every second and recalculates the effects whose value
// changed. Armor is taken when the aura is applied, at the summon (EV-0078).
class classic_spell_warl_pet_scaling : public AuraScript
{
    static constexpr int32 RecalculateIntervalMs = 1 * IN_MILLISECONDS;
    static constexpr std::array<SpellEffIndex, 6> ScaledEffects = { EFFECT_0, EFFECT_1, EFFECT_2, EFFECT_9, EFFECT_10, EFFECT_16 };

    bool Validate(SpellInfo const* spellInfo) override
    {
        return ValidateSpellEffect({ { spellInfo->Id, EFFECT_16 } });
    }

    // Pet::GetOwner (the owner pointer the pet is created with), not WorldObject::GetOwner (a lookup by OwnerGUID), as for Hunter Pet Scaling.
    static Player const* GetWarlock(Unit const* unit)
    {
        Pet const* pet = unit ? unit->ToPet() : nullptr;
        if (!pet || pet->getPetType() != SUMMON_PET)
            return nullptr;

        Player const* owner = pet->GetOwner();
        if (!owner || owner->GetClass() != CLASS_WARLOCK)
            return nullptr;

        return owner;
    }

    static WarlockPetForever::WarlockStats ReadWarlock(Player const* warlock)
    {
        WarlockPetForever::WarlockStats stats;
        stats.Stamina = warlock->GetStat(STAT_STAMINA);
        stats.Intellect = warlock->GetStat(STAT_INTELLECT);
        stats.Armor = float(warlock->GetResistance(SPELL_SCHOOL_NORMAL)); // signed: GetArmor() is unsigned
        stats.ShadowDamage = float(warlock->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_SHADOW));
        stats.FireDamage = float(warlock->SpellBaseDamageBonusDone(SPELL_SCHOOL_MASK_FIRE));
        stats.SpellHit = warlock->m_modSpellHitChance; // rating plus SPELL_AURA_MOD_SPELL_HIT_CHANCE (Player::UpdateSpellHitChances)
        return stats;
    }

    static float ScaledAmount(Unit const* pet, uint8 effIndex)
    {
        Player const* warlock = GetWarlock(pet);
        if (!warlock)
            return 0.0f;

        WarlockPetForever::WarlockStats const stats = ReadWarlock(warlock);
        switch (effIndex)
        {
            case EFFECT_0:  return std::floor(WarlockPetForever::MaxHealth(stats));
            case EFFECT_1:  return std::floor(WarlockPetForever::AttackPower(stats));
            case EFFECT_2:  return std::floor(WarlockPetForever::SpellDamage(stats));
            case EFFECT_8:  return std::floor(WarlockPetForever::Armor(stats));
            case EFFECT_9:  return WarlockPetForever::MeleeHit(stats);
            case EFFECT_10: return WarlockPetForever::SpellHit(stats);
            case EFFECT_16: return std::floor(WarlockPetForever::ManaPer5(stats, pet->ToCreature()->GetCreatureTemplate()->family == CREATURE_FAMILY_IMP));
            default:        return 0.0f;
        }
    }

    void CalcAmount(AuraEffect const* aurEff, SpellEffectValue& amount, bool& canBeRecalculated)
    {
        canBeRecalculated = true;
        amount = ScaledAmount(GetUnitOwner(), aurEff->GetEffIndex());
    }

    // Armor stays what it was at the summon
    void CalcArmor(AuraEffect const* aurEff, SpellEffectValue& amount, bool& canBeRecalculated)
    {
        canBeRecalculated = false;
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
        if (!GetWarlock(pet))
            return; // keep the last amounts rather than dropping them all to 0 for a moment

        for (SpellEffIndex effIndex : ScaledEffects)
        {
            AuraEffect* effect = GetEffect(effIndex);
            if (!effect)
                continue;

            SpellEffectValue const oldAmount = effect->GetAmount();
            if (std::abs(oldAmount - ScaledAmount(pet, effIndex)) <= 0.001)
                continue;

            // Keep the demon's health, moved by the change, rather than the heal SPELL_AURA_MOD_MAX_HEALTH gives on reapply (see Hunter Pet Scaling)
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
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcAmount, EFFECT_0, SPELL_AURA_MOD_MAX_HEALTH);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcAmount, EFFECT_1, SPELL_AURA_MOD_ATTACK_POWER);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcAmount, EFFECT_2, SPELL_AURA_MOD_DAMAGE_DONE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcArmor, EFFECT_8, SPELL_AURA_MOD_RESISTANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcAmount, EFFECT_9, SPELL_AURA_MOD_HIT_CHANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcAmount, EFFECT_10, SPELL_AURA_MOD_SPELL_HIT_CHANCE);
        DoEffectCalcAmount += AuraEffectCalcAmountFn(classic_spell_warl_pet_scaling::CalcAmount, EFFECT_16, SPELL_AURA_MOD_POWER_REGEN);
        DoEffectCalcPeriodic += AuraEffectCalcPeriodicFn(classic_spell_warl_pet_scaling::CalcRecalculateTimer, EFFECT_0, SPELL_AURA_MOD_MAX_HEALTH);
        OnEffectUpdatePeriodic += AuraEffectUpdatePeriodicFn(classic_spell_warl_pet_scaling::RecalculateChanged, EFFECT_0, SPELL_AURA_MOD_MAX_HEALTH);
    }
};

void AddSC_classic_warlock_pet_scaling()
{
    RegisterSpellScript(classic_spell_warl_pet_scaling);
}
