# advocaite/TrinityCore#304: Shadowfang Keep: boss gates open, and stay open when their grid reloads

Karrz1, 2026-11-07, commit 3a0d105342. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** In Shadowfang Keep the gates after bosses stayed shut and the instance showed 0 bosses done: the revamped
bosses run on SmartAI and never set a boss state, and a gate's grid can be unloaded when its boss dies far from it
(Fenrus, Nandos), so there was no door object to open.

**Conflict.** `everlake` already has half of this: forever-bots (d13cdf728d) added the same `OnUnitDeath` handler for the
five Cataclysm bosses. #304 is that code plus three things: the instance remembers open gates (`_openDoors`), reopens a
gate in `OnGameObjectCreate`, and opens the Sorcerer's Gate on Fenrus the Devourer (4274) and Arugal's Lair on Wolf
Master Nandos (3927). Resolved by taking the file from #304; the header merged cleanly.

**Check.**
- Our world release (2026-10-14) spawns the Classic keep on map 33: Rethilgore, Razorclaw, Silverlaine, Springvale,
  Odo, Fenrus, Nandos, Arugal; no Ashbury, Walden or Godfrey. So the Fenrus and Nandos cases are the ones that matter
  here. Courtyard Door 18895, Sorcerer's Gate 18972 and Arugal's Lair 18971 are spawned closed (state 1).
- The imported VMaNGOS scripts for Fenrus and Nandos call `SET_INST_DATA` 3 and 4 with DONE on death, which VMaNGOS's
  instance script turned into opening those gates. Our instance script has no `SetData`, so nothing opened them. The
  courtyard door has its own lever script (activates 18895), so it doesn't depend on this. Fenrus → Sorcerer's Gate and
  Nandos → Arugal's Lair match the Classic dungeon.
- `InstanceScript::OnGameObjectCreate` is still called first, so object registration is unchanged.
- **Gap:** `_openDoors` lives in memory only. If the instance map unloads (everyone out longer than the unload delay) or
  the server restarts mid-run, Fenrus and Nandos stay dead (they are not bosses with a saved state) and both gates come
  back closed. Not fixed here; it was the same before.

**Test.** None in `tests/`: an instance script needs the instance map. In-game test for the PTR realm: run Shadowfang Keep,
kill Fenrus, run far away (so the gate's grid unloads), come back. Expected: the Sorcerer's Gate is open; after
Nandos, Arugal's Lair is open.

**Verdict:** take (conflict resolved as above).
