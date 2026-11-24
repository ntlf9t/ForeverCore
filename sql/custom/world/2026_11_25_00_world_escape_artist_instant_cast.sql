-- Escape Artist is instant in the client spell data. The generated classic override
-- treated the vanilla 500 ms casting-time index as a real cast bar.
UPDATE `classic_spell_info`
SET `cast_ms` = NULL
WHERE `spell_id` = 20589;
