-- WoW Forever class tuning that the vanilla classic_spell_value rows (VMaNGOS 1.12, 2026_10_10_21_world_classic_spell_values_v2.sql)
-- still hid: these ranks kept Classic Era numbers while the client (and live's hotfixes) carry Blizzard's new ones. Dropping the rows
-- lets the client effect apply, its points and its spell power coefficient (with the vanilla level penalty), as on live, the same way
-- 2026_10_31_40_world_forever_class_spell_rows_unchanged.sql dropped the rows that matched.
--  * Druid Shred, ranks 1-5 (5221, 6800, 8992, 9829, 9830), effect 1 weapon damage: vanilla 225%, client 200%. Note of build 70755
--    (3 November 2026): "Weapon damage percent increased to 200% from 155%". Effect 0 went earlier (2026_10_25_50, 2026_10_31_40).
--  * Druid Starfire ranks 4-7 (8950, 8951, 9875, 9876), effect 0: vanilla 200+1d41 .. 444+1d81. Note of build 70755: base damage points
--    up by about 40%. Ranks 1-3 and 8 (2912, 8949, 25298) have no row and already take the client value.
--  * Hunter Aimed Shot ranks 1-6 (19434, 20900-20904), effect 0 bonus damage: vanilla 70/125/200/330/460/600, live 40/70/115/185/260/350
--    (client 70753 and the live hotfix rows of 2026_11_03_41_hotfixes_forever_live_class_spells_and_talents.sql). Note of build 70755:
--    bonus damage of all ranks up by about 110%.
--  * Shaman Lightning Bolt ranks 4-10 (915, 943, 6041, 10391, 10392, 15207, 15208), effect 0: Classic Era damage. Note of build 70755: each
--    rank's base damage is about 78% of the Classic Era one. Ranks 1-3 have no row.
--  * Shaman Chain Lightning rank 4 (10605), effect 0: vanilla 492+1d59. Note of build 70755: primary target base damage about 145% of
--    the comparable Lightning Bolt rank. Ranks 1-3 have no row.
--  * Imp Firebolt ranks 1-4 (3110, 7799, 7800, 7801), effect 0: vanilla 5+1d3 .. 32+1d5, live base points 6/11/15/18 with variance and the
--    same coefficients (live hotfix rows of build 70888, 2026_11_10_80_hotfixes_forever_live_pushes_70888.sql). Note of 10 November 2026
--    (build 70888): "Imp base damage of the first 4 Ranks of Imp's Firebolt increased".
-- Aimed Shot 27632 (not a trainer rank, no live row in our hotfixes) keeps its row. Safe to run again.
DELETE FROM `classic_spell_value` WHERE (`spell_id`, `effect_index`) IN (
-- Druid: Shred
(5221, 1), (6800, 1), (8992, 1), (9829, 1), (9830, 1),
-- Druid: Starfire
(8950, 0), (8951, 0), (9875, 0), (9876, 0),
-- Hunter: Aimed Shot
(19434, 0), (20900, 0), (20901, 0), (20902, 0), (20903, 0), (20904, 0),
-- Shaman: Lightning Bolt
(915, 0), (943, 0), (6041, 0), (10391, 0), (10392, 0), (15207, 0), (15208, 0),
-- Shaman: Chain Lightning
(10605, 0),
-- Warlock pet: Imp Firebolt
(3110, 0), (7799, 0), (7800, 0), (7801, 0));
