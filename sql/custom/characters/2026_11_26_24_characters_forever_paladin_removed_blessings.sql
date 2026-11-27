-- WoW Forever build 1.60.1.70755 (notes "About this build", 4 November 2026): Salvation and Blessing of Light are removed from paladins
-- (world 2026_11_26_23 takes them off the trainers). Characters (players and bots) who learned Blessing of Salvation 1038, Greater
-- Blessing of Salvation 25895, Blessing of Light 19977 / 19978 / 19979 or Greater Blessing of Light 25890 lose the spell, its action
-- buttons and any saved buff. Safe to run again.
DELETE FROM `character_spell` WHERE `spell` IN (1038, 25895, 19977, 19978, 19979, 25890);
DELETE FROM `character_action` WHERE `type` = 0 AND `action` IN (1038, 25895, 19977, 19978, 19979, 25890);
DELETE FROM `character_aura_effect` WHERE `spell` IN (1038, 25895, 19977, 19978, 19979, 25890);
DELETE FROM `character_aura` WHERE `spell` IN (1038, 25895, 19977, 19978, 19979, 25890);
