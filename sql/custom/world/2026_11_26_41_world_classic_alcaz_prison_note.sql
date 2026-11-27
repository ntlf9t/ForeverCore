-- Alcaz Prison (map 2994): the Perfumed Note that lies on the ground after Blazeroar (255702) dies.
-- The instance script (classic_instance_alcaz_prison) puts it there; opening it gives the "read the note" credit
-- (KC Creature 264861) through classic_go_alcaz_perfumed_note.
--
-- gameobject_template 630604 "Perfumed Note": type 2 (quest giver), display 190, size 1, data [0,29555,0,42504,...]
--   from the client's object data (1.60.1.71037 object_details) and Icy Veins (gameobject 630604, gossip 42504). Not
--   on the realm before this file. Which object the note is: its name and Icy Veins' progress text for 95262 and
--   95454 ("Despite the sweetness of the perfume coming from the note ..."); no source ties the id to the quests
--   directly, so that link is INFERRED.
-- Quest rows (Wowhead comment on the quests: "Note spawns on the ground after killing final boss"; Icy Veins gives
--   no npc for the turn-in text of 95262/95454 nor for the start of 95263/96369, and those texts are the note's):
--   ends   95262 The Secret Prison (Alliance), 95454 The Honor of the Kor'kron (Horde)
--   starts 95263 Somber News (Alliance; ends at Sully McCleary 260271), 96369 Bad News for Folkar (Horde; ends at
--          Commander Folkar 260386)
-- quest_template_addon 95263: PrevQuestID 96335 -> 95262. Icy Veins lists both 95262 and 96335 (The Man in the Iron
--   Chains) as leading to Somber News, but 96335 is open to both factions and is not needed for the Horde twin 96369
--   (prev 95454), so requiring it locked Alliance players out of the note's quest. 95262's next quest is 95263
--   (Icy Veins next_quest_id).
-- Safe to run again.

DELETE FROM `gameobject_template` WHERE `entry`=630604;
INSERT INTO `gameobject_template` (`entry`,`type`,`displayId`,`name`,`IconName`,`castBarCaption`,`unk1`,`size`,
 `Data0`,`Data1`,`Data2`,`Data3`,`Data4`,`Data5`,`Data6`,`Data7`,`Data8`,`Data9`,`Data10`,`Data11`,`Data12`,`Data13`,
 `Data14`,`Data15`,`Data16`,`Data17`,`Data18`,`Data19`,`Data20`,`Data21`,`Data22`,`Data23`,`Data24`,`Data25`,`Data26`,
 `Data27`,`Data28`,`Data29`,`Data30`,`Data31`,`Data32`,`Data33`,`Data34`,`ContentTuningId`,`RequiredLevel`,`AIName`,
 `ScriptName`,`StringId`,`VerifiedBuild`) VALUES
(630604,2,190,'Perfumed Note','','','',1,
 0,29555,0,42504,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,0,0,0,
 0,0,0,0,0,0,0,0,0,0,'',
 'classic_go_alcaz_perfumed_note',NULL,71037);

DELETE FROM `gameobject_questender` WHERE `id`=630604 AND `quest` IN (95262,95454);
INSERT INTO `gameobject_questender` (`id`,`quest`,`VerifiedBuild`) VALUES
(630604,95262,0),
(630604,95454,0);

DELETE FROM `gameobject_queststarter` WHERE `id`=630604 AND `quest` IN (95263,96369);
INSERT INTO `gameobject_queststarter` (`id`,`quest`,`VerifiedBuild`) VALUES
(630604,95263,0),
(630604,96369,0);

UPDATE `quest_template_addon` SET `PrevQuestID`=95262 WHERE `ID`=95263;
