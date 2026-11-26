-- Remove SmartAI actions skipped at runtime because the Classic DB2 data has no
-- matching phase, phase group, or spawn record. The valid parent action is kept
-- when an invalid linked child is removed.
DELETE FROM `smart_scripts`
WHERE (`entryorguid`, `source_type`, `id`, `link`) IN (
    (181058, 1, 2, 0),
    (184798, 1, 0, 0),
    (190594, 1, 0, 0),
    (191124, 1, 0, 0),
    (191365, 1, 0, 0),
    (191578, 1, 0, 0),
    (2362200, 9, 3, 0),
    (2411800, 9, 5, 0),
    (2411800, 9, 6, 0),
    (2550404, 9, 1, 0),
    (2724800, 9, 1, 0),
    (3038200, 9, 2, 0),
    (3774500, 9, 131, 0),
    (3774501, 9, 129, 0),
    (13041900, 9, 0, 0),
    (13041900, 9, 6, 0),
    (18707300, 9, 0, 0),
    (18707300, 9, 1, 0),
    (19055500, 9, 0, 0),
    (19055500, 9, 1, 0),
    (19112300, 9, 0, 0),
    (19112300, 9, 1, 0),
    (19136500, 9, 0, 0)
);

UPDATE `smart_scripts` SET `link` = 0
WHERE (`entryorguid`, `source_type`, `id`, `link`) = (181058, 1, 1, 2);

DELETE FROM `smart_scripts`
WHERE (`entryorguid`, `source_type`, `id`, `link`) IN (
    (156807, 0, 0, 0),
    (450807, 9, 3, 0),
    (2878703, 9, 2, 0),
    (12492200, 9, 2, 0)
);

UPDATE `smart_scripts` SET `event_flags` = `event_flags` | 1
WHERE (`entryorguid`, `source_type`, `id`, `link`) = (253002, 0, 5, 0);

-- SMART_ACTION_MOVE_TO_POS does not consume target_o; VMaNGOS sentinel values
-- outside the radian range are replaced with a neutral orientation.
UPDATE `smart_scripts` SET `target_o` = 0
WHERE (`entryorguid`, `source_type`, `id`, `link`) IN (
    (950000427, 9, 1, 0),
    (950001295, 9, 0, 0)
);
