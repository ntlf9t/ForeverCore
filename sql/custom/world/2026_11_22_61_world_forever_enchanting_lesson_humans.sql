-- An Enchanting Lesson (91753, Kitta Firewind, Tower of Azora): Humans could not take it.
-- 2026_10_27_04_world_forever_enchanting_lessons.sql gave it AllowableRaces 4294967372 = races 3, 4, 7, 33 (Dwarf, Night Elf,
-- Gnome, ...): the Human bit (1) is missing. Wowhead Forever (https://www.wowhead.com/forever/quest=91753/an-enchanting-lesson):
-- "Side: Alliance", no race requirement. 4294967373 is the Alliance mask the other Elwynn Forever quests use (e.g. 91746, 91751).
UPDATE `quest_template` SET `AllowableRaces`=4294967373 WHERE `ID`=91753;
