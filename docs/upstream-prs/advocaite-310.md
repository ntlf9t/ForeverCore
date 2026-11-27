# advocaite/TrinityCore#310: World: quest, NPC and object fixes

Karrz1, 2026-11-07, commit 61864508d7. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** Ten world SQL files with small fixes players reported, each safe to run again (list below).

**Check**, file by file. "Before" is TDB `forever-tdb-2026-10-14` (the tables touched, loaded on their own); "after" is
TDB + every `everlake` world update + this pull request, on a scratch MySQL 8.0.
1. `2026_11_05_92` The Abandoned 250631 (Ruins of Lordaeron): replaces its SmartAI rows 50-54 with 50-63: passive while
   flying out of the statue, lands, becomes selectable and aggressive when it reaches the courtyard, when pulled, or 10 s
   after rising at the latest. Event and action numbers match our `SmartScriptMgr.h` (54 just summoned, 34 movement
   inform point 1, 4 aggro, 60 update; actions 60 gravity, 8 react state, 69 move to point 1, 146 uninteractible, 38 zone
   combat). Right. If the flight to the courtyard takes longer than 10 s it lands where it is: PTR check.
2. `2026_11_06_00_..._boss_and_undead_rows` restates three of Karrz1's update files of 26 Oct (`2026_10_26_53/54/56`)
   "that fresh installs lack". Those files are not in advocaite `forever` or in `everlake` either, so here the rows are new,
   not repeated. Obsidian Eradicator 15262 (mana reset 23777, Drop Obsidian 27628), Mana Fiend 15527 timers, Magma Spit
   19449 on Magmadar, Kazzak's Berserk (21340, "Frenzy" in the client), Burning Spirit condition pointing at Flamelash
   9156 (was 9178): spells exist in the 70862 client and the rows replace their own keys. **Touch of the Grave**: the
   file binds 1260189 to `classic_spell_undead_touch_of_the_grave`, a script that exists only in Karrz1's repository
   (no such script in `everlake` or any open upstream pull request). Here the racial still does nothing and the
   worldserver reports the missing script at every start until that script comes.
3. `2026_11_06_00_..._stormwind_officers_door_duplicate`: true here. TDB has door 176576 (guid 30026262) and plaque 179735
   (30026590) at the same spots as the sniff copies 696375/696376 (guids 21201739/21201740 here; the comment's
   21201820/21201821 are other objects in our data, but the delete is keyed on the old guids and ids, so it is safe). Old
   copies deleted, Russian names moved to the new entries.
4. `2026_11_06_11` Life Tap 1454: true here, it has both `classic_talent_warl_life_tap` and the retail
   `spell_gen_trigger_exclude_caster_aura_spell`; the second goes.
5. `2026_11_06_41` Sword of Corruption 13032: **not true here**, our `item_template_addon` already has 1.4 procs per
   minute (VMaNGOS list), and the statement only sets 1 when the rate is 0. No change on `everlake`.
6. `2026_11_06_45` Purple Parlor portal 1318270: landing moves from x 470.36 to 464.36, 3 yards inside the parlor's own
   portal object 691558 (467.36) instead of 3 yards outside. A position worked out from the room's objects: PTR check.
7. `2026_11_06_46` Head of Herak 286075: 40% -> 100% for players on the quest (QuestRequired 1). Quest 99080 exists.
8. `2026_11_06_55` goober Data1 -1 -> 0: 25 objects in TDB, all fixed. Data1 is the goober's quest id in this core, so
   -1 meant quest 4294967295. Right.
9. `2026_11_06_60` quest items to the bags: clears `QUEST_OBJECTIVE_FLAG_2_QUEST_BOUND_ITEM` on every item objective. In
   TDB that is 9,137 objectives; 107 of them on 91 quests a player can start here, all Forever ids. With the flag
   `Player` only counts the item in the quest log and never creates it; the claim that the 1.60 client shows quest items
   only in the bags is from the player report and Karrz1's test, not something we can check offline: PTR check. Bugged
   93949 now counts Skyhopper 251727, and 251314 gives that credit.
10. `2026_11_06_80` library book quests: needs Karrz1's quest data restore (`2026_11_05_99`, not in `everlake`), which
    gave the librarians these quests. None of the 29 book quests exists in our world, so the 29 conditions only add
    worldserver start-up errors ("quest does not exist", skipped), the queststarter deletes match nothing, and Research
    Access 97286 is not here either.

**Test.** All ten files applied twice: no errors (MySQL 8.0 warns that `VALUES()` in `ON DUPLICATE KEY UPDATE` is
deprecated). Before/after values as above. PTR: pull The Abandoned on its way out of the statue; Purple Parlor portal;
loot a quest item on a Zephras quest (Harvesting Windstones 93552) and see it in the bags and counted; Revenge of Gann's
explosive on the flying machine; Stormwind Officers' Lounge has one door.

**Verdict:** take. Parts 2 (Touch of the Grave), 5 and 10 do nothing on `everlake` until the script and the Forever
quests exist here; the start-up errors from 2 and 10 are expected until then.
