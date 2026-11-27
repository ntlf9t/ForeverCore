-- WoW Forever: Dark Inspiration (1326159) is handled by forever-bugs' classic_spell_pri_dark_inspiration (2026_11_16_42, #372). This
-- branch's earlier duplicate scripts on Mind Blast and Mind Flay cast the buff a second time; their bindings are removed. Safe to run again.
DELETE FROM `spell_script_names` WHERE `ScriptName` IN ('classic_spell_pri_dark_inspiration_mind_blast', 'classic_spell_pri_dark_inspiration_mind_flay');
