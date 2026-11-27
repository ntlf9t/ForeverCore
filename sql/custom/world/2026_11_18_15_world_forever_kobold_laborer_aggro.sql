-- Kobold Laborer (80, Fargodeep and Jasperlode mines, levels 3-4) starts fights again.
-- 2026_11_16_50 gave it faction 26 from the live capture, so it shows red, but it still carried the old civilian flag
-- (flags_extra 0x2), and a civilian never starts a fight: a red mob that ignores players. This clears that flag only.
-- Kobold Worker (257) and Kobold Vermin (6) keep theirs. Safe to run more than once.
UPDATE `creature_template` SET `flags_extra` = `flags_extra` & ~2 WHERE `entry` = 80;
