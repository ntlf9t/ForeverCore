# advocaite/TrinityCore#265: boss loot sweep for the Horde-side dungeons

dqhoang, 2026-10-29, commit 719784adad (14 files). Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** An audit of Horde-side dungeon bosses against Wowhead Forever found (1) bosses with no Forever set, and (2) boss
references whose items "do not exist in the Forever universe" (Wowhead tooltip "Entity not found"), which roll nothing.
Files 00-04 inline Wailing Caverns, Shadowfang Keep, Blackfathom Deeps, Razorfen Kraul and Scarlet Monastery sets with the
new Forever items (one group, one item per kill) and add two rare drops; 05-12 delete the "dead" references in Razorfen
Downs, Uldaman, Zul'Farrak, Maraudon, Sunken Temple, Blackrock Depths and Blackrock Spire and add some measured drops; 92
removes duplicate rows.

**How it was checked.** Every row the files remove or add was diffed on the release brought to `everlake`, references
expanded, and each item looked up in: the 70862 client's ItemSparse (wago.tools), our hotfixes release (`item_sparse`, 5291
items), live Forever's item answers (EG Link `item_hotfixes`, builds 70790-70862: `valid` = sent, `invalid` = "the item
exists, and the server doesn't show it yet", `removed` = no such item), Wowhead Forever tooltips, and EG Link's recorded
boss loot rolls. Wowhead's drop tables (the "N of M kills" figures) can't be read from here: they are script data in the
page and direct requests get 403, so none of the quoted rates could be checked.

**Files 00-04: right.** Every item is known to our server and `valid` on live. The one-of-three groups fit EG Link's rolls:
- Wailing Caverns: Kresh 13245 x2, 6447; Pythas 6472 x2, 6473; Anacondra 5404 x2, 10412 x2; Skum 6448, 6449, 273137.
- Shadowfang Keep: Rethilgore 273457 (no 5254 in that kill, so 5254 isn't the guaranteed drop it is on `everlake`),
  Silverlaine 273637, Springvale 273643, Odo 273645, Fenrus 3230, Nandos 6314.
- Blackfathom Deeps: Kelris 273846, Ghamoo-ra 273839; Gelihast's and Lorgus Jett's items are `valid` on live.
- Razorfen Kraul and Scarlet Monastery: no recorded rolls; all items `valid` on live and on Wowhead Forever (274290,
  274291, 274294, 274149-274161 checked).
- Two unchecked rates: Mutanus's Hypnotic Crystal (209838) at 14% (Wowhead Forever's item page says "Added in Season of
  Discovery. May not be in WoW: Forever."; 3 recorded kills, none dropped it) and Doan's Library Walkers at 0.0463%.

**Files 05-12: wrong.** None of the "dead" items is `removed` on live; most are `valid`, the rest `invalid` (exist, not shown
yet). Wowhead Forever has tooltips for most of them; "Entity not found" holds only for a few ids that came after 1.12
(22245, 22253, ...). They roll nothing on our server because our item data lacks them (not in the client's ItemSparse nor
our hotfixes), not because Forever lacks them. Examples:
- Razorfen Downs, Ragglesnout: X'caliboar 10758, Savage Boar's Guard 10767, Boar Champion's Belt 10768: all `valid` on
  live, all on Wowhead Forever.
- Uldaman, Archaedas: The Rockpounder 9413 and Stoneslayer 9418 `valid` and on Wowhead Forever; the replacement row,
  Archaedic Stone 11118, is `valid` on live but also missing from our item data, so it rolls nothing either.
- Zul'Farrak: Ukorz's five, Zum'rah's two, Antu'sul's four are all `valid`. File 07 adds 9476/9477/11086/18082/9379/9639/
  9640 (`valid`, missing here), file 08 takes them out again and gives Ukorz 9380, which is not the drop: 11086 is the main
  hand Jang'thraze the Protector; 9380 is the other one-hand version with a "Use:" line.
- Maraudon, Landslide: the reference is replaced by Fist of Stone 17733, also the other version; the drop is 17943
  (`invalid` = not shown yet). Helm of the Mountain 17734 in the removed reference is `valid`.
- Sunken Temple: the Atal'ai warder items 10783-10788 are `invalid` (not shown yet), on Wowhead Forever (10783 Atal'ai
  Spaulders).
- Blackrock Depths: Dagran's references hold Hand of Justice 11815 and Robes of the Royal Crown 11924 (`valid`); Bael'Gar's
  Sash of the Burning Heart 11807 (`valid`).
- Blackrock Spire: Drakkisath's reference 30272 is every Tier 0 chest (16666, 16674, 16688, 16690, 16700, 16706, 16721,
  16726, 16730), all known to our server and `valid` on live; deleting it removes his chest drop. Omokk's ref holds Boots
  of Elements 16670, Wyrmthalak's Beaststalker's Mantle 16679, Rend's reference 10429 Spaulders of Valor 16733, all known here.
  Emberseer's Tablet of Flame Shock VI goes from 8% to 1.37% and Zigris's footlocker from 12.4% to 55.4% on Wowhead figures
  that couldn't be checked.
- 92: the 277917 rows on 4012-4015 and gameobject 16577's reference 12008 really are doubled on `everlake` (deletes 8 and 2,
  inserts 4 and 1); the 7267/9380 part belongs to 08.

**Test.** SQL. Load test (as in advocaite-123.md): all 14 files apply with no error (rows: 00: 4 deleted, 14 inserted;
01: 6/18; 02: 3/12; 03: 3/12; 04: 2/7; 05: 1 deleted; 06: 1/1; 07: 3/7; 08: 7/1; 09: 1/1; 10: 6 deleted; 11: 5/1; 12:
21/9; 92: 11/6). The deletes match the rows the comments name; nothing else is removed.

**Verdict:** hold. Files 00-04 and the 4012-4015 / 16577 part of 92 are good and could come in on their own. 05-12 should
not: the fix for those bosses is the missing item data (the `invalid` and missing-here items), not deleting their loot.
Asked of upstream: split the pull request.
