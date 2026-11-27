# TrinityCore 5a58175f49: Hall of Awakening, conversation event for "Who Am I?"

Naddley, 2026-10-29, TrinityCore#32113. Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools export of 1.60.1.70862 (Map). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables batch I's SQL touches) with every batch I world file applied in TrinityCore order and the tables dumped before and after.

**Claim.** New `hall_of_awakening.cpp` (`AddSC_zone_hall_of_awakening`, registered in `khaz_algar_script_loader.cpp`)
with conversation script `conversation_quest_who_am_i` for conversation 25327: it finds the stair copies of Dawn and
Foreman Uzjax (224782, 224783, StringId `CloneTarget`) and summons personal clones. SQL: those two spawns (phase
23761, map 2739), conversation 25327, SmartAI and waypoints for 221839 / 224782 / 224783, a corrected phase condition.

**Check.** Map 2739 is not in 70862. New ids are free in Forever's data (creature guids 10006986-10006987, phase 23761,
conversation 25327 and lines 68939-68940, paths 22478200 / 22478300). **The file has**
``UPDATE `conversation_template` SET `ScriptName` = 'conversation_quest_who_am_i';`` **with no WHERE**: on the
scratch database it changed all 250 rows, including Forever's 248 (53 of which have their own ScriptName). That is what
b75afc756f repairs. Everlake's `sql/custom/world` files add no conversation_template row (grep), so after b75afc756f
nothing is left changed (checked by dump diff: 248 rows identical to the release, 2 new). The new script compiles in
the local build; it binds only to conversation 25327.

Taken together with dc5955decd, 5a58175f49, b75afc756f and bb3d6fd535 (the Earthen start-area chain): 5a58175f49 without b75afc756f breaks every conversation ScriptName. Both files are new on every Everlake world database and run in the same updater pass, in name order
(2026_10_29_00 then 2026_11_07_00), so the broken state is not left between starts.

**Test.** Scratch database (above). Unreachable in game.

**Verdict:** take (only with b75afc756f and bb3d6fd535).
