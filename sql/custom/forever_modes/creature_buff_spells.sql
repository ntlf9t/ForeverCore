-- ============================================================
-- 怪物随机附魔：30 个光环法术
--   930001-930007  伤害提高 10/20/50/100/150/200/300%   (aura 79)
--   930008-930013  攻速提高 10/20/50/100/200/300%       (aura 138)
--   930014-930017  受到伤害降低 10/20/50/80%            (aura 87, 全系)
--   930018-930024  单系受到伤害降低 50%                 (aura 87, 按系)
--   930025-930029  复合 buff（狂暴/铁壁/嗜血/迅捷/元素灌注）
--   930030         宝藏（无实际属性，仅标记）
--
-- 关键点：
--   * Attributes1 = 64 (PASSIVE) + DurationIndex = 0 => 永久光环
--   * EffectBasePoints 从 0 开始，所以 数值 = EffectBasePoints + 1
--   * aura 79 的 EffectMiscValue1 是法术系掩码，127 = 全系
--   * aura 87 的 EffectMiscValue1 是法术系掩码，负值 = 减伤
--
-- 可重复执行（先删后插）
-- ============================================================
SET NAMES utf8mb4;

DROP TABLE IF EXISTS world.tmp_crb_spell;
CREATE TABLE world.tmp_crb_spell (
  sid       INT UNSIGNED NOT NULL PRIMARY KEY,
  name      VARCHAR(48) NOT NULL,
  aura1     SMALLINT NOT NULL,
  misc1     INT NOT NULL,
  bp1       INT NOT NULL,
  aura2     SMALLINT NULL,
  misc2     INT NULL,
  bp2       INT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO world.tmp_crb_spell (sid, name, aura1, misc1, bp1, aura2, misc2, bp2) VALUES
-- 伤害提高
(930001, '伤害提高 10%',   79, 127,   9, NULL, NULL, NULL),
(930002, '伤害提高 20%',   79, 127,  19, NULL, NULL, NULL),
(930003, '伤害提高 50%',   79, 127,  49, NULL, NULL, NULL),
(930004, '伤害提高 100%',  79, 127,  99, NULL, NULL, NULL),
(930005, '伤害提高 150%',  79, 127, 149, NULL, NULL, NULL),
(930006, '伤害提高 200%',  79, 127, 199, NULL, NULL, NULL),
(930007, '伤害提高 300%',  79, 127, 299, NULL, NULL, NULL),
-- 攻速提高
(930008, '攻速提高 10%',  138,   0,   9, NULL, NULL, NULL),
(930009, '攻速提高 20%',  138,   0,  19, NULL, NULL, NULL),
(930010, '攻速提高 50%',  138,   0,  49, NULL, NULL, NULL),
(930011, '攻速提高 100%', 138,   0,  99, NULL, NULL, NULL),
(930012, '攻速提高 200%', 138,   0, 199, NULL, NULL, NULL),
(930013, '攻速提高 300%', 138,   0, 299, NULL, NULL, NULL),
-- 全系受到伤害降低
(930014, '受到伤害降低 10%',  87, 127, -11, NULL, NULL, NULL),
(930015, '受到伤害降低 20%',  87, 127, -21, NULL, NULL, NULL),
(930016, '受到伤害降低 50%',  87, 127, -51, NULL, NULL, NULL),
(930017, '受到伤害降低 80%',  87, 127, -81, NULL, NULL, NULL),
-- 单系受到伤害降低 50%
(930018, '物理伤害降低 50%',  87,   1, -51, NULL, NULL, NULL),
(930019, '神圣伤害降低 50%',  87,   2, -51, NULL, NULL, NULL),
(930020, '火焰伤害降低 50%',  87,   4, -51, NULL, NULL, NULL),
(930021, '自然伤害降低 50%',  87,   8, -51, NULL, NULL, NULL),
(930022, '冰霜伤害降低 50%',  87,  16, -51, NULL, NULL, NULL),
(930023, '暗影伤害降低 50%',  87,  32, -51, NULL, NULL, NULL),
(930024, '奥术伤害降低 50%',  87,  64, -51, NULL, NULL, NULL),
-- 复合 buff
(930025, '狂暴',      79, 127,  29, 138,   0,  29),   -- 伤害+30% 攻速+30%
(930026, '铁壁',      87, 127, -31,  79, 127,  19),   -- 受伤-30% 伤害+20%
(930027, '嗜血',      79, 127,  49, 138,   0,  49),   -- 伤害+50% 攻速+50%
(930028, '迅捷',     138,   0,  39,  31,   0,  39),   -- 攻速+40% 移速+40%
(930029, '元素灌注',  79, 127,  39,  87, 127, -21),   -- 伤害+40% 受伤-20%
-- 宝藏：0% 伤害的空光环，只用来当标记
(930030, '宝藏',      79, 127,  -1, NULL, NULL, NULL);

SET @hid = (SELECT IFNULL(MAX(Id), 0) FROM hotfixes.hotfix_data);

DELETE FROM hotfixes.hotfix_data
 WHERE (TableHash = 1187407512 AND RecordId BETWEEN 930001 AND 930030)
    OR (TableHash = 3322146344 AND RecordId BETWEEN 930001 AND 930030)
    OR (TableHash = 4030871717 AND RecordId BETWEEN 2930011 AND 2930322);

DELETE FROM hotfixes.spell_name   WHERE ID BETWEEN 930001 AND 930030;
DELETE FROM hotfixes.spell_misc   WHERE ID BETWEEN 930001 AND 930030;
DELETE FROM hotfixes.spell_effect WHERE SpellID BETWEEN 930001 AND 930030;

INSERT INTO hotfixes.spell_name (ID, Name, VerifiedBuild)
SELECT sid, name, 70938 FROM world.tmp_crb_spell;

INSERT INTO hotfixes.spell_misc
  (ID, SpellID, DifficultyID, CastingTimeIndex, DurationIndex, RangeIndex, SchoolMask, Attributes1,
   Speed, LaunchDelay, MinDuration, SpellIconFileDataID, ActiveIconFileDataID, ContentTuningID,
   ShowFutureSpellPlayerConditionID, SpellVisualScript, ActiveSpellVisualScript, VerifiedBuild)
SELECT sid, sid, 0, 1, 0, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 70938
FROM world.tmp_crb_spell;

-- 图标：被动光环客户端不会显示在 buff 栏，所以用非被动 + 代码强制永久时长；
-- 图标 FileDataID 取自现有法术，保证客户端能渲染
UPDATE hotfixes.spell_misc SET SpellIconFileDataID = 135806 WHERE ID BETWEEN 930001 AND 930007;  -- 伤害
UPDATE hotfixes.spell_misc SET SpellIconFileDataID = 136118 WHERE ID BETWEEN 930008 AND 930013;  -- 攻速
UPDATE hotfixes.spell_misc SET SpellIconFileDataID = 135953 WHERE ID BETWEEN 930014 AND 930017;  -- 全系减伤
UPDATE hotfixes.spell_misc SET SpellIconFileDataID = 135992 WHERE ID BETWEEN 930018 AND 930024;  -- 单系减伤
UPDATE hotfixes.spell_misc SET SpellIconFileDataID = 135924 WHERE ID BETWEEN 930025 AND 930029;  -- 复合
UPDATE hotfixes.spell_misc SET SpellIconFileDataID = 133951 WHERE ID = 930030;                  -- 宝藏

-- 第一个效果
INSERT INTO hotfixes.spell_effect
  (ID, SpellID, DifficultyID, EffectIndex, Effect, EffectAura, EffectBasePoints, EffectRealPointsPerLevel,
   EffectMiscValue1, EffectMiscValue2, ImplicitTarget1, ImplicitTarget2, EffectAmplitude, Coefficient,
   ScalingClass, VerifiedBuild)
SELECT 2930000 + (sid - 930000) * 10 + 1, sid, 0, 0, 6, aura1, bp1, 0, misc1, 0, 1, 0, 0, 0, 0, 70938
FROM world.tmp_crb_spell;

-- 第二个效果（复合 buff）
INSERT INTO hotfixes.spell_effect
  (ID, SpellID, DifficultyID, EffectIndex, Effect, EffectAura, EffectBasePoints, EffectRealPointsPerLevel,
   EffectMiscValue1, EffectMiscValue2, ImplicitTarget1, ImplicitTarget2, EffectAmplitude, Coefficient,
   ScalingClass, VerifiedBuild)
SELECT 2930000 + (sid - 930000) * 10 + 2, sid, 0, 1, 6, aura2, bp2, 0, misc2, 0, 1, 0, 0, 0, 0, 70938
FROM world.tmp_crb_spell
WHERE aura2 IS NOT NULL;

-- 推送给客户端 / 标记为有效
INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
SELECT @hid := @hid + 1, @hid, 1187407512, sid, 1, 70938 FROM world.tmp_crb_spell;

INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
SELECT @hid := @hid + 1, @hid, 3322146344, sid, 1, 70938 FROM world.tmp_crb_spell;

INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
SELECT @hid := @hid + 1, @hid, 4030871717, 2930000 + (sid - 930000) * 10 + 1, 1, 70938
FROM world.tmp_crb_spell;

INSERT INTO hotfixes.hotfix_data (Id, UniqueId, TableHash, RecordId, Status, VerifiedBuild)
SELECT @hid := @hid + 1, @hid, 4030871717, 2930000 + (sid - 930000) * 10 + 2, 1, 70938
FROM world.tmp_crb_spell
WHERE aura2 IS NOT NULL;

SELECT COUNT(*) AS spells FROM hotfixes.spell_name WHERE ID BETWEEN 930001 AND 930030;
SELECT COUNT(*) AS effects FROM hotfixes.spell_effect WHERE SpellID BETWEEN 930001 AND 930030;
SELECT COUNT(*) AS hotfix_rows FROM hotfixes.hotfix_data
 WHERE (TableHash = 1187407512 AND RecordId BETWEEN 930001 AND 930030)
    OR (TableHash = 3322146344 AND RecordId BETWEEN 930001 AND 930030)
    OR (TableHash = 4030871717 AND RecordId BETWEEN 2930011 AND 2930322);

DROP TABLE world.tmp_crb_spell;
