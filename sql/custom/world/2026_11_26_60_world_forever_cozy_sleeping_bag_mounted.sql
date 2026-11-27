-- Cozy Sleeping Bag (211527), area trigger 30821 of Unroll Bag 429961: WoW Forever note of 70959 (2026-11-17, Blizzard's notes in the
-- tracker's timeline): "Mounted Players will no longer be permitted to sleep while saddled up atop the Cozy Sleeping Bag."
-- 2026_11_11_93 gave the owner Well-Rested Tracking Aura 429960 through an area trigger action, mounted or not. The script
-- classic_at_cozy_sleeping_bag now gives and takes the aura (inside and not mounted), so the action goes.
-- Safe to run again.
DELETE FROM `areatrigger_template_actions` WHERE `AreaTriggerId` = 30821 AND `IsCustom` = 1 AND `ActionParam` = 429960;
UPDATE `areatrigger_create_properties` SET `ScriptName` = 'classic_at_cozy_sleeping_bag' WHERE `Id` = 30821 AND `IsCustom` = 0;
