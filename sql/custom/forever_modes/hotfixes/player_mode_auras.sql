SET NAMES utf8mb4;
-- 孤勇 Buff 光环（客户端不可见，被动）
-- 玻璃大炮（仅 1~59 级）：
--   931001 造成伤害 +30%   (aura 79)
--   931002 受到伤害 +30%   (aura 87)
-- 孤勇永久属性（60 级也保留，靠重生叠加）：
--   931004 造成伤害 +X%    (aura 79)
--   931005 受到伤害 +X%    (aura 87)
--   931006 最大生命 +X%    (aura 133)

DELETE FROM hotfixes.hotfix_data WHERE (TableHash=1187407512 AND RecordId BETWEEN 931001 AND 931006)
   OR (TableHash=3322146344 AND RecordId BETWEEN 931001 AND 931006)
   OR (TableHash=4030871717 AND RecordId BETWEEN 2933001 AND 2933006);
DELETE FROM hotfixes.spell_name WHERE ID BETWEEN 931001 AND 931006;
DELETE FROM hotfixes.spell_name_locale WHERE ID BETWEEN 931001 AND 931006 AND locale='zhCN';
DELETE FROM hotfixes.spell_misc WHERE ID BETWEEN 931001 AND 931006;
DELETE FROM hotfixes.spell_effect WHERE ID BETWEEN 2933001 AND 2933006;

INSERT INTO hotfixes.spell_name (ID,Name,VerifiedBuild) VALUES
(931001,'玻璃大炮-伤害',70938),
(931002,'玻璃大炮-承伤',70938),
(931004,'孤勇-伤害',70938),
(931005,'孤勇-承伤',70938),
(931006,'孤勇-生命',70938);

INSERT INTO hotfixes.spell_name_locale (ID,locale,Name_lang,VerifiedBuild) VALUES
(931001,'zhCN','玻璃大炮-伤害',70938),
(931002,'zhCN','玻璃大炮-承伤',70938),
(931004,'zhCN','孤勇-伤害',70938),
(931005,'zhCN','孤勇-承伤',70938),
(931006,'zhCN','孤勇-生命',70938);

INSERT INTO hotfixes.spell_misc
  (ID,SpellID,DifficultyID,CastingTimeIndex,DurationIndex,RangeIndex,SchoolMask,Attributes1,
   Speed,LaunchDelay,MinDuration,SpellIconFileDataID,ActiveIconFileDataID,ContentTuningID,
   ShowFutureSpellPlayerConditionID,SpellVisualScript,ActiveSpellVisualScript,VerifiedBuild) VALUES
(931001,931001,0,1,0,1,1,64,0,0,0,0,0,0,0,0,0,70938),
(931002,931002,0,1,0,1,1,64,0,0,0,0,0,0,0,0,0,70938),
(931004,931004,0,1,0,1,1,64,0,0,0,0,0,0,0,0,0,70938),
(931005,931005,0,1,0,1,1,64,0,0,0,0,0,0,0,0,0,70938),
(931006,931006,0,1,0,1,1,64,0,0,0,0,0,0,0,0,0,70938);

INSERT INTO hotfixes.spell_effect
  (ID,SpellID,DifficultyID,EffectIndex,Effect,EffectAura,EffectBasePoints,EffectRealPointsPerLevel,
   EffectMiscValue1,EffectMiscValue2,ImplicitTarget1,ImplicitTarget2,EffectAmplitude,Coefficient,
   ScalingClass,VerifiedBuild) VALUES
(2933001,931001,0,0,6,79,0,0,127,0,1,0,0,0,0,70938),
(2933002,931002,0,0,6,87,0,0,127,0,1,0,0,0,0,70938),
(2933004,931004,0,0,6,79,0,0,127,0,1,0,0,0,0,70938),
(2933005,931005,0,0,6,87,0,0,127,0,1,0,0,0,0,70938),
(2933006,931006,0,0,6,133,0,0,0,0,1,0,0,0,0,70938);

SET @hid = (SELECT IFNULL(MAX(Id),0) FROM hotfixes.hotfix_data);
INSERT INTO hotfixes.hotfix_data (Id,UniqueId,TableHash,RecordId,Status,VerifiedBuild) VALUES
(@hid := @hid + 1, @hid, 1187407512, 931001, 1, 70938),
(@hid := @hid + 1, @hid, 1187407512, 931002, 1, 70938),
(@hid := @hid + 1, @hid, 1187407512, 931004, 1, 70938),
(@hid := @hid + 1, @hid, 1187407512, 931005, 1, 70938),
(@hid := @hid + 1, @hid, 1187407512, 931006, 1, 70938),
(@hid := @hid + 1, @hid, 3322146344, 931001, 1, 70938),
(@hid := @hid + 1, @hid, 3322146344, 931002, 1, 70938),
(@hid := @hid + 1, @hid, 3322146344, 931004, 1, 70938),
(@hid := @hid + 1, @hid, 3322146344, 931005, 1, 70938),
(@hid := @hid + 1, @hid, 3322146344, 931006, 1, 70938),
(@hid := @hid + 1, @hid, 4030871717, 2933001, 1, 70938),
(@hid := @hid + 1, @hid, 4030871717, 2933002, 1, 70938),
(@hid := @hid + 1, @hid, 4030871717, 2933004, 1, 70938),
(@hid := @hid + 1, @hid, 4030871717, 2933005, 1, 70938),
(@hid := @hid + 1, @hid, 4030871717, 2933006, 1, 70938);

SELECT ID,Name FROM hotfixes.spell_name WHERE ID BETWEEN 931001 AND 931006;
