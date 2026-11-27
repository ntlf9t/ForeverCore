-- 416189 Warlock Pet Scaling: WoW Forever's demon stat inheritance from the warlock (health, attack power, spell damage, armor, hit,
-- mana regen). Every effect is 0 in the 1.60 client, so the amounts come from C++: classic_spell_warl_pet_scaling
-- (Custom/Classic/world/classic_warlock_pet_scaling.cpp, shares in WarlockPetForever.h). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_warl_pet_scaling';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(416189, 'classic_spell_warl_pet_scaling');
