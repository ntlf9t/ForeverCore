-- WoW Forever live XP removals (XP rate audit, everlake-reports/xp-rate-audit-2026-11-19.md).
-- Hotfixes of November 10 2026: "Shatterspear Trolls no longer grant XP on kill". Every Shatterspear troll gets
-- CREATURE_FLAG_EXTRA_NO_XP (0x40); the four Shatterspear bunnies (33056, 33913, 34231, 34321) are not kill targets.
UPDATE `creature_template` SET `flags_extra` = `flags_extra` | 0x40
WHERE `entry` IN (10919, 11196, 32855, 32858, 32860, 32861, 32863, 33071, 34248, 34309, 130120, 142621, 142622, 144204,
                  147418, 147423, 147426, 149597, 149598, 149599);

-- Hotfixes of November 16 2026: Water Pouch Bounty (1878) gives no experience; Wowhead Forever also shows 0 for Troll Necklace
-- Bounty (2881). Both are repeatable turn-ins. QuestXP difficulty 0 is 0 at every level in the Forever client.
UPDATE `quest_template` SET `RewardXPDifficulty` = 0 WHERE `ID` IN (1878, 2881);
