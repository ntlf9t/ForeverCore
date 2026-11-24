-- The inferred Relic of the Claw spawn is below the walkable surface at its
-- own coordinates: the Moonglade navmesh resolves it to z 439.972, not 438.4.
UPDATE `gameobject` SET `position_z` = 439.97
WHERE `guid` = 67309300 AND `id` = 673093 AND ABS(`position_z` - 438.4) < 0.01;

-- The existing Great Cat Spirit marker still points to the old hilltop height.
UPDATE `quest_poi_points` SET `Z` = 440
WHERE `QuestID` = 98396 AND `Idx1` = 2 AND `Idx2` = 0 AND `X` = 7457 AND `Y` = -3117 AND `Z` = 593;
