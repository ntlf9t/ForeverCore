# TrinityCore dc5955decd: Earthen start area, first Awakening Machine conversation

Naddley, 2026-10-26 (no pull request number). Reviewed 2026-11-09 against `everlake` 029c5dd9ca. Client data: wago.tools export of 1.60.1.70862 (Map). World data: the Forever world release `forever-tdb-2026-10-14`, loaded into a scratch MySQL 8.0 (the 30 tables batch I's SQL touches) with every batch I world file applied in TrinityCore order and the tables dumped before and after.

**Claim.** World data for the Earthen (Khaz Algar) start: Dawn and Foreman Uzjax spawned in phase 23759 on map 2739,
15 gameobject templates, conversation 25326, gossip, a scene, quest 79200 details, and a server-side area trigger
(template 191 custom, create properties **182 custom**, spawn 293) with SmartAI that starts the conversation.

**Check.** Map 2739 is not in 70862's Map table, and the creature templates involved (221839, 221841, 227994 ...) only
have TrinityCore's retail rows in Forever's release. New ids are free in Forever's data: creature guids
10006984-10006985, phase 23759, npc_text 600178, gossip menu 35980, conversation 25326 and lines 68937-68938, smart
script source 12 / 191, area trigger template 191 custom, area trigger spawns 293-294 (Forever's highest spawn is 8).

**One clash.** `areatrigger_create_properties` Id 182 IsCustom 1 is already Forever's: the Zephras Isle inn rest areas,
area trigger spawns 3 ("Zephras Inn (rested)") and 4 ("south inn (rested)") on map 2991, which **is** in 70862. Forever's
row is a cylinder (shape 4, radius 22, height 15) on custom trigger 137. TrinityCore's file deletes it and inserts its
own 182 (a 10x30x15 box on custom trigger 191, whose SmartAI starts conversation 25326). On the scratch database,
after the file, spawns 3 and 4 had TrinityCore's shape and trigger. TrinityCore's custom create properties end at 181;
Forever took 182 and 300-303, Everlake 1310000-1310001.

**Our fix.** `sql/custom/world/2026_11_09_79_world_everlake_zephras_inn_create_properties.sql`: Forever's row again as
custom 1310002 (next free in Everlake's block; checked against `everlake` and the other batch branches), and spawns 3 and 4
point to it. It does not depend on which file runs first. TrinityCore's file is left as it is, so later TrinityCore
changes to their 182 still apply. On the scratch database after both: spawns 3 and 4 have Forever's exact shape and
trigger 137; 182 is TrinityCore's and used only by spawn 293 on map 2739.

Taken together with dc5955decd, 5a58175f49, b75afc756f and bb3d6fd535 (the Earthen start-area chain): 5a58175f49 without b75afc756f breaks every conversation ScriptName.

**Test.** Scratch database (above). PTR check: rest at the Zephras Inn and the south inn on Zephras Isle (the "Rested"
state appears on entering, as before), and no conversation or SmartAI error in the server log there.

**Verdict:** take, with our fix (the Zephras inn area trigger row).
