-- WoW Forever server-side notes for the Summon Hawk guardian and the Undead racial Touch of the Grave. Safe to run again.

-- Hawk (264850, Summon Hawk 1293241/1293525-1293527): its own AI, classic_npc_hun_summoned_hawk, sticks it to the target it was summoned on
-- even with the pet on Passive, then attacks the hunter's current target when idle (notes 70450, Oct 16: "Summon Hawk will now stick your
-- Hawk to the target that it was summoned on"; 71139, Nov 25: "attack the target they're summoned on even if the player's pet is set to
-- Passive", "will attack your current target if they are not actively attacking a target"). The AI casts the sniffed SmartAI's 415431 on
-- reset itself, so the SmartAI row goes.
UPDATE `creature_template` SET `AIName` = '', `ScriptName` = 'classic_npc_hun_summoned_hawk' WHERE `entry` = 264850;
DELETE FROM `smart_scripts` WHERE `source_type` = 0 AND `entryorguid` = 264850;

-- Hawk melee damage: note 70888 (Nov 10) "Melee damage dealt by the Hawk pet increased by about 80%". The tracker shows no client change
-- to the hawk spells or its scaling aura 1293586 for it, and the row's DamageModifier 1 is from the build 70124 sniff, before the change.
-- The note's "about 80%" is the only number there is: DamageModifier 1.8.
UPDATE `creature_template_difficulty` SET `DamageModifier` = 1.8 WHERE `Entry` = 264850 AND `DifficultyID` = 0;

-- Dismiss Pet (2641) also unsummons the hunter's hawks when the cast completes (note 71139, Nov 25: "Summoned Hawks are now dismissed when
-- the Dismiss Pet spell is completed").
DELETE FROM `spell_script_names` WHERE `spell_id` = 2641 AND `ScriptName` = 'classic_spell_hun_dismiss_pet_hawks';
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(2641, 'classic_spell_hun_dismiss_pet_hawks');

-- Touch of the Grave: the casters' copy 1260201 had two drain scripts bound (classic_spell_grave_touch from 2026_11_08_00 and
-- classic_spell_undead_touch_of_the_grave from 2026_11_16_06), so a proc drained twice. One script per copy: classic_spell_grave_touch,
-- as 1260189 has had since 2026_11_08_00. Both scripts now proc only from damage, not from periodic ticks (note 70009, Sep 24).
-- The internal cooldown stays the client's 15 sec: notes 70755 and Oct 30 cut the 25 sec of note 70450 to 15 sec.
DELETE FROM `spell_script_names` WHERE `spell_id` IN (1260189, 1260201)
  AND `ScriptName` IN ('classic_spell_undead_touch_of_the_grave', 'classic_spell_grave_touch');
INSERT INTO `spell_script_names` (`spell_id`, `ScriptName`) VALUES
(1260189, 'classic_spell_grave_touch'),
(1260201, 'classic_spell_grave_touch');
