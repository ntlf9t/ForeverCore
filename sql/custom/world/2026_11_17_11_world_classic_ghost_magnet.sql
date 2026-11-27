-- Ghost Magnet (177746), placed for Ghost-o-plasm Round Up (6134): the Classic script classic_go_ghost_magnet (classic_desolace.cpp, after
-- VMaNGOS go_ghost_magnetAI) calls the Magrami Spectres (11560) the quest's Ghost-o-plasm drops from. The object had no script here, so the
-- magnet called nothing and the spectres, which no spawn row holds in Classic either, never came (the ForeverTracker's locator offered to
-- spawn them for good).
UPDATE `gameobject_template` SET `ScriptName` = 'classic_go_ghost_magnet' WHERE `entry` = 177746;
