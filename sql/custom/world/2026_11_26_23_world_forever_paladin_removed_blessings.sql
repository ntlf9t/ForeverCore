-- WoW Forever build 1.60.1.70755 (notes "About this build", 4 November 2026): "Paladin: Salvation, Mass Salvation, and Revoke have been
-- removed." and "Paladin: Blessing of Light has been removed." Trainers stop teaching Blessing of Salvation 1038, Greater Blessing of
-- Salvation 25895, Blessing of Light 19977 / 19978 / 19979 and Greater Blessing of Light 25890 (characters lose them in
-- characters 2026_11_26_24). Mass Salvation and Revoke have no rows here. Safe to run again.
DELETE FROM `trainer_spell` WHERE `SpellId` IN (1038, 25895, 19977, 19978, 19979, 25890);
