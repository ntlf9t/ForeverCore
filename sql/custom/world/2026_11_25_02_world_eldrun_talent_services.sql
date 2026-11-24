-- Eldrun Stormbreaker uses the sniffed training-only menu 41915, so the classic
-- talent-reset pass and dual-spec generator did not add these class services.
INSERT INTO `gossip_menu_option`
(`MenuID`, `GossipOptionID`, `OptionID`, `OptionNpc`, `OptionText`, `OptionBroadcastTextID`, `Language`, `Flags`,
 `ActionMenuID`, `ActionPoiID`, `GossipNpcOptionID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`,
 `SpellID`, `OverrideIconID`, `VerifiedBuild`)
VALUES
(41915, 94341281, 1, 11, 'I wish to unlearn my talents.', 0, 0, 0, 0, 0, NULL, 0, 0, NULL, 0, NULL, NULL, 0),
(41915, 95041915, 2, 0, 'I wish to purchase a Dual Talent Specialization.', 0, 0, 0, 0, 0, NULL, 0, 500000,
 'Are you sure you wish to purchase a Dual Talent Specialization?', 0, NULL, NULL, 0)
ON DUPLICATE KEY UPDATE
`GossipOptionID` = VALUES(`GossipOptionID`),
`OptionNpc` = VALUES(`OptionNpc`),
`OptionText` = VALUES(`OptionText`),
`BoxMoney` = VALUES(`BoxMoney`),
`BoxText` = VALUES(`BoxText`);

INSERT INTO `gossip_menu_option_locale`
(`MenuID`, `OptionID`, `Locale`, `OptionText`, `BoxText`)
VALUES
(41915, 0, 'zhCN', '我要训练！', NULL),
(41915, 1, 'zhCN', '我想遗忘天赋。', NULL),
(41915, 2, 'zhCN', '我想购买双天赋专精。', '你确定要购买双天赋专精吗？')
ON DUPLICATE KEY UPDATE
`OptionText` = VALUES(`OptionText`),
`BoxText` = VALUES(`BoxText`);

INSERT INTO `creature_template_locale`
(`entry`, `locale`, `Name`, `NameAlt`, `Title`, `TitleAlt`, `VerifiedBuild`)
VALUES (258098, 'zhCN', '埃尔德伦·风暴击破者', '', '萨满训练师', '', 0)
ON DUPLICATE KEY UPDATE
`Name` = VALUES(`Name`),
`Title` = VALUES(`Title`),
`VerifiedBuild` = VALUES(`VerifiedBuild`);
