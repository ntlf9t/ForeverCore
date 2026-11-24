-- Chinese names for the custom Paladin and Priest trainers.
INSERT INTO `creature_template_locale`
    (`entry`, `locale`, `Name`, `NameAlt`, `Title`, `TitleAlt`, `VerifiedBuild`)
VALUES
(8102001, 'zhCN', '晨蹄', NULL, '圣骑士训练师', NULL, 70959),
(8102002, 'zhCN', '奥瑞琳·晨羽', NULL, '圣骑士训练师', NULL, 70959),
(8102003, 'zhCN', '塞拉·风语', NULL, '牧师训练师', NULL, 70959)
ON DUPLICATE KEY UPDATE
    `Name` = VALUES(`Name`),
    `NameAlt` = VALUES(`NameAlt`),
    `Title` = VALUES(`Title`),
    `TitleAlt` = VALUES(`TitleAlt`),
    `VerifiedBuild` = VALUES(`VerifiedBuild`);
