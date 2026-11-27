-- 415429 Hunter Pet Scaling: WoW Forever's stat inheritance from the hunter (pet AP, health, armor, hit, crit). Every effect but the
-- +50 focus is 0 in the 1.60 client, so the amounts come from C++: classic_spell_hun_pet_scaling
-- (Custom/Classic/world/classic_hunter_pet_scaling.cpp). Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` = 'classic_spell_hun_pet_scaling';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(415429, 'classic_spell_hun_pet_scaling');
