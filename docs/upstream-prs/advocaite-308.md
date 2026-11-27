# advocaite/TrinityCore#308: Mounts: 19 item mounts with no 70790 mount data get a mount type

Karrz1, 2026-11-07, commit d6a50becbf. Reviewed 2026-11-08 against `everlake` dab8f8aa45.

**Claim.** 19 item mount spells have no Mount.db2 row in the 70790 client, so the server finds no mount type: the rider
moves at walk speed and is dismounted at the next area update. Each gets a Mount row sent as a hotfix (type 453 =
Riding 75 / 60%, 454 = Riding 150 / 100%, 471 = no Riding / 60%; flag 64 keeps them out of the journal until learned).
Mottled Raptor (mount 3900) moves from retail type 230 to 453 with a new push. Swift Spectral Tiger uses the Swift
Zulian Tiger look (display 15290).

**Check** (wago.tools, builds 70790 and 70862, the same in both):
- No Mount row has any of the 20 source spells, and mount ids 3900-3919 and MountXDisplay id 9901 are free (the client's
  highest Mount id is 3169, MountXDisplay 3828).
- MountTypeXCapability has types 453 (Riding 75, Standard Ground Mount speed), 454 (Riding 150, Epic Ground Mount) and
  471 (no Riding, standard speed); 230 is not there, so the old row for 3900 could never work. Riding Turtle uses 453 and
  Swift Zulian Tiger 454 in the client's own data, the same pattern.
- Creature display 21974 (Swift Spectral Tiger) is not in CreatureDisplayInfo; 15290 is.
- The spells exist with the names in the file. Riding Gryphon 3363 is an old unused spell; with flag 64 it only shows
  if someone learns it.
- The pull request deletes hotfix push 984000 (the old Mottled Raptor push from `2026_10_04_00`, which is in
  `everlake`) and re-sends 3900 as push 984319; push 984001 (its MountXDisplay 9900) stays. No other file uses
  984300-984320.

**Risk.** Mount ids 3901-3919 are our own; a later client build could add Blizzard rows with the same ids. The world
import check should compare the ids with each new build's Mount.db2.

**Test.** Applied twice to a scratch MySQL 8.0 hotfixes database (TDB + `everlake` hotfixes updates), no errors. PTR: use
Whistle of the Mottled Raptor, a Swift Dawnsaber and a Trainee's Sentinel Nightsaber (no Riding): each runs at mount
speed and stays mounted through a zone change; Swift Spectral Tiger shows the tiger model.

**Verdict:** take.
