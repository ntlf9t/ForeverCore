# TrinityCore 33e08119b4: Shadow Labyrinth, Blackheart the Inciter rewritten

offl, 2026-09-30, TrinityCore#31970. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools exports of 1.60.1.70862 (Map, SpellName). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables this batch's SQL touches) with every batch I world file applied in TrinityCore order.

**Claim.** Blackheart's Incite Chaos becomes a charm spell script (33684) on the party, his five "dummy" copies
(19300-19304) get a new script and the threat trigger 45339 targets them through `conditions`; the instance no longer
keeps a list of dummies (`GetBlackheartDummies` and `NPC_BLACKHEART_DUMMY*` removed from `shadow_labyrinth.h`);
his texts are replaced (8 rows).

**Check.** 70862's Map table has 81 rows: the Classic maps (0-533) and Forever's own maps (2720-3218, e.g. 2991 Zephras Isle). None of 540 Shattered Halls, 552 Arcatraz, 553 Botanica, 554 Mechanar, 555 Shadow Labyrinth, 565 Gruul's Lair, 568 Zul'Aman, 1501 Black Rook Hold, 2739 (Earthen start area) is there, and the world release has no creature spawned on any of them. None of the new spell ids is in 70862 except 21912 (Dummy Nuke), which only Blackheart's own AI casts;
33684 (the only spell script bound by the SQL) is absent, so the spell script never binds. SQL against Forever's
release: `creature_template` 19300-19304 (Forever has TrinityCore's TBC rows, ScriptName
`boss_blackheart_the_inciter_mc_dummy`) get the new ScriptName and lose flags_extra 2 and 128; `creature_text` 18667
goes from 20 rows to 8; `conditions` 13/45339 and `spell_script_names` 33684 are new. All rows are TBC data with no
spawn in Forever. Nothing else in `src/` (Custom, modules included) uses the removed header names (grep).

**Test.** None: dungeon not in the Forever client.

**Verdict:** take (unreachable).
