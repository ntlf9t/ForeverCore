-- Skyborne Paladins start with one-handed and two-handed sword proficiencies.
DELETE FROM `playercreateinfo_spell_custom`
WHERE `racemask` = 12884901888 AND `classmask` = 2 AND `Spell` IN (201, 202);

INSERT INTO `playercreateinfo_spell_custom` (`racemask`, `classmask`, `Spell`, `Note`) VALUES
(12884901888, 2, 201, 'Skyborne Paladin - One-Handed Swords'),
(12884901888, 2, 202, 'Skyborne Paladin - Two-Handed Swords');
