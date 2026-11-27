-- Karrz 0.1.35 casts the shaman imbue procs in core (Player::CastItemCombatSpell, ClassicWeaponImbue.h): Windfury Weapon at 20%
-- per melee hit, Flametongue Weapon on every hit. Our advocaite/TrinityCore#325 scripts on the same dummy auras would proc them a
-- second time (double Fire damage, two Windfury rolls). Same rule as 2026_11_09_60: where Karrz implements a spell, his code owns it,
-- so the two #325 bindings from 2026_11_08_00 come off. The scripts stay in classic_spell_scripts.cpp, unbound. Safe to run again.
DELETE FROM `spell_script_names` WHERE (`spell_id`, `ScriptName`) IN
((436519, 'classic_spell_sha_flametongue_weapon'),
 (439431, 'classic_spell_sha_windfury_weapon'));
