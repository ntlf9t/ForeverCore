-- Classic 1.60 Legacy perk reset (forever-bugs #503): on live the class trainer unlearns Legacy perks for gold, 10 gold the first
-- time and more after that. Here the Legacy trees cannot be refunded from the Legacy window and no trainer offered a reset, so
-- learned perks could never be taken back. One option per class trainer menu (the menus that offer "I wish to unlearn my
-- talents."), next to the dual spec option; GossipOptionID 97000000 + MenuID is recognised by
-- Player::IsClassicLegacyResetGossipOption, which hides it for other classes and before the Legacy system is open. The client's
-- own popup (CONFIRM_TALENT_WIPE_5) shows the price. Safe to run again.
DELETE FROM `gossip_menu_option` WHERE `GossipOptionID` BETWEEN 97000000 AND 97999999;
INSERT INTO `gossip_menu_option` (`MenuID`, `GossipOptionID`, `OptionID`, `OptionNpc`, `OptionText`, `OptionBroadcastTextID`, `Language`, `Flags`,
    `ActionMenuID`, `ActionPoiID`, `GossipNpcOptionID`, `BoxCoded`, `BoxMoney`, `BoxText`, `BoxBroadcastTextID`, `SpellID`, `OverrideIconID`, `VerifiedBuild`)
SELECT m.`MenuID`, 97000000 + m.`MenuID`, m.`NextOptionID`, 0, 'I wish to unlearn my legacy perks.', 0, 0, 0,
    0, 0, NULL, 0, 0, '', 0, NULL, NULL, 0
FROM (SELECT o.`MenuID`, MAX(o.`OptionID`) + 1 AS `NextOptionID` FROM `gossip_menu_option` o
      WHERE o.`MenuID` IN (SELECT t.`MenuID` FROM `gossip_menu_option` t WHERE t.`OptionNpc` = 11) AND o.`MenuID` < 1000000
      GROUP BY o.`MenuID`) m;
