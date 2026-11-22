-- Fix Shadowfang Keep cell levers after 2026_11_19_84.
-- Negative spawn-ID scripts override the existing entry-level
-- SMART_ACTION_ACTIVATE_GOBJECT scripts used by these levers.

DELETE FROM `smart_scripts`
WHERE source_type = 1 AND entryorguid IN (-30032442,-30034006);
